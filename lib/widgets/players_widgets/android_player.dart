// Flutter packages
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';
import 'package:file_picker/file_picker.dart';

// Additional packages
import 'package:logging/logging.dart';
import 'package:quark/services/database/database.dart';
import 'package:quark/services/files.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:quark/services/cached_images.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:animated_expand/animated_expand.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// Local components&modules
import '../player_buttons.dart';
import '/objects/playlist.dart';
import '/widgets/settings.dart';
import '/widgets/state_indicator.dart';
import '../../services/player/player.dart';
import '../../services/database/database_engine.dart';
import '../../services/player/net_player.dart';
import '../playlist/playlist_widget_android.dart';

// #TODO:открывание плейлиста по наведению

class AndroidWidget extends StatefulWidget {
  final PlayerPlaylist playlist;
  final YandexMusic yandexMusic;

  const AndroidWidget({
    super.key,
    required this.playlist,
    required this.yandexMusic,
  });

  @override
  State<AndroidWidget> createState() => _PlaylistPage1State();
}

class _PlaylistPage1State extends State<AndroidWidget>
    with TickerProviderStateMixin {
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

  List<String> likedTracks = [];
  List<PlayerTrack> yandexUploadingTracks = [];

  /// Main playlist
  late List<PlayerTrack> currentPlaylist;

  /// Unshuffled playlist
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
  OverlayEntry? playlistOverlayEntry;
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

  /// Agreement on track relocation caused by playlistview
  void moveTrack(int oldIndex, int newIndex) async {
    final element = currentPlaylist[oldIndex];
    currentPlaylist.remove(element);
    currentPlaylist.insert(
      newIndex < oldIndex ? newIndex : newIndex - 1,
      element,
    );
    await player.updatePlaylist(currentPlaylist);
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
  Future<void> togglePlaylist() async {
    if (isPlaylistOpened) {
      setState(() {
        isPlaylistOpened = false;
        isManuallyOpenedPlaylist = false;
        playerPadding = 0.0;
      });
      await playlistAnimationController.reverse();
    } else {
      if (playlistOverlayEntry == null) {
        playlistOverlayEntry = OverlayEntry(
          builder: (context) => AndroidPlaylistOverlay(
            playlistAnimationController: playlistAnimationController,
            playlistOffsetAnimation: playlistOffsetAnimation,
            togglePlaylist: togglePlaylist,
            playlist: currentPlaylist,
            playlistName: widget.playlist.name,
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
                Container(
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
      playlistOverlayEntry?.remove();
      playlistOverlayEntry = OverlayEntry(
        builder: (context) => AndroidPlaylistOverlay(
          playlistAnimationController: playlistAnimationController,
          playlistOffsetAnimation: playlistOffsetAnimation,
          togglePlaylist: manuallyClosedPlaylist,
          playlist: currentPlaylist,
          playlistName: widget.playlist.name,
          yandexMusic: widget.yandexMusic,
          showOperation: showOperation,
          likedPlaylist: likedTracks,
          addNext: addTrack,
          removeTrack: removeTrack,
          moveTrack: moveTrack,
        ),
      );
      Overlay.of(context).insert(playlistOverlayEntry!);
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
      final fileBytes = await File(trackss.filepath).readAsBytes();
      String id = await widget.yandexMusic.usertracks.uploadUGCTrack(
        widget.playlist.kind,
        fileBytes,
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
      updateLiked();
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
    if (likedTracks.contains((nowPlayingTrack as YandexMusicTrack).track.id)) {
      try {
        await widget.yandexMusic.usertracks.unlike([
          (nowPlayingTrack as YandexMusicTrack).track.id,
        ]);
        setState(() {
          likedTracks.remove((nowPlayingTrack as YandexMusicTrack).track.id);
          isLiked = false;
        });
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
          likedTracks.add((nowPlayingTrack as YandexMusicTrack).track.id);
          isLiked = true;
        });
        if (!currentPlaylist.contains(nowPlayingTrack) &&
            widget.playlist.name == 'Liked') {
          currentPlaylist.insert(0, nowPlayingTrack);
          backupPlaylist.insert(0, nowPlayingTrack);
          await player.updatePlaylist(currentPlaylist);
        }

        showOperation(StateIndicatorOperation.success);
      } catch (e) {
        log.warning('Failed to send unlike track POST', e);
        showOperation(StateIndicatorOperation.error);
      }
    }
    print(isLiked);
  }

  /// Reaction on volume interactive slider
  void changeVolume(value) async {
    volume = value;

    await player.setVolume(value);
    setState(() {
      volume = value;
    });
  }

  /// Reaction on setting closing button
  void closeSettings() async {
    setState(() {
      settingsView = false;
      if (openPlaylistNextTime) {
        openPlaylistNextTime = false;
        if (!isPlaylistOpened) {
          togglePlaylist();
        }
      }

    });
  }

  void updateFromDatabase() {
    setState(() {
      volume = Player.player.volumeNotifier.value;
      transitionSpeed = DatabaseStreamerService().transitionSpeed.value;
      stateIndicator = DatabaseStreamerService().stateIndicator.value;
    });

    playAnimation();
    setAnimationSpeed(transitionSpeed);
  }

  void subscribeDatabase() {
    DatabaseStreamerService().all.addListener(updateFromDatabase);
  }

  void unSubscribeDatabase() {
    DatabaseStreamerService().all.removeListener(updateFromDatabase);
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

  /// Initializing player listeners
  void playerListeners() async {
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

  /// Initializing liked tracks
  void updateLiked() async {
    try {
      List<ShortTrack> result = await widget.yandexMusic.usertracks.getLiked();
      likedTracks.clear();

      for (ShortTrack track in result) {
        likedTracks.add(track.trackID);
      }
      showOperation(StateIndicatorOperation.success);
    } catch (e) {
      log.warning('Failed to update liked tracks ', e);
      showOperation(StateIndicatorOperation.error);
    }
  }

  /// Dispose
  @override
  void initState() {
    // Init playlists

    super.initState();

    currentPlaylist = [...widget.playlist.tracks];
    backupPlaylist = [...widget.playlist.tracks];
    nowPlayingTrack = player.nowPlayingTrack;
    isPlaying = player.isPlaying;
    volume = player.volumeNotifier.value;
    netPlayer = NetPlayer(player: player, yandexMusic: widget.yandexMusic);
    NetConductor().init(Player.player, widget.yandexMusic);

    // Controllers

    playlistAnimationController = AnimationController(
      duration: Duration(milliseconds: (650 * transitionSpeed).round()),
      vsync: this,
    );

    playlistOffsetAnimation =
        Tween<Offset>(
          begin: const Offset(0.0, 0.94),
          end: const Offset(0.0, 0.10),
        ).animate(
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

    updateFromDatabase();
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: ${record.time.toIso8601String()}: ${record.message} ${record.error ?? ''}',
      );
    });
    updateLiked();
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

  Widget get _expandedHeader => animatedExpandButton(
    () => expandController.collapse(),
    Icons.radio_button_checked,
  );

  Widget get _collapsedHeader => functionPlayerButtonAndroid(
    Icons.radio_button_off_rounded,
    Icons.radio_button_off_rounded,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 45),

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
                                          height: 350,
                                          width: 350,
                                        ),
                                      )
                                    : CachedImage(
                                        borderRadius: 10,
                                        coverUri:
                                            'https://${nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                                        height: 370,
                                        width: 370,
                                      ),
                              ),

                              const SizedBox(height: 14),

                              Container(
                                child: // ALBUM TEXT
                                Text(
                                  key: ValueKey<PlayerTrack>(nowPlayingTrack),
                                  nowPlayingTrack.albums.join(','),
                                  style: GoogleFonts.lexend(
                                    color: const Color.fromARGB(
                                      200,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 15,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),

                              // ALBUM TEXT
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsetsGeometry.only(
                                            left: 30,
                                          ),
                                          height: 35,
                                          child: Text(
                                            key: ValueKey<PlayerTrack>(
                                              nowPlayingTrack,
                                            ),
                                            nowPlayingTrack.title,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.lexend(
                                              decoration: TextDecoration.none,
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        Container(
                                          padding: EdgeInsetsGeometry.only(
                                            left: 30,
                                          ),
                                          child: Text(
                                            nowPlayingTrack.artists.isNotEmpty
                                                ? nowPlayingTrack.artists.join(
                                                    ",",
                                                  )
                                                : 'Unknown artist',
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.lexend(
                                              color: Colors.white,
                                              fontSize: 18,
                                              decoration: TextDecoration.none,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (nowPlayingTrack is YandexMusicTrack)
                                    Padding(
                                      padding: EdgeInsetsGeometry.only(
                                        top: 30,
                                        right: 30,
                                      ),
                                      child: functionPlayerButtonAndroid(
                                        Icons.favorite_outlined,
                                        Icons.favorite_outlined,
                                        likedTracks.contains(
                                          (nowPlayingTrack as YandexMusicTrack)
                                              .track
                                              .id,
                                        ),
                                        () => likeUnlike(),
                                      ),
                                    ),

                                  if (nowPlayingTrack is! YandexMusicTrack &&
                                      widget.playlist.source ==
                                          PlaylistSource.yandexMusic &&
                                      !yandexUploadingTracks.contains(
                                        nowPlayingTrack,
                                      ))
                                    functionPlayerButtonAndroid(
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
                                    const Spacer(),
                                ],
                              ),

                              SizedBox(height: 10),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width,
                                    height: 15,
                                    child: InteractiveSlider(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
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
                                  Row(
                                    children: [
                                      SizedBox(width: 30, height: 30),
                                      Text(
                                        currentPosition,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'noto',
                                          fontSize: 13,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        totalSongDuration,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontFamily: 'noto',

                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(width: 30, height: 30),
                                    ],
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  functionPlayerButtonAndroid(
                                    Icons.shuffle,
                                    Icons.shuffle_outlined,
                                    isShuffleEnable,
                                    () async => isShuffleEnable
                                        ? await Player.player.unShuffle()
                                        : await Player.player.shuffle(null),
                                  ),
                                  const SizedBox(width: 35),

                                  // PREVIOUS btn
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
                                        height: 55,
                                        width: 55,

                                        decoration: buttonDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.skip_previous,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  // PLAY btn
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),

                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50),
                                      ),
                                      onTap: () async {
                                        await Player.player.playPause(
                                          !Player.player.isPlaying,
                                        );
                                      },

                                      child: Container(
                                        height: 65,
                                        width: 65,

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

                                              size: 32,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  // NEXT btn
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
                                        height: 55,
                                        width: 55,

                                        decoration: buttonDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.skip_next,
                                              color: Colors.white,
                                              size: 26,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 35),

                                  functionPlayerButtonAndroid(
                                    Icons.repeat_one_outlined,
                                    Icons.repeat_one_outlined,
                                    isRepeatEnable,
                                    () async => isRepeatEnable
                                        ? await Player.player.disableRepeat()
                                        : await Player.player.enableRepeat(),
                                  ),
                                ],
                              ),

                              Container(
                                alignment: Alignment.center,
                                height: 80,
                                padding: EdgeInsetsGeometry.only(top: 5),
                                child: AnimatedExpand(
                                  duration: Duration(milliseconds: 500),
                                  axis: Axis.vertical,
                                  controller: expandController,
                                  expandedHeader: _expandedHeader,
                                  collapsedHeader: _collapsedHeader,
                                  content: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      animatedExpandButton(() async {
                                        bool recursiveFilesAdding =
                                            DatabaseStreamerService()
                                                .recursiveFilesAdding
                                                .value;

                                        String? selectedDirectory =
                                            await FilePicker.platform
                                                .getDirectoryPath();
                                        if (selectedDirectory != null) {
                                          List<PlayerTrack> result =
                                              await Files()
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
                                          if (isPlaylistOpened) {
                                            togglePlaylist();
                                            openPlaylistNextTime = true;
                                          }
                                        }),
                                        Icons.settings,
                                      ),
                                      animatedExpandButton(() async {
                                        await Player.player.stop();
                                        setState(() {
                                          playlistAnimationController
                                              .reverse()
                                              .then((_) {
                                                playlistOverlayEntry?.remove();
                                                playlistOverlayEntry = null;
                                                Navigator.pop(context);
                                              });
                                        });
                                      }, Icons.exit_to_app),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 100,
                child: AndroidPlaylistOverlay(
                  playlistAnimationController: playlistAnimationController,
                  playlistOffsetAnimation: playlistOffsetAnimation,
                  togglePlaylist: togglePlaylist,
                  playlist: currentPlaylist,
                  playlistName: widget.playlist.name,
                  yandexMusic: widget.yandexMusic,
                  showOperation: showOperation,
                  likedPlaylist: likedTracks,
                  addNext: addTrack,
                  removeTrack: removeTrack,
                  moveTrack: moveTrack,
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
