import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yandex_music/yandex_music.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

Widget playlistSearch(
  TextEditingController searchController,
  Function(String newView) search,
) {
  return TextField(
    cursorColor: Colors.white.withOpacity(0.8),
    cursorErrorColor: Colors.white,
    onChanged: (value) {
      search(value);
    },
    controller: searchController,
    style: TextStyle(color: Colors.white.withOpacity(0.8)),
    decoration: InputDecoration(
      hintText: 'Search',
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      filled: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}

class PlaylistOverlay extends StatefulWidget {
  final AnimationController playlistAnimationController;
  final Animation<Offset> playlistOffsetAnimation;
  final VoidCallback togglePlaylist;
  final List<Track> playlist;
  final String playlistName;
  final Function(List<Track> newPlaylist) setPlaylist;
  final YandexMusic yandexMusic;
  final Function({
    bool next,
    bool previous,
    bool playpause,
    bool reload,
    Track? custom,
  })
  changeTrack;
  final Function(List<Track> playlist) changePlaylist;
  final Function(int operation) showOperation;
  final List<String> likedPlaylist;
  final Function(
    Track, [
    bool? addToEnd,
    bool? addLikedTrack,
    bool? removeLiked,
  ])
  addNext;
  final Function(Track track) removeTrack;

  const PlaylistOverlay({
    super.key,
    required this.playlistAnimationController,
    required this.playlistOffsetAnimation,
    required this.togglePlaylist,
    required this.playlist,
    required this.playlistName,
    required this.changeTrack,
    required this.changePlaylist,
    required this.setPlaylist,
    required this.yandexMusic,
    required this.showOperation,
    required this.likedPlaylist,
    required this.addNext,
    required this.removeTrack,
  });

  @override
  State<PlaylistOverlay> createState() => _PlaylistOverlayState();
}

class _PlaylistOverlayState extends State<PlaylistOverlay> {
  late final TextEditingController _searchController;
  late List<Track> playlistView;
  Timer? _searchDebounceTimer;
  final Duration _searchDebounceDuration = const Duration(milliseconds: 500);
  CancelToken? searchCancel = CancelToken();
  Color popupIconsColor = Colors.white.withAlpha(170);
  Color popupTextColor = Colors.white.withAlpha(220);
  final double popupIconSize = 22;
  final double popupSpaceBetween = 10;
  bool menuOpened = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    playlistView = [...widget.playlist];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PlaylistOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.playlist != widget.playlist) {
      playlistView = [...widget.playlist];
      _searchController.clear();
    }
  }

  void search(String search, [bool? nonuser]) {
    _searchDebounceTimer?.cancel();
    searchCancel?.cancel();
    searchCancel = null;

    var filtered = widget.playlist.where((track) {
      final searchLower = search.toLowerCase();
      if (track.title.toLowerCase().contains(searchLower)) {
        return true;
      }

      for (final artist in track.artists) {
        final artistTitle = artist.title;
        if (artistTitle != null) {
          if (artistTitle.toLowerCase().contains(searchLower)) {
            return true;
          }
        }
      }

      for (final album in track.albums) {
        final albumtitle = album.title;
        if (albumtitle != null) {
          if (albumtitle.toLowerCase().contains(searchLower)) {
            return true;
          }
        }
      }

      return false;
    }).toList();

    setState(() {
      playlistView = filtered;
    });

    if (nonuser == null) {
      final currentQuery = search;

      _searchDebounceTimer = Timer(_searchDebounceDuration, () async {
        if (search.isEmpty || currentQuery != search) {
          return;
        }

        searchCancel = CancelToken();

        try {
          var directory = await getApplicationCacheDirectory();
          var result = await widget.yandexMusic.search.tracks(search);
          for (var track in result) {
            track.filepath =
                '${directory.path}/cisum_xednay_krauq${track.id}.flac';
            filtered.add(track);
          }

          if (currentQuery == search && currentQuery.isNotEmpty) {
            setState(() {
              playlistView = filtered;
            });
          }
        } catch (e) {
          widget.showOperation(-1);
        }
      });
    }
  }

  void searchSimilar(String trackId) {}

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      child: SlideTransition(
        position: widget.playlistOffsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity != null &&
                  details.primaryVelocity!.abs() > 500) {
                widget.togglePlaylist();
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
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 50,
                              left: 15,
                              right: 15,
                              bottom: 10,
                            ),
                            child: playlistSearch(_searchController, search),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: playlistView.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  trailing: PopupMenuButton(
                                    iconColor: Colors.white.withOpacity(0.6),
                                    elevation: 1000,
                                    offset: Offset(70, 0),
                                    color: Color.fromARGB(20, 255, 255, 255),
                                    onCanceled: () {
                                      menuOpened = false;
                                    },
                                    itemBuilder: (context) {
                                      if (menuOpened) {
                                        return [];
                                      } else {
                                        menuOpened = true;
                                        return [
                                          PopupMenuItem(
                                            onTap: () {
                                              if (widget.likedPlaylist.contains(
                                                playlistView[index].id,
                                              )) {
                                                try {
                                                  widget.yandexMusic.usertracks
                                                      .unlike([
                                                        playlistView[index].id,
                                                      ]);
                                                  widget.showOperation(1);
                                                  setState(() {
                                                    widget.likedPlaylist.remove(
                                                      playlistView[index].id,
                                                    );
                                                  });
                                                  widget.addNext(
                                                    playlistView[index],
                                                    null,
                                                    null,
                                                    true,
                                                  );
                                                } catch (e) {
                                                  widget.showOperation(-1);
                                                }
                                              } else {
                                                try {
                                                  widget.yandexMusic.usertracks
                                                      .like([
                                                        playlistView[index].id,
                                                      ]);
                                                  widget.showOperation(1);
                                                  widget.likedPlaylist.add(
                                                    playlistView[index].id,
                                                  );
                                                  widget.addNext(
                                                    playlistView[index],
                                                    null,
                                                    true,
                                                  );
                                                } catch (e) {
                                                  widget.showOperation(-1);
                                                }
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.favorite,
                                                  size: popupIconSize,
                                                  color: popupIconsColor,
                                                ),
                                                SizedBox(
                                                  width: popupSpaceBetween,
                                                ),
                                                Text(
                                                  widget.likedPlaylist.contains(
                                                        playlistView[index].id,
                                                      )
                                                      ? 'Unlike'
                                                      : 'Like',
                                                  style: TextStyle(
                                                    fontFamily: 'noto',
                                                    color: popupTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () {
                                              widget.removeTrack(
                                                playlistView[index],
                                              );
                                              setState(() {
                                                playlistView.remove(
                                                  playlistView[index],
                                                );
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.delete_sweep_rounded,

                                                  size: popupIconSize,
                                                  color: popupIconsColor,
                                                ),
                                                SizedBox(
                                                  width: popupSpaceBetween,
                                                ),
                                                Text(
                                                  'Remove from playlist',
                                                  style: TextStyle(
                                                    fontFamily: 'noto',
                                                    color: popupTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () async {
                                              var track = playlistView[index];
                                              var directory =
                                                  await getApplicationCacheDirectory();
                                              Track newTrack = Track(track.raw);
                                              newTrack.filepath =
                                                  '${directory.path}/cisum_xednay_krauq${newTrack.id}.flac';
                                              index = widget.addNext(newTrack);
                                              print(index);
                                              setState(() {
                                                playlistView.insert(
                                                  index,
                                                  newTrack,
                                                );
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons
                                                      .arrow_up_to_line,

                                                  size: popupIconSize,
                                                  color: popupIconsColor,
                                                ),
                                                SizedBox(
                                                  width: popupSpaceBetween,
                                                ),
                                                Text(
                                                  'Play next',
                                                  style: TextStyle(
                                                    fontFamily: 'noto',
                                                    color: popupTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () async {
                                              var track = playlistView[index];
                                              var directory =
                                                  await getApplicationCacheDirectory();
                                              Track newTrack = Track(track.raw);
                                              newTrack.filepath =
                                                  '${directory.path}/cisum_xednay_krauq${newTrack.id}.flac';
                                              index = widget.addNext(
                                                newTrack,
                                                true,
                                              );
                                              print(index);
                                              setState(() {
                                                playlistView.add(newTrack);
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons
                                                      .arrow_up_to_line,
                                                  size: popupIconSize,
                                                  color: popupIconsColor,
                                                ),
                                                SizedBox(
                                                  width: popupSpaceBetween,
                                                ),
                                                Text(
                                                  'Add to bottom of queue',
                                                  style: TextStyle(
                                                    fontFamily: 'noto',
                                                    color: popupTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () async {
                                              try {
                                                _searchController.text =
                                                    'Similar: ${playlistView[index].title}';
                                                List<Track> filtered = [];
                                                var directory =
                                                    await getApplicationCacheDirectory();
                                                var result = await widget
                                                    .yandexMusic
                                                    .tracks
                                                    .getSimilar(
                                                      playlistView[index].id,
                                                    );

                                                for (Track track in result) {
                                                  track.filepath =
                                                      '${directory.path}/cisum_xednay_krauq${track.id}.flac';
                                                  filtered.add(track);
                                                }
                                                setState(() {
                                                  playlistView = filtered;
                                                });
                                              } catch (e) {
                                                print(e);
                                                widget.showOperation(-1);
                                              }
                                            },
                                            enabled: playlistView[index]
                                                .albums
                                                .isNotEmpty,
                                            child: Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.search,
                                                  size: popupIconSize,
                                                  color: popupIconsColor,
                                                ),
                                                SizedBox(
                                                  width: popupSpaceBetween,
                                                ),
                                                Text(
                                                  'Find similar',
                                                  style: TextStyle(
                                                    fontFamily: 'noto',
                                                    color: popupTextColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (playlistView[index]
                                              .albums
                                              .isEmpty)
                                            PopupMenuItem(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.pencil,
                                                    size: popupIconSize,
                                                    color: popupIconsColor,
                                                  ),
                                                  SizedBox(
                                                    width: popupSpaceBetween,
                                                  ),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      fontFamily: 'noto',
                                                      color: popupTextColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          // PopupMenuItem(
                                          //   child: Row(
                                          //     children: [
                                          //       Icon(
                                          //         CupertinoIcons.info,
                                          //         size: popupIconSize,
                                          //         color: popupIconsColor,
                                          //       ),
                                          //       SizedBox(
                                          //         width: popupSpaceBetween,
                                          //       ),
                                          //       Text(
                                          //         'Show about',
                                          //         style: TextStyle(
                                          //           color: popupTextColor,
                                          //         ),
                                          //       ),
                                          //       PopupMenuButton(
                                          //         constraints: BoxConstraints(
                                          //           minWidth: 300,
                                          //           maxWidth:
                                          //               MediaQuery.of(
                                          //                 context,
                                          //               ).size.width -
                                          //               10,
                                          //         ),
                                          //         iconColor: Colors.white
                                          //             .withOpacity(0.6),
                                          //         elevation: 1000,
                                          //         offset: Offset(70, 0),
                                          //         color: Color.fromARGB(
                                          //           20,
                                          //           255,
                                          //           255,
                                          //           255,
                                          //         ),
                                          //         onCanceled: () {
                                          //           menuOpened = false;
                                          //         },
                                          //         itemBuilder: (context) {
                                          //           menuOpened = true;
                                          //           return [
                                          //             PopupMenuItem(
                                          //               onTap: () {},
                                          //               child: Row(
                                          //                 children: [
                                          //                   Icon(
                                          //                     Icons.title,
                                          //                     size:
                                          //                         popupIconSize,
                                          //                     color:
                                          //                         popupIconsColor,
                                          //                   ),
                                          //                   SizedBox(
                                          //                     width:
                                          //                         popupSpaceBetween,
                                          //                   ),
                                          //                   Text(
                                          //                     'Title: ${playlistView[index].title}',
                                          //                     style: TextStyle(
                                          //                       color:
                                          //                           popupTextColor,
                                          //                     ),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //             if (playlistView[index]
                                          //                 .artists
                                          //                 .isNotEmpty)
                                          //               PopupMenuItem(
                                          //                 onTap: () {},
                                          //                 child: Row(
                                          //                   children: [
                                          //                     Icon(
                                          //                       Icons
                                          //                           .face_6_outlined,
                                          //                       size:
                                          //                           popupIconSize,
                                          //                       color:
                                          //                           popupIconsColor,
                                          //                     ),
                                          //                     SizedBox(
                                          //                       width:
                                          //                           popupSpaceBetween,
                                          //                     ),
                                          //                     Text(
                                          //                       'Artists: ${playlistView[index].artists.map((artist) => artist.title ?? 'Unknown').join(', ')}',
                                          //                       style: TextStyle(
                                          //                         color:
                                          //                             popupTextColor,
                                          //                       ),
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //               ),
                                          //             if (playlistView[index]
                                          //                 .albums
                                          //                 .isNotEmpty)
                                          //               PopupMenuItem(
                                          //                 onTap: () {},
                                          //                 child: Row(
                                          //                   children: [
                                          //                     Icon(
                                          //                       Icons.album,
                                          //                       size:
                                          //                           popupIconSize,
                                          //                       color:
                                          //                           popupIconsColor,
                                          //                     ),
                                          //                     SizedBox(
                                          //                       width:
                                          //                           popupSpaceBetween,
                                          //                     ),
                                          //                     Text(
                                          //                       'Album: ${playlistView[index].albums.map((artist) => artist.title ?? 'Unknown').join(', ')}',
                                          //                       style: TextStyle(
                                          //                         color:
                                          //                             popupTextColor,
                                          //                       ),
                                          //                     ),
                                          //                   ],
                                          //                 ),
                                          //               ),
                                          //             PopupMenuItem(
                                          //               onTap: () {},
                                          //               child: Row(
                                          //                 children: [
                                          //                   Icon(
                                          //                     Icons
                                          //                         .access_time_sharp,
                                          //                     size:
                                          //                         popupIconSize,
                                          //                     color:
                                          //                         popupIconsColor,
                                          //                   ),
                                          //                   SizedBox(
                                          //                     width:
                                          //                         popupSpaceBetween,
                                          //                   ),
                                          //                   Text(
                                          //                     'Duration: ${playlistView[index].durationMs}ms',
                                          //                     style: TextStyle(
                                          //                       color:
                                          //                           popupTextColor,
                                          //                     ),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //             PopupMenuItem(
                                          //               onTap: () {},
                                          //               child: Row(
                                          //                 children: [
                                          //                   Icon(
                                          //                     Icons.numbers,
                                          //                     size:
                                          //                         popupIconSize,
                                          //                     color:
                                          //                         popupIconsColor,
                                          //                   ),
                                          //                   SizedBox(
                                          //                     width:
                                          //                         popupSpaceBetween,
                                          //                   ),
                                          //                   Text(
                                          //                     'ID: ${playlistView[index].id}',
                                          //                     style: TextStyle(
                                          //                       color:
                                          //                           popupTextColor,
                                          //                     ),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           ];
                                          //         },
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ];
                                      }
                                    },
                                  ),
                                  onTap: () {
                                    widget.changeTrack(
                                      custom: playlistView[index],
                                    );
                                  },
                                  title: songElement(playlistView[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: appBar(
                          widget.playlistName,
                          widget.togglePlaylist,
                          () {},
                          () {},
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
  }
}

Widget songElement(Track track) {
  return Row(
    children: [
      Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (track.coverByted != null)
                ? MemoryImage(track.coverByted ??= Uint8List(0))
                : CachedNetworkImageProvider(
                    'https://${track.coverUri.replaceAll('%%', '300x300')}',
                  ),

            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0),
              BlendMode.darken,
            ),
          ),

          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 21, 21, 21),
              blurRadius: 10,
              offset: Offset(5, 10),
            ),
          ],
        ),
      ),
      const SizedBox(width: 10),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              track.title,
              overflow: TextOverflow.ellipsis,

              style: TextStyle(color: Colors.white, fontFamily: 'noto'),
            ),
            Text(
              track.artists
                  .map((artist) => artist.title ?? 'Unknown')
                  .join(', '),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey, fontFamily: 'noto'),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget appBar(
  String playlistName,
  Function() togglePlaylist,
  Function() refreshPlaylist,
  Function() search,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        onPressed: search,
        icon: Icon(Icons.search),
        color: Colors.white.withOpacity(0.8),
      ),
      // SizedBox(width: 5,),
      Text(
        playlistName,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
          fontFamily: 'noto',
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: refreshPlaylist,
            icon: Icon(Icons.refresh),
            color: Colors.white.withOpacity(0.8),
          ),
          IconButton(
            onPressed: togglePlaylist,
            icon: Icon(Icons.close),
            color: Colors.white.withOpacity(0.8),
          ),
        ],
      ),
    ],
  );
}

BoxDecoration overlayBoxDecoration() {
  return BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
    borderRadius: const BorderRadius.only(
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
    ),
  );
}
