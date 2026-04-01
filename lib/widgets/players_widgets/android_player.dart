// Flutter packages
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/cupertino.dart';
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
import 'package:quark/services/yandex_music_singleton.dart';
import 'package:quark/widgets/players_widgets/main_player.dart';
import 'package:quark/widgets/players_widgets/slider_widget.dart';
import 'package:quark/widgets/playlist/playlist_widget.dart';
import 'package:quark/widgets/yandex_music_integration/yandex_widgets.dart';
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
import '../../services/player/net_player.dart';

class AndroidWidget extends StatefulWidget {
  const AndroidWidget({
    super.key,
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

  bool isLiked = false;
  bool isPlaying = false;
  bool settingsView = false;
  bool isSliderActive = true;
  bool stateIndicator = true;
  bool isRepeatEnable = false;
  bool isShuffleEnable = false;
  bool isPlaylistOpened = false;
  bool isYandexUploading = false;
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

  Color popupIconsColor = const Color.fromARGB(
    255,
    255,
    255,
    255,
  ).withAlpha(170); // TODO: MAKE ACCENT COLORS AS SETTINGS
  Color popupTextColor = Colors.white.withAlpha(220);
  Color albumArtShadowColor = Color.fromARGB(255, 21, 21, 21);

  StateIndicatorOperation operation = StateIndicatorOperation.none;

  final expandController = ExpandController(
    initialValue: ExpandState.collapsed,
  );

  OverlayEntry? coverOverlayEntry;
  late AnimationController coverAnimationController;
  late Animation<double> coverDoubleAnimation;

  late final VoidCallback _playingListener;
  late final VoidCallback _trackListener;
  late final VoidCallback _repeatListener;
  late final VoidCallback _shuffleListener;
  late final VoidCallback _playlistListener;

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

  //
  //
  // Button's && Slider's functions
  //
  //

  // void uploadTrack(PlayerTrack trackss) async {
  //   // #TODO: make a button, by clicking which you can upload all tracks to Yandex music
  //   setState(() {
  //     yandexUploadingTracks.add(trackss);
  //   });
  //   try {
  //     if (widget.playlist.kind == 0 ||
  //         widget.playlist.source != PlaylistSource.yandexMusic) {
  //       return;
  //     }
  //     final fileBytes = await File(trackss.filepath).readAsBytes();
  //     String id = await widget.yandexMusic.usertracks.uploadUGCTrack(
  //       widget.playlist.kind,
  //       fileBytes,
  //       path.basename(trackss.filepath),
  //     );
  //     List<Track> info = await widget.yandexMusic.tracks.getTracks([id]);
  //     final String trackPath = await getTrackPath(id);
  //     YandexMusicTrack track = YandexMusicTrack(
  //       track: info[0],
  //       title: info[0].title,
  //       artists: info[0].artists.isNotEmpty
  //           ? info[0].artists.map((album) => album.title).toList()
  //           : ['Unknown artist'],
  //       albums: info[0].albums.isNotEmpty
  //           ? info[0].albums.map((album) => album.title).toList()
  //           : ['Unknown album'],
  //       filepath: trackPath,
  //     );
  //     track.cover = info[0].coverUri ?? track.cover;
  //     final int index = isShuffleEnable
  //         ? backupPlaylist.indexOf(trackss)
  //         : currentPlaylist.indexOf(trackss);
  //     currentPlaylist.remove(trackss);
  //     backupPlaylist.remove(trackss);
  //     currentPlaylist.insert(index, track);
  //     backupPlaylist.insert(index, track);
  //     await player.updatePlaylist(currentPlaylist);
  //     if (trackss == nowPlayingTrack) {
  //       await NetConductor().cacheFiles([track]);
  //       await NetConductor().playYandex(track);
  //     }
  //   } catch (e) {
  //     print('Failed to load local track to Yandex music. Error: $e');
  //     showOperation(StateIndicatorOperation.error);
  //   }
  // }

  /// Reaction on animation edit buttons
  void setAnimationSpeed(double speed) async {
    setState(() {
      transitionSpeed = speed;
    });
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

    _trackListener = () async {
      setState(() {
        nowPlayingTrack = player.trackNotifier.value;
      });
    };

    _playlistListener = () async {
      setState(() {
        currentPlaylist = player.playlistNotifier.value;
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
    volume = player.volumeNotifier.value;

    // Controllers

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
  }

  @override
  void dispose() {
    player.playingNotifier.removeListener(_playingListener);
    player.trackNotifier.removeListener(_trackListener);
    player.playlistNotifier.removeListener(_playlistListener);
    player.shuffleModeNotifier.removeListener(_shuffleListener);
    player.repeatModeNotifier.removeListener(_repeatListener);
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

    // TODO: SPLIT WIDGETS
print("1");
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
              AnimatedSwitcher(
                duration: Duration(
                  milliseconds: (650 * transitionSpeed).round(),
                ),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  fit: StackFit.expand,
                  children: [
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                ),
                child:
                    (nowPlayingTrack is LocalTrack &&
                        !listEquals(nowPlayingTrack.coverByted, Uint8List(0)))
                    ? ColorFiltered(
                        key: ValueKey(nowPlayingTrack.filepath),
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                        child: CachedBlurredImageFromBytes(
                          key: ValueKey(nowPlayingTrack.filepath),
                          bytes: nowPlayingTrack.coverByted,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ColorFiltered(
                        key: ValueKey(nowPlayingTrack.cover),
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                        child: CachedBlurredNetworkImage(
                          key: ValueKey(nowPlayingTrack.cover),

                          coverUri:
                              'https://${nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
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
                    child: Container(
                      key: ValueKey((nowPlayingTrack, animationInitiator)),
                      color: Colors.transparent,
                      child: AnimatedPadding(
                        duration: Duration(
                          milliseconds: (750 * transitionSpeed).round(),
                        ),
                        curve: Curves.ease,
                        padding: EdgeInsets.only(left: playerPadding),
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.trackpad,
                            },
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight:
                                        MediaQuery.of(context).size.height - 20,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                    BorderRadiusGeometry.circular(
                                                      10,
                                                    ),
                                                child: Image.memory(
                                                  nowPlayingTrack.coverByted,
                                                  height: 350,
                                                  width: 350,
                                                ),
                                              )
                                            : CachedImage(
                                                borderRadius: 10,
                                                coverUri:
                                                    'https://${nowPlayingTrack.cover.replaceAll('%%', '600x600')}',
                                                height: 370,
                                                width: 370,
                                              ),
                                      ),

                                      const SizedBox(height: 14),

                                      InkWell(
                                        onTap:
                                            (nowPlayingTrack
                                                    is! YandexMusicTrack ||
                                                (nowPlayingTrack
                                                        as YandexMusicTrack)
                                                    .track
                                                    .artists
                                                    .isEmpty ||
                                                (nowPlayingTrack
                                                            as YandexMusicTrack)
                                                        .track
                                                        .artists[0]
                                                    is UGCArtist ||
                                                (nowPlayingTrack
                                                        as YandexMusicTrack)
                                                    .track
                                                    .albums
                                                    .isEmpty)
                                            ? null
                                            : () async {
                                                final track =
                                                    nowPlayingTrack
                                                        as YandexMusicTrack;

                                                try {
                                                  showOperation(
                                                    StateIndicatorOperation
                                                        .loading,
                                                  );

                                                  final album =
                                                      await YandexMusicSingleton.getAlbumInfo(
                                                        track
                                                            .track
                                                            .albums[0]
                                                            .id,
                                                      );
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      maintainState: false,

                                                      builder: (builder) =>
                                                          AlbumInfoWidget(
                                                            album: album,
                                                          ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  showOperation(
                                                    StateIndicatorOperation
                                                        .error,
                                                  );
                                                  Logger('MainPlayer').warning(
                                                    "Failed to get album info. ID: ${track.track.albums[0].id}",
                                                    e,
                                                  );
                                                }
                                              },
                                        child: // ALBUM TEXT
                                        Text(
                                          key: ValueKey<PlayerTrack>(
                                            nowPlayingTrack,
                                          ),
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

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap:
                                                      (nowPlayingTrack
                                                              is! YandexMusicTrack ||
                                                          (nowPlayingTrack
                                                                  as YandexMusicTrack)
                                                              .track
                                                              .artists
                                                              .isEmpty ||
                                                          (nowPlayingTrack
                                                                      as YandexMusicTrack)
                                                                  .track
                                                                  .artists[0]
                                                              is UGCArtist ||
                                                          (nowPlayingTrack
                                                                  as YandexMusicTrack)
                                                              .track
                                                              .albums
                                                              .isEmpty)
                                                      ? null
                                                      : () async {
                                                          final track =
                                                              nowPlayingTrack
                                                                  as YandexMusicTrack;

                                                          try {
                                                            showOperation(
                                                              StateIndicatorOperation
                                                                  .loading,
                                                            );

                                                            final album =
                                                                await YandexMusicSingleton.getAlbumInfo(
                                                                  track
                                                                      .track
                                                                      .albums[0]
                                                                      .id,
                                                                );
                                                            Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                maintainState:
                                                                    false,

                                                                builder: (builder) =>
                                                                    AlbumInfoWidget(
                                                                      album:
                                                                          album,
                                                                    ),
                                                              ),
                                                            );
                                                          } catch (e) {
                                                            showOperation(
                                                              StateIndicatorOperation
                                                                  .error,
                                                            );
                                                            Logger(
                                                              'MainPlayer',
                                                            ).warning(
                                                              "Failed to get album info. ID: ${track.track.albums[0].id}",
                                                              e,
                                                            );
                                                          }
                                                        },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsetsGeometry.only(
                                                          left: 30,
                                                        ),
                                                    height: 35,
                                                    child: Text(
                                                      key:
                                                          ValueKey<PlayerTrack>(
                                                            nowPlayingTrack,
                                                          ),
                                                      nowPlayingTrack.title,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.lexend(
                                                        decoration:
                                                            TextDecoration.none,
                                                        color: Colors.white,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                InkWell(
                                                  onTap:
                                                      (nowPlayingTrack
                                                              is! YandexMusicTrack ||
                                                          (nowPlayingTrack
                                                                      as YandexMusicTrack)
                                                                  .track
                                                                  .trackSource ==
                                                              TrackSource.UGC ||
                                                          (nowPlayingTrack
                                                                      as YandexMusicTrack)
                                                                  .track
                                                                  .artists[0]
                                                              is UGCArtist)
                                                      ? null
                                                      : () async {
                                                          final track =
                                                              nowPlayingTrack
                                                                  as YandexMusicTrack;

                                                          int val = 0;

                                                          if (track
                                                                  .track
                                                                  .artists
                                                                  .length >
                                                              1) {
                                                            final value = await showDialog<int>(
                                                              context: context,
                                                              builder: (context) => WarningMessage(
                                                                messageHeader:
                                                                    'Choose an artist',
                                                                messageDiscription:
                                                                    '',
                                                                buttons: track
                                                                    .track
                                                                    .artists
                                                                    .map(
                                                                      (
                                                                        toElement,
                                                                      ) => toElement
                                                                          .title,
                                                                    )
                                                                    .toList(),
                                                              ),
                                                            );

                                                            if (value == null)
                                                              return;
                                                            val = value;
                                                          }

                                                          showOperation(
                                                            StateIndicatorOperation
                                                                .loading,
                                                          );
                                                          try {
                                                            final artist =
                                                                await YandexMusicSingleton.getArtistInfo(
                                                                  (track.track.artists[val]
                                                                          as OfficialArtist)
                                                                      .id,
                                                                );
                                                            Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                maintainState:
                                                                    false,

                                                                builder: (builder) =>
                                                                    ArtistInfoWidget(
                                                                      artist:
                                                                          artist!,
                                                                    ),
                                                              ),
                                                            );
                                                          } catch (e) {
                                                            showOperation(
                                                              StateIndicatorOperation
                                                                  .error,
                                                            );
                                                            Logger(
                                                              'MainPlayer',
                                                            ).warning(
                                                              "Failed to get album info. ID: ${(track.track.artists[val] as OfficialArtist).id}",
                                                              e,
                                                            );
                                                          }
                                                        },

                                                  child: Container(
                                                    padding:
                                                        EdgeInsetsGeometry.only(
                                                          left: 30,
                                                        ),
                                                    child: Text(
                                                      nowPlayingTrack
                                                              .artists
                                                              .isNotEmpty
                                                          ? nowPlayingTrack
                                                                .artists
                                                                .join(",")
                                                          : 'Unknown artist',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.lexend(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          if (nowPlayingTrack
                                              is YandexMusicTrack)
                                            Padding(
                                              padding: EdgeInsetsGeometry.only(
                                                top: 30,
                                                right: 30,
                                              ),
                                              child: functionPlayerButtonAndroid(
                                                Icons.favorite_outlined,
                                                Icons.favorite_outlined,
                                                likedTracks.contains(
                                                  (nowPlayingTrack
                                                          as YandexMusicTrack)
                                                      .track
                                                      .id,
                                                ),
                                                () async =>
                                                    likedTracks.contains(
                                                      (nowPlayingTrack
                                                              as YandexMusicTrack)
                                                          .track
                                                          .id,
                                                    )
                                                    ? await YandexMusicSingleton.likeTrack(
                                                        (nowPlayingTrack
                                                                as YandexMusicTrack)
                                                            .track
                                                            .id,
                                                      )
                                                    : await YandexMusicSingleton.unlikeTrack(
                                                        (nowPlayingTrack
                                                                as YandexMusicTrack)
                                                            .track
                                                            .id,
                                                      ),
                                              ),
                                            ),

                                          // if (nowPlayingTrack
                                          //         is! YandexMusicTrack &&
                                          //     Player.player.playlistInfo.source ==
                                          //         PlaylistSource.yandexMusic &&
                                          //     !yandexUploadingTracks.contains(
                                          //       nowPlayingTrack,
                                          //     ))
                                          //   functionPlayerButtonAndroid(
                                          //     Icons.cloud_upload,
                                          //     Symbols.cloud_upload,
                                          //     false,
                                          //     () =>
                                          //         uploadTrack(nowPlayingTrack),
                                          //   ),
                                          // if ((nowPlayingTrack
                                          //             is! YandexMusicTrack &&
                                          //         widget.playlist.source !=
                                          //             PlaylistSource
                                          //                 .yandexMusic) ||
                                          //     (yandexUploadingTracks.contains(
                                          //       nowPlayingTrack,
                                          //     )))
                                          //   const Spacer(),
                                        ],
                                      ),

                                      SizedBox(height: 10),

                                      ProgressWidget(
                                        timings: true,
                                        interactiveWidth:
                                            MediaQuery.of(context).size.width -
                                            100,
                                      ),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          functionPlayerButtonAndroid(
                                            Icons.shuffle,
                                            Icons.shuffle_outlined,
                                            isShuffleEnable,
                                            () async => isShuffleEnable
                                                ? await Player.player
                                                      .unShuffle()
                                                : await Player.player.shuffle(
                                                    null,
                                                  ),
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
                                                await Player.player
                                                    .playPrevious();
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
                                                ? await Player.player
                                                      .disableRepeat()
                                                : await Player.player
                                                      .enableRepeat(),
                                          ),
                                        ],
                                      ),

                                      Container(
                                        alignment: Alignment.center,
                                        height: 80,
                                        padding: EdgeInsetsGeometry.only(
                                          top: 5,
                                        ),
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
                                                  List<PlayerTrack>
                                                  result = await Files()
                                                      .getFilesFromDirectory(
                                                        directoryPath:
                                                            selectedDirectory,
                                                        recursiveEnable:
                                                            recursiveFilesAdding,
                                                      );
                                                  if (result.isNotEmpty) {
                                                    currentPlaylist.addAll(
                                                      result,
                                                    );
                                                    backupPlaylist.addAll(
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
                                              }, Icons.exit_to_app),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 600,
                                  child: PlaylistOverlay(
                                    closePlaylist: () {},
                                    background: false,
                                    reordable: false,
                                    width: MediaQuery.of(context).size.width,
                                    showOperation: showOperation,
                                    borderRadiusGeometry:
                                        const BorderRadius.all(
                                          Radius.circular(15),
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
              ),

              // Positioned(
              //   child: PlaylistOverlay(
              //     closePlaylist: () {},
              //     width: MediaQuery.of(context).size.width,
              //     showOperation: showOperation,
              //     borderRadiusGeometry: const BorderRadius.all(
              //       Radius.circular(15),
              //     ),
              //   ),
              // ),
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
