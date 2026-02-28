// Flutter packages
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';

// Additional packages
import 'package:logging/logging.dart';
import 'package:quark/services/cached_images.dart';
import 'package:quark/services/yandex_music_singleton.dart';
import 'package:window_manager/window_manager.dart';
import 'package:interactive_slider/interactive_slider.dart';

// Local components&modules
import '../player_buttons.dart';
import '/objects/playlist.dart';
import '../../services/player/player.dart';
import '../../services/database/database_engine.dart';

class MiniPlayerWidget extends StatefulWidget {
  final PlayerPlaylist playlist;

  const MiniPlayerWidget({super.key, required this.playlist});

  @override
  State<MiniPlayerWidget> createState() => _PlaylistPage1State();
}

class _PlaylistPage1State extends State<MiniPlayerWidget>
    with TickerProviderStateMixin {
  String currentPosition = '0:00';
  String totalSongDuration = '0:00';

  double volume = 0.7;
  double playerPadding = 0.0;
  double transitionSpeed = 1;

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

  late final VoidCallback _playingListener;
  late final VoidCallback _trackListener;
  late final VoidCallback _repeatListener;
  late final VoidCallback _shuffleListener;

  /// Forced animation playback
  void playAnimation() async {
    /// To play the animation, simply reassign the key variable.
    setState(() {
      animationInitiator = Uint8List(0);
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
    setState(() {
      volume = value;
    });
  }

  //
  //
  // Initializing functions
  //
  //

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
    volume = player.volumeNotifier.value;

    // Update UI
    playerListeners();

    player.playingNotifier.addListener(_playingListener);
    player.trackNotifier.addListener(_trackListener);
    player.shuffleModeNotifier.addListener(_shuffleListener);
    player.repeatModeNotifier.addListener(_repeatListener);
    playAnimation();
  }

  @override
  void dispose() {
    player.playingNotifier.removeListener(_playingListener);
    player.trackNotifier.removeListener(_trackListener);
    player.shuffleModeNotifier.removeListener(_shuffleListener);
    player.repeatModeNotifier.removeListener(_repeatListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCompact = MediaQuery.of(context).size.width > 350;
    double isCompactPadding = isCompact ? 25 : 18;
    final double buttonSize = (MediaQuery.of(context).size.width * 0.1).clamp(
      30.0,
      40.0,
    );

    ImageProvider<Object> imageProvider;

    if (nowPlayingTrack is LocalTrack &&
        !listEquals(nowPlayingTrack.coverByted, Uint8List(0))) {
      imageProvider = MemoryImage(nowPlayingTrack.coverByted);
    } else {
      imageProvider = CachedImageProvider(
        'https://${nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
      );
    }

    // TODO: SPLIT WIDGETS

    return ClipRect(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: (750 * transitionSpeed).round()),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
            ),
          ),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: (650 * transitionSpeed).round()),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: BackdropFilter(
              key: ValueKey((nowPlayingTrack, animationInitiator)),
              filter: ImageFilter.blur(sigmaX: 95.0, sigmaY: 95.0),
              child: Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 16,
                      left: 12,
                      right: 12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            // RECTANGLE MINI PLAYER SIZE
                            height: 169,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    (nowPlayingTrack is LocalTrack &&
                                            !listEquals(
                                              nowPlayingTrack.coverByted,
                                              Uint8List(0),
                                            ))
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  3,
                                                ),
                                            child: Image.memory(
                                              nowPlayingTrack.coverByted,
                                              height: 48,
                                              width: 48,
                                            ),
                                          )
                                        : CachedImage(
                                            borderRadius: 3,
                                            coverUri:
                                                'https://${nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                                            height: 48,
                                            width: 48,
                                          ),
                                    SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nowPlayingTrack.title,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'noto',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                          Text(
                                            nowPlayingTrack.artists.isNotEmpty
                                                ? nowPlayingTrack.artists.join(
                                                    ', ',
                                                  )
                                                : 'Unknown artist',
                                            style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: 'noto',
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
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
                                    SizedBox(width: 7),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 350),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,

                                    children: [
                                      SizedBox(
                                        height: buttonSize,
                                        width: buttonSize,
                                        child: functionPlayerButton(
                                          Icons.shuffle,
                                          Icons.shuffle_outlined,
                                          isShuffleEnable,
                                          () async => isShuffleEnable
                                              ? await Player.player.unShuffle()
                                              : await Player.player.shuffle(
                                                  null,
                                                ),
                                        ),
                                      ),

                                      Spacer(),

                                      InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
                                          await Player.player.playPrevious();
                                        },

                                        child: Container(
                                          height: buttonSize,
                                          width: buttonSize,

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

                                      Spacer(),
                                      InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
                                          await Player.player.playPause(
                                            !Player.player.isPlaying,
                                          );
                                        },

                                        child: Container(
                                          height: buttonSize + 5,
                                          width: buttonSize + 5,
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
                                      Spacer(),
                                      InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
                                          await Player.player.playNext(
                                            forceNext: true,
                                          );
                                        },
                                        child: Container(
                                          height: buttonSize,
                                          width: buttonSize,
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
                                      Spacer(),
                                      SizedBox(
                                        height: buttonSize,
                                        width: buttonSize,
                                        child: functionPlayerButton(
                                          Icons.repeat_one_outlined,
                                          Icons.repeat_one_outlined,
                                          isRepeatEnable,
                                          () async => isRepeatEnable
                                              ? await Player.player
                                                    .disableRepeat()
                                              : await Player.player
                                                    .enableRepeat(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  width: 250,
                                  height: 30,
                                  child: InteractiveSlider(
                                    padding: EdgeInsets.only(top: 8, bottom: 0),
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

                                DragToMoveArea(
                                  child: Icon(
                                    Icons.drag_handle_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
