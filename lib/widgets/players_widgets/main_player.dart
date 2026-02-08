// Flutter packages
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:quark/objects/track.dart';
import 'package:file_picker/file_picker.dart';

// Additional packages
import 'package:logging/logging.dart';
import 'package:quark/services/files.dart';
import 'package:quark/services/yandex_music_singleton.dart';
import 'package:quark/widgets/yandex_music_integration/yandex_widgets.dart';
// import 'package:quark/widgets/listen_stats.dart';
import 'package:quark/services/cached_images.dart';
// import 'package:quark/services/listen_logger.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:animated_expand/animated_expand.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:window_manager/window_manager.dart';
// import 'package:desktop_multi_window/desktop_multi_window.dart';

// Local components&modules
import '../player_buttons.dart';
import '../../services/player/player.dart';
import '/objects/playlist.dart';
import '/widgets/settings.dart';
import '../playlist/playlist_widget.dart';
import '../../services/player/net_player.dart';
import '/widgets/state_indicator.dart';
import '../../services/database/database_engine.dart';

class MainPlayer extends StatefulWidget {
  final PlayerPlaylist playlist;
  final YandexMusic yandexMusic;

  const MainPlayer({
    super.key,
    required this.playlist,
    required this.yandexMusic,
  });

  @override
  State<MainPlayer> createState() => _MainPlayerState();
}

class _MainPlayerState extends State<MainPlayer> with TickerProviderStateMixin {
  String currentPosition = '0:00';
  String totalSongDuration = '0:00';

  double volume = 0.7;
  double playerSpeed = 1;
  double songProgress = 0.0;
  double playerPadding = 0.0;
  double transitionSpeed = 1;
  // The distance that will be between icons when animatedExpand is open
  double expandedIconGap = 22;

  bool isManuallyOpenedPlaylist = false;
  bool isLiked = false;
  bool isPlaying = false;
  bool settingsView = false;
  bool isSliderActive = true;
  bool stateIndicator = true;
  bool isRepeatEnable = false;
  bool isShuffleEnable = false;
  bool isPlaylistOpened = false;
  bool isYandexUploading = false;
  bool playlistOpeningArea = true;
  bool openPlaylistNextTime = false;
  bool isCompact = false;

  final log = Logger('PlaylistPage');

  List<PlayerTrack> yandexUploadingTracks = [];

  /// Main playlist
  late List<PlayerTrack> currentPlaylist;
  late List<PlayerTrack> backupPlaylist;

  /// Now playing track
  late PlayerTrack nowPlayingTrack;

  Uint8List animationInitiator = Uint8List(0);

  //
  //
  // Instances
  //
  //

  /// Main Player instance
  Player player = Player.player;

  /// Network player instance (shell over the main player class)
  late NetPlayer netPlayer;

  Color popupIconsColor = const Color.fromARGB(
    255,
    255,
    255,
    255,
  ).withAlpha(170); // TODO: MAKE ACCENT COLORS AS SETTINGS
  Color popupTextColor = Colors.white.withAlpha(220);
  Color albumArtShadowColor = Color.fromARGB(255, 21, 21, 21);

  StateIndicatorOperation operation = StateIndicatorOperation.none;

  InteractiveSliderController positionController = InteractiveSliderController(
    0.0,
  );

  final expandController = ExpandController(
    initialValue: ExpandState.collapsed,
  );

  late AnimationController playlistAnimationController;
  late Animation<Offset> playlistOffsetAnimation;
  // OverlayEntry? playlistOverlayEntry;
  OverlayEntry? coverOverlayEntry;
  late AnimationController coverAnimationController;
  late Animation<double> coverDoubleAnimation;

  late final VoidCallback _playingListener;
  late final VoidCallback _playedListener;
  late final VoidCallback _trackListener;
  late final VoidCallback _repeatListener;
  late final VoidCallback _shuffleListener;
  late final VoidCallback _playlistListener;

  /// The name tells for itself
  Future<int> getSecondsByValue(double value) async {
    final duration = player.durationNotifier.value;
    return ((value / 100.0) * duration.inSeconds).round();
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

  /// Agreement on track removing caused by playlistview
  void removeTrack(PlayerTrack track) async {
    currentPlaylist.remove(track);
    backupPlaylist.remove(track);
    player.updatePlaylist(currentPlaylist);
  }

  /// Forced animation playback
  void playAnimation() async {
    /// To play the animation, simply reassign the key variable.
    setState(() {
      animationInitiator = Uint8List(0);
    });
  }

  //
  //
  // Playlist interaction functions
  //
  //

  /// Reaction on playlist button
  Future<void> togglePlaylist() async {
    if (isPlaylistOpened) {
      setState(() {
        isPlaylistOpened = false;
        isManuallyOpenedPlaylist = false;
        playerPadding = 0.0;
      });
      await playlistAnimationController.reverse();
    } else {
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

  void manuallyClosedPlaylist() async {
    await togglePlaylist();
    isManuallyOpenedPlaylist = false;
  }

  void closeFullScreenCover() async {
    coverAnimationController.reverse().then((_) {
      coverOverlayEntry?.remove();
      coverOverlayEntry = null;
    });
  }

  void toggleCover() async {
    if (coverOverlayEntry != null) return;

    coverAnimationController.value = 0.0;
    coverOverlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () => closeFullScreenCover(),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                            padding: EdgeInsets.only(),

                            child: ScaleTransition(
                              scale: coverDoubleAnimation,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final maxWidth = constraints.maxWidth * 0.9;
                                  final maxHeight = constraints.maxHeight * 0.9;
                                  final size = min(
                                    maxWidth,
                                    maxHeight,
                                  ).clamp(270.0, 1200.0);
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOutQuint,
                                    width: size,
                                    height: size,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child:
                                          (nowPlayingTrack is LocalTrack &&
                                              !listEquals(
                                                nowPlayingTrack.coverByted,
                                                Uint8List(0),
                                              ))
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadiusGeometry.circular(
                                                    10,
                                                  ),
                                              child: Image.memory(
                                                nowPlayingTrack.coverByted,
                                                height: 270,
                                                width: 270,
                                              ),
                                            )
                                          : CachedImage(
                                              borderRadius: 15,
                                              coverUri:
                                                  'https://${nowPlayingTrack.cover.replaceAll('%%', '1000x1000')}',
                                              height: 270,
                                              width: 270,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(coverOverlayEntry!);
    coverAnimationController.forward();
  }

  /// Forced playlist update
  void updatePlaylist() async {
    if (isPlaylistOpened) {
    } else {}
  }

  //
  //
  // Button's && Slider's functions
  //
  //

  void uploadTrack(PlayerTrack trackss) async {
    // #TODO: make a button, by clicking which you can upload all tracks to Yandex music
    setState(() {
      yandexUploadingTracks.add(trackss);
    });
    try {
      if (widget.playlist.kind == 0 ||
          widget.playlist.source != PlaylistSource.yandexMusic) {
        return;
      }
      final file = await File(trackss.filepath).readAsBytes();
      String id = await widget.yandexMusic.usertracks.uploadUGCTrack(
        widget.playlist.kind,
        file,
        path.basename(trackss.filepath),
      );
      List<Track> info = await widget.yandexMusic.tracks.getTracks([id]);
      final String trackPath = await getTrackPath(id);
      YandexMusicTrack track = YandexMusicTrack(
        track: info[0],
        title: info[0].title,
        artists: info[0].artists.isNotEmpty
            ? info[0].artists.map((album) => album.title).toList()
            : ['Unknown artist'],
        albums: info[0].albums.isNotEmpty
            ? info[0].albums.map((album) => album.title).toList()
            : ['Unknown album'],
        filepath: trackPath,
      );
      track.cover = info[0].coverUri ?? track.cover;
      final int index = isShuffleEnable
          ? backupPlaylist.indexOf(trackss)
          : currentPlaylist.indexOf(trackss);
      currentPlaylist.remove(trackss);
      backupPlaylist.remove(trackss);
      currentPlaylist.insert(index, track);
      backupPlaylist.insert(index, track);
      await player.updatePlaylist(currentPlaylist);
      if (trackss == nowPlayingTrack) {
        NetConductor().cacheFiles([track]);
        await netPlayer.playYandex(track);
      }
    } catch (e) {
      print('Failed to load local track to Yandex music. Error: $e');
      showOperation(StateIndicatorOperation.error);
    }
  }

  /// Reaction on animation edit buttons
  void setAnimationSpeed(double speed) async {
    setState(() {
      transitionSpeed = speed;
    });
  }

  /// Reaction on like button
  void likeUnlike() async {
    final List<String> likedTrack =
        YandexMusicSingleton.likedTracksNotifier.value;
    final track = (nowPlayingTrack as YandexMusicTrack).track;
    if (likedTrack.contains(track.id)) {
      await YandexMusicSingleton.unlikeTrack(track.id);
    } else {
      await YandexMusicSingleton.likeTrack(track.id);
    }
  }

  /// Reaction on volume interactive slider
  void changeVolume(value) async {
    volume = value;
    await player.setVolume(value);
    await Database.put(DatabaseKeys.volume.value, value);
    setState(() {
      volume = value;
    });
  }

  /// Reaction on setting closing button
  void closeSettings() async {
    bool? indicator = await Database.get(
      DatabaseKeys.stateIndicatorState.value,
    );
    double? transitionSpeed2 = await Database.get(
      DatabaseKeys.transitionSpeed.value,
    );
    bool? playlistArea = await Database.get(
      DatabaseKeys.playlistOpeningArea.value,
    );
    setState(() {
      settingsView = false;
      transitionSpeed = transitionSpeed2 ?? transitionSpeed;
      stateIndicator = indicator ?? stateIndicator;
      playlistOpeningArea = playlistArea ?? playlistOpeningArea;
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
    double? dbVolume = await Database.get(DatabaseKeys.volume.value);
    double? transition = await Database.get(DatabaseKeys.transitionSpeed.value);
    bool? indicator = await Database.get(
      DatabaseKeys.stateIndicatorState.value,
    );
    bool? playlistArea = await Database.get(
      DatabaseKeys.playlistOpeningArea.value,
    );
    dbVolume ??= volume;
    transition ??= transitionSpeed;
    stateIndicator = indicator ?? stateIndicator;
    playlistOpeningArea = playlistArea ?? playlistOpeningArea;
    setState(() {
      playlistOpeningArea = playlistOpeningArea;
    });

    changeVolume(dbVolume);
    await player.setVolume(dbVolume);
    playAnimation();
    setAnimationSpeed(transition);
  }

  /// Initializing player listeners
  void playerListeners() async {
    setState(() {
      isPlaying = player.playingNotifier.value;
      nowPlayingTrack = player.trackNotifier.value;
      isShuffleEnable = player.shuffleModeNotifier.value;
      isRepeatEnable = player.repeatModeNotifier.value;
    });

    _playingListener = () async {
      setState(() {
        isPlaying = player.playingNotifier.value;
      });
    };

    _playedListener = () async {
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
    };
    _trackListener = () async {
      setState(() {
        nowPlayingTrack = player.trackNotifier.value;
      });
    };

    _playlistListener = () async {
      setState(() {
        currentPlaylist = player.playlistNotifier.value;
      });
      updatePlaylist();
    };

    _shuffleListener = () async {
      setState(() {
        isShuffleEnable = player.shuffleModeNotifier.value;
      });
    };

    _repeatListener = () async {
      setState(() {
        isRepeatEnable = player.repeatModeNotifier.value;
      });
    };
  }
  // void showMiniPlayerDialog() async {
  //   final windowController = await WindowController.fromCurrentEngine();

  //   // final arguments = parseArguments(windowController.arguments);
  //   // switch (arguments.type) {
  //   //   case YourArgumentDefinitions.main:
  //   //     runApp(const MainWindow());
  //   //   case YourArgumentDefinitions.sample:
  //   //     runApp(const SampleWindow());
  //   //   // Add more window types as needed
  //   // }

  //   final controller = await WindowController.create(
  //     WindowConfiguration(
  //       hiddenAtLaunch: true,
  //       arguments: 'YOUR_WINDOW_ARGUMENTS_HERE',
  //     ),
  //   );

  //   await controller.show();
  // }

  /// Dispose
  @override
  void initState() {
    // Init playlists

    super.initState();

    currentPlaylist = [...widget.playlist.tracks];
    backupPlaylist = [...widget.playlist.tracks];
    nowPlayingTrack = player.nowPlayingTrack;
    isPlaying = player.isPlaying;
    volume = player.playerInstance.volume;
    netPlayer = NetPlayer(player: player, yandexMusic: widget.yandexMusic);
    NetConductor().init(Player.player, widget.yandexMusic);

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
    coverAnimationController = AnimationController(
      duration: Duration(milliseconds: (500 * transitionSpeed).round()),
      reverseDuration: Duration(milliseconds: (400 * transitionSpeed).round()),
      vsync: this,
    );
    coverDoubleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: coverAnimationController,
        curve: Curves.easeOutQuint,
      ),
    );

    // Update UI
    playerListeners();

    player.playingNotifier.addListener(_playingListener);
    player.playedNotifier.addListener(_playedListener);
    player.trackNotifier.addListener(_trackListener);

    player.playlistNotifier.addListener(_playlistListener);
    player.shuffleModeNotifier.addListener(_shuffleListener);
    player.repeatModeNotifier.addListener(_repeatListener);

    loadDatabase();
    Future.delayed(Duration(milliseconds: 150), () {
      if (MediaQuery.of(context).size.width > 800) {
        togglePlaylist();
        isManuallyOpenedPlaylist = true;
      }
    });
  }

  @override
  void dispose() {
    player.playingNotifier.removeListener(_playingListener);
    player.playedNotifier.removeListener(_playedListener);
    player.trackNotifier.removeListener(_trackListener);
    player.playlistNotifier.removeListener(_playlistListener);
    player.shuffleModeNotifier.removeListener(_shuffleListener);
    player.repeatModeNotifier.removeListener(_repeatListener);
    playlistAnimationController.dispose();
    super.dispose();
  }

  //
  //
  /// WIDGETS
  //
  //

  Widget get _expandedHeader =>
      animatedExpandButton(() => expandController.collapse(), Icons.arrow_back);

  Widget get _collapsedHeader => functionPlayerButton(
    Icons.more_vert,
    Icons.more_vert,
    false,
    () => expandController.toggle(),
    color: Colors.transparent,
  );

  Widget animatedExpandButton(Function() onTap, IconData icon) {
    return InkWell(
      onTap: () async {
        await onTap();
      },
      borderRadius: BorderRadius.circular(30),
      splashColor: Color.fromRGBO(255, 255, 255, 0.5),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Icon(icon, size: 20, color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // WINDOW SIZE LOG
    // print(size);
    final bool isCompactState = size.width <= 400 && size.height <= 300;

    if (isCompactState != isCompact) {
      setState(() {
        isCompact = isCompactState;
      });
    }

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
                            !listEquals(
                              nowPlayingTrack.coverByted,
                              Uint8List(0),
                            ))
                        ? MemoryBytesImageProvider(nowPlayingTrack.coverByted)
                        : CachedImageProvider(
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
                      Color.fromRGBO(24, 24, 26, 1),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => toggleCover(),
                                child:
                                    (nowPlayingTrack is LocalTrack &&
                                        !listEquals(
                                          nowPlayingTrack.coverByted,
                                          Uint8List(0),
                                        ))
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                        child: Image.memory(
                                          nowPlayingTrack.coverByted,
                                          height: 270,
                                          width: 270,
                                        ),
                                      )
                                    : CachedImage(
                                        borderRadius: 10,
                                        coverUri:
                                            'https://${nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                                        height: 270,
                                        width: 270,
                                      ),
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
                              InkWell(
                                onTap:
                                    (nowPlayingTrack is! YandexMusicTrack ||
                                        (nowPlayingTrack as YandexMusicTrack)
                                            .track
                                            .artists
                                            .isEmpty ||
                                        (nowPlayingTrack as YandexMusicTrack)
                                                .track
                                                .artists[0]
                                            is UGCArtist ||
                                        (nowPlayingTrack as YandexMusicTrack)
                                            .track
                                            .albums
                                            .isEmpty)
                                    ? null
                                    : () async {
                                        final track =
                                            nowPlayingTrack as YandexMusicTrack;

                                        showOperation(
                                          StateIndicatorOperation.loading,
                                        );

                                        final album = await widget
                                            .yandexMusic
                                            .albums
                                            .getInfo(track.track.albums[0].id);
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (builder) =>
                                                AlbumInfoWidget(album: album),
                                          ),
                                        );
                                      },
                                child: Text(
                                  key: ValueKey(nowPlayingTrack),
                                  nowPlayingTrack.albums.join(','),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'noto',
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4),
                              InkWell(
                                onTap:
                                    (nowPlayingTrack is! YandexMusicTrack ||
                                        (nowPlayingTrack as YandexMusicTrack)
                                                .track
                                                .trackSource ==
                                            TrackSource.UGC ||
                                        (nowPlayingTrack as YandexMusicTrack)
                                                .track
                                                .artists[0]
                                            is UGCArtist)
                                    ? null
                                    : () async {
                                        final track =
                                            nowPlayingTrack as YandexMusicTrack;

                                        int val = 0;

                                        if (track.track.artists.length > 1) {
                                          final value = await showDialog<int>(
                                            context: context,
                                            builder: (context) => WarningMessage(
                                                messageHeader:
                                                    'Choose an artist',
                                                messageDiscription: '',
                                                buttons: track.track.artists
                                                    .map(
                                                      (toElement) =>
                                                          toElement.title,
                                                    )
                                                    .toList(),
                                              
                                            ),
                                          );

                                          if (value == null) return;
                                          val = value;
                                        }

                                        showOperation(
                                          StateIndicatorOperation.loading,
                                        );

                                        final artist = await widget
                                            .yandexMusic
                                            .artists
                                            .getInfo(track.track.artists[val]);
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (builder) =>
                                                ArtistInfoWidget(
                                                  artist: artist,
                                                ),
                                          ),
                                        );
                                      },

                                child: Text(
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
                                        await Player.player.playPrevious();
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
                                        await Player.player.playPause(
                                          !Player.player.isPlaying,
                                        );
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
                                        await Player.player.playNext(
                                          forceNext: true,
                                        );
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
                                    Icons.list_alt,
                                    Icons.list_alt_outlined,
                                    isPlaylistOpened,
                                    () async {
                                      await togglePlaylist();
                                      if (isPlaylistOpened) {
                                        isManuallyOpenedPlaylist = true;
                                      } else {
                                        isManuallyOpenedPlaylist = false;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    width: expandController.isCollapsed
                                        ? 24
                                        : expandedIconGap,
                                  ),
                                  functionPlayerButton(
                                    Icons.shuffle,
                                    Icons.shuffle_outlined,
                                    isShuffleEnable,
                                    () async => isShuffleEnable
                                        ? await Player.player.unShuffle()
                                        : await Player.player.shuffle(null),
                                  ),
                                  SizedBox(
                                    width: expandController.isCollapsed
                                        ? 24
                                        : expandedIconGap,
                                  ),
                                  if (nowPlayingTrack is YandexMusicTrack)
                                    functionPlayerButton(
                                      Icons.favorite_outlined,
                                      Icons.favorite_outlined,
                                      YandexMusicSingleton
                                          .likedTracksNotifier
                                          .value
                                          .contains(
                                            (nowPlayingTrack
                                                    as YandexMusicTrack)
                                                .track
                                                .id,
                                          ),
                                      () => likeUnlike(),
                                    ),
                                  if (nowPlayingTrack is! YandexMusicTrack &&
                                      widget.playlist.source ==
                                          PlaylistSource.yandexMusic &&
                                      !yandexUploadingTracks.contains(
                                        nowPlayingTrack,
                                      ))
                                    functionPlayerButton(
                                      Icons.cloud_upload,
                                      Symbols.cloud_upload,
                                      false,
                                      () => uploadTrack(nowPlayingTrack),
                                    ),
                                  if ((nowPlayingTrack is! YandexMusicTrack &&
                                          widget.playlist.source !=
                                              PlaylistSource.yandexMusic) ||
                                      (yandexUploadingTracks.contains(
                                        nowPlayingTrack,
                                      )))
                                    const SizedBox(width: 35),

                                  SizedBox(
                                    width: expandController.isCollapsed
                                        ? 24
                                        : expandedIconGap,
                                  ),
                                  functionPlayerButton(
                                    Icons.repeat_one_outlined,
                                    Icons.repeat_one_outlined,
                                    isRepeatEnable,
                                    () async => isRepeatEnable
                                        ? await Player.player.disableRepeat()
                                        : await Player.player.enableRepeat(),
                                  ),
                                  SizedBox(
                                    width: expandController.isCollapsed
                                        ? 24
                                        : expandedIconGap,
                                  ),
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
                                      content: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (Platform.isLinux)
                                            Row(
                                              children: [
                                                animatedExpandButton(() async {
                                                  double speed = player
                                                      .playerInstance
                                                      .playbackRate;
                                                  await player.playerInstance
                                                      .setPlaybackRate(
                                                        speed -= 0.2,
                                                      );
                                                  setState(() {});
                                                }, Symbols.speed_0_75),
                                                animatedExpandButton(() async {
                                                  double speed = player
                                                      .playerInstance
                                                      .playbackRate;
                                                  await player.playerInstance
                                                      .setPlaybackRate(
                                                        speed += 0.2,
                                                      );
                                                  setState(() {});
                                                }, Symbols.speed_1_2),
                                              ],
                                            ),

                                          // if (!Platform.isAndroid)
                                          // animatedExpandButton(
                                          //   () async => await windowManager.setSize(Size(330, 90)),
                                          //   Icons.close_fullscreen,
                                          // ),
                                          animatedExpandButton(() async {
                                            final bool? recursiveFilesAdding =
                                                await Database.get(
                                                  DatabaseKeys
                                                      .recursiveFilesAdding
                                                      .value,
                                                  defaultValue: true,
                                                );

                                            String? selectedDirectory =
                                                await FilePicker.platform
                                                    .getDirectoryPath();
                                            if (selectedDirectory != null) {
                                              List<PlayerTrack>
                                              result = await Files()
                                                  .getFilesFromDirectory(
                                                    directoryPath:
                                                        selectedDirectory,
                                                    recursiveEnable:
                                                        recursiveFilesAdding,
                                                  );
                                              if (result.isNotEmpty) {
                                                currentPlaylist.addAll(result);
                                                backupPlaylist.addAll(result);
                                                await player.updatePlaylist(
                                                  currentPlaylist,
                                                );
                                                updatePlaylist();
                                              }
                                            }
                                          }, Symbols.create_new_folder),

                                          animatedExpandButton(
                                            () => setState(() {
                                              settingsView = true;
                                            }),
                                            Icons.settings,
                                          ),
                                          animatedExpandButton(() async {
                                            await Player.player.stop();
                                            Navigator.pop(context);
                                          }, Icons.exit_to_app),
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
              if (stateIndicator)
                Positioned(
                  top: 15,
                  right: 15,
                  child: StateIndicator(operation: operation),
                ),
              if (playlistOpeningArea)
                Positioned(
                  left: 0,
                  child: MouseRegion(
                    onEnter: (event) {
                      if (isCompact) {
                        return;
                      }
                      if (event.localPosition.dx > 150 &&
                          !isManuallyOpenedPlaylist) {
                        togglePlaylist();
                      } else if (event.localPosition.dx < 100) {
                        togglePlaylist();
                      }
                    },
                    child: SizedBox(
                      height: size.height,
                      width: (isPlaylistOpened && !isManuallyOpenedPlaylist)
                          ? size.width
                          : 50,
                    ),
                  ),
                ),

              Positioned(
                left: 0,
                child: SlideTransition(
                  position: playlistOffsetAnimation,
                  child: PlaylistOverlay(
                    showOperation: showOperation,
                    closePlaylist: () {
                      togglePlaylist();
                    },
                  ),
                ),
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

class WarningMessage extends StatefulWidget {
  final String messageHeader;
  final String messageDiscription;
  final List<String> buttons;

  const WarningMessage({
    super.key,
    required this.messageHeader,
    required this.messageDiscription,
    required this.buttons,
  });

  @override
  State<StatefulWidget> createState() => _WarningMessage();
}

class _WarningMessage extends State<WarningMessage> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(55, 0, 0, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            color: Color.fromARGB(15, 255, 255, 255),
              
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    widget.messageHeader,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (String text in widget.buttons)
                    Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(
                              context,
                            ).pop(widget.buttons.indexOf(text)),
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              width: 250,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  50,
                                  74,
                                  74,
                                  77,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
