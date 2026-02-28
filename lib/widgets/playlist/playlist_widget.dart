import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:quark/services/database/database.dart';
import 'package:quark/services/yandex_music_singleton.dart';
import 'package:quark/widgets/players_widgets/main_player.dart';
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

/// TODO: make GestureDetector on ScrollUp/Down to create smooth playlist scrolling as in the SilkyScroll package

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

  void stater() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    setState(() {
      playlistView = Player.player.playlist;
    });

    Player.player.playlistNotifier.addListener(listener);
    Player.player.queueNotifier.addListener(stater);
  }

  @override
  void dispose() {
    _searchController.dispose();
    Player.player.playlistNotifier.removeListener(listener);
    Player.player.queueNotifier.removeListener(stater);
    super.dispose();
  }

  void search(String query, [bool? nonuser]) async {
    _searchDebounceTimer?.cancel();
    searchCancel?.cancel();
    searchCancel = null;

    if (query == '') {
      setState(() {
        playlistView = Player.player.playlist;
      });
      scrollToCurrentTrack();
      return;
    }

    var filtered = Player.player.playlist.where((track) {
      final searchLower = query.toLowerCase();
      if (track.title
          .toLowerCase()
          .replaceAll(RegExp(r'\s+'), '')
          .contains(searchLower)) {
        return true;
      }

      for (final artist in track.artists) {
        final artistTitle = artist;

        if (artistTitle
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '')
            .contains(searchLower)) {
          return true;
        }
      }

      for (final album in track.albums) {
        final albumtitle = album;

        if (albumtitle
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '')
            .contains(searchLower)) {
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
        bool enable = DatabaseStreamerService().yandexMusicSearch.value;
        if (query.isEmpty || currentQuery != query || enable == false) {
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
      await Player.player.addTracks([tr]);
    } else if (track is YandexMusicTrack) {
      YandexMusicTrack tr = YandexMusicTrack(
        filepath: track.filepath,
        title: track.title,
        albums: track.albums,
        artists: track.artists,
        track: track.track,
      );
      tr.cover = track.cover;

      await Player.player.addTracks([tr]);
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
      await Player.player.addTracks([tr], after: playlistView.last);
    } else if (track is YandexMusicTrack) {
      YandexMusicTrack tr = YandexMusicTrack(
        filepath: track.filepath,
        title: track.title,
        albums: track.albums,
        artists: track.artists,
        track: track.track,
      );
      tr.cover = track.cover;
      await Player.player.addTracks([tr], after: playlistView.last);
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
    int currentIndex = playlistView.indexWhere(
      (track) => track == Player.player.nowPlayingTrack,
    );
    if (currentIndex == -1 && Player.player.unQueuedLastTrack != null) {
      currentIndex = playlistView.indexWhere(
        (e) => e == Player.player.unQueuedLastTrack,
      );
    }

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
                            final track = playlistView[index];
                            final mainKey = ValueKey(
                              'main_${track.title}_$index',
                            );
                            if (playlistView[index] ==
                                    Player.player.unQueuedLastTrack &&
                                Player.player.queue.isNotEmpty) {
                              List<Widget> widgets = [
                                ReorderableDragStartListener(
                                  index: index,
                                  enabled: _searchController.text.isEmpty,
                                  child: PlaylistTileWidget(
                                    index: index,
                                    queued: false,
                                    track: playlistView[index],
                                    menuOpened: menuOpened,
                                    onMenuOpen: () =>
                                        setState(() => menuOpened = true),
                                    onMenuClose: () =>
                                        setState(() => menuOpened = false),
                                    likeUnlike: likeUnlike,
                                    removeTrackFromPlaylist:
                                        removeTrackFromPlaylist,
                                    addNextQueue: addNextQueue,
                                    showOperation: widget.showOperation,
                                    addBottomQueue: addBottomQueue,
                                    findSimilar: findSimilar,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'From queue',
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            175,
                                            255,
                                            255,
                                            255,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Divider(
                                          height: 1,
                                          color: const Color.fromARGB(
                                            175,
                                            255,
                                            255,
                                            255,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      IconButton(
                                        highlightColor: const Color.fromARGB(
                                          50,
                                          255,
                                          255,
                                          255,
                                        ),
                                        onPressed: () async =>
                                            Player.player.clearQueue(),
                                        icon: Icon(
                                          Icons.delete,
                                          color: const Color.fromARGB(
                                            175,
                                            255,
                                            255,
                                            255,
                                          ),
                                          size: 21,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                              for (PlayerTrack track in Player.player.queue) {
                                widgets.add(
                                  ReorderableDragStartListener(
                                    index: index,
                                    enabled: false,
                                    child: PlaylistTileWidget(
                                      queued: true,
                                      index: index,
                                      track: track,
                                      menuOpened: menuOpened,
                                      onMenuOpen: () =>
                                          setState(() => menuOpened = true),
                                      onMenuClose: () =>
                                          setState(() => menuOpened = false),
                                      likeUnlike: likeUnlike,
                                      removeTrackFromPlaylist:
                                          removeTrackFromPlaylist,
                                      addNextQueue: addNextQueue,
                                      addBottomQueue: addBottomQueue,
                                      showOperation: widget.showOperation,
                                      findSimilar: findSimilar,
                                    ),
                                  ),
                                );
                              }
                              widgets.add(
                                Container(
                                  color: const Color.fromARGB(
                                    50,
                                    255,
                                    255,
                                    255,
                                  ),
                                  width: 320,
                                  height: 2,
                                ),
                              );
                              return Column(key: mainKey, children: widgets);
                            }
                            return ReorderableDragStartListener(
                              key: mainKey,
                              index: index,
                              enabled: _searchController.text.isEmpty,
                              child: PlaylistTileWidget(
                                queued: false,
                                index: index,
                                track: playlistView[index],
                                menuOpened: menuOpened,
                                onMenuOpen: () =>
                                    setState(() => menuOpened = true),
                                onMenuClose: () =>
                                    setState(() => menuOpened = false),
                                likeUnlike: likeUnlike,
                                removeTrackFromPlaylist:
                                    removeTrackFromPlaylist,
                                addNextQueue: addNextQueue,
                                addBottomQueue: addBottomQueue,
                                findSimilar: findSimilar,
                                showOperation: widget.showOperation,
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

class PlaylistTileWidget extends StatelessWidget {
  final int index;
  final PlayerTrack track;
  final bool menuOpened;
  final bool queued;
  final VoidCallback onMenuOpen;
  final VoidCallback onMenuClose;
  final void Function(int) likeUnlike;
  final void Function(int) removeTrackFromPlaylist;
  final void Function(int) addNextQueue;
  final void Function(int) addBottomQueue;
  final void Function(int) findSimilar;
  final void Function(StateIndicatorOperation) showOperation;

  final double popupIconSize = 22;
  final double popupSpaceBetween = 10;
  final Color popupTextColor = const Color.fromARGB(220, 255, 255, 255);
  final Color popupIconsColor = const Color.fromARGB(170, 255, 255, 255);

  const PlaylistTileWidget({
    super.key,
    required this.index,
    required this.track,
    required this.menuOpened,
    required this.onMenuOpen,
    required this.onMenuClose,
    required this.likeUnlike,
    required this.removeTrackFromPlaylist,
    required this.addNextQueue,
    required this.addBottomQueue,
    required this.findSimilar,
    required this.queued,
    required this.showOperation,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async => await Player.player.playCustom(track),
      title: songElement(track),
      trailing: PopupMenuButton(
        iconColor: Colors.white.withOpacity(0.6),
        elevation: 1000,
        offset: const Offset(70, 0),
        color: const Color.fromARGB(20, 255, 255, 255),
        onCanceled: () => onMenuClose(),
        itemBuilder: (context) {
          if (menuOpened) return [];

          onMenuOpen();

          return [
            if (track is YandexMusicTrack)
              PopupMenuItem(
                onTap: () => likeUnlike(index),
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: popupIconSize,
                      color: popupIconsColor,
                    ),
                    SizedBox(width: popupSpaceBetween),
                    Text(
                      YandexMusicSingleton.likedTracksNotifier.value.contains(
                            (track as YandexMusicTrack).track.id,
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
            if (!queued)
              PopupMenuItem(
                onTap: () => removeTrackFromPlaylist(index),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_sweep_rounded,
                      size: popupIconSize,
                      color: popupIconsColor,
                    ),
                    SizedBox(width: popupSpaceBetween),
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
            if (queued)
              PopupMenuItem(
                onTap: () async => await Player.player.removeFromQueue(track),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_sweep_rounded,
                      size: popupIconSize,
                      color: popupIconsColor,
                    ),
                    SizedBox(width: popupSpaceBetween),
                    Text(
                      'Remove from queue',
                      style: TextStyle(
                        fontFamily: 'noto',
                        color: popupTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            if (!queued)
              PopupMenuItem(
                onTap: () => addNextQueue(index),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.arrow_up_to_line,
                      size: popupIconSize,
                      color: popupIconsColor,
                    ),
                    SizedBox(width: popupSpaceBetween),
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
            if (track is YandexMusicTrack)
              PopupMenuItem(
                onTap: () async {
                  int selected = 0;
                  final value = await showDialog<int>(
                    context: context,
                    builder: (context) => WarningMessage(
                      messageHeader: 'Choose playlist',
                      messageDiscription: '',
                      buttons: YandexMusicSingleton.playlists
                          .map((e) => e.title)
                          .toList(),
                    ),
                  );

                  if (value == null) return;
                  selected = value;
                  try {
                    await YandexMusicSingleton.instance.playlists.insertTrack(
                      YandexMusicSingleton.playlists[selected].kind,
                      (track as YandexMusicTrack).track.id,
                      (track as YandexMusicTrack).track.albums[0].id.toString(),
                    );
                    showOperation(StateIndicatorOperation.success);
                  } catch (e) {
                    showOperation(StateIndicatorOperation.error);
                  }
                },
                enabled: track.albums.isNotEmpty,
                child: Row(
                  children: [
                    Icon(
                      Icons.queue_outlined,
                      size: popupIconSize,
                      color: popupIconsColor,
                    ),
                    SizedBox(width: popupSpaceBetween),
                    Text(
                      'Add to yandex playlist',
                      style: TextStyle(
                        fontFamily: 'noto',
                        color: popupTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            if (track is YandexMusicTrack &&
                (track as YandexMusicTrack).track.trackSource !=
                    TrackSource.UGC)
              PopupMenuItem(
                onTap: () => findSimilar(index),
                enabled: track.albums.isNotEmpty,
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.search,
                      size: popupIconSize,
                      color: popupIconsColor,
                    ),
                    SizedBox(width: popupSpaceBetween),
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
            if (track is YandexMusicTrack &&
                (track as YandexMusicTrack).track.trackSource !=
                    TrackSource.UGC)
              PopupMenuItem(
                enabled: track.albums.isNotEmpty,
                onTap: () async {
                  if (!YandexMusicSingleton.inited) {
                    final String tok =
                        DatabaseStreamerService().yandexMusicToken.value;
                    YandexMusicSingleton.init(YandexMusic(token: tok));
                  }
                  final artist = await YandexMusicSingleton.instance.artists
                      .getInfo((track as YandexMusicTrack).track.artists[0]);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => ArtistInfoWidget(artist: artist),
                      ),
                    );
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.person,
                      size: popupIconSize,
                      color: popupIconsColor,
                    ),
                    SizedBox(width: popupSpaceBetween),
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
        },
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
                width: 55,
                alphaChannel: 255,
                backgroundColor: const Color.fromARGB(255, 77, 77, 77),
                iconColor: Colors.grey,
                alphaChannelIcon: 255,
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
                color: const Color.fromARGB(255, 185, 185, 185),
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
