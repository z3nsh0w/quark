import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:quark/objects/track.dart';
import 'package:quark/objects/playlist.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:cached_network_image/cached_network_image.dart';

class YandexPlaylists extends StatefulWidget {
  final Function() closeView;
  final YandexMusic yandexMusic;
  final List<PlaylistWShortTracks> playlists;
  final Function(PlayerPlaylist playlist) playlistRouter;

  const YandexPlaylists({
    required this.closeView,
    required this.yandexMusic,
    required this.playlistRouter,
    required this.playlists,
  });

  @override
  State<YandexPlaylists> createState() => _YandexPlaylistsState();
}

class _YandexPlaylistsState extends State<YandexPlaylists> {
  bool enabled = true;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
          child: Container(
            width: min(size.width * 0.92, 1040),
            height: min(size.height * 0.92, 1036),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(36.0),
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                children: List.generate(widget.playlists.length, (index) {
                  return Container(
                    width: 310,
                    height: 310,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          '${widget.yandexMusic.playlists.getPlaylistCoverArtUrl(widget.playlists[index].cover ?? {"type": "pic", "uri": "raw.githubusercontent.com/z3nsh0w/z3nsh0w.github.io/refs/heads/master/nocover.png", "custom": true})}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),

                      child: InkWell(
                        onTap: () async {
                          if (!enabled) {
                            return;
                          }

                          final trackIds = widget.playlists[index].tracks
                              .map((track) => track.trackID)
                              .toList();
                          if (trackIds.isEmpty) {
                            return;
                          }
                          enabled = false;
                          final playlistTracks = await widget.yandexMusic.tracks
                              .getTracks(trackIds);

                          List<YandexMusicTrack> output = [];

                          for (Track track in playlistTracks) {
                            String path = await getTrackPath(track.id);
                            YandexMusicTrack tr = YandexMusicTrack(
                              filepath: path,
                              title: track.title,
                              albums: track.albums.isNotEmpty
                                  ? track.albums
                                        .map((album) => album.title)
                                        .toList()
                                  : ['Unknown album'],
                              artists: track.artists.isNotEmpty
                                  ? track.artists
                                        .map((album) => album.title)
                                        .toList()
                                  : ['Unknown artist'],
                              track: track,
                            );
                            String? cover = track.coverUri;
                            cover ??= tr.cover;
                            tr.cover = cover;
                            output.add(tr);
                          }
                          output.removeWhere(
                            (track) => track.track.available != true,
                          );

                          await widget.closeView();

                          widget.playlistRouter(
                            PlayerPlaylist(
                              ownerUid: widget.playlists[index].ownerUid,
                              kind: widget.playlists[index].kind,
                              name: widget.playlists[index].title,
                              tracks: output,
                              source: PlaylistSource.yandexMusic,
                            ),
                          );
                        },

                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  widget.playlists[index].title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            if (false)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Transform.rotate(
                                    angle: 40 * (3.14159 / 180),
                                    child: Icon(
                                      Icons.push_pin_rounded,
                                      color: Color.fromRGBO(
                                        255,
                                        255,
                                        255,
                                        0.500,
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
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
