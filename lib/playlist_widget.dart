import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/widgets/state_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:quark/objects/track.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quark/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final List<PlayerTrack> playlist;
  final String playlistName;
  final YandexMusic yandexMusic;
  final Function({
    bool next,
    bool previous,
    bool playpause,
    bool reload,
    PlayerTrack? custom,
  })
  changeTrack;
  final Function(StateIndicatorOperation operation) showOperation;
  final List<String> likedPlaylist;
  final Function(
    PlayerTrack, [
    bool? addToEnd,
    bool? addLikedTrack,
    bool? removeLiked,
  ])
  addNext;
  final Function(PlayerTrack track) removeTrack;
  final Function(int oldIndex, int newIndex) moveTrack;

  const PlaylistOverlay({
    super.key,
    required this.playlistAnimationController,
    required this.playlistOffsetAnimation,
    required this.togglePlaylist,
    required this.playlist,
    required this.playlistName,
    required this.changeTrack,
    required this.yandexMusic,
    required this.showOperation,
    required this.likedPlaylist,
    required this.addNext,
    required this.removeTrack,
    required this.moveTrack,
  });

  @override
  State<PlaylistOverlay> createState() => _PlaylistOverlayState();
}

class _PlaylistOverlayState extends State<PlaylistOverlay> {
  bool needSync = false;
  bool menuOpened = false;
  final double popupIconSize = 22;
  final double popupSpaceBetween = 10;
  Color popupTextColor = Colors.white.withAlpha(220);
  Color popupIconsColor = Colors.white.withAlpha(170);

  CancelToken? searchCancel = CancelToken();

  late List<PlayerTrack> playlistView;
  late final TextEditingController _searchController;

  Timer? _searchDebounceTimer;
  final Duration _searchDebounceDuration = const Duration(milliseconds: 500);

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

  void search(String query, [bool? nonuser]) async {
    _searchDebounceTimer?.cancel();
    searchCancel?.cancel();
    searchCancel = null;

    var filtered = widget.playlist.where((track) {
      final searchLower = query.toLowerCase();
      if (track.title.toLowerCase().contains(searchLower)) {
        return true;
      }

      for (final artist in track.artists) {
        final artistTitle = artist;

        if (artistTitle.toLowerCase().contains(searchLower)) {
          return true;
        }
      }

      for (final album in track.albums) {
        final albumtitle = album;

        if (albumtitle.toLowerCase().contains(searchLower)) {
          return true;
        }
      }

      return false;
    }).toList();

    setState(() {
      playlistView = filtered;
    });

    if (nonuser == null) {
      final currentQuery = query;

      _searchDebounceTimer = Timer(_searchDebounceDuration, () async {
        bool? enabled = await Database.get(
          DatabaseKeys.yandexMusicSearch.value,
        );
        if (query.isEmpty || currentQuery != query || enabled == false) {
          return;
        }

        searchCancel = CancelToken();

        try {
          var directory = await getApplicationCacheDirectory();
          var result = await widget.yandexMusic.search.search(
            query,
            withBestResults: true,
            withLikesCount: true,
            pageSize: 10,
            cancelToken: searchCancel,
          );
          List<Track> results = result.tracks;
          if (result.bestTrack != null) {
            results.insert(0, result.bestTrack!);
          }
          for (var track in result.tracks) {
            YandexMusicTrack tr = YandexMusicTrack(
              filepath: '${directory.path}/cisum_xednay_krauq${track.id}.flac',
              title: track.title,
              albums: track.albums.isNotEmpty
                  ? track.albums.map((album) => album.title).toList()
                  : ['Unknown album'],
              artists: track.artists.map((album) => album.title).toList(),
              track: track,
            );
            String? cover = track.coverUri;
            cover ??= tr.cover;
            tr.cover = cover;
            filtered.add(tr);
          }

          if (currentQuery == query && currentQuery.isNotEmpty) {
            setState(() {
              playlistView = filtered;
            });
          }
        } on YandexMusicException catch (e) {
          switch (e.type) {
            case YandexMusicExceptionType.initialization:
              try {
                await widget.yandexMusic.init();
                search(query, nonuser);
              } catch (e) {
                break;
              }
            default:
              break;
          }
        } catch (e) {
          widget.showOperation(StateIndicatorOperation.error);
        }
      });
    }
  }

  // WIDGET FUNCTIONS

  void likeUnlike(int index) async {
    if (widget.likedPlaylist.contains(
      (playlistView[index] as YandexMusicTrack).track.id,
    )) {
      try {
        widget.yandexMusic.usertracks.unlike([
          (playlistView[index] as YandexMusicTrack).track.id,
        ]);
        widget.showOperation(StateIndicatorOperation.success);
        setState(() {
          widget.likedPlaylist.remove(
            (playlistView[index] as YandexMusicTrack).track.id,
          );
        });
        widget.addNext(playlistView[index], null, null, true);
      } catch (e) {
        widget.showOperation(StateIndicatorOperation.error);
      }
    } else {
      try {
        widget.yandexMusic.usertracks.like([
          (playlistView[index] as YandexMusicTrack).track.id,
        ]);
        widget.showOperation(StateIndicatorOperation.success);
        widget.likedPlaylist.add(
          (playlistView[index] as YandexMusicTrack).track.id,
        );
        widget.addNext(playlistView[index], null, true);
      } catch (e) {
        widget.showOperation(StateIndicatorOperation.error);
      }
    }
  }

  void removeTrackFromPlaylist(int index) async {
    widget.removeTrack(playlistView[index]);
    setState(() {
      playlistView.remove(playlistView[index]);
    });
  }

  void addNextQueue(int index) async {
    PlayerTrack track = playlistView[index];
    if (track is LocalTrack) {
      LocalTrack tr = LocalTrack(
        filepath: track.filepath,
        title: track.title,
        albums: track.albums,
        artists: track.artists,
        cover: track.cover,
        coverByted: track.coverByted,
      );
      tr.cover = track.cover;
      index = widget.addNext(tr);
      setState(() {
        playlistView.insert(index, tr);
      });
    } else if (track is YandexMusicTrack) {
      YandexMusicTrack tr = YandexMusicTrack(
        filepath: track.filepath,
        title: track.title,
        albums: track.albums,
        artists: track.artists,
        track: track.track,
      );
      tr.cover = track.cover;

      index = widget.addNext(tr);
      print(index);
      setState(() {
        playlistView.insert(index, tr);
      });
    }
  }

  void addBottomQueue(int index) async {
    PlayerTrack track = playlistView[index];
    if (track is LocalTrack) {
      LocalTrack tr = LocalTrack(
        filepath: track.filepath,
        title: track.title,
        albums: track.albums,
        artists: track.artists,
        cover: track.cover,
        coverByted: track.coverByted,
      );
      tr.cover = track.cover;
      index = widget.addNext(tr, true);
      print(index);
      setState(() {
        playlistView.add(tr);
      });
    } else if (track is YandexMusicTrack) {
      YandexMusicTrack tr = YandexMusicTrack(
        filepath: track.filepath,
        title: track.title,
        albums: track.albums,
        artists: track.artists,
        track: track.track,
      );
      tr.cover = track.cover;
      index = widget.addNext(tr, true);
      print(index);
      setState(() {
        playlistView.add(tr);
      });
    }
  }

  void findSimilar(int index) async {
    try {
      _searchController.text = 'Similar: ${playlistView[index].title}';
      List<PlayerTrack> filtered = [];
      var directory = await getApplicationCacheDirectory();
      var result = await widget.yandexMusic.tracks.getSimilar(
        (playlistView[index] as YandexMusicTrack).track.id,
      );

      for (Track track in result) {
        YandexMusicTrack tr = YandexMusicTrack(
          filepath: '${directory.path}/cisum_xednay_krauq${track.id}.flac',
          title: track.title,
          albums: track.albums.isNotEmpty
              ? track.albums.map((album) => album.title).toList()
              : ['Unknown album'],
          artists: track.artists.map((album) => album.title).toList(),
          track: track,
        );
        String? cover = track.coverUri;
        cover ??= tr.cover;
        tr.cover = cover;
        filtered.add(tr);
      }
      setState(() {
        playlistView = filtered;
      });
    } catch (e) {
      print(e);
      widget.showOperation(StateIndicatorOperation.error);
    }
  }

  void moveTrack(int oldIndex, int newIndex) async {
    if (_searchController.text == '') {
      setState(() {
        final element = playlistView[oldIndex];
        playlistView.remove(element);
        playlistView.insert(
          newIndex < oldIndex ? newIndex : newIndex - 1,
          element,
        );
      });
      widget.moveTrack(oldIndex, newIndex);
      // #TODO: syncing yandex music reord
    }
  }

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
                            child: ReorderableListView.builder(
                              itemCount: playlistView.length,
                              onReorder: (int oldIndex, int newIndex) async {
                                moveTrack(oldIndex, newIndex);
                              },

                              buildDefaultDragHandles: false,
                              proxyDecorator:
                                  (
                                    Widget child,
                                    int index,
                                    Animation<double> animation,
                                  ) {
                                    return Material(
                                      color: Colors.transparent,
                                      child: child,
                                    );
                                  },

                              itemBuilder: (context, index) {
                                return ReorderableDragStartListener(
                                  key: Key('$index'),
                                  index: index,
                                  enabled: _searchController.text == ''
                                      ? true
                                      : false,
                                  child: ListTile(
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
                                            if (playlistView[index]
                                                is YandexMusicTrack)
                                              PopupMenuItem(
                                                onTap: () async {
                                                  likeUnlike(index);
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
                                                            (playlistView[index]
                                                                    as YandexMusicTrack)
                                                                .track
                                                                .id,
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
                                              onTap: () async {
                                                removeTrackFromPlaylist(index);
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
                                                addNextQueue(index);
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
                                                addBottomQueue(index);
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
                                            if (playlistView[index]
                                                is YandexMusicTrack)
                                              PopupMenuItem(
                                                onTap: () async {
                                                  findSimilar(index);
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
                                  ),
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

Widget songElement(PlayerTrack track) {
  return Row(
    children: [
      Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (track is LocalTrack && track.coverByted != Uint8List(0))
                ? MemoryImage(track.coverByted)
                : CachedNetworkImageProvider(
                    'https://${track.cover.replaceAll('%%', '300x300')}',
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
              offset: Offset(-2, -2),
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

              style: TextStyle(
                color: Colors.white,
                fontFamily: 'noto',
                fontSize: 16,
              ),
            ),
            Text(
              track.artists.join(', '),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'noto',
                fontSize: 16,
              ),
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
