import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:quark/objects/track.dart';
import 'package:quark/objects/playlist.dart';
import 'package:quark/services/cached_images.dart';
import 'package:quark/services/yandex_music_singleton.dart';
import 'package:quark/widgets/yandex_music_integration/yandex_widgets.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexPlaylists extends StatefulWidget {
  final Function() closeView;
  final YandexMusic yandexMusic;
  final Function(PlayerPlaylist playlist) playlistRouter;

  const YandexPlaylists({
    super.key,
    required this.closeView,
    required this.yandexMusic,
    required this.playlistRouter,
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(36.0),
                  child: Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    children: List.generate(YandexMusicSingleton.playlists.length, (index) {
                      return Container(
                        width: 310,
                        // width: 260,
                        // height: 260,
                        height: 310,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: CachedImageProvider(
                              '${widget.yandexMusic.playlists.getPlaylistCoverArtUrl(YandexMusicSingleton.playlists[index].cover ?? {"type": "pic", "uri": "raw.githubusercontent.com/z3nsh0w/z3nsh0w.github.io/refs/heads/master/nocover.png", "custom": true})}',
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

                              final trackIds = YandexMusicSingleton.playlists[index].tracks
                                  .map((track) => track.trackID)
                                  .toList();
                              if (trackIds.isEmpty) {
                                return;
                              }
                              enabled = false;
                              final playlistTracks = await widget
                                  .yandexMusic
                                  .tracks
                                  .getTracks(trackIds);

                              List<YandexMusicTrack> output = [];

                              for (Track track in playlistTracks) {
                                output.add(
                                  YandexMusicTrack.fromYMTtoLocalTrack(track),
                                );
                              }
                              output.removeWhere(
                                (track) => track.track.available != true,
                              );

                              await widget.closeView();

                              widget.playlistRouter(
                                PlayerPlaylist(
                                  ownerUid: YandexMusicSingleton.playlists[index].ownerUid,
                                  kind: YandexMusicSingleton.playlists[index].kind,
                                  name: YandexMusicSingleton.playlists[index].title,
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
                                      YandexMusicSingleton.playlists[index].title,
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
                                Positioned(
                                  right: 5,
                                  top: 5,
                                  child: IconButton2(
                                    icon: Icons.remove_red_eye_outlined,
                                    onTap: () async {
                                      final playlist =
                                          await YandexMusicSingleton
                                              .instance
                                              .playlists
                                              .getPlaylist(
                                                YandexMusicSingleton.playlists[index].kind,
                                                accountId: YandexMusicSingleton.playlists[index]
                                                    .ownerUid,
                                              );
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (builder) =>
                                              PlaylistInfoWidget(
                                                playlist: playlist,
                                              ),
                                        ),
                                      );
                                    },
                                    height: 35,
                                    width: 35,
                                    iconColor: Colors.white70,
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
                Positioned(
                  right: 5,
                  top: 5,
                  child: IconButton(
                    onPressed: () async {
                      final playlist = await YandexMusicSingleton
                          .instance
                          .playlists
                          .createPlaylist("New playlist", "private");
                      YandexMusicSingleton.playlists.insert(1, PlaylistWShortTracks(playlist.raw));
                      setState(() {});
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (builder) =>
                              PlaylistInfoWidget(playlist: playlist),
                        ),
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
