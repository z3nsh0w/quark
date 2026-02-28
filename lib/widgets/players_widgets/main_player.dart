// Flutter packages
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

// Additional packages
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:animated_expand/animated_expand.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:quark/services/database/database.dart';

// Local components&modules
import '../player_buttons.dart';
import '../../objects/track.dart';
import '../../services/files.dart';
import '../../widgets/settings.dart';
import '../../objects/playlist.dart';
import '../playlist/playlist_widget.dart';
import '../../services/player/player.dart';
import '../../services/cached_images.dart';
import '../../widgets/state_indicator.dart';
import '../../services/player/net_player.dart';
import '../../services/yandex_music_singleton.dart';
import '../yandex_music_integration/yandex_widgets.dart';
import '../yandex_music_integration/lyrics_playlist_extension.dart';
import '../yandex_music_integration/my_wave_playlist_extension.dart';

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
  double expandedIconGap = Platform.isLinux ? 16 : 24;

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

  bool infoWidget = false;
  bool waveWidget = false;

  final log = Logger('PlaylistPage');

  List<PlayerTrack> yandexUploadingTracks = [];

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

  InteractiveSliderController volumeController = InteractiveSliderController(
    0.6,
  );

  final expandController = ExpandController(
    initialValue: ExpandState.collapsed,
  );

  late AnimationController playlistAnimationController;
  late Animation<Offset> playlistOffsetAnimation;
  OverlayEntry? coverOverlayEntry;
  late AnimationController coverAnimationController;
  late Animation<double> coverDoubleAnimation;

  late final VoidCallback _playingListener;
  late final VoidCallback _playedListener;
  late final VoidCallback _trackListener;
  late final VoidCallback _repeatListener;
  late final VoidCallback _shuffleListener;

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
      YandexMusicTrack track = YandexMusicTrack.fromYMTtoLocalTrack(info[0]);
      await player.removeTrack(trackss);
      if (trackss == nowPlayingTrack) {
        await NetConductor().cacheFiles([track]);
        await netPlayer.playYandex(track);
      }
    } catch (e) {
      print('Failed to load local track to Yandex music. Error: $e');
      showOperation(StateIndicatorOperation.error);
    }
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
    await player.setVolume(value);
  }

  /// Reaction on setting closing button
  void closeSettings() async {
    setState(() {
      settingsView = false;
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

  /// Reaction on animation edit buttons
  void setAnimationSpeed(double speed) async {
    setState(() {
      transitionSpeed = speed;
    });
  }

  void updateFromDatabase() {
    if (!mounted) return;
    setState(() {
      transitionSpeed = DatabaseStreamerService().transitionSpeed.value;
      stateIndicator = DatabaseStreamerService().stateIndicator.value;
      playlistOpeningArea = DatabaseStreamerService().playlistOpeningArea.value;
    });

    setAnimationSpeed(transitionSpeed);
  }

  void subscribeDatabase() {
    DatabaseStreamerService().all.addListener(updateFromDatabase);
  }

  void unSubscribeDatabase() {
    DatabaseStreamerService().all.removeListener(updateFromDatabase);
  }

  /// Initializing player listeners
  void playerListeners() {
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

  /// Dispose
  @override
  void initState() {
    // Init playlists

    super.initState();

    nowPlayingTrack = player.nowPlayingTrack;
    isPlaying = player.isPlaying;
    volume = volumeController.value = player.volumeNotifier.value;
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

    player.shuffleModeNotifier.addListener(_shuffleListener);
    player.repeatModeNotifier.addListener(_repeatListener);

    updateFromDatabase();
    subscribeDatabase();
    Future.delayed(Duration(milliseconds: 150), () {
      if (MediaQuery.of(context).size.width > 800) {
        togglePlaylist();
        isManuallyOpenedPlaylist = true;
      }
    });
    playAnimation();
  }

  @override
  void dispose() {
    player.playingNotifier.removeListener(_playingListener);
    player.playedNotifier.removeListener(_playedListener);
    player.trackNotifier.removeListener(_trackListener);
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
                        ? MemoryImage(nowPlayingTrack.coverByted)
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 32,
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

                                        try {
                                          showOperation(
                                            StateIndicatorOperation.loading,
                                          );

                                          final album = await widget
                                              .yandexMusic
                                              .albums
                                              .getInfo(
                                                track.track.albums[0].id,
                                              );
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (builder) =>
                                                  AlbumInfoWidget(album: album),
                                            ),
                                          );
                                        } catch (e) {
                                          showOperation(
                                            StateIndicatorOperation.error,
                                          );
                                          Logger('MainPlayer').warning(
                                            "Failed to get album info. ID: ${track.track.albums[0].id}",
                                            e,
                                          );
                                        }
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
                                            builder: (context) =>
                                                WarningMessage(
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
                                        try {
                                          final artist = await widget
                                              .yandexMusic
                                              .artists
                                              .getInfo(
                                                track.track.artists[val],
                                              );
                                          Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (builder) =>
                                                  ArtistInfoWidget(
                                                    artist: artist,
                                                  ),
                                            ),
                                          );
                                        } catch (e) {
                                          showOperation(
                                            StateIndicatorOperation.error,
                                          );
                                          Logger('MainPlayer').warning(
                                            "Failed to get album info. ID: ${(track.track.artists[val] as OfficialArtist).id}",
                                            e,
                                          );
                                        }
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

                                  Listener(
                                    onPointerSignal: (pointerSignal) async {
                                      if (pointerSignal is PointerScrollEvent) {
                                        if (pointerSignal.scrollDelta.dy < 0) {
                                          await Player.player.seek(
                                            Player.player.playedNotifier.value +
                                                Duration(seconds: 10),
                                          );
                                        }
                                        if (pointerSignal.scrollDelta.dy > 0) {
                                          Duration dur =
                                              Player
                                                  .player
                                                  .playedNotifier
                                                  .value -
                                              Duration(seconds: 10);
                                          await Player.player.seek(
                                            dur < Duration.zero
                                                ? Duration.zero
                                                : dur,
                                          );
                                        }
                                      }
                                    },
                                    child: SizedBox(
                                      width: 325,

                                      child: InteractiveSlider(
                                        controller: positionController,
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

                                child: Listener(
                                  onPointerSignal: (pointerSignal) async {
                                    if (pointerSignal is PointerScrollEvent) {
                                      if (pointerSignal.scrollDelta.dy < 0) {
                                        setState(() {
                                          volume = min(volume += 0.05, 1);
                                        });
                                        await Player.player.setVolume(volume);
                                        volumeController.value = volume;
                                      }
                                      if (pointerSignal.scrollDelta.dy > 0) {
                                        setState(() {
                                          volume = max(volume -= 0.05, 0);
                                        });
                                        await Player.player.setVolume(volume);
                                        volumeController.value = volume;
                                      }
                                    }
                                  },
                                  child: InteractiveSlider(
                                    controller: volumeController,
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
                                    width:
                                        expandController.isCollapsed ||
                                            !Platform.isLinux
                                        ? 24
                                        : expandedIconGap,
                                  ),
                                  functionPlayerButton(
                                    Icons.shuffle,
                                    Icons.shuffle_outlined,
                                    isShuffleEnable,
                                    () async =>
                                        Player.player.shuffleModeNotifier.value
                                        ? await Player.player.unShuffle()
                                        : await Player.player.shuffle(null),
                                  ),
                                  SizedBox(
                                    width:
                                        expandController.isCollapsed ||
                                            !Platform.isLinux
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
                                    width:
                                        expandController.isCollapsed ||
                                            !Platform.isLinux
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
                                    width:
                                        expandController.isCollapsed ||
                                            !Platform.isLinux
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
                                          // TODO: FIX OVERFLOW
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
                                          animatedExpandButton(() async {
                                            if (Player
                                                .player
                                                .shuffleModeNotifier
                                                .value) {
                                              await Player.player.unShuffle();
                                            }
                                            final bool recursiveFilesAdding =
                                                DatabaseStreamerService()
                                                    .recursiveFilesAdding
                                                    .value;

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
                                                final currentPlaylist =
                                                    List<PlayerTrack>.from(
                                                      Player.player.playlist,
                                                    );
                                                currentPlaylist.insertAll(
                                                  0,
                                                  result,
                                                );
                                                await player.updatePlaylist(
                                                  currentPlaylist,
                                                );
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

              if (nowPlayingTrack is YandexMusicTrack && infoWidget)
                Positioned(
                  left: 0,
                  child: SlideTransition(
                    position: playlistOffsetAnimation,
                    child: LyricsView(
                      showOperation: showOperation,
                      closePlaylist: () {
                        togglePlaylist();
                      },
                      track: (nowPlayingTrack as YandexMusicTrack).track,
                      key: ValueKey(
                        (nowPlayingTrack as YandexMusicTrack).track,
                      ),
                    ),
                  ),
                ),

              // // TODO: MY WAVE
              // if (Player.player.playlistInfo.source == PlaylistSource.yandexMusic && waveWidget)
              //   Positioned(
              //     left: 0,
              //     child: SlideTransition(
              //       position: playlistOffsetAnimation,
              //       child: MyWaveView(
              //         showOperation: showOperation,
              //         closePlaylist: () {
              //           togglePlaylist();
              //         },
              //       ),
              //     ),
              //   ),
              if (isPlaylistOpened)
                Positioned(
                  left: 0,
                  top: 50,
                  child: MarkWidget(
                    children: [
                      MarkItemWidget(
                        icon: Icon(Icons.playlist_play, color: Colors.white),
                        onTap: () => setState(() {
                          waveWidget = false;
                          infoWidget = false;
                        }),
                      ),
                      MarkItemWidget(
                        icon: Icon(Symbols.text_ad, color: Colors.white),
                        onTap: () => setState(() {
                          if ((Player.player.nowPlayingTrack
                                      as YandexMusicTrack)
                                  .track
                                  .trackSource !=
                              TrackSource.UGC) {
                            waveWidget = false;
                            infoWidget = true;
                          }
                        }),
                      ),

                      // // TODO: MY WAVE
                      // MarkItemWidget(
                      //   icon: Icon(Symbols.waves, color: Colors.white),
                      //   onTap: () => setState(() {
                      //     infoWidget = false;
                      //     waveWidget = true;
                      //   }),
                      // ),
                    ],
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

class MarkWidget extends StatelessWidget {
  final double gap;
  final List<MarkItemWidget> children;
  const MarkWidget({super.key, required this.children, this.gap = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class MarkItemWidget extends Widget {
  final Icon icon;
  final VoidCallback? onTap;
  const MarkItemWidget({super.key, required this.icon, this.onTap});

  @override
  MarkElement createElement() => MarkElement(this);
}

class MarkElement extends ComponentElement {
  MarkElement(MarkItemWidget super.widget);

  @override
  MarkItemWidget get widget => super.widget as MarkItemWidget;

  bool _hovered = false;

  @override
  Widget build() {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
          child: MouseRegion(
            onEnter: (event) {
              _hovered = true;
              markNeedsBuild();
            },
            onExit: (event) {
              _hovered = false;
              markNeedsBuild();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _hovered ? 30 : 10,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: InkWell(
                onTap: widget.onTap,
                child: _hovered ? widget.icon : null,
              ),
            ),
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
  final int transparency;
  final Color color;
  final Color? borderColor;

  const WarningMessage({
    super.key,
    required this.messageHeader,
    required this.messageDiscription,
    required this.buttons,
    this.transparency = 15,
    this.color = Colors.white,
    this.borderColor,
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
                color: widget.borderColor ?? Colors.white.withOpacity(0.2),
                width: 1,
              ),
              color: widget.color.withAlpha(widget.transparency),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
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
                                  color: const Color.fromARGB(50, 74, 74, 77),
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
      ),
    );
  }
}
