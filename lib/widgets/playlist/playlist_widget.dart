import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:quark/services/yandex_music_singleton.dart';
import 'package:quark/widgets/yandex_music_integration/yandex_widgets.dart';
import '../../services/cached_images.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quark/services/player/player.dart';
import '/widgets/state_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:quark/objects/track.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quark/services/database/database_engine.dart';

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
  final Function(StateIndicatorOperation operation) showOperation;
  final VoidCallback closePlaylist;

  const PlaylistOverlay({
    super.key,
    required this.showOperation,
    required this.closePlaylist,
  });

  @override
  State<PlaylistOverlay> createState() => _PlaylistOverlayState();
}

class _PlaylistOverlayState extends State<PlaylistOverlay> {
  bool menuOpened = false;
  final double popupIconSize = 22;
  final double popupSpaceBetween = 10;
  Color popupTextColor = Colors.white.withAlpha(220);
  Color popupIconsColor = Colors.white.withAlpha(170);
  final ScrollController _scrollController = ScrollController();

  CancelToken? searchCancel = CancelToken();

  List<PlayerTrack> playlistView = [];

  late final TextEditingController _searchController;

  Timer? _searchDebounceTimer;
  final Duration _searchDebounceDuration = const Duration(milliseconds: 500);

  void listener() async {
    if (_searchController.text == '') {
      setState(() => playlistView = Player.player.playlist);
      scrollToCurrentTrack();
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    setState(() {
      playlistView = Player.player.playlist;
    });
    Player.player.playlistNotifier.addListener(listener);
  }

  @override
  void dispose() {
    _searchController.dispose();
    Player.player.playlistNotifier.removeListener(listener);
    super.dispose();
  }

  void search(String query, [bool? nonuser]) async {
    _searchDebounceTimer?.cancel();
    searchCancel?.cancel();
    searchCancel = null;

    if (query == '') {
      playlistView = Player.player.playlist;
      scrollToCurrentTrack();
      return;
    }

    var filtered = playlistView.where((track) {
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
          var result = await YandexMusicSingleton.instance.search.search(
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
                await YandexMusicSingleton.instance.init();
                search(query, nonuser);
              } catch (e) {
                Logger('Playlist_Widget').warning(
                  'SEARCH: Failed to initizalie YandexMusic instance',
                  e,
                );
                break;
              }
            default:
              break;
          }
        } catch (e) {
          widget.showOperation(StateIndicatorOperation.error);
          Logger(
            'Playlist_Widget',
          ).warning('SEARCH: YandexMusic instance has not been initalized', e);
        }
      });
    }
  }

  // WIDGET FUNCTIONS

  void likeUnlike(int index) async {
    final List<String> likedTrack =
        YandexMusicSingleton.likedTracksNotifier.value;
    final track = (playlistView[index] as YandexMusicTrack).track;
    if (likedTrack.contains(track.id)) {
      await YandexMusicSingleton.unlikeTrack(track.id);
    } else {
      await YandexMusicSingleton.likeTrack(track.id);
    }
  }

  void removeTrackFromPlaylist(int index) async {
    await Player.player.removeTrack(playlistView[index]);
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
      await Player.player.addQueue([tr]);
    } else if (track is YandexMusicTrack) {
      YandexMusicTrack tr = YandexMusicTrack(
        filepath: track.filepath,
        title: track.title,
        albums: track.albums,
        artists: track.artists,
        track: track.track,
      );
      tr.cover = track.cover;

      await Player.player.addQueue([tr]);
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
      await Player.player.addQueue([tr], after: playlistView.last);
    } else if (track is YandexMusicTrack) {
      YandexMusicTrack tr = YandexMusicTrack(
        filepath: track.filepath,
        title: track.title,
        albums: track.albums,
        artists: track.artists,
        track: track.track,
      );
      tr.cover = track.cover;
      await Player.player.addQueue([tr], after: playlistView.last);
    }
  }

  void findSimilar(int index) async {
    try {
      _searchController.text = 'Similar: ${playlistView[index].title}';
      List<PlayerTrack> filtered = [];
      var directory = await getApplicationCacheDirectory();
      var result = await YandexMusicSingleton.instance.tracks.getSimilar(
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
      Logger(
        'Playlist_Widget',
      ).warning('findSimilar: Failed to find similar tracks', e);
      widget.showOperation(StateIndicatorOperation.error);
    }
  }

  void scrollToCurrentTrack() {
    final currentIndex = playlistView.indexWhere(
      (track) => track == Player.player.nowPlayingTrack,
    );

    if (currentIndex != -1 && _scrollController.hasClients) {
      _scrollController.animateTo(
        currentIndex * 71.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void moveTrack(int oldIndex, int newIndex) async {
    if (_searchController.text == '') {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      Player.player.moveTrack(playlistView[oldIndex], newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 500) {
            widget.closePlaylist();
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
                          scrollController: _scrollController,
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
                                                  YandexMusicSingleton
                                                          .likedTracksNotifier
                                                          .value
                                                          .contains(
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
                                                CupertinoIcons.arrow_up_to_line,

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
                                                CupertinoIcons.arrow_up_to_line,
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
                                        if ((playlistView[index]
                                                is YandexMusicTrack) &&
                                            ((playlistView[index]
                                                        as YandexMusicTrack)
                                                    .track
                                                    .trackSource !=
                                                TrackSource.UGC))
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
                                                is YandexMusicTrack &&
                                            (playlistView[index]
                                                        as YandexMusicTrack)
                                                    .track
                                                    .artists[0]
                                                is! UGCArtist)
                                          PopupMenuItem(
                                            onTap: () async {
                                              if (YandexMusicSingleton.inited ==
                                                  false) {
                                                final tok = await Database.get(
                                                  DatabaseKeys
                                                      .yandexMusicToken
                                                      .value,
                                                );
                                                YandexMusicSingleton.init(
                                                  YandexMusic(token: tok),
                                                );
                                              }
                                              final artist =
                                                  await YandexMusicSingleton
                                                      .instance
                                                      .artists
                                                      .getInfo(
                                                        (playlistView[index]
                                                                as YandexMusicTrack)
                                                            .track
                                                            .artists[0],
                                                      );
                                              widget.closePlaylist();
                                              Future.delayed(
                                                Duration(milliseconds: 500),
                                                () async {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (builder) =>
                                                          ArtistInfoWidget(
                                                            artist: artist,
                                                          ),
                                                    ),
                                                  );
                                                },
                                              );
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
                                                  'Artist info',
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
                                onTap: () async => await Player.player
                                    .playCustom(playlistView[index]),
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
                      widget.closePlaylist,
                      () {},
                      () {},
                      scrollToCurrentTrack,
                    ),
                  ),
                ],
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
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 21, 21, 21),
              blurRadius: 10,
              offset: Offset(-2, -2),
            ),
          ],
        ),
        child:
            (track is LocalTrack && !listEquals(track.coverByted, Uint8List(0)))
            ? ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(3),
                child: Image.memory(track.coverByted, height: 270, width: 270),
              )
            : CachedImage(
                borderRadius: 3,
                coverUri: 'https://${track.cover.replaceAll('%%', '300x300')}',
                height: 55,
                alphaChannel: 255,
                backgroundColor: const Color.fromARGB(255, 77, 77, 77),
                iconColor: Colors.grey,
                alphaChannelIcon: 255,
                width: 55,
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
  Function() togglePlaylist,
  Function() refreshPlaylist,
  Function() search,
  Function() scrollTo,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
        onPressed: scrollTo,
        icon: Icon(Icons.keyboard_double_arrow_down),
        color: Colors.white.withOpacity(0.8),
        tooltip: 'Scroll to now track',
      ),
      Text(
        Player.player.playlistInfo.name,
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
