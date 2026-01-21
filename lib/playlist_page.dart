// Flutter packages
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';
import 'package:file_picker/file_picker.dart';

// Additional packages
import 'package:logging/logging.dart';
import 'package:quark/playlist_page_widget.dart';
import 'package:quark/services/files.dart';
import 'package:quark/widgets/mini_player.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:animated_expand/animated_expand.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

// Local components&modules
import 'player_widget.dart';
import 'playlist_widget.dart';
import '/services/player.dart';
import '/objects/playlist.dart';
import '/widgets/settings.dart';
import 'services/database.dart';
import '/services/net_player.dart';
import '/services/native_control.dart';
import '/widgets/state_indicator.dart';

// #TODO:открывание плейлиста по наведению

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

  /// The name tells for itself
  Future<int> getSecondsByValue(double value) async {
    final duration = player.durationNotifier.value;
    return ((value / 100.0) * duration.inSeconds).round();
  }

  /// Saving last track from database
  Future<void> saveLastTrack() async {
    await Database.put(DatabaseKeys.lastTrack.value, nowPlayingTrack.filepath);
  }

  /// Top function for caching tracks in storage
  Future<void> cacheFiles([List<PlayerTrack>? tracks]) async {
    if (tracks == null) {
      tracks = [];
      for (int i = -1; i < 2; i++) {
        tracks.add(
          currentPlaylist[(currentPlaylist.indexOf(nowPlayingTrack) + i) %
              currentPlaylist.length],
        );
      }
    }
    for (PlayerTrack track in tracks) {
      if (track is! LocalTrack) {
        _cacheFileInBackground(track);
      }
    }
  }

  /// Function for changing the indicator status
  Future<void> showOperation(StateIndicatorOperation newOperation) async {
    if (mounted) {
      setState(() => operation = newOperation);
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) setState(() => operation = StateIndicatorOperation.none);
      });
    }
  }

  /// Lower function for caching tracks in storage
  Future<void> _cacheFileInBackground(PlayerTrack track) async {
    String? quality = await Database.get(
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
  Future<void> removeTrack(PlayerTrack track) async {
    currentPlaylist.remove(track);
    backupPlaylist.remove(track);
    player.updatePlaylist(currentPlaylist);
    updateDatabasePlaylist();
  }

  /// Forced animation playback
  Future<void> playAnimation() async {
    /// To play the animation, simply reassign the key variable.
    setState(() {
      animationInitiator = Uint8List(0);
    });
  }

  /// Update database playlist
  Future<void> updateDatabasePlaylist() async {
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
  // Playlist interaction functions
  //
  //

  /// Agreement on track relocation caused by playlistview
  Future<void> moveTrack(int oldIndex, int newIndex) async {
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

  Future<void> manuallyClosedPlaylist() async {
    await togglePlaylist();
    isManuallyOpenedPlaylist = false;
  }

  Future<void> closeFullScreenCover() async {
    coverAnimationController.reverse().then((_) {
      coverOverlayEntry?.remove();
      coverOverlayEntry = null;
    });
  }

  Future<void> toggleCover() async {
    if (coverOverlayEntry != null) return;
    ImageProvider<Object> imageProvider;
    if (nowPlayingTrack is LocalTrack &&
        nowPlayingTrack.coverByted != Uint8List(0)) {
      imageProvider = MemoryImage(nowPlayingTrack.coverByted);
    } else {
      imageProvider = CachedNetworkImageProvider(
        'https://${nowPlayingTrack.cover.replaceAll('%%', '700x700')}',
      );
    }

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
                                      child: Image(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
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
  Future<void> updatePlaylist() async {
    if (isPlaylistOpened) {
      playlistOverlayEntry?.remove();
      playlistOverlayEntry = OverlayEntry(
        builder: (context) => PlaylistOverlay(
          playlistAnimationController: playlistAnimationController,
          playlistOffsetAnimation: playlistOffsetAnimation,
          togglePlaylist: manuallyClosedPlaylist,
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
    } else {}
  }

  //
  //
  // Button's && Slider's functions
  //
  //

  Future<void> uploadTrack(PlayerTrack trackss) async {
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
        cacheFiles([track]);
        await netPlayer.playYandex(track);
      }
    } catch (e) {
      print('Failed to load local track to Yandex music. Error: $e');
      showOperation(StateIndicatorOperation.error);
    }
  }

  /// Reaction on animation edit buttons
  Future<void> setAnimationSpeed(double speed) async {
    setState(() {
      transitionSpeed = speed;
    });
  }

  /// Reaction on repeat button
  Future<void> repeatChange() async {
    setState(() {
      isRepeatEnable = !isRepeatEnable;
    });
    player.isRepeat = isRepeatEnable;
  }

  /// Reaction on like button
  Future<void> likeUnlike() async {
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

  /// Reaction on shuffle button
  Future<void> shuffle() async {
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
  Future<void> changeTrack({
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

      isPlaying
          ? await player.player_instance.resume()
          : await player.player_instance.pause();
      player.isPlaying = isPlaying ? true : false;
    }
    cacheFiles();
    saveLastTrack();
    nativeControl.updateData(nowPlayingTrack);
  }

  /// Reaction on volume interactive slider
  Future<void> changeVolume(value) async {
    volume = value;
    await player.setVolume(value);
    await Database.put(DatabaseKeys.volume.value, value);
    setState(() {
      volume = value;
    });
  }

  /// Reaction on setting closing button
  Future<void> closeSettings() async {
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
      if (openPlaylistNextTime) {
        openPlaylistNextTime = false;
        if (!isPlaylistOpened) {
          togglePlaylist();
        }
      }
      transitionSpeed = transitionSpeed2 ?? transitionSpeed;
      stateIndicator = indicator ?? stateIndicator;
      playlistOpeningArea = playlistArea ?? playlistOpeningArea;
    });
  }

  /// Reaction on progress interactive slider
  Future<void> updateProgress(value) async {
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
  Future<void> updateSlider() async {
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
  Future<void> loadDatabase() async {
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
    setAnimationSpeed(transition);
  }

  /// Initializing player listeners
  Future<void> playerListeners() async {
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
  Future<void> updateLiked() async {
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

  /// Restoring last track from database
  Future<void> restoreLastTrack() async {
    String? resl = await Database.get(DatabaseKeys.lastTrack.value);
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
  Future<void> initPlayers() async {
    await player.playCustom(nowPlayingTrack);
    await player.setVolume(volume);
    await player.updatePlaylist(currentPlaylist);
    log.info('Trying to initialize the player instance...');
    player.init();
    log.fine('Player instance initialized successfully');
    // bool exists = await File(nowPlayingTrack.filepath).exists();
    netPlayer = NetPlayer(player: player, yandexMusic: widget.yandexMusic);
    log.info('Trying to set source of track...');
    // if (exists) {
    //   try {
    //     log.info('The track was found locally. Trying to set source...');
    //     player.player_instance.setSource(DeviceFileSource(nowPlayingTrack.filepath));
    //   } catch (e) {
    //     log.shout(
    //       'Failed to set local source (file exists: $exists). Attempting to set network source',
    //     );
    //     netPlayer.playYandex(nowPlayingTrack);
    //   }
    // } else {
    //   log.info(
    //     'The track was NOT found locally. Trying to set network source...',
    //   );
    //   netPlayer.playYandex(nowPlayingTrack);
    // }
  }

  /// Dispose
  @override
  void initState() {
    // Init playlists

    super.initState();

    // SET MINIMUM SIZE

    currentPlaylist = [...widget.playlist.tracks];
    backupPlaylist = [...widget.playlist.tracks];
    nowPlayingTrack = currentPlaylist[0];
    restoreLastTrack();
    
    // Classes
    initPlayers();
    log.info('Trying to initialize database...');
    Database.init();
    log.fine('Database initialized successfully');

    log.info('Trying to initialize native controls...');

    nativeControl = NativeControl();

    nativeControl.init(changeTrack, () {});
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
    loadDatabase();
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
    // player.player_instance.onPositionChanged.drain();
    // player.player_instance.stop();
    // player.player_instance.dispose();
    // player.onCompleteSubscription?.cancel();
    // player.onDurationChanged?.cancel();
    // player.onPlayedChanged?.cancel();
    // player.trackNotifier.dispose();
    // player.playedNotifier.dispose();
    // player.durationNotifier.dispose();
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

    // WINDOW SIZE LOGGER
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
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: isCompact
          ? MiniPlayerWidget(
              playlist: widget.playlist,
              yandexMusic: widget.yandexMusic,
            )
          : PlaylistPage1(
              playlist: widget.playlist,
              yandexMusic: widget.yandexMusic,
            ),
    );
  }
}
