// Flutter packages
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';

// Additional packages
import 'package:logging/logging.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:animated_expand/animated_expand.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:window_manager/window_manager.dart';
// Local components&modules
import '../player_widget.dart';
import '/services/player.dart';
import '/objects/playlist.dart';
import '../services/database_engine.dart';
import '/services/net_player.dart';
import '/widgets/state_indicator.dart';


class MiniPlayerWidget extends StatefulWidget {
  final PlayerPlaylist playlist;
  final YandexMusic yandexMusic;

  const MiniPlayerWidget({
    super.key,
    required this.playlist,
    required this.yandexMusic,
  });

  @override
  State<MiniPlayerWidget> createState() => _PlaylistPage1State();
}

class _PlaylistPage1State extends State<MiniPlayerWidget>
    with TickerProviderStateMixin {
  String currentPosition = '0:00';
  String totalSongDuration = '0:00';

  double volume = 0.7;
  double songProgress = 0.0;
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

  /// The name tells for itself
  Future<int> getSecondsByValue(double value) async {
    final duration = player.durationNotifier.value;
    return ((value / 100.0) * duration.inSeconds).round();
  }

  /// Saving last track from database
  void saveLastTrack() async {
    await Database.put(DatabaseKeys.lastTrack.value, nowPlayingTrack.filepath);
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
    await Database.put(DatabaseKeys.lastPlaylist.value, play);
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
      String id = await widget.yandexMusic.usertracks.uploadUGCTrack(
        widget.playlist.kind,
        File(trackss.filepath),
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
      updateDatabasePlaylist();
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
          updateDatabasePlaylist();
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
    await Database.put(DatabaseKeys.volume.value, value);
    setState(() {
      volume = value;
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
      DatabaseKeys.stateIndicatorState.value,
    );
    dbVolume ??= volume;
    transition ??= transitionSpeed;
    stateIndicator = indicator ?? stateIndicator;
    playlistOpeningArea = playlistArea ?? playlistOpeningArea;

    changeVolume(dbVolume);
    await player.setVolume(dbVolume);
    playAnimation();
  }

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
      saveLastTrack();
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
    player.shuffleModeNotifier.addListener(_shuffleListener);
    player.repeatModeNotifier.addListener(_repeatListener);

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
    player.playingNotifier.removeListener(_playingListener);
    player.playedNotifier.removeListener(_playedListener);
    player.trackNotifier.removeListener(_trackListener);
    playlistAnimationController.dispose();
    super.dispose();
  }

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
    if (!isPlaylistOpened) {
      playerPadding = 0.0;
    } else if (size.width > 810 && size.height > 600) {
      playerPadding = 400.0;
    } else if (size.width > 810) {
      playerPadding = 400.0;
    } else {
      playerPadding = 0.0;
    }

    bool isCompact = MediaQuery.of(context).size.width > 350;
    double isCompactPadding = isCompact ? 25 : 18; 

    ImageProvider<Object> imageProvider;
    if (nowPlayingTrack is LocalTrack &&
        nowPlayingTrack.coverByted != Uint8List(0)) {
      imageProvider = MemoryImage(nowPlayingTrack.coverByted);
    } else {
      imageProvider = CachedNetworkImageProvider(
        'https://${nowPlayingTrack.cover.replaceAll('%%', '700x700')}',
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
                                    if (nowPlayingTrack is LocalTrack &&
                                        nowPlayingTrack.coverByted !=
                                            Uint8List(0))
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.memory(
                                          nowPlayingTrack.coverByted,
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://${nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                                Icons.music_note,
                                                size: 24,
                                                color: Colors.grey[500],
                                              ),
                                        ),
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
                                        likedTracks.contains(
                                          (nowPlayingTrack as YandexMusicTrack)
                                              .track
                                              .id,
                                        ),
                                        () => likeUnlike(),
                                      ),
                                    SizedBox(width: 7),
                                  ],
                                ),

                                const SizedBox(height: 10),
                                
                                AnimatedContainer(
                                  duration: Duration(milliseconds: 1000),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                     AnimatedContainer(
                                        duration: Duration(milliseconds: 600),
                                        height: isCompact ? 40 : 30,
                                        width: isCompact ? 40 : 30,
                                        child: functionPlayerButton(
                                          Icons.shuffle,
                                          Icons.shuffle_outlined,
                                          isShuffleEnable,
                                          () async => isShuffleEnable ? await Player.player.unShuffle() : await Player.player.shuffle(null),
                                        ),
                                      ),

                                      AnimatedPadding(padding: EdgeInsetsGeometry.only(right: isCompactPadding), duration: Duration(milliseconds: 1000), curve: Curves.ease,),

                                      // SizedBox(width: isCompact ? 32 : 18 ),
                                      InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
                                          await Player.player.playPrevious();
                                        },

                                        child: AnimatedContainer(
                                        duration: Duration(milliseconds: 600),
                                        height: isCompact ? 40 : 30,
                                        width: isCompact ? 40 : 30,

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

                                      AnimatedPadding(padding: EdgeInsetsGeometry.only(right: isCompactPadding), duration: Duration(milliseconds: 1000)),

                                      InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
                                          await Player.player.playPause(!Player.player.isPlaying);
                                        },

                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 600),
                                          height: isCompact ? 45 : 35,
                                          width: isCompact ? 45 : 35,

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

                                      AnimatedPadding(padding: EdgeInsetsGeometry.only(right: isCompactPadding), duration: Duration(milliseconds: 1000)),

                                      InkWell(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                        onTap: () async {
await Player.player.playNext(forceNext: true);
                                        },
                                        child: AnimatedContainer(
                                        duration: Duration(milliseconds: 600),
                                        height: isCompact ? 40 : 30,
                                        width: isCompact ? 40 : 30,

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
                                      AnimatedPadding(padding: EdgeInsetsGeometry.only(left: isCompactPadding), duration: Duration(milliseconds: 1000)),

                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 600),
                                        height: isCompact ? 40 : 30,
                                        width: isCompact ? 40 : 30,
                                        child: functionPlayerButton(
                                          Icons.repeat_one_outlined,
                                          Icons.repeat_one_outlined,
                                          isRepeatEnable,
                                          () async => isRepeatEnable ? await Player.player.disableRepeat() : await Player.player.enableRepeat(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      height: 30,
                                      child: Container(
                                        // color: Colors.red,
                                        child: InteractiveSlider(
                                          padding: EdgeInsets.only(
                                            top: 8,
                                            bottom: 0,
                                          ),
                                          startIcon: const Icon(
                                            Icons.volume_down,
                                          ),
                                          endIcon: const Icon(Icons.volume_up),
                                          min: 0.0,
                                          max: 1.0,
                                          brightness: Brightness.light,
                                          initialProgress: volume,
                                          iconColor: Colors.white,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.white,
                                            ],
                                          ),
                                          onChanged: (value) =>
                                              changeVolume(value),
                                        ),
                                      ),
                                    ),
                                  ],
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
