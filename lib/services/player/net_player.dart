import 'package:quark/services/database/database.dart';

import 'player.dart';
import 'package:async/async.dart';
import 'package:logging/logging.dart';
import '../database/database_engine.dart';
import 'package:quark/objects/track.dart';
import 'package:yandex_music/yandex_music.dart';

/// A complementary class to the main player, created for network playback of tracks. (SPOTIFY may be added)
class NetPlayer {
  final Player player;

  YandexMusic yandexMusic;

  NetPlayer({required this.player, required this.yandexMusic});

  Future<void> init(YandexMusic instance) async {
    yandexMusic = instance;
    Logger('NetPlayerService').fine('Inited');
  }

  Future<void> playYandex(PlayerTrack track) async {
    try {
      String link = await yandexMusic.tracks.getDownloadLink(
        (track as YandexMusicTrack).track.id,
      );
      await player.playNetTrack(link, track);
    } catch (e) {
      Logger(
        'NetPlayer',
      ).severe('An error has occured while processing online track');
    }
  }
}

/// Controls playback and caching of non-local and non-cached tracks

class NetConductor {
  late final Player _player;
  late final YandexMusic _yandex;

  static final NetConductor _singleton = NetConductor._internal();

  factory NetConductor() {
    return _singleton;
  }

  bool _isInitialized = false;
  bool _isLoading = false;

  NetConductor._internal();

  CancelableOperation? _operation;

  List<String> caching = [];
  PlayerTrack? _lastTrack;

  void init(Player player, YandexMusic yandex) async {
    if (_isInitialized) {
      return;
    }
    _player = player;
    _yandex = yandex;
    _player.trackChangeNotifier.addListener(_onTrackChanged);
    _isInitialized = true;
    Logger('NetConductorSerivce').fine('Inited');
  }

  void _onTrackChanged() async {
    final track = _player.trackNotifier.value;

    if (track == _lastTrack || _isLoading) return;
    _lastTrack = track;
    _isLoading = true;

    await _operation?.cancel();

    if (track is YandexMusicTrack && !await File(track.filepath).exists()) {
      try {
        _operation = CancelableOperation.fromFuture(_getLinkAndPlay(track));
        await _operation!.value;
      } catch (e) {
        Logger('NetConductor').severe('Error: $e');
      }
    }

    _isLoading = false;
    await cacheFiles();
  }

  Future<void> _getLinkAndPlay(PlayerTrack track) async {
    if (_operation?.isCanceled ?? false) return;
    final quality = DatabaseStreamerService().yandexMusicQuality.value;
            AudioQuality downloadQuality = switch (quality) {
        'lossless' => AudioQuality.lossless,
        'nq' => AudioQuality.normal,
        'lq' => AudioQuality.low,
        'mp3' => AudioQuality.normal,
        _ => AudioQuality.normal,
      };
    final link = await _yandex.tracks.getDownloadLink(
      (track as YandexMusicTrack).track.id,
      quality:  downloadQuality
    );
    if (_operation?.isCanceled ?? true) return;
    await _player.playNetTrack(link, track);
  }

  /// Top function for caching tracks in storage
  Future<void> cacheFiles([List<PlayerTrack>? tracks]) async {
    if (tracks == null) {
      tracks = [];
      for (int i = -1; i < 2; i++) {
        tracks.add(
          Player.player.playlist[(Player.player.playlist.indexOf(
                    Player.player.nowPlayingTrack,
                  ) +
                  i) %
              Player.player.playlist.length],
        );
      }
    }
    for (PlayerTrack track in tracks) {
      if (track is! LocalTrack) {
        _cacheFileInBackground(track);
      }
    }
  }

  Future<void> _cacheFileInBackground(PlayerTrack track) async {
    if (caching.contains(track.filepath)) {
      return;
    }
    if (track is YandexMusicTrack) {
    final quality = DatabaseStreamerService().yandexMusicQuality.value;
      AudioQuality downloadQuality = switch (quality) {
        'lossless' => AudioQuality.lossless,
        'nq' => AudioQuality.normal,
        'lq' => AudioQuality.low,
        'mp3' => AudioQuality.normal,
        _ => AudioQuality.normal,
      };
      caching.add(track.filepath);
      try {
        final exists = await File(track.filepath).exists();
        if (!exists) {
          // try {
          final download = await _yandex.tracks.download(
            track.track.id,
            quality: downloadQuality,
          );
          await File(track.filepath).parent.create(recursive: true);
          await File(track.filepath).writeAsBytes(download);
        }
      } catch (e) {
        Logger(
          'NetConductor',
        ).severe('An error has occured while caching online track', e);
      }
    }
  }
}
