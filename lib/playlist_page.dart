// Flutter packages
import 'dart:io';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Additional packages
import 'package:quark/objects/track.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Local components&modules
import 'player_widget.dart';
import 'playlist_widget.dart';
import '/services/player.dart';
import '/objects/playlist.dart';
import '/services/database.dart';
import '/services/net_player.dart';
import '/services/native_control.dart';
import '/widgets/state_indicator.dart';

// TODO: ADVANCED SETTINGS MENU

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
  double songProgress = 0.0;
  double transitionSpeed = 1;
  double playerSpeed = 1;
  double playerPadding = 0.0;
  Uint8List animationInitiator = Uint8List(0);

  bool isSliderActive = true;
  bool isPlaying = false;
  bool isLiked = false;
  bool isPlaylistOpened = false;
  bool isShuffleEnable = false;
  bool isRepeatEnable = false;
  bool stateIndicator = true;

  late List<PlayerTrack> currentPlaylist;
  late List<PlayerTrack> backupPlaylist;
  late PlayerTrack nowPlayingTrack;
  late NetPlayer netPlayer;
  late Player player2;
  late NativeControl nativeControl;
  List<String> likedTracks = [];

  Color popupIconsColor = Colors.white.withAlpha(
    170,
  ); // TODO: MAKE ACCENT COLORS AS SETTINGS
  Color popupTextColor = Colors.white.withAlpha(220);
  Color albumArtShadowColor = Color.fromARGB(255, 21, 21, 21);

  StateIndicatorOperation operation = StateIndicatorOperation.none;

  InteractiveSliderController positionController = InteractiveSliderController(
    0.0,
  );

  late AnimationController playlistAnimationController;
  late Animation<Offset> playlistOffsetAnimation;
  OverlayEntry? playlistOverlayEntry;

  void updateProgress(value) async {
    setState(() {
      isSliderActive = true;
    });
    try {
      final seconds = await getSecondsByValue(value);
      await player2.seek(Duration(seconds: seconds));
    } catch (e) {}
  }

  void updateSlider() async {
    setState(() {
      isSliderActive = false;
    });
  }

  Future<int> getSecondsByValue(double value) async {
    final duration = player2.durationNotifier.value;

    return ((value / 100.0) * duration.inSeconds).round();
  }

  void changeVolume(value) async {
    volume = value;
    await player2.setVolume(value);
    await Database.setValue(DatabaseKeys.volume.value, value);
    setState(() {
      volume = value;
    });
  }

  void saveLastTrack() async {
    await Database.setValue(
      DatabaseKeys.lastTrack.value,
      nowPlayingTrack.filepath,
    );
  }

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
        await player2.playCustom(nowPlayingTrack);
        playAnimation();
      }
    }
  }

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
      await player2.playCustom(custom);
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
      await player2.playNext(forceNext: true);
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
      await player2.playPrevious();
    } else if (reload) {
      PlayerTrack next = nowPlayingTrack;
      await player2.playCustom(next);
    } else if (playpause) {
      setState(() {
        isPlaying = !isPlaying;
      });

      isPlaying ? await player2.player.resume() : await player2.player.pause();
      player2.isPlaying = isPlaying ? true : false;
    }
    cacheFiles();
    saveLastTrack();
    nativeControl.updateData(nowPlayingTrack);
  }

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

  void updateLiked() async {
    try {
      List<Track2> result = await widget.yandexMusic.usertracks.getLiked();
      likedTracks.clear();

      for (Track2 track in result) {
        likedTracks.add(track.trackID);
      }
      showOperation(StateIndicatorOperation.success);
    } catch (e) {
      showOperation(StateIndicatorOperation.error);
    }
  }

  void showOperation(StateIndicatorOperation newOperation) {
    if (mounted) {
      setState(() => operation = newOperation);
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) setState(() => operation = StateIndicatorOperation.none);
      });
    }
  }

  Future<void> _cacheFileInBackground(PlayerTrack track) async {
    // TODO: FIX BUGS WHILE MULTIPLE TRACKS LOADING
    final exists = await File(track.filepath).exists();
    if (!exists) {
      try {
        final downloadLink = await widget.yandexMusic.tracks.getDownloadLink(
          (track as YandexMusicTrack).track.id,
        );
        showOperation(StateIndicatorOperation.loading);
        final download = await widget.yandexMusic.tracks.getAsBytes(
          downloadLink,
        );
        await File(track.filepath).parent.create(recursive: true);
        await File(track.filepath).writeAsBytes(download);
        showOperation(StateIndicatorOperation.success);
      } catch (error) {
        print('''
An error has occured while downloading track
TrackID: ${(track as YandexMusicTrack).track.id}
Filepath: ${track.filepath}
YandexMusic client: ${widget.yandexMusic.accountID}
Error: ${error}
''');
        if (mounted) {
          showOperation(StateIndicatorOperation.error);
        }
      }
    }
  }

  void playerListeners() {
    player2.playedNotifier.addListener(() {
      final duration = player2.durationNotifier.value;
      final position = player2.playedNotifier.value;
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
    player2.trackNotifier.addListener(() {
      nowPlayingTrack = player2.trackNotifier.value;
      saveLastTrack();
    });
  }

  List<T> shuffleList<T>(List<T> list) {
    final shuffled = List<T>.from(list);
    shuffled.shuffle();
    return shuffled;
  }

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

      await player2.updatePlaylist(tcp);
      setState(() {
        currentPlaylist = tcp;
      });
    }

    if (!enable) {
      lcpl = [...backupPlaylist];
      setState(() {
        currentPlaylist = lcpl;
      });
      await player2.updatePlaylist(lcpl);
    }
    updatePlaylist();
    setState(() {
      isShuffleEnable = enable;
    });
  }

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
        ),
      );
      Overlay.of(context).insert(playlistOverlayEntry!);
    }
  }

  /// Playlist functions

  void removeTrack(PlayerTrack track) {
    currentPlaylist.remove(track);
    backupPlaylist.remove(track);
    // player2.updatePlaylist(currentPlaylist);
  }

  // TODO: REMOVE THE CRUTCHES
  // I don't even know what -56 -78 0 -2 and -1 are.
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

  void repeatChange() {
    setState(() {
      isRepeatEnable = !isRepeatEnable;
    });
    player2.isRepeat = isRepeatEnable;
  }

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
        showOperation(StateIndicatorOperation.error);
      }
    }
  }

  void loadDatabase() async {
    double? dbVolume = await Database.getValue(DatabaseKeys.volume.value);
    dbVolume ??= volume;
    changeVolume(dbVolume);
    await player2.setVolume(dbVolume);
    playAnimation();
    double? transition = await Database.getValue(
      DatabaseKeys.transitionSpeed.value,
    );
    transition ??= transitionSpeed;
    setAnimationSpeed(transition);
  }

  void setAnimationSpeed(double speed) async {
    setState(() {
      transitionSpeed = speed;
    });
  }

  void playAnimation() async {
    setState(() {
      animationInitiator = Uint8List(0);
    });
  }

  /// Playlist functions

  @override
  void initState() {
    // Init playlists

    super.initState();
    currentPlaylist = [...widget.playlist.tracks];
    backupPlaylist = [...widget.playlist.tracks];
    nowPlayingTrack = currentPlaylist[0];
    restoreLastTrack();
    // Classes

    player2 = Player(
      startVolume: volume,
      playlist: currentPlaylist,
      nowPlayingTrack: nowPlayingTrack,
    );
    player2.init();
    player2.player.setSource(DeviceFileSource(nowPlayingTrack.filepath));
    netPlayer = NetPlayer(player: player2, yandexMusic: widget.yandexMusic);
    nativeControl = NativeControl(
      onPlay: player2.playPause,
      onPause: player2.playPause,
      onNext: player2.playNext,
      onPrevious: player2.playPrevious,
      onSeek: () {},
    );
    nativeControl.init();
    Database.init();
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

    updateLiked();
  }

  @override
  void dispose() {
    player2.player.onPositionChanged.drain();
    player2.player.stop();
    player2.player.dispose();
    player2.onCompleteSubscription?.cancel();
    player2.onDurationChanged?.cancel();
    player2.onPlayedChanged?.cancel();
    player2.trackNotifier.dispose();
    player2.playedNotifier.dispose();
    player2.durationNotifier.dispose();
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
                        return FadeTransition(opacity: animation, child: child);
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
                              Container(
                                height: 270,
                                width: 270,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: albumArtShadowColor,

                                      blurRadius: 20,
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
                                            (context, url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                  value:
                                                      downloadProgress.progress,
                                                  color: Color.fromARGB(
                                                    31,
                                                    255,
                                                    255,
                                                    255,
                                                  ),
                                                ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
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
                                nowPlayingTrack.artists.join(","),
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
                                width: 300,

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
                                  const SizedBox(width: 15),
                                  functionPlayerButton(
                                    Icons.shuffle,
                                    Icons.shuffle_outlined,
                                    isShuffleEnable,
                                    () {
                                      shuffle();
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  if (nowPlayingTrack is YandexMusicTrack)
                                    functionPlayerButton(
                                      Icons.favorite_outlined,
                                      Icons.favorite_outlined,
                                      likedTracks.contains(
                                        (nowPlayingTrack as YandexMusicTrack)
                                            .track
                                            .id,
                                      ),
                                      () async {
                                        likeUnlike();
                                      },
                                    ),
                                  if (nowPlayingTrack is! YandexMusicTrack)
                                    const SizedBox(width: 35),

                                  const SizedBox(width: 15),
                                  functionPlayerButton(
                                    Icons.repeat_one_outlined,
                                    Icons.repeat_one_outlined,
                                    isRepeatEnable,
                                    () => repeatChange(),
                                  ),
                                  const SizedBox(width: 15),
                                  Material(
                                    color: Color.fromARGB(31, 255, 255, 255),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      onTap: () {},
                                      child: PopupMenuButton(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                        iconColor: Colors.white.withOpacity(
                                          0.6,
                                        ),

                                        offset: Offset(100, -60),
                                        color: Color.fromARGB(25, 59, 59, 59),
                                        itemBuilder: (context) => [
                                          if (Platform.isLinux)
                                            PopupMenuItem(
                                              height: 45,
                                              child: StatefulBuilder(
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
                                                              await player2
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
                                                              await player2
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
                                            ),
                                          PopupMenuItem(
                                            height: 45,
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
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Exit',
                                                  style: TextStyle(
                                                    color: popupTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            enabled: false,
                                            height: 5,
                                            child: Container(
                                              height: 1,
                                              width: double.infinity,
                                              color: popupTextColor,
                                            ),
                                          ),

                                          PopupMenuItem(
                                            height: 45,
                                            child: StatefulBuilder(
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    StateSetter setMenuState,
                                                  ) {
                                                    return Row(
                                                      children: [
                                                        Text(
                                                          'Transition speed',
                                                          style: TextStyle(
                                                            color:
                                                                popupTextColor,
                                                          ),
                                                        ),
                                                        SizedBox(width: 15),
                                                        IconButton(
                                                          onPressed: () async {
                                                            setMenuState(() {
                                                              transitionSpeed =
                                                                  transitionSpeed -
                                                                  0.1;
                                                            });

                                                            setState(() {});
                                                            await Database.setValue(
                                                              DatabaseKeys
                                                                  .transitionSpeed
                                                                  .value,
                                                              transitionSpeed,
                                                            );
                                                            setAnimationSpeed(
                                                              transitionSpeed,
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.remove,
                                                            color:
                                                                popupIconsColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          transitionSpeed
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
                                                              transitionSpeed =
                                                                  transitionSpeed +
                                                                  0.1;
                                                            });
                                                            setState(() {});
                                                            await Database.setValue(
                                                              DatabaseKeys
                                                                  .transitionSpeed
                                                                  .value,
                                                              transitionSpeed,
                                                            );
                                                            setAnimationSpeed(
                                                              transitionSpeed,
                                                            );
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
                                          ),
                                          PopupMenuItem(
                                            enabled: false,
                                            height: 5,
                                            child: Container(
                                              height: 1,
                                              width: double.infinity,
                                              color: popupTextColor,
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
          ],
        ),
      ),
    );
  }
}
