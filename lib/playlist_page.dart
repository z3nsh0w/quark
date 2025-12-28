// Flutter packages
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:quark/objects/track.dart';

// Additional packages
import 'package:logging/logging.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:wheel_slider/wheel_slider.dart';
import 'package:animated_expand/animated_expand.dart';
import 'package:animations/animations.dart';

// Local components&modules
import 'player_widget.dart';
import 'playlist_widget.dart';
import '/services/player.dart';
import '/objects/playlist.dart';
import '/widgets/settings.dart';
import '/services/database.dart';
import '/services/net_player.dart';
import '/services/native_control.dart';
import '/widgets/state_indicator.dart';

class PlaylistPage extends StatefulWidget {
  final PlayerPlaylist playlist;
  final YandexMusic yandexMusic;

  const PlaylistPage({
    super.key,
    required this.playlist,
    required this.yandexMusic,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage>
    with TickerProviderStateMixin {
  String currentPosition = '0:00';
  String totalSongDuration = '0:00';

  double volume = 0.5;
  double songProgress = 0.0;
  double transitionSpeed = 1.0;
  double playerSpeed = 1;
  double playerPadding = 0.0;
  Uint8List animationInitiator = Uint8List(0);

  bool settingsView = false;

  bool isSliderActive = true;
  bool isPlaying = false;
  bool isLiked = false;
  bool isPlaylistOpened = false;
  bool isShuffleEnable = false;
  bool isRepeatEnable = false;
  bool stateIndicator = true;
  bool openPlaylistNextTime = false;

  /// Main playlist
  late List<PlayerTrack> currentPlaylist;

  /// Unshuffled playlist
  late List<PlayerTrack> backupPlaylist;

  /// Now playing track
  late PlayerTrack nowPlayingTrack;

  List<String> likedTracks = [];
  final log = Logger('PlaylistPage');

  //
  //
  // Instances
  //
  //

  /// Main Player instance
  late Player player;

  /// Network player instance (shell over the main player class)
  late NetPlayer netPlayer;

  /// NativeControl instance
  late NativeControl nativeControl;

  Color popupIconsColor = const Color.fromARGB(
    255,
    255,
    255,
    255,
  ).withAlpha(170); // TODO: MAKE ACCENT COLORS AS SETTINGS
  Color popupTextColor = Colors.white.withAlpha(220);
  Color albumArtShadowColor = Color.fromARGB(255, 21, 21, 21);
  Color _childrenColor = Colors.blue;
  StateIndicatorOperation operation = StateIndicatorOperation.none;

  InteractiveSliderController positionController = InteractiveSliderController(
    0.0,
  );

  late AnimationController playlistAnimationController;
  late Animation<Offset> playlistOffsetAnimation;
  OverlayEntry? playlistOverlayEntry;

  // EXPANDED btn controller
  final expandController = ExpandController(
    initialValue: ExpandState.collapsed,
  );

  /// The name tells for itself
  Future<int> getSecondsByValue(double value) async {
    final duration = player.durationNotifier.value;

    return ((value / 100.0) * duration.inSeconds).round();
  }

  /// Saving last track from database
  void saveLastTrack() async {
    await Database.setValue(
      DatabaseKeys.lastTrack.value,
      nowPlayingTrack.filepath,
    );
  }

  /// Top function for caching tracks in storage
  void cacheFiles([List<PlayerTrack>? tracks]) {
    tracks ??= [];
    for (int i = -1; i < 2; i++) {
      tracks.add(
        currentPlaylist[(currentPlaylist.indexOf(nowPlayingTrack) + i) %
            currentPlaylist.length],
      );
    }
    for (PlayerTrack track in tracks) {
      if (track is! LocalTrack) {
        _cacheFileInBackground(track);
      }
    }
  }

  /// Function for changing the indicator status
  void showOperation(StateIndicatorOperation newOperation) {
    if (mounted) {
      setState(() => operation = newOperation);
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) setState(() => operation = StateIndicatorOperation.none);
      });
    }
  }

  /// Lower function for caching tracks in storage
  Future<void> _cacheFileInBackground(PlayerTrack track) async {
    String? quality = await Database.getValue(
      DatabaseKeys.yandexMusicTrackQuality.value,
    );
    quality ??= 'mp3';
    AudioQuality downloadQuality = switch (quality) {
      'lossless' => AudioQuality.lossless,
      'nq' => AudioQuality.normal,
      'lq' => AudioQuality.low,
      'mp3' => AudioQuality.mp3,
      _ => AudioQuality.mp3,
    };

    final exists = await File(track.filepath).exists();
    if (!exists) {
      try {
        showOperation(StateIndicatorOperation.loading);
        final download = await widget.yandexMusic.tracks.download(
          (track as YandexMusicTrack).track.id,
          quality: downloadQuality,
        );
        await File(track.filepath).parent.create(recursive: true);
        await File(track.filepath).writeAsBytes(download);
        showOperation(StateIndicatorOperation.success);
      } catch (error) {
        log.shout('''
An error has occured while downloading track
TrackID: ${(track as YandexMusicTrack).track.id}
Filepath: ${track.filepath}
Quality: $quality
YandexMusic client: ${widget.yandexMusic.accountID}
''', error);
        if (mounted) {
          showOperation(StateIndicatorOperation.error);
        }
      }
    }
  }

  /// A convenient shuffle function that is only needed in one place xd
  List<T> shuffleList<T>(List<T> list) {
    final shuffled = List<T>.from(list);
    shuffled.shuffle();
    return shuffled;
  }

  /// Agreement on track removing caused by playlistview
  void removeTrack(PlayerTrack track) async {
    currentPlaylist.remove(track);
    backupPlaylist.remove(track);
    player.updatePlaylist(currentPlaylist);
    updateDatabasePlaylist();
  }

  /// Forced animation playback
  void playAnimation() async {
    /// To play the animation, simply reassign the key variable.
    setState(() {
      animationInitiator = Uint8List(0);
    });
  }

  /// Update database playlist
  void updateDatabasePlaylist() async {
    if (isShuffleEnable) {
      return;
    }
    PlayerPlaylist pl = PlayerPlaylist(
      ownerUid: widget.playlist.ownerUid,
      kind: widget.playlist.kind,
      name: widget.playlist.name,
      tracks: currentPlaylist,
      source: widget.playlist.source,
    );
    Map play = await serializePlaylist(pl);
    await Database.setValue(DatabaseKeys.lastPlaylist.value, play);
  }

  //
  //
  // Playlist interaction functions
  //
  //

  /// Agreement on track relocation caused by playlistview
  void moveTrack(int oldIndex, int newIndex) async {
    final element = currentPlaylist[oldIndex];
    currentPlaylist.remove(element);
    currentPlaylist.insert(
      newIndex < oldIndex ? newIndex : newIndex - 1,
      element,
    );
    await player.updatePlaylist(currentPlaylist);
    updateDatabasePlaylist();
  }

  // TODO: REMOVE THE CRUTCHES
  /// Agreement on track adding caused by playlistview
  int addTrack(
    PlayerTrack track, [
    bool? addToEnd,
    bool? addLikedTrack,
    bool? removeLiked,
  ]) {
    if (addToEnd == null && addLikedTrack == null) {
      currentPlaylist.insert(
        currentPlaylist.indexOf(nowPlayingTrack) + 1,
        track,
      );
      return currentPlaylist.indexOf(nowPlayingTrack) + 1;
    } else if (addLikedTrack != null) {
      if (widget.playlist.name == "Liked") {
        if (!currentPlaylist.contains(track)) {
          currentPlaylist.insert(0, track);
          likedTracks.add((track as YandexMusicTrack).track.id);
          if (track == nowPlayingTrack) {
            setState(() {
              isLiked = false;
            });
          }
          return -56;
        }
        return -1;
      }
      return -2;
    } else if (removeLiked != null) {
      likedTracks.remove((track as YandexMusicTrack).track.id);
      if (track == nowPlayingTrack) {
        setState(() {
          isLiked = false;
        });
      }
      return 0;
    } else if (addToEnd != null) {
      print(5);
      currentPlaylist.add(track);
      return currentPlaylist.indexOf(track);
    } else {
      return -78;
    }
  }

  /// Reaction on playlist button
  void togglePlaylist() async {
    if (isPlaylistOpened) {
      setState(() {
        isPlaylistOpened = false;
        playerPadding = 0.0;
      });
      await playlistAnimationController.reverse();
    } else {
      if (playlistOverlayEntry == null) {
        playlistOverlayEntry = OverlayEntry(
          builder: (context) => PlaylistOverlay(
            playlistAnimationController: playlistAnimationController,
            playlistOffsetAnimation: playlistOffsetAnimation,
            togglePlaylist: togglePlaylist,
            playlist: currentPlaylist,
            playlistName: widget.playlist.name,
            changeTrack: changeTrack,
            yandexMusic: widget.yandexMusic,
            showOperation: showOperation,
            likedPlaylist: likedTracks,
            addNext: addTrack,
            removeTrack: removeTrack,
            moveTrack: moveTrack,
          ),
        );
        Overlay.of(context).insert(playlistOverlayEntry!);
      }

      playlistAnimationController.forward();
      setState(() {
        isPlaylistOpened = true;
        if (MediaQuery.of(context).size.width > 800) {
          playerPadding = 400.0;
        } else {
          playerPadding = 0.0;
        }
      });
    }
  }

  /// Forced playlist update
  void updatePlaylist() async {
    if (isPlaylistOpened) {
      playlistOverlayEntry?.remove();
      playlistOverlayEntry = OverlayEntry(
        builder: (context) => PlaylistOverlay(
          playlistAnimationController: playlistAnimationController,
          playlistOffsetAnimation: playlistOffsetAnimation,
          togglePlaylist: togglePlaylist,
          playlist: currentPlaylist,
          playlistName: widget.playlist.name,
          changeTrack: changeTrack,
          yandexMusic: widget.yandexMusic,
          showOperation: showOperation,
          likedPlaylist: likedTracks,
          addNext: addTrack,
          removeTrack: removeTrack,
          moveTrack: moveTrack,
        ),
      );
      Overlay.of(context).insert(playlistOverlayEntry!);
    }
  }

  //
  //
  // Button's && Slider's functions
  //
  //

  /// Reaction on animation edit buttons
  void setAnimationSpeed(double speed) async {
    setState(() {
      transitionSpeed = speed;
    });
  }

  /// Reaction on repeat button
  void repeatChange() {
    setState(() {
      isRepeatEnable = !isRepeatEnable;
    });
    player.isRepeat = isRepeatEnable;
  }

  /// Reaction on like button
  void likeUnlike() async {
    if (isLiked) {
      try {
        await widget.yandexMusic.usertracks.unlike([
          (nowPlayingTrack as YandexMusicTrack).track.id,
        ]);
        setState(() {
          isLiked = false;
        });
        likedTracks.remove((nowPlayingTrack as YandexMusicTrack).track.id);
        showOperation(StateIndicatorOperation.success);
      } catch (e) {
        log.warning('Failed to send like track POST', e);
        showOperation(StateIndicatorOperation.error);
      }
    } else {
      try {
        await widget.yandexMusic.usertracks.like([
          (nowPlayingTrack as YandexMusicTrack).track.id,
        ]);
        setState(() {
          isLiked = true;
        });
        likedTracks.add((nowPlayingTrack as YandexMusicTrack).track.id);
        addTrack(nowPlayingTrack, null, true);

        showOperation(StateIndicatorOperation.success);
      } catch (e) {
        log.warning('Failed to send unlike track POST', e);
        showOperation(StateIndicatorOperation.error);
      }
    }
  }

  /// Reaction on shuffle button
  void shuffle() async {
    bool enable = !isShuffleEnable;
    List<PlayerTrack> lcpl = [];

    if (enable) {
      backupPlaylist.clear();
      backupPlaylist.addAll([...currentPlaylist]);
      final currentIndex = backupPlaylist.indexOf(nowPlayingTrack);

      if (currentIndex == -1) return;

      final fixedPart = backupPlaylist.sublist(0, currentIndex + 1);
      final queue = backupPlaylist.sublist(currentIndex + 1);
      final shuffledQueue = shuffleList(queue);

      List<PlayerTrack> tcp = []
        ..addAll(fixedPart)
        ..addAll(shuffledQueue);

      await player.updatePlaylist(tcp);
      setState(() {
        currentPlaylist = tcp;
      });
    }

    if (!enable) {
      lcpl = [...backupPlaylist];
      setState(() {
        currentPlaylist = lcpl;
      });
      await player.updatePlaylist(lcpl);
    }
    updatePlaylist();
    setState(() {
      isShuffleEnable = enable;
    });
  }

  /// Reaction on change track buttons
  void changeTrack({
    bool next = false,
    bool previous = false,
    bool playpause = false,
    bool reload = false,
    PlayerTrack? custom,
  }) async {
    // TODO: update
    if (custom != null) {
      setState(() {
        nowPlayingTrack = custom;
      });
      bool exists = await File(custom.filepath).exists();
      if (!exists && custom is! LocalTrack) {
        showOperation(StateIndicatorOperation.loading);
        await netPlayer.playYandex(nowPlayingTrack);
        cacheFiles();
        return;
      } else if (!exists && custom is LocalTrack) {
        showOperation(StateIndicatorOperation.error);
        return;
      }
      await player.playCustom(custom);
    } else if (next) {
      PlayerTrack next =
          currentPlaylist[(currentPlaylist.indexOf(nowPlayingTrack) + 1) %
              currentPlaylist.length];
      setState(() {
        nowPlayingTrack = next;
      });
      bool exists = await File(next.filepath).exists();
      if (!exists && next is! LocalTrack) {
        showOperation(StateIndicatorOperation.loading);
        await netPlayer.playYandex(next);
        cacheFiles();
        return;
      } else if (!exists && next is LocalTrack) {
        showOperation(StateIndicatorOperation.error);
        changeTrack(next: true);
        return;
      }
      await player.playNext(forceNext: true);
    } else if (previous) {
      PlayerTrack next =
          currentPlaylist[(currentPlaylist.indexOf(nowPlayingTrack) - 1) %
              currentPlaylist.length];
      setState(() {
        nowPlayingTrack = next;
      });
      bool exists = await File(next.filepath).exists();
      if (!exists && next is! LocalTrack) {
        showOperation(StateIndicatorOperation.loading);
        await netPlayer.playYandex(next);
        cacheFiles();
        return;
      } else if (!exists && next is LocalTrack) {
        showOperation(StateIndicatorOperation.error);
        changeTrack(previous: true);
        return;
      }
      await player.playPrevious();
    } else if (reload) {
      PlayerTrack next = nowPlayingTrack;
      await player.playCustom(next);
    } else if (playpause) {
      setState(() {
        isPlaying = !isPlaying;
      });

      isPlaying ? await player.player.resume() : await player.player.pause();
      player.isPlaying = isPlaying ? true : false;
    }
    cacheFiles();
    saveLastTrack();
    nativeControl.updateData(nowPlayingTrack);
  }

  /// Reaction on volume interactive slider
  void changeVolume(value) async {
    volume = value;
    await player.setVolume(value);
    await Database.setValue(DatabaseKeys.volume.value, value);
    setState(() {
      volume = value;
    });
  }

  /// Reaction on setting closing button
  void closeSettings() async {
    bool? indicator = await Database.getValue(
      DatabaseKeys.stateIndicatorState.value,
    );
    setState(() {
      settingsView = false;
      if (openPlaylistNextTime) {
        openPlaylistNextTime = false;
        if (!isPlaylistOpened) {
          togglePlaylist();
        }
      }
      stateIndicator = indicator ?? stateIndicator;
    });
  }

  /// Reaction on progress interactive slider
  void updateProgress(value) async {
    setState(() {
      isSliderActive = true;
    });
    try {
      final seconds = await getSecondsByValue(value);
      await player.seek(Duration(seconds: seconds));
    } catch (e) {
      log.warning('Progress update failed ', e);
    }
  }

  /// A function that protects the slider's progress from external changes while the user selects the track position.
  void updateSlider() async {
    setState(() {
      isSliderActive = false;
    });
  }

  //
  //
  // Initializing functions
  //
  //

  /// Load keys from database
  void loadDatabase() async {
    double? dbVolume = await Database.getValue(DatabaseKeys.volume.value);
    double? transition = await Database.getValue(
      DatabaseKeys.transitionSpeed.value,
    );
    bool? indicator = await Database.getValue(
      DatabaseKeys.stateIndicatorState.value,
    );
    dbVolume ??= volume;
    transition ??= transitionSpeed;
    stateIndicator = indicator ?? stateIndicator;

    changeVolume(dbVolume);
    await player.setVolume(dbVolume);
    playAnimation();
    setAnimationSpeed(transition);
  }

  /// Initializing player listeners
  void playerListeners() {
    player.playedNotifier.addListener(() {
      final duration = player.durationNotifier.value;
      final position = player.playedNotifier.value;
      String durationLocal = '';
      double currentPos = 0.0;

      int durationTimeInMinutes = duration.inSeconds ~/ 60;
      int durationTimeInSeconds = duration.inSeconds % 60;

      durationLocal += '$durationTimeInMinutes:';

      if (durationTimeInSeconds < 10) {
        durationLocal += '0$durationTimeInSeconds';
      } else {
        durationLocal += '$durationTimeInSeconds';
      }

      currentPos = position.inMicroseconds / duration.inMicroseconds * 100.0;
      if (currentPos > 100.0) {
        currentPos = 100.0;
      }

      int timeInMinutes = position.inSeconds ~/ 60;
      int timeInSeconds = position.inSeconds % 60;

      String timing = '';

      timing += '$timeInMinutes:';

      if (timeInSeconds < 10) {
        timing += '0$timeInSeconds';
      } else {
        timing += '$timeInSeconds';
      }

      if (mounted) {
        setState(() {
          currentPosition = timing;
          totalSongDuration = durationLocal;
          songProgress = currentPos;
          if (isSliderActive) {
            positionController.value = currentPos / 100;
          }
        });
      }
    });
    player.trackNotifier.addListener(() {
      nowPlayingTrack = player.trackNotifier.value;
      saveLastTrack();
    });
  }

  /// Initializing liked tracks
  void updateLiked() async {
    try {
      List<Track2> result = await widget.yandexMusic.usertracks.getLiked();
      likedTracks.clear();

      for (Track2 track in result) {
        likedTracks.add(track.trackID);
      }
      showOperation(StateIndicatorOperation.success);
    } catch (e) {
      log.warning('Failed to update liked tracks ', e);
      showOperation(StateIndicatorOperation.error);
    }
  }

  /// Restoring last track from database
  void restoreLastTrack() async {
    String? resl = await Database.getValue(DatabaseKeys.lastTrack.value);
    if (resl != null) {
      bool exist = false;
      PlayerTrack? tracks;
      for (PlayerTrack track in currentPlaylist) {
        if (track.filepath == resl) {
          exist = true;
          tracks = track;
          break;
        }
      }
      if (exist) {
        nowPlayingTrack = tracks!;
        bool exists = await File(nowPlayingTrack.filepath).exists();

        if (exists) {
          try {
            log.info('Trying to set source for last track...');
            await player.playCustom(nowPlayingTrack);
          } catch (e) {
            log.shout(
              'Failed to set local source (file exists: $exists). Attempting to set network source...',
            );
            netPlayer.playYandex(nowPlayingTrack);
          }
        } else {
          log.info(
            'The track was NOT found locally. Trying to set network source...',
          );
          netPlayer.playYandex(nowPlayingTrack);
        }
        playAnimation();
      }
    }
  }

  /// Initializing all players
  void initPlayers() async {
    player = Player(
      startVolume: volume,
      playlist: currentPlaylist,
      nowPlayingTrack: nowPlayingTrack,
    );
    log.info('Trying to initialize the player instance...');
    player.init();
    log.fine('Player instance initialized successfully');
    bool exists = await File(nowPlayingTrack.filepath).exists();
    netPlayer = NetPlayer(player: player, yandexMusic: widget.yandexMusic);
    log.info('Trying to set source of track...');
    if (exists) {
      try {
        log.info('The track was found locally. Trying to set source...');
        player.player.setSource(DeviceFileSource(nowPlayingTrack.filepath));
      } catch (e) {
        log.shout(
          'Failed to set local source (file exists: $exists). Attempting to set network source',
        );
        netPlayer.playYandex(nowPlayingTrack);
      }
    } else {
      log.info(
        'The track was NOT found locally. Trying to set network source...',
      );
      netPlayer.playYandex(nowPlayingTrack);
    }
  }

  Widget get _expandedHeader => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: expandController.collapse,
    child: Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(Icons.arrow_back, color: Colors.grey)],
      ),
    ),
  );

  Widget get _collapsedHeader => InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: expandController.expand,
    child: SizedBox(
      width: 35,
      height: 35,
      child: IconButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          expandController.toggle();
        },
        icon: Icon(Icons.more_horiz, color: Colors.grey),
      ),
    ),
  );

  @override
  void initState() {
    // Init playlists

    super.initState();

    currentPlaylist = [...widget.playlist.tracks];
    backupPlaylist = [...widget.playlist.tracks];
    nowPlayingTrack = currentPlaylist[0];
    restoreLastTrack();
    // Classes
    log.info('Trying to initialize players...');
    initPlayers();
    log.info('Trying to initialize database...');
    Database.init();
    log.fine('Database initialized successfully');

    log.info('Trying to initialize native controls...');

    nativeControl = NativeControl(
      onPlay: player.playPause,
      onPause: player.playPause,
      onNext: player.playNext,
      onPrevious: player.playPrevious,
      onSeek: () {},
    );

    nativeControl.init();
    log.fine('Native controls initialized successfully');

    // Controllers

    playlistAnimationController = AnimationController(
      duration: Duration(milliseconds: (650 * transitionSpeed).round()),
      vsync: this,
    );

    playlistOffsetAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: playlistAnimationController,
            curve: Curves.ease,
          ),
        );
    // Update UI

    playerListeners();
    loadDatabase();
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: ${record.time.toIso8601String()}: ${record.message} ${record.error ?? ''}',
      );
    });
    updateLiked();
  }

  @override
  void dispose() {
    player.player.onPositionChanged.drain();
    player.player.stop();
    player.player.dispose();
    player.onCompleteSubscription?.cancel();
    player.onDurationChanged?.cancel();
    player.onPlayedChanged?.cancel();
    player.trackNotifier.dispose();
    player.playedNotifier.dispose();
    player.durationNotifier.dispose();
    playlistAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!isPlaylistOpened) {
      playerPadding = 0.0;
    } else if (size.width > 810 && size.height > 600) {
      playerPadding = 400.0;
    } else if (size.width > 810) {
      playerPadding = 400.0;
    } else {
      playerPadding = 0.0;
    }

    // TODO: SPLIT WIDGETS

    return ClipRect(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: (750 * transitionSpeed).round()),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        (nowPlayingTrack is LocalTrack &&
                            nowPlayingTrack.coverByted != Uint8List(0))
                        ? MemoryImage(nowPlayingTrack.coverByted)
                        : CachedNetworkImageProvider(
                            'https://${nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                          ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(24, 24, 26, 1),
                      Color.fromRGBO(18, 18, 20, 1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipRect(
                  child: AnimatedSwitcher(
                    duration: Duration(
                      milliseconds: (650 * transitionSpeed).round(),
                    ),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: BackdropFilter(
                      key: ValueKey((nowPlayingTrack, animationInitiator)),
                      filter: ImageFilter.blur(sigmaX: 95.0, sigmaY: 95.0),
                      child: Container(
                        color: Colors.transparent,
                        child: AnimatedPadding(
                          duration: Duration(
                            milliseconds: (750 * transitionSpeed).round(),
                          ),
                          curve: Curves.ease,
                          padding: EdgeInsets.only(left: playerPadding),
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                OpenContainer(
                                  closedBuilder: (context, action) {
                                    return Container(
                                      height: 300,
                                      width: 300,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: albumArtShadowColor,
                                            blurRadius: 18,
                                            offset: Offset(1, -1),
                                          ),
                                        ],
                                      ),
                                      child:
                                          (nowPlayingTrack is LocalTrack &&
                                              nowPlayingTrack.coverByted !=
                                                  Uint8List(0))
                                          ? Image.memory(
                                              nowPlayingTrack.coverByted,
                                              height: 270,
                                              width: 270,
                                            )
                                          : CachedNetworkImage(
                                              key: ValueKey<PlayerTrack>(
                                                nowPlayingTrack,
                                              ),

                                              imageUrl:
                                                  'https://${nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                                              progressIndicatorBuilder:
                                                  (
                                                    context,
                                                    url,
                                                    downloadProgress,
                                                  ) =>
                                                      CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress,
                                                        color: Color.fromARGB(
                                                          31,
                                                          255,
                                                          255,
                                                          255,
                                                        ),
                                                      ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              height: 270,
                                              width: 270,
                                            ),
                                    );
                                  },
                                  openBuilder: (context, action) {
                                    ImageProvider<Object> imageProvider;
                                    if (nowPlayingTrack is LocalTrack &&
                                        nowPlayingTrack.coverByted !=
                                            Uint8List(0)) {
                                      imageProvider = MemoryImage(
                                        nowPlayingTrack.coverByted,
                                      );
                                    } else {
                                      imageProvider = CachedNetworkImageProvider(
                                        'https://${nowPlayingTrack.cover.replaceAll('%%', '800x800')}',
                                      );
                                    }

                                    return Stack(
                                      children: [
                                        Positioned.fill(
                                          child: ClipRect(
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 95,
                                                sigmaY: 95,
                                              ), 
                                              child: Container(
                                                color: Colors.black.withOpacity(
                                                  0.5,
                                                ),
                                                child: Image(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        Column(
                                          children: [
                                            SafeArea(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  14,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    icon: const Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                    ),
                                                    splashRadius: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Container(
                                                height: 700,
                                                width: 700,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(1),
                                                      blurRadius: 40,
                                                      spreadRadius: -10,
                                                    ),
                                                  ],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image(
                                                    image: imageProvider,
                                                    height: 700,
                                                    width: 700,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                const SizedBox(height: 20),

                                SizedBox(
                                  height: 45,
                                  child: Text(
                                    key: ValueKey<PlayerTrack>(nowPlayingTrack),
                                    nowPlayingTrack.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'noto',
                                      decoration: TextDecoration.none,
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                Text(
                                  key: ValueKey<PlayerTrack>(nowPlayingTrack),
                                  nowPlayingTrack.albums.join(','),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'noto',
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  nowPlayingTrack.artists.isNotEmpty
                                      ? nowPlayingTrack.artists.join(",")
                                      : 'Unknown artist',
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      200,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 14,
                                    fontFamily: 'noto',
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      currentPosition,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'noto',
                                        fontSize: 15,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),

                                    SizedBox(
                                      width: 325,

                                      child: InteractiveSlider(
                                        controller: positionController,
                                        key: ValueKey<double>(volume),
                                        unfocusedHeight: 5,
                                        focusedHeight: 10,
                                        min: 0.0,
                                        max: 100.0,
                                        onProgressUpdated: (value) {
                                          isSliderActive = true;
                                          updateProgress(value);
                                        },
                                        onFocused: (value) {
                                          updateSlider();
                                        },

                                        brightness: Brightness.light,
                                        initialProgress: songProgress,
                                        iconColor: Colors.white,
                                        gradient: LinearGradient(
                                          colors: [Colors.white, Colors.white],
                                        ),
                                        shapeBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Text(
                                      totalSongDuration,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontFamily: 'noto',

                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),

                                      child: InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
                                          changeTrack(previous: true);
                                        },

                                        child: Container(
                                          height: 40,
                                          width: 40,

                                          decoration: buttonDecoration(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.skip_previous,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),

                                      child: InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
                                          changeTrack(playpause: true);
                                        },

                                        child: Container(
                                          height: 50,
                                          width: 50,

                                          decoration: buttonDecoration(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                isPlaying
                                                    ? Icons.pause
                                                    : Icons.play_arrow,
                                                color: Colors.white,

                                                size: 28,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),

                                      child: InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
                                          changeTrack(next: true);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,

                                          decoration: buttonDecoration(),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.skip_next,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  width: 330,

                                  child: InteractiveSlider(
                                    startIcon: const Icon(Icons.volume_down),
                                    endIcon: const Icon(Icons.volume_up),
                                    min: 0.0,
                                    max: 1.0,
                                    brightness: Brightness.light,
                                    initialProgress: volume,
                                    iconColor: Colors.white,
                                    gradient: LinearGradient(
                                      colors: [Colors.white, Colors.white],
                                    ),
                                    onChanged: (value) => changeVolume(value),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    functionPlayerButton(
                                      Icons.featured_play_list_outlined,
                                      Icons.featured_play_list_outlined,
                                      isPlaylistOpened,
                                      togglePlaylist,
                                    ),
                                    const SizedBox(width: 22),
                                    functionPlayerButton(
                                      Icons.shuffle,
                                      Icons.shuffle_outlined,
                                      isShuffleEnable,
                                      () {
                                        shuffle();
                                      },
                                    ),
                                    const SizedBox(width: 22),
                                    if (nowPlayingTrack is YandexMusicTrack)
                                      functionPlayerButton(
                                        Icons.favorite_outlined,
                                        Icons.favorite_outlined,
                                        isLiked,
                                        () async {
                                          likeUnlike();
                                        },
                                      ),
                                    if (nowPlayingTrack is! YandexMusicTrack)
                                      const SizedBox(width: 35),

                                    const SizedBox(width: 22),
                                    functionPlayerButton(
                                      Icons.repeat_one_outlined,
                                      Icons.repeat_one_outlined,
                                      isRepeatEnable,
                                      () => repeatChange(),
                                    ),
                                    const SizedBox(width: 22),
                                    Material(
                                      color: Color.fromARGB(31, 255, 255, 255),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      child: AnimatedExpand(
                                        duration: Duration(milliseconds: 500),
                                        axis: Axis.horizontal,
                                        controller: expandController,
                                        expandedHeader: _expandedHeader,
                                        collapsedHeader: _collapsedHeader,
                                        onEnd: () {
                                          if (expandController.isCollapsed) {
                                            setState(
                                              () => _childrenColor =
                                                  _childrenColor == Colors.blue
                                                  ? Colors.red
                                                  : Colors.blue,
                                            );
                                          }
                                        },
                                        content: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (Platform.isLinux)
                                              StatefulBuilder(
                                                builder:
                                                    (
                                                      BuildContext context,
                                                      StateSetter setMenuState,
                                                    ) {
                                                      return Row(
                                                        children: [
                                                          Text(
                                                            'Playback speed',
                                                            style: TextStyle(
                                                              color:
                                                                  popupTextColor,
                                                            ),
                                                          ),
                                                          SizedBox(width: 15),
                                                          IconButton(
                                                            onPressed: () async {
                                                              setMenuState(() {
                                                                playerSpeed =
                                                                    playerSpeed -
                                                                    0.1;
                                                              });
                                                              print(
                                                                'Player changed speed to: $playerSpeed',
                                                              );
                                                              await player
                                                                  .player
                                                                  .setPlaybackRate(
                                                                    playerSpeed,
                                                                  );
                                                              setState(() {});
                                                            },
                                                            icon: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  popupIconsColor,
                                                            ),
                                                          ),
                                                          Text(
                                                            playerSpeed
                                                                .toStringAsFixed(
                                                                  1,
                                                                ),
                                                            style: TextStyle(
                                                              color:
                                                                  popupTextColor,
                                                            ),
                                                          ),
                                                          IconButton(
                                                            onPressed: () async {
                                                              setMenuState(() {
                                                                playerSpeed =
                                                                    playerSpeed +
                                                                    0.1;
                                                              });
                                                              await player
                                                                  .player
                                                                  .setPlaybackRate(
                                                                    playerSpeed,
                                                                  );
                                                              print(
                                                                'Player changed speed to: $playerSpeed',
                                                              );
                                                              setState(() {});
                                                            },
                                                            icon: Icon(
                                                              Icons.add,
                                                              color:
                                                                  popupIconsColor,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                              ),

                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  settingsView = true;
                                                  if (isPlaylistOpened) {
                                                    togglePlaylist();
                                                    openPlaylistNextTime = true;
                                                  }
                                                });
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              splashColor: Colors.white24,
                                              highlightColor:
                                                  Colors.transparent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 7,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.settings,
                                                      size: 20,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  playlistAnimationController
                                                      .reverse()
                                                      .then((_) {
                                                        playlistOverlayEntry
                                                            ?.remove();
                                                        playlistOverlayEntry =
                                                            null;
                                                        Navigator.pop(context);
                                                      });
                                                });
                                              },
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              splashColor: Colors.white24,
                                              highlightColor:
                                                  Colors.transparent,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 7,
                                                    ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.exit_to_app,
                                                      size: 20,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (stateIndicator)
                Positioned(
                  top: 15,
                  right: 15,
                  child: StateIndicator(operation: operation),
                ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: settingsView
                    ? GestureDetector(
                        onTap: () => closeSettings(),
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Settings(closeView: closeSettings),
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  onPressed: () => setState(() {
                                    settingsView = false;
                                    if (openPlaylistNextTime) {
                                      openPlaylistNextTime = false;
                                      if (!isPlaylistOpened) {
                                        togglePlaylist();
                                      }
                                    }
                                  }),
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
