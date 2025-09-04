// Dart
import 'dart:math';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
// Flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Libraries
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
// Local modules
import 'package:quark/src/yandex_music_modified/yandex_music_interface.dart';
import 'package:quark/src/services/database.dart';
import 'package:quark/src/services/file_tags.dart';
import 'package:quark/src/services/path_manager.dart';
import 'package:quark/src/widgets/box_decorations.dart';
import 'package:quark/src/overlay/playlist_overlay.dart';

class YmPlaylistPage extends StatefulWidget {
  final List<String> songs;
  final List ymTracksInfo;
  final YandexMusic yandexMusicInstance;
  final YandexMusicInterface musicInterface;
  final Map<String, dynamic> playlistInfo;
  const YmPlaylistPage({
    super.key,
    required this.songs,
    required this.ymTracksInfo,
    required this.yandexMusicInstance,
    required this.musicInterface,
    required this.playlistInfo,
  });

  @override
  State<YmPlaylistPage> createState() => _PlaylistPageState();
}

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final Function(Duration)? onSeek;

  // The most common callbacks:

  MyAudioHandler({
    this.onPlay,
    this.onPause,
    this.onNext,
    this.onPrevious,
    this.onSeek,
  }) {}

  @override
  Future<void> play() {
    onPlay?.call();
    return Future.value();
  }

  @override
  Future<void> pause() {
    onPause?.call();
    return Future.value();
  }

  @override
  Future<void> stop() {
    onPause?.call();
    return Future.value();
  }

  @override
  Future<void> seek(Duration position) {
    onSeek?.call(position);
    return Future.value();
  }

  @override
  Future<void> skipToQueueItem(int i) {
    onPlay?.call();
    return Future.value();
  }

  @override
  Future<void> skipToNext() {
    onNext?.call();
    return Future.value();
  }

  @override
  Future<void> skipToPrevious() {
    onPrevious?.call();
    return Future.value();
  }

  Future<void> setPlayback(
    String title,
    String artist,
    String album,
    Duration duration,
    String artUri,
    String id,
  ) async {
    // mediaItem.close();
    mediaItem.add(
      MediaItem(
        id: id,
        title: title,
        artist: artist,
        album: album,
        duration: duration,
        artUri: Uri.parse(artUri),
      ),
    );
  }
}

class _PlaylistPageState extends State<YmPlaylistPage>
    with TickerProviderStateMixin {
  void _showPlaylistOverlay() {
    if (isPlaylistAnimating) {
      playerPadding = 0.0;

      return;
    }
    if (isPlaylistOpened) {
      playlistAnimationController.reverse().then((_) {
        playlistOverlayEntry?.remove();
        playlistOverlayEntry = null;
      });
      if (mounted) {
        setState(() {
          playerPadding = 0.0;

          isPlaylistOpened = false;
        });
      }
      return;
    }

    if (isPlaylistOpened == false) {
      if (mounted) {
        setState(() {
          isPlaylistOpened = true;
          if (MediaQuery.of(context).size.width > 800) {
            playerPadding = 400.0;
          }
        });
      }

      playlistOverlayEntry = OverlayEntry(
        builder:
            (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setOverlayState) {
                return Positioned(
                  left: 0,
                  child: SlideTransition(
                    position: playlistOffsetAnimation,
                    child: Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity!.abs() > 500) {
                            if (details.primaryVelocity! < -500 ||
                                details.primaryVelocity! > 500) {
                              _hidePlaylistOverlay();
                            }
                          }
                        },

                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                            child: Container(
                              width: 400,
                              height: MediaQuery.of(context).size.height,
                              decoration: overlayBoxDecoration(),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: ListView.builder(
                                      itemCount: playlistView.length + 1,
                                      itemBuilder: (context, index) {
                                        if (!search && index == 0) {
                                          return Container();
                                        }
                                        if (search && index == 0) {
                                          return ListTile(
                                            title: TextField(
                                              cursorColor: Colors.white
                                                  .withOpacity(0.8),
                                              cursorErrorColor: Colors.white,

                                              controller: searchController,
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.8,
                                                ),
                                              ),
                                              decoration: InputDecoration(
                                                hintText: 'Search',
                                                hintStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.7),
                                                  fontSize: 16,
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white
                                                            .withOpacity(0.3),
                                                        width: 1,
                                                      ),
                                                    ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                filled: false,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12,
                                                    ),
                                              ),
                                              onChanged: (query) async {
                                                _searchDebounceTimer?.cancel();
                                                _searchCancelToken?.cancel();
                                                _searchCancelToken = null;

                                                if (query.isEmpty) {
                                                  setOverlayState(() {
                                                    playlistView = widget.songs;
                                                  });

                                                  setState(() {
                                                    playlistView = widget.songs;
                                                  });
                                                  return;
                                                }
                                                final suggestions =
                                                    widget.songs.where((info) {
                                                      String trackID =
                                                          PathManager.getFileName(
                                                            info,
                                                          ).replaceAll(
                                                            RegExp(
                                                              r'^quarkaudiotemptrack|\.mp3$',
                                                            ),
                                                            '',
                                                          );

                                                      Map? foundMap = widget
                                                          .ymTracksInfo
                                                          .firstWhere(
                                                            (map) =>
                                                                map['id'] ==
                                                                trackID,
                                                            orElse: () => null,
                                                          );

                                                      var name = 'Unknown';
                                                      var artist = 'Unknown';
                                                      var nowTrack = info;
                                                      var image1 = dummyArtUri;

                                                      if (foundMap != null) {
                                                        name =
                                                            foundMap['title'];
                                                        artist =
                                                            foundMap['artists'];
                                                        nowTrack = info;
                                                        image1 =
                                                            'https://${foundMap['cover']}';
                                                      }

                                                      if (name
                                                          .toLowerCase()
                                                          .contains(
                                                            query.toLowerCase(),
                                                          )) {
                                                        print(
                                                          'name lower: ${name.toLowerCase()}',
                                                        );
                                                        print(
                                                          'query lower: ${query.toLowerCase()}',
                                                        );
                                                        return true;
                                                      }
                                                      return false;
                                                    }).toList();

                                                setOverlayState(() {
                                                  playlistView = suggestions;
                                                });

                                                setState(() {
                                                  playlistView = suggestions;
                                                });

                                                final currentQuery = query;

                                                _searchDebounceTimer = Timer(
                                                  _searchDebounceDuration,
                                                  () async {
                                                    if (currentQuery.isEmpty ||
                                                        currentQuery != query) {
                                                      return;
                                                    }

                                                    _searchCancelToken =
                                                        CancelToken();

                                                    try {
                                                      print(
                                                        'Searching: $query',
                                                      );
                                                      var result = await widget
                                                          .yandexMusicInstance
                                                          .search
                                                          .tracks(
                                                            query,
                                                            0,
                                                            false,
                                                            _searchCancelToken,
                                                          );

                                                      if (currentQuery !=
                                                              query ||
                                                          currentQuery
                                                              .isEmpty) {
                                                        return;
                                                      }

                                                      if (result == null) {
                                                        return;
                                                      }

                                                      for (var track
                                                          in result['results']) {
                                                        String cover = '';
                                                        if (track['coverUri'] !=
                                                            null) {
                                                          cover =
                                                              track['coverUri']
                                                                  .toString()
                                                                  .replaceAll(
                                                                    "%%",
                                                                    "300x300",
                                                                  );
                                                        }
                                                        Map b = {
                                                          'id':
                                                              track['id']
                                                                  .toString(),
                                                          'title':
                                                              track['title'] ??
                                                              '',
                                                          'cover': cover,
                                                          'artists':
                                                              track['artists']
                                                                      .isNotEmpty
                                                                  ? track['artists'][0]['name']
                                                                  : 'Unknown',
                                                        };

                                                        widget.ymTracksInfo.add(
                                                          b,
                                                        );
                                                        suggestions.add(
                                                          '$downloadDirectory/quarkaudiotemptrack${track['id']}.mp3',
                                                        );
                                                        print('added');
                                                      }

                                                      if (currentQuery ==
                                                              query &&
                                                          currentQuery
                                                              .isNotEmpty) {
                                                        setOverlayState(() {
                                                          playlistView =
                                                              suggestions;
                                                        });

                                                        setState(() {
                                                          playlistView =
                                                              suggestions;
                                                        });
                                                      }

                                                      print(result);
                                                    } on YandexMusicException {
                                                      return;
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          );
                                        }

                                        if (index - 1 >= 0) {
                                          index = index - 1;
                                        }
                                        String trackID =
                                            PathManager.getFileName(
                                              playlistView[index],
                                            ).replaceAll(
                                              RegExp(
                                                r'^quarkaudiotemptrack|\.mp3$',
                                              ),
                                              '',
                                            );

                                        Map? foundMap = widget.ymTracksInfo
                                            .firstWhere(
                                              (map) => map['id'] == trackID,
                                              orElse: () => null,
                                            );
                                        // playlistView = widget.songs;
                                        // print(playlistView);

                                        var name = 'Unknown';
                                        var artist = 'Unknown';
                                        var nowTrack = playlistView[index];
                                        var image1 = dummyArtUri;
                                        if (foundMap != null) {
                                          name = foundMap['title'];
                                          artist = foundMap['artists'];
                                          nowTrack = playlistView[index];
                                          image1 =
                                              'https://${foundMap['cover']}';
                                        }

                                        // search = true;

                                        return ListTile(
                                          title: Row(
                                            children: [
                                              Container(
                                                height: 55,
                                                width: 55,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:
                                                        CachedNetworkImageProvider(
                                                          image1,
                                                        ),
                                                    fit: BoxFit.cover,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                          Colors.black
                                                              .withOpacity(0),
                                                          BlendMode.darken,
                                                        ),
                                                  ),

                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            21,
                                                            21,
                                                            21,
                                                          ),
                                                      blurRadius: 10,
                                                      offset: Offset(5, 10),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              SizedBox(width: 10),

                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '$name',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      '$artist',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              ValueListenableBuilder<int>(
                                                valueListenable:
                                                    nowPlayingIndexNotifier,
                                                builder: (
                                                  context,
                                                  currentIndex,
                                                  child,
                                                ) {
                                                  return AnimatedOpacity(
                                                    opacity:
                                                        (currentIndex == index)
                                                            ? 1.0
                                                            : 0.0,
                                                    duration: Duration(
                                                      milliseconds:
                                                          (650 * transitionSpeed)
                                                              .round(),
                                                    ),
                                                    curve: Curves.easeInOut,
                                                    child: Icon(
                                                      Icons.play_arrow_sharp,
                                                      color: Colors.grey,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          onTap: () async {
                                            FileTags.getAllTracksMetadata(
                                              playlistView,
                                            );
                                            if (mounted) {
                                              if (!widget.songs.contains(
                                                '$downloadDirectory/quarkaudiotemptrack${trackID}.mp3',
                                              )) {
                                                player.stop();
                                                Map? foundMap = widget
                                                    .ymTracksInfo
                                                    .firstWhere(
                                                      (map) =>
                                                          map['id'] == trackID,
                                                      orElse: () => null,
                                                    );
                                                logger.fine('States');

                                                if (foundMap != null) {
                                                  setState(() {
                                                    trackName =
                                                        foundMap['title'];
                                                    trackArtistNames = [
                                                      foundMap['artists'],
                                                    ];
                                                    coverArtData = Uint8List(0);
                                                    albumArtUri =
                                                        'https://${foundMap['cover']}';
                                                  });
                                                  updateSMTC();
                                                } else {
                                                  logger.warning(
                                                    'Track metadata not found! Excecuting fallback.',
                                                  );
                                                  setState(() {
                                                    coverArtData = Uint8List(0);
                                                    trackName = 'Unknown';
                                                    trackArtistNames = [
                                                      'Unknown',
                                                    ];
                                                    albumArtUri = dummyArtUri;
                                                  });
                                                  updateSMTC();
                                                }

                                                File trackFile = File(
                                                  '$downloadDirectory/quarkaudiotemptrack$trackID.mp3',
                                                );
                                                bool exists =
                                                    await trackFile.exists();
                                                if (!exists) {
                                                  widget.musicInterface
                                                      .getTrackDownloadLink(
                                                        trackID,
                                                      )
                                                      .then((link) {
                                                        logger.fine(
                                                          'Download link: $link',
                                                        );

                                                        return widget
                                                            .musicInterface
                                                            .downloadTrack(
                                                              '$downloadDirectory/quarkaudiotemptrack$trackID.mp3',
                                                              trackID,
                                                            );
                                                      })
                                                      .then((onValue) {
                                                        player.stop();

                                                        Future.delayed(
                                                          Duration(
                                                            milliseconds: 100,
                                                          ),
                                                          () {
                                                            player.play(
                                                              DeviceFileSource(
                                                                '$downloadDirectory/quarkaudiotemptrack$trackID.mp3',
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        logger.fine(
                                                          'Track $trackID downloaded successfully.',
                                                        );

                                                        // });
                                                      })
                                                      .catchError((error) {
                                                        logger.warning(
                                                          'Downloading track failed: $error',
                                                        );
                                                      });
                                                } else {
                                                  player.stop();
                                                  Future.delayed(
                                                    Duration(milliseconds: 100),
                                                    () {
                                                      player.play(
                                                        DeviceFileSource(
                                                          '$downloadDirectory/quarkaudiotemptrack$trackID.mp3',
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }

                                                return;
                                              }
                                              setState(() {
                                                if (search &&
                                                    searchController.text !=
                                                        '') {
                                                  int newPlayingIndex = widget
                                                      .songs
                                                      .indexWhere((test) {
                                                        return test.contains(
                                                          trackID,
                                                        );
                                                      });
                                                  nowPlayingIndex =
                                                      newPlayingIndex - 1;
                                                  steps(nextStep: true);
                                                } else {
                                                  nowPlayingIndex = index - 1;
                                                  nowPlayingIndexNotifier
                                                      .value = nowPlayingIndex;

                                                  steps(nextStep: true);
                                                }
                                              });
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),

                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                      onPressed: _hidePlaylistOverlay,
                                    ),
                                  ),
                                  Positioned(
                                    top: 15,
                                    left: 150,
                                    child: Text(
                                      'Playlist',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 50,
                                    child: IconButton(
                                      onPressed: () async {
                                        checkPlaylistUpdates();
                                      },
                                      icon: Icon(Icons.refresh),
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: IconButton(
                                      onPressed: () async {
                                        bool nsearch;

                                        if (search) {
                                          nsearch = false;
                                        } else {
                                          nsearch = true;
                                        }

                                        setState(() {
                                          search = nsearch;
                                        });
                                        setOverlayState(() {
                                          search = nsearch;
                                        });
                                      },
                                      icon: Icon(Icons.search),
                                      color: Colors.white.withOpacity(0.8),
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
                );
              },
            ),
      );

      Overlay.of(context).insert(playlistOverlayEntry!);
      playlistAnimationController.forward();
    }
  }

  void _hidePlaylistOverlay() {
    playlistAnimationController.reverse().then((_) {
      playlistOverlayEntry?.remove();
      playlistOverlayEntry = null;
    });
    setState(() {
      playerPadding = 0.0;
    });
    if (isPlaylistOpened) {
      if (mounted) {
        setState(() {
          playerPadding = 0.0;
          isPlaylistOpened = false;
          isPlaylistAnimating = false;
        });
      }
    }
  }

  void showWarningMessage(String errorMessage) {
    warningMetadataOverlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            right: 15,
            top: 15,
            child: SlideTransition(
              position: warningMetadataOffsetAnimation,
              child: Material(
                color: Colors.transparent,
                child: GestureDetector(
                  // onHorizontalDragEnd: (details) {
                  //   if (details.primaryVelocity! > 100) {
                  //     _hideWarningMetadataOverlay();
                  //   }
                  // },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                      child: Container(
                        width: 350,
                        height: 80,
                        decoration: overlayBoxDecoration(),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              left: 300,
                              child: IconButton(
                                onPressed: _hideWarningMetadataOverlay,
                                icon: Icon(Icons.close),
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 15, top: 15),
                                  child: Text(
                                    errorMessage,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
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
    );

    Overlay.of(context).insert(warningMetadataOverlayEntry!);
    warningMetadataAnimationController.forward();
  }

  void _hideWarningMetadataOverlay() {
    warningMetadataAnimationController.reverse().then((_) {
      warningMetadataOverlayEntry?.remove();
      warningMetadataOverlayEntry = null;
    });
  }

  void _showSettingsOverlay() {
    settingsOverlayEntry = OverlayEntry(
      builder:
          (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setOverlayState) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _hideSettingsOverlay,
                      child: Container(color: Colors.black.withOpacity(0.05)),
                    ),
                  ),

                  Positioned(
                    child: SlideTransition(
                      position: settingsOffsetAnimation,
                      child: Center(
                        child: Material(
                          color: Colors.transparent,

                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 175,
                                sigmaY: 175,
                              ),
                              child: Container(
                                width: min(
                                  MediaQuery.of(context).size.width * 0.92,
                                  600,
                                ),
                                height: min(
                                  MediaQuery.of(context).size.height * 0.92,
                                  715,
                                ),
                                decoration: overlayBoxDecoration(),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 675,
                                      left: 290,
                                      child: Text(
                                        "made by Penises DG. No rights reserved.",
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 15),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 45,
                                                width: 150,

                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 35),
                                                    Icon(
                                                      Icons.interests,
                                                      color: Colors.grey[300],
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Main',
                                                      style: TextStyle(
                                                        color: Colors.grey[300],
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 50),
                                              Container(
                                                height: 45,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  // color: themeColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    SizedBox(width: 35),
                                                    Icon(
                                                      Icons.cloud_sync_sharp,
                                                      color: Colors.grey[300],
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Server',
                                                      style: TextStyle(
                                                        color: Colors.grey[300],
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              IconButton(
                                                onPressed: _hideSettingsOverlay,
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 25),
                                          Row(
                                            children: [
                                              SizedBox(width: 50),
                                              Text(
                                                'Playlist',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsetsGeometry.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                child: Container(
                                                  width: 500,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    // color: themeColor,
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.grey,
                                                    ),

                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {},
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 15),
                                                        Text(
                                                          'Add songs',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding:
                                                    EdgeInsetsGeometry.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                child: Container(
                                                  width: 500,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    // color: themeColor,
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      addFolderToSongs();
                                                      // var oldlist = widget.songs;

                                                      // setState(() {
                                                      //   widget.songs = oldlist
                                                      // });

                                                      Database.setValue(
                                                        'lastPlaylist',
                                                        widget.songs,
                                                      ); // After initializing the playlist, we add it to the table as the last one
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 15),
                                                        Text(
                                                          'Add Folder',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding:
                                                    EdgeInsetsGeometry.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                child: Container(
                                                  width: 500,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    // color: themeColor,
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.grey,
                                                    ),

                                                    borderRadius:
                                                        BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      // player.stop();
                                                      // _hidePlaylistOverlay();
                                                      // _hideWarningMetadataOverlay();
                                                      // _hideSettingsOverlay();

                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 15),
                                                        Text(
                                                          'Clear',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 25),
                                          Row(
                                            children: [
                                              SizedBox(width: 50),
                                              Text(
                                                'UI',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Column(
                                            children: [
                                              SizedBox(height: 5),
                                              Padding(
                                                padding:
                                                    EdgeInsetsGeometry.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                child: Container(
                                                  width: 500,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    // color: themeColor,
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 15),
                                                      Expanded(
                                                        child: Text(
                                                          'Album art as background',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding:
                                                            EdgeInsetsGeometry.only(
                                                              right: 15,
                                                            ),

                                                        child: Switch(
                                                          value:
                                                              isBackgroudArtEnable,
                                                          onChanged: (
                                                            bool value,
                                                          ) {
                                                            if (mounted) {
                                                              setState(() {
                                                                isBackgroudArtEnable =
                                                                    value;
                                                              });
                                                              setOverlayState(() {
                                                                isBackgroudArtEnable =
                                                                    value;
                                                              });
                                                            }

                                                            if (!value) {
                                                              coverArtData =
                                                                  Uint8List(0);
                                                              Database.setValue(
                                                                "isBackgroudArtEnable",
                                                                false,
                                                              );
                                                            } else {
                                                              FileTags.getTagsFromFile(
                                                                widget
                                                                    .songs[nowPlayingIndex],
                                                              ).then((value) {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    coverArtData =
                                                                        value['albumArt'];
                                                                  });
                                                                }
                                                              });
                                                              Database.setValue(
                                                                "isBackgroudArtEnable",
                                                                true,
                                                              );
                                                            }
                                                          },
                                                          activeColor:
                                                              const Color.fromARGB(
                                                                255,
                                                                34,
                                                                34,
                                                                34,
                                                              ),
                                                          activeTrackColor:
                                                              Colors.grey[300],
                                                          inactiveThumbColor:
                                                              Colors.grey[300],
                                                          inactiveTrackColor:
                                                              const Color.fromARGB(
                                                                255,
                                                                34,
                                                                34,
                                                                34,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding:
                                                    EdgeInsetsGeometry.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                child: Container(
                                                  width: 500,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.grey,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 15),
                                                      Expanded(
                                                        child: Text(
                                                          'Transition speed',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding:
                                                            EdgeInsetsGeometry.only(
                                                              right: 0,
                                                            ),
                                                        child: SizedBox(
                                                          width: 200,
                                                          child: InteractiveSlider(
                                                            brightness:
                                                                Brightness
                                                                    .light,
                                                            // initialProgress: songProgress,
                                                            iconColor:
                                                                Colors.white,
                                                            gradient:
                                                                LinearGradient(
                                                                  colors: [
                                                                    Colors
                                                                        .white,
                                                                    Colors
                                                                        .white,
                                                                  ],
                                                                ),
                                                            shapeBorder:
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                        Radius.circular(
                                                                          8,
                                                                        ),
                                                                      ),
                                                                ),
                                                            min: 0.0,
                                                            max: 2.0,
                                                          ),
                                                        ),
                                                        // child: Slider(
                                                        //   min: 0.0,

                                                        //   max: 2.0,
                                                        //   // overlayColor: Color.fromARGB(1, 218, 218, 218),
                                                        //   activeColor:
                                                        //       Color.fromARGB(
                                                        //         255,
                                                        //         218,
                                                        //         218,
                                                        //         218,
                                                        //       ),
                                                        //   inactiveColor:
                                                        //       Color.fromARGB(
                                                        //         255,
                                                        //         218,
                                                        //         218,
                                                        //         218,
                                                        //       ),
                                                        //   value:
                                                        //       transitionSpeed,
                                                        //   onChanged: (value) {
                                                        //     if (mounted) {
                                                        //       setOverlayState(() {
                                                        //         transitionSpeed =
                                                        //             value;
                                                        //       });
                                                        //       setState(() {
                                                        //         transitionSpeed =
                                                        //             value;
                                                        //       });
                                                        //     }
                                                        //     Database.setValue(
                                                        //       "transitionSpeed",
                                                        //       value,
                                                        //     );
                                                        //   },
                                                        //   thumbColor:
                                                        //       Colors.white,
                                                        // ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(height: 25),

                                          Row(
                                            children: [
                                              SizedBox(width: 50),
                                              Text(
                                                'Functional',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsetsGeometry.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                child: Container(
                                                  width: 500,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    // color: themeColor,
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.grey,
                                                    ),

                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(width: 15),
                                                      Expanded(
                                                        child: Text(
                                                          'Automatic sorting of tracks',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding:
                                                            EdgeInsetsGeometry.only(
                                                              right: 15,
                                                            ),

                                                        child: Switch(
                                                          value:
                                                              autoTrackSorting,
                                                          onChanged: (
                                                            bool value,
                                                          ) {
                                                            if (mounted) {
                                                              setState(() {
                                                                autoTrackSorting =
                                                                    value;
                                                              });
                                                              setOverlayState(() {
                                                                autoTrackSorting =
                                                                    value;
                                                              });
                                                            }

                                                            if (autoTrackSorting) {
                                                              Database.setValue(
                                                                'autoTrackSorting',
                                                                true,
                                                              );
                                                            } else {
                                                              Database.setValue(
                                                                'autoTrackSorting',
                                                                false,
                                                              );
                                                            }
                                                          },
                                                          activeColor:
                                                              const Color.fromARGB(
                                                                255,
                                                                34,
                                                                34,
                                                                34,
                                                              ),
                                                          activeTrackColor:
                                                              Colors.grey[300],
                                                          inactiveThumbColor:
                                                              Colors.grey[300],
                                                          inactiveTrackColor:
                                                              const Color.fromARGB(
                                                                255,
                                                                34,
                                                                34,
                                                                34,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Padding(
                                                padding:
                                                    EdgeInsetsGeometry.only(
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                child: Container(
                                                  width: 500,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    // color: themeColor,
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Colors.grey,
                                                    ),

                                                    borderRadius:
                                                        BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      // player.stop();
                                                      // _hidePlaylistOverlay();
                                                      // _hideWarningMetadataOverlay();
                                                      // _hideSettingsOverlay();
                                                      Database.clear();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SizedBox(width: 15),
                                                        Text(
                                                          'Reset settings to default',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                ],
              );
            },
          ),
    );

    Overlay.of(context).insert(settingsOverlayEntry!);
    settingsAnimationController.forward();
  }

  void _hideSettingsOverlay() {
    settingsAnimationController.reverse().then((_) {
      settingsOverlayEntry?.remove();
      settingsOverlayEntry = null;
    });
  }

  late AnimationController warningMetadataAnimationController;
  late Animation<Offset> warningMetadataOffsetAnimation;
  OverlayEntry? warningMetadataOverlayEntry;

  late AnimationController playlistAnimationController;
  late Animation<Offset> playlistOffsetAnimation;
  OverlayEntry? playlistOverlayEntry;

  late AnimationController settingsAnimationController;
  late Animation<Offset> settingsOffsetAnimation;
  OverlayEntry? settingsOverlayEntry;

  // IF WE CAN MAKE SHIT, WE WILL

  // List<String> songs = [];
  List<String> notShuffledPlaylist = [];
  List<String>? trackArtistNames = [];
  List<String> files = [];
  List<String> selectedFiles = [];
  List<String> fetchedSongs = [];
  List<String> playlistView = [];
  List<Map<String, dynamic>>? cachedPlaylist;
  List<ListTile> cachedListview = [];

  String currentPosition = '0:00';
  String songDurationWidget = '0:00';
  String trackName = '';
  String lastSong = '';
  String? selectedFolderPath;
  String logPath = '';
  String albumArtUri =
      'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/unknown-cd-album-mixtape-cover-design-templat-template-a0089f026a71f9722a55157364f22590_screen.jpg?ts=1644153606';
  String downloadDirectory = '';
  String dummyArtUri =
      'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/unknown-cd-album-mixtape-cover-design-templat-template-a0089f026a71f9722a55157364f22590_screen.jpg?ts=1644153606';
  double songProgress = 0.0;
  double volumeValue = 0.7;
  double transitionSpeed = 1.0;
  double playerPadding = 0.0;

  int nowPlayingIndex = 0;
  int searchChangeTS = 0;
  Uint8List coverArtData = Uint8List.fromList([]);

  // Setting default settings (u know). They will be replaced with user settings upon initialization.

  bool isWhiteTheme = false;
  bool isRepeatEnable = false;
  bool isSliderActive = true;
  bool isPlaylistOpened = false;
  bool isPlayling = false;
  bool isShuffleEnable = false;
  bool isMetadataRecognizeEnable = true;
  bool isBackgroudArtEnable = true;
  bool isPlaylistAnimating = false;
  bool autoTrackSorting = true;
  bool search = false;
  bool isLiked = false;

  final player = AudioPlayer();
  final ValueNotifier<int> nowPlayingIndexNotifier = ValueNotifier<int>(0);

  final volumeController = InteractiveSliderController(0.0);
  final transitionController = InteractiveSliderController(0.0);
  final String serverApiURL = '127.0.0.1:5678';
  final logger = Logger('mainlogger');
  final TextEditingController searchController = TextEditingController();
  Timer? _searchDebounceTimer;
  final Duration _searchDebounceDuration = const Duration(milliseconds: 1000);
  CancelToken? _searchCancelToken;
  Color themeColor = Color.fromARGB(255, 34, 34, 34);
  Color backgroundGradientColor = Color.fromRGBO(24, 24, 26, 1);
  Color backgroundSecondGradientColor = Color.fromRGBO(18, 18, 20, 1);
  Color albumArtShadowColor = Color.fromARGB(255, 21, 21, 21);
  Color alternativeThemeColor = Color.fromARGB(255, 197, 197, 197);
  Color pickerColor = Colors.blue;

  CancelToken? _currentToken;
  CancelToken searchCancel = CancelToken();

  File? filePath;

  late File logFile;
  // late PlaylistOverlayState overlayState;
  late AudioHandler _audioHandler;

  // SMTCWindows smtc = SMTCWindows();

  // Working with additiongal songs that we can take from settings
  Future<void> addFolderToSongs() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        var files2 = await getFilesFromDirectory(selectedDirectory);
        if (files2.isNotEmpty) {
          for (var i in files2) {
            if (mounted) {
              setState(() {
                widget.songs.add(PathManager.getnormalizePath(i));
              });
            }
          }
        }
      }
    } catch (e) {
      logger.warning(
        'An error occurred while retrieving the selected multiple file: $e',
      );
    }
  }

  // Working with additiongal directories that we can take from settings
  Future<List<String>> getFilesFromDirectory(String directoryPath) async {
    try {
      final dir = Directory(directoryPath);
      final List<String> fileNames = [];

      await for (final entity in dir.list()) {
        if (entity is File) {
          if (entity.path.toLowerCase().endsWith('.mp3') ||
              entity.path.toLowerCase().endsWith('.wav') ||
              entity.path.toLowerCase().endsWith('.flac') ||
              entity.path.toLowerCase().endsWith('.aac') ||
              entity.path.toLowerCase().endsWith('.m4a')) {
            fileNames.add(entity.path);
          }
        }
      }
      files = fileNames.map((path) => path.split('/').last).toList();
      selectedFiles = fileNames;

      return fileNames;
    } catch (e) {
      logger.warning(
        'An error occurred while retrieving the selected multiple file: $e',
      );
      return [];
    }
  }

  // Applying existing tag to page

  Future<void> applyTagToPage(Map<String, dynamic> tag) async {
    setState(() {
      trackName =
          (tag['trackName']?.toString().trim().isNotEmpty ?? false)
              ? tag['trackName'].toString()
              : PathManager.getFileName(widget.songs[nowPlayingIndex]);

      trackArtistNames =
          (tag['trackArtistNames'] is List &&
                  tag['trackArtistNames'].isNotEmpty)
              ? List<String>.from(
                tag['trackArtistNames'].where(
                  (artist) => artist?.toString().trim().isNotEmpty ?? false,
                ),
              )
              : ['Unknown'];

      if (isBackgroudArtEnable) {
        coverArtData =
            (tag['albumArt'] is Uint8List) ? tag['albumArt'] : Uint8List(0);
      } else {
        coverArtData = Uint8List(0);
      }
      // smtc.updateMetadata(
      //   MusicMetadata(
      //     title: trackName,
      //     album: 'almbu',
      //     albumArtist: trackArtistNames?.join(', ') ?? 'Unknown',
      //     artist: trackArtistNames?.join(', ') ?? 'Unknown',
      //   ),
      // );
    });
  }

  // Future<void>

  void updatePageTag() async {
    String trackID = PathManager.getFileName(
      widget.songs[nowPlayingIndex],
    ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');
    Map? foundMap = widget.ymTracksInfo.firstWhere(
      (map) => map['id'] == trackID,
      orElse: () => null,
    );

    if (foundMap != null) {
      // var coverArt = await RecognizerService.urlImageToUint8List('https://${foundMap['cover']}');
      setState(() {
        trackName = foundMap['title'];
        trackArtistNames = [foundMap['artists']];
        albumArtUri = 'https://${foundMap['cover']}';
        coverArtData = Uint8List(0);
      });
      updateSMTC();
    } else {
      setState(() {
        trackName = 'Unknown';
        trackArtistNames = ['Unknown'];
        albumArtUri = dummyArtUri;
        coverArtData = Uint8List(0);
      });
      updateSMTC();
    }
  }

  Future<void> downloadNowTrackCauseItDoesntExists() async {
    String trackID = PathManager.getFileName(
      widget.songs[nowPlayingIndex],
    ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');
    setState(() {
      trackName = 'Loading...';
    });

    widget.musicInterface
        .getTrackDownloadLink(trackID)
        .then((link) async {
          logger.fine('Download link: $link');
          player.stop();
          player.setSource(UrlSource(link));
          player.play(UrlSource(link));
          return widget.musicInterface.downloadTrack(
            '$downloadDirectory/quarkaudiotemptrack$trackID.mp3',
            trackID,
          );
        })
        .then((onValue) {
          logger.fine('Track downloaded successfully');
          Map? foundMap = widget.ymTracksInfo.firstWhere(
            (map) => map['id'] == trackID,
            orElse: () => null,
          );

          if (foundMap != null) {
            setState(() {
              logger.fine('States');
              trackName = foundMap['title'];
              trackArtistNames = [foundMap['artists']];
              albumArtUri = 'https://${foundMap['cover']}';
            });
            updateSMTC();
          } else {
            logger.warning('Track metadata not found! Excecuting fallback.');
            setState(() {
              trackName = 'Unknown';
              trackArtistNames = ['Unknown'];
              albumArtUri = dummyArtUri;
            });
            updateSMTC();
          }
          // });
        })
        .catchError((error) {
          logger.warning('Downloading track failed: $error');
        });
  }

  // I was too lazy to make a class with an audio player, so we live like this for now
  Future<void> steps({
    // Ну не надо, ну не стукай
    bool nextStep = false,
    bool previousStep = false,
    bool stopSteps = false,
    bool replayStep = false,
  }) async {
    _hideWarningMetadataOverlay();

    if (nextStep) {
      logger.fine('Current track index: $nowPlayingIndex');

      _currentToken?.cancel();
      final token = CancelToken();
      _currentToken = token;
      if (mounted) {
        setState(() {
          nowPlayingIndex++;

          if (nowPlayingIndex >= widget.songs.length) {
            nowPlayingIndex = 0;
          }
          nowPlayingIndexNotifier.value = nowPlayingIndex;
        });
      }

      player.stop();
      var trackfile = File(widget.songs[nowPlayingIndex]);
      var exists = await trackfile.exists();

      if (!exists) {
        await downloadNowTrackCauseItDoesntExists();
      } else {
        if (isPlayling) {
          await Future.delayed(Duration(milliseconds: 50));
          player.play(DeviceFileSource(widget.songs[nowPlayingIndex]));
        } else {
          currentPosition = '0:00';
          songDurationWidget = '0:00';
        }
      }

      updatePageTag();

      Database.setValue('lastPlaylistTrack', widget.songs[nowPlayingIndex]);
      updateSMTC();
    }

    if (previousStep) {
      if (mounted) {
        setState(() {
          _currentToken?.cancel();
          nowPlayingIndex--;
          if (nowPlayingIndex < 0) {
            nowPlayingIndex = widget.songs.length - 1;
          }
          nowPlayingIndexNotifier.value = nowPlayingIndex;
        });
      }

      player.stop();
      var trackfile = File(widget.songs[nowPlayingIndex]);
      var exists = await trackfile.exists();

      if (!exists) {
        await downloadNowTrackCauseItDoesntExists();
      } else {
        if (isPlayling) {
          logger.info('Playing previous track $nowPlayingIndex');
          await Future.delayed(Duration(milliseconds: 50));
          player.play(DeviceFileSource(widget.songs[nowPlayingIndex]));
        } else {
          currentPosition = '0:00';
          songDurationWidget = '0:00';
        }
      }

      updatePageTag();

      Database.setValue('lastPlaylistTrack', widget.songs[nowPlayingIndex]);

      updateSMTC();
    }

    if (stopSteps) {
      if (mounted) {
        setState(() {
          isPlayling = !isPlayling;

          if (!isPlayling) {
            player.pause();
            // smtc.setPlaybackStatus(PlaybackStatus.paused);
          } else {
            // smtc.setPlaybackStatus(PlaybackStatus.playing);
            player.play(DeviceFileSource(widget.songs[nowPlayingIndex]));
            Database.setValue(
              'lastPlaylistTrack',
              widget.songs[nowPlayingIndex],
            );
          }
        });
      }
    }

    if (replayStep) {
      _currentToken?.cancel();
      final token = CancelToken();
      _currentToken = token;
      // This function is intended for when we have designated index outside this class and want to reproduce it.
      player.stop();
      if (isPlayling) {
        logger.fine('it should be playing');
        player.setSource(DeviceFileSource(widget.songs[nowPlayingIndex + 1]));
        player.stop();

        Future.delayed(Duration(milliseconds: 100), () {
          player.play(DeviceFileSource(widget.songs[nowPlayingIndex]));
        });
      } else {
        currentPosition = '0:00';
        songDurationWidget = '0:00';
      }
      String trackID = PathManager.getFileName(
        widget.songs[nowPlayingIndex],
      ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');
      Map? foundMap = widget.ymTracksInfo.firstWhere(
        (map) => map['id'] == trackID,
        orElse: () => null,
      );

      if (foundMap != null) {
        setState(() {
          trackName = foundMap['title'];
          trackArtistNames = [foundMap['artists']];
          albumArtUri = 'https://${foundMap['cover']}';
        });
      }

      Database.setValue('lastPlaylistTrack', widget.songs[nowPlayingIndex]);
      updateSMTC();
    }

    try {
      String trackID2 = PathManager.getFileName(
        nowPlayingIndex - 1 < widget.songs.length
            ? widget.songs[0]
            : widget.songs[nowPlayingIndex],
      ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');

      String trackID3 = PathManager.getFileName(
        nowPlayingIndex + 1 > widget.songs.length
            ? widget.songs[0]
            : widget.songs[nowPlayingIndex + 2],
      ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');

      var trackfile2 = File(
        nowPlayingIndex - 1 < widget.songs.length
            ? widget.songs[0]
            : widget.songs[nowPlayingIndex],
      );
      var exists2 = await trackfile2.exists();
      var trackfile3 = File(
        nowPlayingIndex + 1 > widget.songs.length
            ? widget.songs[0]
            : widget.songs[nowPlayingIndex + 2],
      );
      var exists3 = await trackfile3.exists();

      Future.delayed(Duration(milliseconds: 50), () {
        if (!exists2) {
          widget.musicInterface
              .getTrackDownloadLink(trackID2)
              .then((link) async {
                return widget.musicInterface.downloadTrack(
                  '$downloadDirectory/quarkaudiotemptrack$trackID2.mp3',
                  trackID2,
                  link,
                );
              })
              .then((onValue) async {
                logger.fine('Track downloaded successfully');
              })
              .catchError((error) {
                logger.warning('Downloading previous track failed: $error');
              });
        }

        if (!exists3) {
          widget.musicInterface
              .getTrackDownloadLink(trackID3)
              .then((link) async {
                logger.fine('Download link: $link');
                return widget.musicInterface.downloadTrack(
                  '$downloadDirectory/quarkaudiotemptrack$trackID3.mp3',
                  trackID3,
                  link,
                );
              })
              .then((onValue) async {
                logger.fine('Track downloaded successfully');
              })
              .catchError((error) {
                logger.warning('Downloading next track failed: $error');
              });
        }
      });
    } catch (e) {
      logger.warning(
        'An error occurred while checking the existence of the next and previous tracks: $e',
      );
    }
  }

  // Working with shuffle
  Future<void> createNewShuffledPlaylist({
    bool turnOnShuffle = false,
    bool turnOffShuffle = false,
  }) async {
    if (turnOnShuffle == true) {
      Database.setValue('shuffle', true);

      List<String> shuffledPlaylist = [];

      shuffledPlaylist = List.from(notShuffledPlaylist)..shuffle();
      widget.songs.clear();
      widget.songs.addAll(shuffledPlaylist);
      logger.fine('Shuffled playlist created: $shuffledPlaylist');
    } else if (turnOffShuffle == true) {
      Database.setValue('shuffle', false);
      widget.songs.clear();
      widget.songs.addAll(notShuffledPlaylist);
      logger.fine('Unshuffled playlist created: $notShuffledPlaylist');
    }
  }

  // Setup track complete listener
  void _setupPlayerListeners() {
    player.onPlayerComplete.listen((_) async {
      if (isRepeatEnable == false) {
        await steps(nextStep: true);
      } else {
        await steps(replayStep: true);
      }
    });
  }

  // Progressing track playback
  void progressState() {
    player.onPositionChanged.listen((position) async {
      final duration = await player.getDuration();
      String durationLocal = '';
      var currentPos = 0.0;

      if (duration != null) {
        var timeInMinutes = duration.inSeconds ~/ 60;
        var timeInSeconds = duration.inSeconds % 60;

        durationLocal += '$timeInMinutes:';

        if (timeInSeconds < 10) {
          durationLocal += '0$timeInSeconds';
        } else {
          durationLocal += '$timeInSeconds';
        }

        currentPos = position.inMicroseconds / duration.inMicroseconds * 100.0;
        if (currentPos > 100.0) {
          currentPos = 100.0;
        }
      }

      var timeInMinutes = position.inSeconds ~/ 60;
      var timeInSeconds = position.inSeconds % 60;

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
          songDurationWidget = durationLocal;
          songProgress = currentPos;

          if (isSliderActive) volumeController.value = currentPos / 100;
        });
      }
      checkScreenWidth();
    });
  }

  void checkScreenWidth() async {
    if (mounted) {
      if (isPlaylistOpened) {
        if (MediaQuery.of(context).size.width > 780) {
          playerPadding = 400.0;
        } else {
          playerPadding = 0.0;
        }
      }
    }
  }

  // Changing volume
  void changeVolume(volume) {
    if (mounted) {
      setState(() {
        volumeValue = volume;
        player.setVolume(volumeValue);
      });
    }

    Database.setValue('volume', volumeValue);
  }

  // Get track timing by 0-100 value from timeline slider
  Future<int> getSecondsByValue(double value) async {
    final duration = await player.getDuration();
    if (duration != null) {
      return ((value / 100.0) * duration.inSeconds).round();
    }
    return 0;
  }

  // Logger init function
  Future<void> initLogger() async {
    final dir = await getApplicationCacheDirectory();
    logFile = File('${dir.path}/yandex_music_playlist.log');
    if (await logFile.exists()) {
      await logFile.delete();
    }
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      final logLine =
          '${DateTime.now()} - ${record.level.name}: ${record.message}';
      logFile.writeAsStringSync('$logLine\n', mode: FileMode.append);
    });
  }

  // Updating native media information
  Future<void> updateSMTC() async {
    Duration? nullableDuration = await player.getDuration();
    Duration duration = nullableDuration ?? Duration.zero;
    await (_audioHandler as MyAudioHandler).setPlayback(
      trackName,
      trackArtistNames?.join(', ') ?? 'Unknown',
      'album',
      duration,
      albumArtUri,
      nowPlayingIndex.toString(),
    );
  }

  Future<void> _initAudioService() async {
    _audioHandler = await AudioService.init(
      builder:
          () => MyAudioHandler(
            onPlay:
                () => setState(() {
                  steps(stopSteps: true);
                }),
            onPause:
                () => setState(() {
                  steps(stopSteps: true);
                }),
            onNext:
                () => setState(() {
                  steps(nextStep: true);
                }),
            onPrevious:
                () => setState(() {
                  steps(previousStep: true);
                }),
            onSeek: (position) => setState(() => {}),
          ),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'quark.quarkaudio.app.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: true,
      ),
    );
  }

  @override
  void initState() {
    initLogger();

    getApplicationCacheDirectory().then((direct) {
      setState(() {
        downloadDirectory = direct.path;
      });
    });
    _initAudioService();
    super.initState();
    _setupPlayerListeners();
    logger.info("setupPlayerListeners initalizing...");
    progressState();
    logger.info("Progress state initalizing...");

    Database.init();
    logger.info("Database initalizing...");

    playlistView = widget.songs;
    // overlayState = PlaylistOverlayState(
    //   songs: widget.songs,
    //   ymTracksInfo: widget.ymTracksInfo,
    //   nowPlayingIndexNotifier: nowPlayingIndexNotifier,
    //   onTrackTap: _handleTrackTap,
    //   onRefresh: checkPlaylistUpdates,
    //   search: search,
    //   searchController: searchController,
    // );

    // INITIALIZING PLAYLIST, INFO MESSAGE AND SETTINGS .... YOU KNOW

    warningMetadataAnimationController = AnimationController(
      duration: Duration(milliseconds: (650 * transitionSpeed).round()),
      vsync: this,
    );

    warningMetadataOffsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: warningMetadataAnimationController,
        curve: Curves.ease,
      ),
    );

    playlistAnimationController = AnimationController(
      duration: Duration(milliseconds: (650 * transitionSpeed).round()),
      vsync: this,
    );

    playlistOffsetAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: playlistAnimationController, curve: Curves.ease),
    );
    settingsAnimationController = AnimationController(
      duration: Duration(milliseconds: (850 * transitionSpeed).round()),
      vsync: this,
    );

    settingsOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: settingsAnimationController, curve: Curves.ease),
    );

    Future.delayed(Duration(milliseconds: 200), () {
      _precacheImages();
      String trackID = PathManager.getFileName(
        widget.songs[nowPlayingIndex],
      ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');
      Map? foundMap = widget.ymTracksInfo.firstWhere(
        (map) => map['id'] == trackID,
        orElse: () => null,
      );

      if (foundMap != null) {
        // var coverArt = await RecognizerService.urlImageToUint8List('https://${foundMap['cover']}');
        logger.fine('Cover art URL: https://${foundMap['cover']}');
        setState(() {
          logger.fine('States');
          trackName = foundMap['title'];
          trackArtistNames = [foundMap['artists']];
          albumArtUri = 'https://${foundMap['cover']}';
          coverArtData = Uint8List(0);
        });
        updateSMTC();
      } else {
        setState(() {
          trackName = 'Unknown';
          trackArtistNames = ['Unknown'];
          albumArtUri = dummyArtUri;
          coverArtData = Uint8List(0);
        });
      }
    });

    Database.getKeys().then((value) {
      logger.info("Get keys from database...");

      // If the application starts for the first time, we set some standard values
      if (value.isEmpty) {
        logger.info("Putting in database...");

        Database.setValue('shuffle', false);
        Database.setValue('volume', 0.7);
        Database.setValue('metadataRecognize', true);
        Database.setValue('autoTrackSorting', true);
        Database.setValue("isBackgroudArtEnable", true);
        Database.setValue("isWhiteTheme", false);
        Database.setValue('transitionSpeed', 1.0);
      }
    });

    Database.getKeys().then(
      (value) => logger.info("Database loaded. Variables: $value"),
    ); // For debugging, we display all database values

    // Database.setValue(
    //   'lastPlaylist',
    //   songList,
    // ); // After initializing the playlist, we add it to the table as the last one

    Database.getValue('lastPlaylist').then(
      (value) => logger.info("Last playlist: $value"),
    ); // Getting data from the table and set the values

    Database.getValue('volume').then(
      (volume) => {
        if (volume != null && mounted)
          {
            setState(() {
              volumeValue = volume;
              player.setVolume(volume);
            }),
          },
      },
    );

    Database.getValue("isBackgroudArtEnable").then((value) {
      if (value != null && mounted) {
        isBackgroudArtEnable = value;
      }
    });

    Database.getValue("isWhiteTheme").then((value) {
      if (value != null && mounted) {
        setState(() {
          isWhiteTheme = value;

          if (isWhiteTheme) {
            themeColor = Color.fromARGB(255, 197, 197, 197);
            backgroundGradientColor = Color.fromRGBO(68, 67, 67, 1);
            backgroundSecondGradientColor = Color.fromRGBO(201, 201, 201, 1);
            albumArtShadowColor = Color.fromARGB(255, 66, 66, 66);
            alternativeThemeColor = Color.fromARGB(255, 34, 34, 34);
          }
        });
      }
    });

    Database.getValue('metadataRecognize').then((value) {
      if (value != null && mounted) {
        setState(() {
          isMetadataRecognizeEnable = value;
        });
      }
      if (value == null && mounted) {
        Database.setValue('metadataRecognize', true).then(
          (value) => {
            setState(() {
              isMetadataRecognizeEnable = true;
            }),
          },
        );
      }
    });

    Database.getValue("transitionSpeed").then((value) {
      if (value != null && mounted) {
        setState(() {
          transitionSpeed = value;
        });
      }
    });
  }

  void _handleTrackTap(int index) {
    FileTags.getAllTracksMetadata(widget.songs);
    setState(() {
      if (search && searchController.text != '') {
        int newPlayingIndex = widget.songs.indexWhere((test) {
          String trackID = PathManager.getFileName(
            test,
          ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');
          return trackID ==
              PathManager.getFileName(
                widget.songs[index],
              ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');
        });
        nowPlayingIndex = newPlayingIndex;
        steps(nextStep: true);
      } else {
        nowPlayingIndex = index;
        nowPlayingIndexNotifier.value = nowPlayingIndex;
        steps(nextStep: true);
      }
    });
  }

  Future<void> _precacheImages() async {
    List<Future> precacheFutures = [];

    for (int index = 0; index < widget.songs.length; index++) {
      String trackID = PathManager.getFileName(
        widget.songs[index],
      ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');

      Map? foundMap = widget.ymTracksInfo.firstWhere(
        (map) => map['id'] == trackID,
        orElse: () => null,
      );

      if (foundMap != null) {
        String imageUrl = 'https://${foundMap['cover']}';
        precacheFutures.add(
          precacheImage(
            CachedNetworkImageProvider(imageUrl),
            context,
          ).catchError((error) {
            logger.warning('Error precaching image for track $trackID: $error');
          }),
        );
      }
    }
    print(widget.playlistInfo);

    // Timer.periodic(Duration(minutes: 5), (timer) async {
    //   checkPlaylistUpdates();
    // });
  }

  void checkPlaylistUpdates() async {
    print('check');
  }

  Future<void> searchPlaylist(String query) async {
    _searchDebounceTimer?.cancel();
    _searchCancelToken?.cancel();
    _searchCancelToken = null;

    List<String> suggestions =
        widget.songs.where((info) {
          String trackID = PathManager.getFileName(
            info,
          ).replaceAll(RegExp(r'^quarkaudiotemptrack|\.mp3$'), '');

          Map? foundMap = widget.ymTracksInfo.firstWhere(
            (map) => map['id'] == trackID,
            orElse: () => null,
          );

          var name = 'Unknown';
          if (foundMap != null) {
            name = foundMap['title'];
          }

          return name.toLowerCase().contains(query.toLowerCase());
        }).toList();

    setState(() {
      playlistView = suggestions;
    });

    if (query.isEmpty) return;
    _searchDebounceTimer = Timer(_searchDebounceDuration, () async {
      _searchCancelToken = CancelToken();
      print('starting search');

      try {
        var result = await widget.yandexMusicInstance.search.tracks(
          query,
          0,
          false,
          _searchCancelToken,
        );
        print(result);
      } on YandexMusicException {
        return;
      }
    });
  }

  // Handling exit from player
  @override
  void dispose() {
    _currentToken?.cancel();
    _searchDebounceTimer?.cancel();
    _searchCancelToken?.cancel();
    player.dispose();
    playlistAnimationController.dispose();

    playlistOverlayEntry?.remove();
    warningMetadataOverlayEntry?.remove();
    settingsOverlayEntry?.remove();
    // smtc.disableSmtc();
    // smtc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: (750 * transitionSpeed).round()),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Row(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(albumArtUri),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      backgroundGradientColor,
                      backgroundSecondGradientColor,
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
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: BackdropFilter(
                      key: ValueKey<Uint8List>(coverArtData),
                      filter: ImageFilter.blur(sigmaX: 95.0, sigmaY: 95.0),
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
                                height: 255,
                                width: 255,

                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      albumArtUri,
                                    ),
                                    fit: BoxFit.cover,

                                    colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0),
                                      BlendMode.darken,
                                    ),
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: albumArtShadowColor,
                                      blurRadius: 10,
                                      offset: Offset(5, 10),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 20),

                              SizedBox(
                                width: 500,

                                child: SizedBox(
                                  height: 45,
                                  child: Text(
                                    PathManager.getFileName(trackName),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              Text(
                                trackArtistNames?.join(', ') ?? 'Unknown',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentPosition,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),

                                  SizedBox(
                                    width: 325,

                                    child: InteractiveSlider(
                                      controller: volumeController,
                                      unfocusedHeight: 5,
                                      focusedHeight: 10,
                                      min: 0.0,
                                      max: 100.0,
                                      onProgressUpdated: (value) async {
                                        isSliderActive = true;
                                        try {
                                          final seconds =
                                              await getSecondsByValue(value);
                                          await player.seek(
                                            Duration(seconds: seconds),
                                          );
                                        } catch (e) {
                                          logger.warning(
                                            "Error while seeking duration: $e",
                                          );
                                        }
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

                                      onFocused:
                                          (value) => {isSliderActive = false},
                                    ),
                                  ),

                                  Text(
                                    songDurationWidget,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 5),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // PREVIOUS BUTTON
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
                                        await steps(previousStep: true);
                                      },

                                      child: Container(
                                        height: 40,
                                        width: 40,

                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            31,
                                            255,
                                            255,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.skip_previous,

                                              color:
                                                  isWhiteTheme
                                                      ? alternativeThemeColor
                                                      : Colors.white,
                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // // PREVIOUS BUTTON
                                  SizedBox(width: 15),

                                  // PLAY BUTTON
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
                                        await steps(stopSteps: true);
                                      },

                                      child: Container(
                                        height: 50,
                                        width: 50,

                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            31,
                                            255,
                                            255,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              isPlayling
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              color:
                                                  isWhiteTheme
                                                      ? alternativeThemeColor
                                                      : Colors.white,

                                              size: 28,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // // PLAY BUTTON
                                  SizedBox(width: 15),

                                  // NEXT SONG BUTTON
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
                                        await steps(nextStep: true);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,

                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            31,
                                            255,
                                            255,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.skip_next,
                                              color:
                                                  isWhiteTheme
                                                      ? alternativeThemeColor
                                                      : Colors.white,

                                              size: 24,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // // NEXT SONG BUTTON
                              SizedBox(height: 5),

                              // VOLUME SLIDER
                              SizedBox(
                                width: 325,

                                child: InteractiveSlider(
                                  startIcon: const Icon(Icons.volume_down),
                                  endIcon: const Icon(Icons.volume_up),
                                  min: 0.0,
                                  max: 1.0,
                                  brightness: Brightness.light,
                                  initialProgress: volumeValue,
                                  iconColor: Colors.white,
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.white],
                                  ),
                                  onChanged: (value) => changeVolume(value),
                                ),
                              ),

                              // // VOLUME SLIDER
                              SizedBox(height: 20),

                              // BUTTONS ROW
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // PLAYLIST BUTTON
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),

                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      onTap: _showPlaylistOverlay,
                                      child: Container(
                                        height: 35,
                                        width: 35,

                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            31,
                                            255,
                                            255,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.featured_play_list_outlined,
                                              color:
                                                  isPlaylistOpened
                                                      ? Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        1,
                                                      )
                                                      : Color.fromRGBO(
                                                        255,
                                                        255,
                                                        255,
                                                        0.500,
                                                      ),
                                              size: 20,
                                              key: ValueKey<bool>(
                                                isPlaylistOpened,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // //PLAYLIST BUTTON
                                  SizedBox(width: 15),

                                  // SHUFFLITAS
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),

                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),

                                      onTap: () async {
                                        if (mounted) {
                                          setState(() {
                                            isShuffleEnable = !isShuffleEnable;
                                          });
                                        }
                                        _hidePlaylistOverlay();
                                      },

                                      child: Container(
                                        height: 35,
                                        width: 35,

                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            31,
                                            255,
                                            255,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),

                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AnimatedSwitcher(
                                              duration: Duration(
                                                milliseconds: 120,
                                              ),
                                              transitionBuilder: (
                                                child,
                                                animation,
                                              ) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                              layoutBuilder:
                                                  (
                                                    currentChild,
                                                    previousChildren,
                                                  ) => Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ...previousChildren,
                                                      if (currentChild != null)
                                                        currentChild,
                                                    ],
                                                  ),
                                              child: Icon(
                                                isShuffleEnable
                                                    ? Icons.shuffle
                                                    : Icons.shuffle_outlined,
                                                key: ValueKey<bool>(
                                                  isShuffleEnable,
                                                ),
                                                color:
                                                    isShuffleEnable
                                                        ? Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1,
                                                        )
                                                        : Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          0.5,
                                                        ),
                                                size: 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // // SHUFFLITAS
                                  SizedBox(width: 15),
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),

                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            isLiked = !isLiked;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 35,

                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            31,
                                            255,
                                            255,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),

                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AnimatedSwitcher(
                                              duration: Duration(
                                                milliseconds: 120,
                                              ),
                                              transitionBuilder: (
                                                child,
                                                animation,
                                              ) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                              layoutBuilder:
                                                  (
                                                    currentChild,
                                                    previousChildren,
                                                  ) => Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ...previousChildren,
                                                      if (currentChild != null)
                                                        currentChild,
                                                    ],
                                                  ),

                                              child: Icon(
                                                Icons.favorite_outlined,
                                                color:
                                                    isLiked
                                                        ? Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1,
                                                        )
                                                        : Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          0.500,
                                                        ),
                                                size: 20,
                                                key: ValueKey<bool>(isLiked),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),

                                  // REPEATER BUTTON
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),

                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            isRepeatEnable = !isRepeatEnable;
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 35,

                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            31,
                                            255,
                                            255,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),

                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            AnimatedSwitcher(
                                              duration: Duration(
                                                milliseconds: 120,
                                              ),
                                              transitionBuilder: (
                                                child,
                                                animation,
                                              ) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                              layoutBuilder:
                                                  (
                                                    currentChild,
                                                    previousChildren,
                                                  ) => Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      ...previousChildren,
                                                      if (currentChild != null)
                                                        currentChild,
                                                    ],
                                                  ),

                                              child: Icon(
                                                Icons.repeat_one_outlined,
                                                color:
                                                    isRepeatEnable
                                                        ? Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          1,
                                                        )
                                                        : Color.fromRGBO(
                                                          255,
                                                          255,
                                                          255,
                                                          0.500,
                                                        ),
                                                size: 20,
                                                key: ValueKey<bool>(
                                                  isRepeatEnable,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // // REPEATER BUTTON
                                  SizedBox(width: 15),

                                  // MENU BUTTON
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30),
                                    ),

                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),

                                      onTap: _showSettingsOverlay,
                                      child: Container(
                                        height: 35,
                                        width: 35,

                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                            31,
                                            255,
                                            255,
                                            255,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.menu,
                                              color: Color.fromRGBO(
                                                255,
                                                255,
                                                255,
                                                0.500,
                                              ),

                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // // MENU BUTTON
                                ],
                              ),
                              // // BUTTONS ROW
                            ],
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
      ),
    );
  }
}
