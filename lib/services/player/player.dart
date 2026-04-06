import 'dart:collection';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:logging/logging.dart';
import 'package:quark/objects/playlist.dart';
import 'package:quark/objects/track.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart' as just_audio;

enum ShuffleMode {
  /// Completely randomizes the list.
  full,

  /// Shuffles tracks after the current track (everything before it will remain unshuffle)
  afterCurrent,

  /// Shuffles the entire list and moves the current track to the top.
  nowOnTop,
}

enum ChangeReason {
  /// If the track has changed for natural reasons
  completed,

  /// If the track has changed due to external interference
  external,
}

class TrackChange {
  final PlayerTrack newTrack;
  final ChangeReason reason;

  const TrackChange({required this.newTrack, required this.reason});
}

class PlaylistInfo {
  final int ownerUid;
  final int kind;
  final String name;
  final PlaylistSource source;

  const PlaylistInfo({
    this.ownerUid = 0,
    this.kind = 0,
    this.source = PlaylistSource.local,
    this.name = 'Local',
  });

  static PlaylistInfo fromPlayerPlaylist(PlayerPlaylist playlist) {
    return PlaylistInfo(
      ownerUid: playlist.ownerUid,
      source: playlist.source,
      kind: playlist.kind,
      name: playlist.name,
    );
  }
}

enum PlayerBackend {
  /// AudioPlayers package ll be used
  audioPlayers,
  justAudio,
  justAudioMediaKit,
}

class _PlayerEngine {
  _PlayerEngine._internal();
  factory _PlayerEngine() => _instance;
  static final _PlayerEngine _instance = _PlayerEngine._internal();

  late PlayerBackend playerBackend;

  just_audio.AudioPlayer? justAudioPlayer;
  AudioPlayer? audioPlayersPlayer;

  StreamSubscription? _onPlayedChanged;
  StreamSubscription? _onDurationChanged;
  StreamSubscription? _onCompleteSubscription;

  Future<void> init({
    PlayerBackend playerBackend2 = PlayerBackend.audioPlayers,
  }) async {
    playerBackend = playerBackend2;
    switch (playerBackend) {
      case PlayerBackend.justAudio:
        justAudioPlayer = just_audio.AudioPlayer();
      case PlayerBackend.justAudioMediaKit:
        JustAudioMediaKit.ensureInitialized();
        JustAudioMediaKit.pitch = true;
        justAudioPlayer = just_audio.AudioPlayer();
      default:
        audioPlayersPlayer = AudioPlayer();
    }
  }

  Future<void> play(String filePath) async {
    try {
      switch (playerBackend) {
        case PlayerBackend.justAudioMediaKit:
        case PlayerBackend.justAudio:
          await justAudioPlayer!.setAudioSource(
            just_audio.AudioSource.file(filePath),
          );
          await justAudioPlayer!.play();
        default:
          await audioPlayersPlayer!.play(DeviceFileSource(filePath));
      }
    } catch (e) {
      Logger("PlayerEngine").warning("Failed to play an audiofile", e);
    }
  }

  Future<void> playNet(String url) async {
    try {
      switch (playerBackend) {
        case PlayerBackend.justAudioMediaKit:
        case PlayerBackend.justAudio:
          await justAudioPlayer!.setAudioSource(
            just_audio.AudioSource.uri(Uri.parse(url)),
          );
          await justAudioPlayer!.play();
        default:
          await audioPlayersPlayer!.play(UrlSource(url));
      }
    } catch (e) {
      Logger("PlayerEngine").warning("Failed to play an networkSource", e);
    }
  }

  Future<void> stop() async {
    try {
      switch (playerBackend) {
        case PlayerBackend.justAudioMediaKit:
        case PlayerBackend.justAudio:
          await justAudioPlayer!.stop();
        default:
          await audioPlayersPlayer!.stop();
      }
    } catch (e) {
      Logger("PlayerEngine").warning("Failed to play an networkSource", e);
    }
  }

  // Future<void> playPause(bool play) async {
  //   try {
  //     switch (playerBackend) {
  //       case PlayerBackend.justAudioMediaKit:
  //       case PlayerBackend.justAudioVlc:
  //       case PlayerBackend.justAudio:
  //         if (play) await justAudioPlayer!.pause();
  //         if (!play) await justAudioPlayer!.play();
  //       default:
  //         if (play) await audioPlayersPlayer!.pause();
  //         if (!play) await audioPlayersPlayer!.resume();
  //     }
  //   } catch (e) {
  //     Logger("PlayerEngine").warning("Failed to play an networkSource", e);
  //   }
  // }

  Future<void> resume() async {
    try {
      switch (playerBackend) {
        case PlayerBackend.justAudioMediaKit:
        case PlayerBackend.justAudio:
          await justAudioPlayer!.play();
        default:
          await audioPlayersPlayer!.resume();
      }
    } catch (e) {
      Logger("PlayerEngine").warning("Failed to play an networkSource", e);
    }
  }

  Future<void> pause() async {
    try {
      switch (playerBackend) {
        case PlayerBackend.justAudioMediaKit:
        case PlayerBackend.justAudio:
          await justAudioPlayer!.pause();
        default:
          await audioPlayersPlayer!.pause();
      }
    } catch (e) {
      Logger("PlayerEngine").warning("Failed to play an networkSource", e);
    }
  }

  Future<void> setupListeners(
    void Function(void) onComplete,
    void Function(Duration) onDuration,
    void Function(Duration) onPlayed,
  ) async {
    switch (playerBackend) {
      case PlayerBackend.justAudioMediaKit:
      case PlayerBackend.justAudio:
        await _onCompleteSubscription?.cancel();
        await _onDurationChanged?.cancel();
        await _onPlayedChanged?.cancel();

        _onCompleteSubscription = justAudioPlayer!.playerStateStream
            .where(
              (state) =>
                  state.processingState == just_audio.ProcessingState.completed,
            )
            .listen((_) => onComplete(null));

        _onDurationChanged = justAudioPlayer!.durationStream
            .where((d) => d != null)
            .cast<Duration>()
            .listen(onDuration);
        justAudioPlayer!.currentIndexStream
            .where((index) => index != null)
            .distinct()
            .listen((index) async {
              if (index! > 0) {
                await justAudioPlayer!.removeAudioSourceAt(0);
                onComplete(null);
              }
            });
        _onPlayedChanged = justAudioPlayer!.positionStream.listen(onPlayed);

      default:
        await _onCompleteSubscription?.cancel();
        await _onDurationChanged?.cancel();
        await _onPlayedChanged?.cancel();
        _onCompleteSubscription = audioPlayersPlayer!.onPlayerComplete.listen(
          onComplete,
        );
        _onDurationChanged = audioPlayersPlayer!.onDurationChanged.listen(
          onDuration,
        );
        _onPlayedChanged = audioPlayersPlayer!.onPositionChanged.listen(
          onPlayed,
        );
    }
  }

  Future<void> seek(Duration duration) async {
    switch (playerBackend) {
      case PlayerBackend.justAudioMediaKit:
      case PlayerBackend.justAudio:
        await justAudioPlayer!.seek(duration);
      default:
        await audioPlayersPlayer!.seek(duration);
    }
  }

  Future<void> setVolume(double volume) async {
    switch (playerBackend) {
      case PlayerBackend.justAudioMediaKit:
      case PlayerBackend.justAudio:
        await justAudioPlayer!.setVolume(volume);
      default:
        await audioPlayersPlayer!.setVolume(volume);
    }
  }

  Future<void> setSpeed(double speed) async {
    switch (playerBackend) {
      case PlayerBackend.justAudioMediaKit:
      case PlayerBackend.justAudio:
        await justAudioPlayer!.setSpeed(speed);
      default:
        await audioPlayersPlayer!.setPlaybackRate(speed);
    }
  }

  Future<void> precacheNext(String filepath) async {
    switch (playerBackend) {
      case PlayerBackend.justAudioMediaKit:
      case PlayerBackend.justAudio:
        await justAudioPlayer!.addAudioSource(
          just_audio.AudioSource.file(filepath),
        );
      default:
    }
  }

  Future<void> dispose() async {
    await _onCompleteSubscription?.cancel();
    await _onDurationChanged?.cancel();
    await _onPlayedChanged?.cancel();

    _onCompleteSubscription = null;
    _onDurationChanged = null;
    _onPlayedChanged = null;

    if (justAudioPlayer != null) {
      await justAudioPlayer!.dispose();
      justAudioPlayer = null;
    }
    if (audioPlayersPlayer != null) {
      await audioPlayersPlayer!.dispose();
      audioPlayersPlayer = null;
    }
  }
}

/// A standalone player running in the background, independent of the stream UI
class Player {
  // SINGLETON INTERNAL REALISATION
  Player._internal() : playlist = [], nowPlayingTrack = LocalTrack.getDummy();

  static final Player _player = Player._internal();

  static Player get player => _player;

  PlayerTrack nowPlayingTrack;
  List<PlayerTrack> playlist;

  Player({required this.playlist, required this.nowPlayingTrack});

  // SETUP NOTIFIERS FOR UI LISTENERS
  final trackNotifier = ValueNotifier<PlayerTrack>(LocalTrack.getDummy());

  final trackChangeNotifier = ValueNotifier<TrackChange>(
    TrackChange(newTrack: LocalTrack.getDummy(), reason: ChangeReason.external),
  );
  final playedNotifier = ValueNotifier<Duration>(Duration());
  final durationNotifier = ValueNotifier<Duration>(Duration());
  final playlistNotifier = ValueNotifier<List<PlayerTrack>>([]);
  final repeatModeNotifier = ValueNotifier<bool>(false);
  final shuffleModeNotifier = ValueNotifier<bool>(false);
  final volumeNotifier = ValueNotifier<double>(0.5);
  final queueNotifier = ValueNotifier<Queue<PlayerTrack>>(
    Queue<PlayerTrack>.from([]),
  );

  /// Notifies whether the playback is playing or stopped
  final playingNotifier = ValueNotifier<bool>(false);

  /// It is not recommended to change this value yourself by using ```Player.unShuffledPlaylist = []```.
  late List<PlayerTrack> unShuffledPlaylist;

  double speed = 1.0;

  // AudioPlayer class listeners
  // StreamSubscription? _onPlayedChanged;
  // StreamSubscription? _onDurationChanged;
  // StreamSubscription? _onCompleteSubscription;

  bool isPlaying = false;
  bool isRepeat = false;
  bool isShuffle = false;

  ShuffleMode shuffleMode = ShuffleMode.nowOnTop;

  PlaylistInfo playlistInfo = PlaylistInfo();

  Queue<PlayerTrack> queue = Queue<PlayerTrack>.from([]);
  PlayerTrack? unQueuedLastTrack;

  Future<void> init({PlayerBackend? backend}) async {
    playlistNotifier.value = playlist;
    unShuffledPlaylist = playlist;
    final engine = Platform.isAndroid
        ? PlayerBackend.audioPlayers
        : PlayerBackend.justAudioMediaKit;
    await _PlayerEngine().init(playerBackend2: backend ?? engine);
    await setupListeners();
  }

  Future<void> dispose() async {
    // await _onCompleteSubscription?.cancel();
    // await _onDurationChanged?.cancel();
    // await _onPlayedChanged?.cancel();
    await _PlayerEngine().dispose();
  }

  Future<void> setupListeners() async {
    _PlayerEngine().setupListeners(
      (event) async {
        await playNext(completed: true);
      },
      (event) {
        durationNotifier.value = event;
      },
      (event) {
        playedNotifier.value = event;
      },
    );

    // await _onCompleteSubscription?.cancel();
    // await _onDurationChanged?.cancel();
    // await _onPlayedChanged?.cancel();
    // _onCompleteSubscription = playerInstance.onPlayerComplete.listen((
    //   event,
    // ) async {

    // });

    // _onDurationChanged = playerInstance.onDurationChanged.listen((event) {
    //   durationNotifier.value = event;
    // });

    // _onPlayedChanged = playerInstance.onPositionChanged.listen((event) {
    //   playedNotifier.value = event;
    // });
  }

  // Future<Duration> getPosition() async {
  //   Duration? position = await playerInstance.getCurrentPosition();
  //   return position ?? Duration();
  // }

  // Future<Duration> getTrackDuration() async {
  //   Duration? duration = await playerInstance.getDuration();
  //   return duration ?? Duration();
  // }

  Future<void> _afterFn() async {
    if (Platform.isLinux) {
      // Fixing the bug where changing the source cause the maximum player's volume (1.0 instead previous value)
      await _PlayerEngine().setVolume(volumeNotifier.value);
      await _PlayerEngine().setSpeed(speed);
    }
    int nowIndex = playlist.indexWhere((t) => t == nowPlayingTrack);
    int nextIndex = (isRepeat)
        ? nowIndex
        : playlist.length - 1 != nowIndex
        ? nowIndex + 1
        : 0;
    await _PlayerEngine().precacheNext(playlist[nextIndex].filepath);
  }

  // Future<dynamic> getNextTrack() async {
  //   if (queue.isNotEmpty) {
  //     if (queue.isEmpty) {
  //       if (unQueuedLastTrack != null) {
  //         int nowIndex = playlist.indexWhere((t) => t == unQueuedLastTrack);
  //         int nextIndex = (isRepeat)
  //             ? nowIndex
  //             : playlist.length - 1 != nowIndex
  //             ? nowIndex + 1
  //             : 0;
  //         return (playlist[nextIndex]);
  //       }
  //     } else {
  //       return queue.first;
  //     }
  //   }

  //   int nowIndex = playlist.indexWhere((t) => t == nowPlayingTrack);

  //   int nextIndex = (isRepeat)
  //       ? nowIndex
  //       : playlist.length - 1 != nowIndex
  //       ? nowIndex + 1
  //       : 0;
  //   return (playlist[nextIndex]);
  // }

  Future<void> playNext({bool? forceNext, bool? completed}) async {
    if (queue.isNotEmpty) {
      queue.removeFirst();
      _notifyQueueListeners();
      if (queue.isEmpty) {
        if (unQueuedLastTrack != null) {
          int nowIndex = playlist.indexWhere((t) => t == unQueuedLastTrack);
          int nextIndex = (isRepeat && forceNext == null)
              ? nowIndex
              : playlist.length - 1 != nowIndex
              ? nowIndex + 1
              : 0;
          nowPlayingTrack = playlist[nextIndex];
        }
      } else {
        nowPlayingTrack = queue.first;
      }
      trackNotifier.value = nowPlayingTrack;
      trackChangeNotifier.value = TrackChange(
        newTrack: nowPlayingTrack,
        reason: (completed ?? false)
            ? ChangeReason.completed
            : ChangeReason.external,
      );
      await _playIsPlaying();
      return;
    }

    int nowIndex = playlist.indexWhere((t) => t == nowPlayingTrack);

    int nextIndex = (isRepeat && forceNext == null)
        ? nowIndex
        : playlist.length - 1 != nowIndex
        ? nowIndex + 1
        : 0;
    nowPlayingTrack = playlist[nextIndex];
    trackNotifier.value = nowPlayingTrack;
    trackChangeNotifier.value = TrackChange(
      newTrack: nowPlayingTrack,
      reason: (completed ?? false)
          ? ChangeReason.completed
          : ChangeReason.external,
    );
    // await playerInstance.stop();
    await _playIsPlaying();
    return;
  }

  Future<void> _playIsPlaying() async {
    bool exists = await File(nowPlayingTrack.filepath).exists();
    if (!exists) {
      return;
    }
    if (isPlaying) {
      await _PlayerEngine().play(nowPlayingTrack.filepath);
    }
    // await playerInstance.setSource(DeviceFileSource(nowPlayingTrack.filepath));
    // if (isPlaying) {
    //   await playerInstance.play(DeviceFileSource(nowPlayingTrack.filepath));
    // }
    await _afterFn();
  }

  Future<void> playPrevious() async {
    if (queue.isNotEmpty) {
      nowPlayingTrack = queue.first;
      trackNotifier.value = nowPlayingTrack;
      trackChangeNotifier.value = TrackChange(
        newTrack: nowPlayingTrack,
        reason: ChangeReason.external,
      );
      // await playerInstance.stop();
      await _playIsPlaying();
    }

    int nowIndex = playlist.indexWhere((t) => t == nowPlayingTrack);
    int nextIndex = nowIndex == 0
        ? playlist.length - 1
        : nowIndex > 0
        ? nowIndex - 1
        : 0;
    nowPlayingTrack = playlist[nextIndex];
    trackNotifier.value = nowPlayingTrack;
    trackChangeNotifier.value = TrackChange(
      newTrack: nowPlayingTrack,
      reason: ChangeReason.external,
    );
    // await playerInstance.stop();
    await _playIsPlaying();
  }

  Future<void> playPause(bool play) async {
    playingNotifier.value = play;
    isPlaying = play ? true : false;
    play ? await _PlayerEngine().resume() : await _PlayerEngine().pause();
  }

  Future<void> setVolume(double volume) async {
    volumeNotifier.value = volume;
    await _PlayerEngine().setVolume(volume);
  }

  Future<void> seek(Duration seek) async {
    await _PlayerEngine().seek(seek);
  }

  Future<void> updatePlaylist(List<PlayerTrack> newPlaylist) async {
    playlist = newPlaylist;
    unShuffledPlaylist = newPlaylist;
    playlistNotifier.value = newPlaylist;
  }

  Future<void> insertTrack(
    PlayerTrack track,
    int index, {
    bool shuffleFix = true,
  }) async {
    playlist.insert(index, track);
    if (shuffleFix == true) unShuffledPlaylist.insert(index, track);
    playlistNotifier.value = playlist;
  }

  Future<void> moveTrack(PlayerTrack track, int newIndex) async {
    final index = playlist.indexOf(track);
    if (index == -1) return;
    playlist.removeAt(index);
    playlist.insert(newIndex, track);
    playlistNotifier.value = playlist;
  }

  Future<void> removeTrack(
    PlayerTrack track, {
    bool unshuffleRemove = true,
  }) async {
    playlist.remove(track);
    playlistNotifier.value = playlist;
    if (unshuffleRemove) {
      unShuffledPlaylist.remove(track);
    }
  }

  Future<void> addTracks(List<PlayerTrack> tracks, {PlayerTrack? after}) async {
    after ??= nowPlayingTrack;
    int index = playlist.indexOf(after) + 1;
    if (index == -1) return;
    for (PlayerTrack track in tracks) {
      playlist.insert(index, track);
      index += 1;
    }
    playlistNotifier.value = playlist;
  }

  Future<void> playTemporaryQueue(
    List<PlayerTrack> tracks, {
    bool? startsNow,
    bool? first,
  }) async {
    if (tracks.isEmpty) {
      return;
    }
    _createQueue();
    startsNow ??= false;
    if (first == true) {
      for (PlayerTrack track in tracks.reversed) {
        queue.addFirst(track);
      }
    } else {
      queue.addAll(tracks);
    }
    queue.addFirst(nowPlayingTrack);

    _notifyQueueListeners();
    if (startsNow) {
      await Player.player.playNext(forceNext: true, completed: false);
    }
    return;
  }

  void insertInQueue(PlayerTrack track) {
    _createQueue();
    queue.addFirst(track);
    queue.addFirst(track);
    _notifyQueueListeners();
  }

  void addEndQueue(PlayerTrack track) {
    _createQueue();
    queue.addLast(track);
    _notifyQueueListeners();
  }

  void _createQueue() {
    if (queue.isEmpty) {
      unQueuedLastTrack = nowPlayingTrack;
    }
  }

  Future<void> playNetTrack(String link, PlayerTrack track) async {
    nowPlayingTrack = track;
    trackNotifier.value = nowPlayingTrack;
    trackChangeNotifier.value = TrackChange(
      newTrack: nowPlayingTrack,
      reason: ChangeReason.external,
    );

    await _PlayerEngine().stop();
    await _PlayerEngine().playNet(link);
    await _afterFn();
  }

  Future<void> enableRepeat() async {
    isRepeat = true;
    repeatModeNotifier.value = true;
  }

  Future<void> removeFromQueue(PlayerTrack track) async {
    queue.remove(track);
    _notifyQueueListeners();
  }

  Future<void> disableRepeat() async {
    isRepeat = false;
    repeatModeNotifier.value = false;
  }

  void updatePlaylistInfo(PlaylistInfo info) {
    playlistInfo = info;
  }

  Future<List<PlayerTrack>> shuffle(ShuffleMode? shuffleMode1) async {
    _clearQueue();
    shuffleMode1 ??= ShuffleMode.nowOnTop;
    shuffleMode = shuffleMode1;

    if (isShuffle) {
      return playlist;
    }
    final List<PlayerTrack> newPlaylist;
    isShuffle = true;

    if (!playlist.contains(nowPlayingTrack)) {
      isShuffle = true;
      newPlaylist = Shuffles.full(playlist);
    } else {
      switch (shuffleMode1) {
        case ShuffleMode.afterCurrent:
          newPlaylist = Shuffles.afterCurrent(playlist, nowPlayingTrack);
        case ShuffleMode.full:
          newPlaylist = Shuffles.full(playlist);
        case ShuffleMode.nowOnTop:
          newPlaylist = Shuffles.nowOnTop(playlist, nowPlayingTrack);
      }
    }

    playlist = newPlaylist;
    shuffleModeNotifier.value = true;
    playlistNotifier.value = playlist;
    return playlist;
  }

  /// completely
  void _clearQueue() {
    queue.clear();
    unQueuedLastTrack = null;
    _notifyQueueListeners();
  }

  void clearQueue() {
    queue.clear();
    queue.add(nowPlayingTrack);
    _notifyQueueListeners();
  }

  void _notifyQueueListeners() {
    queueNotifier.value = queue;
  }

  Future<List<PlayerTrack>> unShuffle() async {
    queue.clear();
    isShuffle = false;
    playlist = unShuffledPlaylist;
    shuffleModeNotifier.value = false;
    playlistNotifier.value = playlist;
    return playlist;
  }

  Future<void> playCustom(PlayerTrack track) async {
    if (queue.contains(track)) {
      queue = Queue.from(queue.skipWhile((e) => e != track));
      _notifyQueueListeners();
    } else {
      _clearQueue();
    }
    nowPlayingTrack = track;
    trackNotifier.value = nowPlayingTrack;
    trackChangeNotifier.value = TrackChange(
      newTrack: nowPlayingTrack,
      reason: ChangeReason.external,
    );
    // await playerInstance.stop();
    await _playIsPlaying();
  }

  Future<void> pause() async {
    playingNotifier.value = false;
    await _PlayerEngine().pause();
  }

  Future<void> resume() async {
    playingNotifier.value = true;
    isPlaying = true;
    await _PlayerEngine().resume();
  }

  Future<void> stop() async {
    playingNotifier.value = false;
    await _PlayerEngine().stop();
  }

  Future<void> setSpeed(double sp) async {
    speed = sp;
    await _PlayerEngine().setSpeed(sp);
  }
}

class Shuffles {
  static List<T> nowOnTop<T>(List<T> list, T topValue) {
    list = [...list];
    list.remove(topValue);
    list.shuffle();
    list.insert(0, topValue);
    return list;
  }

  static List<T> full<T>(List<T> list) {
    list = [...list];
    list.shuffle();
    return list;
  }

  static List<T> afterCurrent<T>(List<T> list, T afterValue) {
    list = [...list];
    final currentIndex = list.indexOf(afterValue);
    if (currentIndex == -1) {
      return list;
    }

    final fixedPart = list.sublist(0, currentIndex + 1);
    final queue = list.sublist(currentIndex + 1);
    queue.shuffle();

    return [...fixedPart, ...queue];
  }
}
