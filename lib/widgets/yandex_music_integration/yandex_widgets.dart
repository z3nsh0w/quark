import 'dart:async';
import 'dart:ui';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:quark/objects/track.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/yandex_music_singleton.dart';
import 'package:quark/services/cached_images.dart';
import 'package:quark/services/player/player.dart';
import 'package:quark/widgets/players_widgets/main_player.dart';
import 'package:quark/services/dynamic_window_color_linux.dart';
import 'package:quark/widgets/players_widgets/macro_player.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class YandexPlaylistsInfo extends StatefulWidget {
  final List<PlaylistWShortTracks> playlists;

  const YandexPlaylistsInfo({super.key, required this.playlists});

  @override
  State<YandexPlaylistsInfo> createState() => _YandexPlaylistsInfoState();
}

class _YandexPlaylistsInfoState extends State<YandexPlaylistsInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Text(
              'Playlists',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: Center(
                child: MacroPlayer(
                  maxWidth: min(MediaQuery.of(context).size.width - 200, 600),
                  height: 45,
                ),
              ),
            ),
          ],
        ),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _grid(),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.0),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.queue_music,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Playlists',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        letterSpacing: -1.0,
                      ),
                    ),
                    Text(
                      '${widget.playlists.length} playlist${widget.playlists.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _grid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double minCardWidth = 280;
        const double spacing = 16;

        int crossAxisCount = max(
          1,
          (constraints.maxWidth + spacing) ~/ (minCardWidth + spacing),
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 1.0,
          ),
          itemCount: widget.playlists.length,
          itemBuilder: (context, index) {
            return _playlist(widget.playlists[index]);
          },
        );
      },
    );
  }

  Widget _playlist(PlaylistWShortTracks playlist) {
    final coverUrl = playlist.cover != null
        ? YandexMusicSingleton.instance.playlists.getPlaylistCoverArtUrl(
            playlist.cover!,
          )
        : 'none';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              coverUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.6),
                        Colors.blue.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.music_note,
                      size: 60,
                      color: Colors.white30,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      playlist.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.music_note,
                          color: Colors.white70,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${playlist.tracks.length} tracks',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    try {
                      final fullPlaylist = await YandexMusicSingleton
                          .instance
                          .playlists
                          .getPlaylist(playlist.kind);

                      if (mounted) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            maintainState: false,
                            builder: (builder) =>
                                PlaylistInfoWidget(playlist: fullPlaylist),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to load playlist: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: SizedBox(height: 250, width: 250),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistInfoWidget extends StatefulWidget {
  final Playlist playlist;
  const PlaylistInfoWidget({super.key, required this.playlist});

  @override
  State<StatefulWidget> createState() => _PlaylistInfo();
}

class _PlaylistInfo extends State<PlaylistInfoWidget> {
  bool visibility = false;
  bool isProcessing = false;
  late Playlist playlist;
  Color borderColor = Colors.white.withAlpha(78);
  late TextEditingController controller = TextEditingController(
    text: playlist.title,
  );
  Timer? debounceTimer;
  final Duration _debounceDuration = const Duration(milliseconds: 500);
  double _width = 400;
  final Color playlistColor = Colors.white;

  void _updateWidth(String text) {
    final painter = TextPainter(
      text: TextSpan(
        text: text.isEmpty ? 'hint' : text,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 42,
          letterSpacing: -1.2,
        ),
      ),
      textDirection: ui.TextDirection.ltr,

      maxLines: 1,
    )..layout();

    setState(() {
      _width = (painter.width + 12).clamp(5, 1200);
    });
  }

  void changeTitle(String value) async {
    debounceTimer?.cancel();
    debounceTimer = Timer(_debounceDuration, () async {
      if (value.isEmpty) {
        return;
      }
      setState(() {
        borderColor = Colors.orange;
      });
      try {
        await YandexMusicSingleton.instance.playlists.renamePlaylist(
          playlist.kind,
          value,
        );
        setState(() {
          borderColor = Colors.green;
        });
      } catch (e) {
        setState(() {
          borderColor = Colors.red;
        });
      }
      Future.delayed(
        Duration(seconds: 2),
        () => setState(() {
          borderColor = Colors.white.withAlpha(78);
        }),
      );
    });
  }

  void setHeader() async {
    DynamicWindowColor.pause();
    await DynamicWindowColor.setHeaderColor([playlistColor]);
  }

  @override
  void dispose() {
    DynamicWindowColor.resume();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    playlist = widget.playlist;
    _updateWidth(playlist.title);
    setState(() {
      visibility = widget.playlist.visibility == 'public';
    });
    setHeader();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      bottomNavigationBar: Container(
        height: 55,
        color: playlistColor.withAlpha(50),
        child: Center(
          child: MacroPlayer(
            maxWidth: MediaQuery.of(context).size.width - 30,
            height: 45,
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserLibraryBar(accentColor: playlistColor),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _mainHeader(),
                  if (playlist.tracks.isNotEmpty) ...[
                    VerticalSection<Track>(
                      title: 'Tracks',
                      items: playlist.tracks,
                      itemBuilder: (track) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 2,
                        ),
                        child: TrackCard(track: track, size: '100x100'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _ownerHeader() {
    return [
      Padding(
        padding: EdgeInsetsGeometry.only(top: 10),
        child: CoverView(
          smallCoverLink: playlist.cover != null
              ? YandexMusicSingleton.instance.playlists.getPlaylistCoverArtUrl(
                  playlist.cover!,
                )
              : 'none',
          bigCoverLink: playlist.cover != null
              ? YandexMusicSingleton.instance.playlists.getPlaylistCoverArtUrl(
                  playlist.cover!,
                  imageSize: '1000x1000',
                )
              : 'none',
        ),
      ),
      const SizedBox(width: 32),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                'PLAYLIST',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: _width,
              height: 60,

              child: TextField(
                onChanged: (value) {
                  _updateWidth(value);
                  changeTitle(value);
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 42,
                  letterSpacing: -1.2,
                  height: 1.1,
                ),
                maxLines: 1,
                controller: controller,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.white.withAlpha(178),
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withAlpha(100),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: borderColor, width: 1.5),
                  ),
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(
                    // horizontal: 8,
                    vertical: 6,
                  ),
                  disabledBorder: null,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'by ${widget.playlist.owner.name ?? 'Unknown'}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 24,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _itemInfo(
                  icon: Icons.music_note,
                  label: 'Tracks',
                  value: '${playlist.tracks.length}',
                ),

                Tooltip(
                  message: "Change visibility",
                  child: InkWell(
                    onTap: () async {
                      if (isProcessing) return;
                      setState(() {
                        isProcessing = true;
                      });

                      try {
                        await YandexMusicSingleton.instance.playlists
                            .changeVisibility(
                              playlist.kind,
                              !visibility
                                  ? YandexMusicSingleton
                                        .instance
                                        .playlists
                                        .publicPlaylist
                                  : YandexMusicSingleton
                                        .instance
                                        .playlists
                                        .privatePlaylist,
                            );

                        setState(() {
                          visibility = !visibility;
                        });
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to change visibility: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } finally {
                        setState(() {
                          isProcessing = false;
                        });
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _itemInfo(
                          icon: visibility ? Icons.public : Icons.lock,
                          label: 'Visibility',
                          value: visibility ? 'Public' : 'Private',
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.edit, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _nowOwnerHeader() {
    return [
      Padding(
        padding: EdgeInsetsGeometry.only(top: 10),
        child: CoverView(
          smallCoverLink: playlist.cover != null
              ? YandexMusicSingleton.instance.playlists.getPlaylistCoverArtUrl(
                  playlist.cover!,
                )
              : 'none',
          bigCoverLink: playlist.cover != null
              ? YandexMusicSingleton.instance.playlists.getPlaylistCoverArtUrl(
                  playlist.cover!,
                  imageSize: '1000x1000',
                )
              : 'none',
        ),
      ),
      const SizedBox(width: 32),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                'PLAYLIST',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              playlist.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 42,
                letterSpacing: -1.2,
                height: 1.1,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            Text(
              'by ${playlist.owner.name ?? 'Unknown'}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 24,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _itemInfo(
                  icon: Icons.music_note,
                  label: 'Tracks',
                  value: '${playlist.tracks.length}',
                ),

                _itemInfo(
                  icon: visibility ? Icons.public : Icons.lock,
                  label: 'Visibility',
                  value: visibility ? 'Public' : 'Private',
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  Widget _mainHeader() {
    final bool isOwner =
        playlist.ownerUid == YandexMusicSingleton.instance.accountID;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            playlistColor.withOpacity(0.3),
            playlistColor.withOpacity(0.0),
          ],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isOwner && playlist.kind != 3
                  ? _ownerHeader()
                  : _nowOwnerHeader(),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
                  child: Material(
                    color: playlistColor.withOpacity(0.2),
                    child: InkWell(
                      onTap: () async {},
                      child: SizedBox(
                        height: 40,
                        width: 180,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),

                Tooltip(
                  message: "Pin",
                  child: ClipOval(
                    child: Material(
                      color: playlistColor.withOpacity(0.2),
                      child: InkWell(
                        onTap: () async {
                          try {
                            await YandexMusicSingleton.instance.pin.playlist(
                              playlist.ownerUid,
                              playlist.kind,
                              YandexMusicSingleton.instance.pin.pin,
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Pinned into your library!'),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Color.alphaBlend(
                                    Colors.black.withOpacity(0.6),
                                    playlistColor,
                                  ),

                                  behavior: SnackBarBehavior.fixed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Fail! $e'),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color.alphaBlend(
                                  Colors.black.withOpacity(0.6),
                                  playlistColor,
                                ),

                                behavior: SnackBarBehavior.fixed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(
                            Symbols.push_pin_sharp,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(width: 5),
                // ClipOval(
                //   child: Material(
                //     color: playlistColor.withOpacity(0.2),
                //     child: InkWell(
                //       onTap: () async {},
                //       child: SizedBox(
                //         height: 40,
                //         width: 40,
                //         child: Icon(
                //           Icons.favorite_sharp,
                //           color: Colors.white,
                //           size: 21,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 5),
                // ClipOval(
                //   child: Material(
                //     color: playlistColor.withOpacity(0.2),
                //     child: InkWell(
                //       onTap: () async {},
                //       child: SizedBox(
                //         height: 40,
                //         width: 40,
                //         child: Icon(Icons.waves, color: Colors.white, size: 21),
                //       ),
                //     ),
                //   ),
                // ),
                // ClipOval(
                //   child: Material(
                //     color: playlistColor.withOpacity(0.2),
                //     child: InkWell(
                //       onTap: () async {},
                //       child: SizedBox(
                //         height: 40,
                //         width: 40,
                //         child: Icon(
                //           Icons.download_done,
                //           color: Colors.white,
                //           size: 21,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                if (isOwner && playlist.kind != 3) ...[
                  const SizedBox(width: 5),
                  Tooltip(
                    message: "Change cover",
                    child: ClipOval(
                      child: Material(
                        color: playlistColor.withOpacity(0.2),
                        child: InkWell(
                          onTap: () async {
                            final result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                            );
                            if (result == null ||
                                result.files.isEmpty ||
                                result.files[0].path == null) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Uploading your cover...'),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color.alphaBlend(
                                  Colors.black.withOpacity(0.6),
                                  playlistColor,
                                ),

                                behavior: SnackBarBehavior.fixed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            try {
                              await YandexMusicSingleton.instance.playlists
                                  .changeCover(
                                    playlist,
                                    filename: result.files[0].name,
                                    coverData: await File(
                                      result.files[0].path!,
                                    ).readAsBytes(),
                                  );
                              final newplaylist = await YandexMusicSingleton
                                  .instance
                                  .playlists
                                  .getPlaylist(playlist.kind);
                              setState(() {
                                playlist = newplaylist;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to upload a new cover. $e',
                                  ),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Color.alphaBlend(
                                    Colors.black.withOpacity(0.6),
                                    playlistColor,
                                  ),

                                  behavior: SnackBarBehavior.fixed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Symbols.add_photo_alternate_sharp,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (isOwner && playlist.kind != 3) ...[
                  const SizedBox(width: 5),
                  Tooltip(
                    message: "Upload tracks",
                    child: ClipOval(
                      child: Material(
                        color: playlistColor.withOpacity(0.2),
                        child: InkWell(
                          onTap: () async {
                            final result = await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                            );
                            if (result == null ||
                                result.files.isEmpty ||
                                result.files[0].path == null) {
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Uploading tracks... Now you can leave page.',
                                ),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color.alphaBlend(
                                  Colors.black.withOpacity(0.6),
                                  playlistColor,
                                ),

                                behavior: SnackBarBehavior.fixed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                            try {
                              await YandexMusicSingleton.uploadTracks(
                                result.files.map((e) => e.path!).toList(),
                                playlist.kind,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to upload a new cover. $e',
                                  ),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Color.alphaBlend(
                                    Colors.black.withOpacity(0.6),
                                    playlistColor,
                                  ),

                                  behavior: SnackBarBehavior.fixed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Symbols.upload,
                              size: 21,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(width: 5),
                Tooltip(
                  message: "Share",
                  child: ClipOval(
                    child: Material(
                      color: playlistColor.withOpacity(0.2),
                      child: InkWell(
                        onTap: () async {
                          final link =
                              'https://music.yandex.ru/playlists/${playlist.playlistUuid}';

                          await Clipboard.setData(ClipboardData(text: link));

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Copied to clipboard!'),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color.alphaBlend(
                                  Colors.black.withOpacity(0.6),
                                  playlistColor,
                                ),

                                behavior: SnackBarBehavior.fixed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        },
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: Icon(
                            Symbols.share,
                            color: Colors.white,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (isOwner && playlist.kind != 3) ...[
                  const SizedBox(width: 5),
                  Tooltip(
                    message: "Remove cover",
                    child: ClipOval(
                      child: Material(
                        color: playlistColor.withOpacity(0.2),
                        child: InkWell(
                          onTap: () async {
                            try {
                              await YandexMusicSingleton.instance.playlists
                                  .clearCover(playlist);
                              final newplaylist = await YandexMusicSingleton
                                  .instance
                                  .playlists
                                  .getPlaylist(playlist.kind);
                              setState(() {
                                playlist = newplaylist;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to upload a new cover. $e',
                                  ),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Color.alphaBlend(
                                    Colors.black.withOpacity(0.6),
                                    playlistColor,
                                  ),

                                  behavior: SnackBarBehavior.fixed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.hide_image_outlined,
                              color: const Color.fromARGB(255, 242, 85, 74),
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                if (isOwner && playlist.kind != 3) ...[
                  const SizedBox(width: 5),
                  Tooltip(
                    message: "Delete",
                    child: ClipOval(
                      child: Material(
                        color: playlistColor.withOpacity(0.2),
                        child: InkWell(
                          onTap: () async {
                            try {
                              await YandexMusicSingleton.instance.playlists
                                  .deletePlaylist(playlist.kind);
                              Navigator.pop(context);
                              YandexMusicSingleton.playlists.remove(
                                YandexMusicSingleton.playlists.firstWhere(
                                  (e) => e.kind == playlist.kind,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to delete playlist. $e',
                                  ),
                                  duration: Duration(seconds: 1),
                                  backgroundColor: Color.alphaBlend(
                                    Colors.black.withOpacity(0.6),
                                    playlistColor,
                                  ),

                                  behavior: SnackBarBehavior.fixed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.delete_forever,
                              color: const Color.fromARGB(255, 242, 85, 74),
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white60, size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ArtistInfoWidget extends StatefulWidget {
  final ArtistInfo artist;

  const ArtistInfoWidget({super.key, required this.artist});

  @override
  State<StatefulWidget> createState() => _ArtistInfo();
}

class _ArtistInfo extends State<ArtistInfoWidget> {
  Album? newRelease;
  List<AlbumInfo>? studioAlbums;
  List<AlbumInfo>? albums;
  List<Concert>? concerts;
  List<ShortPlaylistInfo>? playlists;
  List<Track>? tracks;

  void initAll() async {
    DynamicWindowColor.setHeaderColor([buildColor(Colors.white)]);

    try {
      final concertsS = await YandexMusicSingleton.getConcerts(
        widget.artist.artist.id,
      );

      setState(() {
        concerts = concertsS;
      });
    } catch (e) {
      Logger('YandexMusicWidgets').warning(
        'Failed to fetch concerts for artist ${widget.artist.artist.id}',
        e,
      );
    }
    try {
      final newReleaseInfo = await YandexMusicSingleton.getNewRelease(
        widget.artist.artist.id,
      );

      setState(() {
        newRelease = newReleaseInfo;
      });
    } catch (e) {
      Logger('YandexMusicWidgets').warning(
        'Failed to fetch new releases for artist ${widget.artist.artist.id}',
        e,
      );
    }
    try {
      final studioAlbumsInfo = await YandexMusicSingleton.getStudioAlbums(
        widget.artist.artist.id,
      );

      setState(() {
        studioAlbums = studioAlbumsInfo;
      });
    } catch (e) {
      Logger('YandexMusicWidgets').warning(
        'Failed to fetch studio albums for artist ${widget.artist.artist.id}',
        e,
      );
    }
    try {
      final albums2 = await YandexMusicSingleton.getAlbums(
        widget.artist.artist.id,
      );

      setState(() {
        albums = albums2;
      });
    } catch (e) {
      Logger('YandexMusicWidgets').warning(
        'Failed to fetch albums for artist ${widget.artist.artist.id}',
        e,
      );
    }

    try {
      final playlistss = await YandexMusicSingleton.getPlaylistsByArtist(
        widget.artist.artist.id,
      );

      setState(() {
        playlists = playlistss;
      });
    } catch (e) {
      Logger('YandexMusicWidgets').warning(
        'Failed to fetch playlists for artist ${widget.artist.artist.id}',
        e,
      );
    }
    try {
      final trackss = await YandexMusicSingleton.getTracksByArtist(
        widget.artist.artist.id,
      );

      setState(() {
        tracks = trackss;
      });
    } catch (e) {
      Logger('YandexMusicWidgets').warning(
        'Failed to fetch tracks for artist ${widget.artist.artist.id}',
        e,
      );
    }
  }

  Color buildColor(Color default2) {
    return widget.artist.covers.isNotEmpty
        ? Color(
            int.parse(widget.artist.covers[0].color.substring(1), radix: 16) +
                0xFF000000,
          )
        : default2;
  }

  @override
  void initState() {
    super.initState();
    initAll();
    DynamicWindowColor.pause();
  }

  @override
  void dispose() {
    DynamicWindowColor.resume();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      bottomNavigationBar: Container(
        height: 55,
        color: buildColor(Colors.white).withAlpha(50),
        child: Center(
          child: MacroPlayer(
            maxWidth: MediaQuery.of(context).size.width - 30,
            height: 45,
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserLibraryBar(accentColor: buildColor(Colors.white)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(buildColor(Colors.white)),

                  const SizedBox(height: 20),

                  if (newRelease != null) ...[
                    _newRelease(),
                    const SizedBox(height: 20),
                  ],

                  if (concerts != null && concerts!.isNotEmpty) ...[
                    HorizontalSection<Concert>(
                      title: 'Concerts',
                      height: 230,
                      items: concerts!,
                      itemBuilder: (concert) => ConcertCard(concert: concert),
                    ),
                  ],

                  if (studioAlbums != null && studioAlbums!.isNotEmpty) ...[
                    HorizontalSection<AlbumInfo>(
                      title: 'Studio Albums',
                      height: 230,
                      items: studioAlbums!,
                      itemBuilder: (album) =>
                          AlbumCard(album: album, size: '300x300'),
                    ),
                  ],

                  if (albums != null && albums!.isNotEmpty) ...[
                    HorizontalSection<AlbumInfo>(
                      title: 'All Albums',
                      items: albums!,
                      height: 230,
                      itemBuilder: (album) =>
                          AlbumCard(album: album, size: '300x300'),
                    ),
                  ],

                  if (playlists != null && playlists!.isNotEmpty) ...[
                    HorizontalSection<ShortPlaylistInfo>(
                      title: 'Playlists',
                      height: 200,
                      items: playlists!,
                      itemBuilder: (playlist) =>
                          PlaylistCard(playlist: playlist, size: '300x300'),
                    ),
                  ],

                  if (tracks != null && tracks!.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Popular tracks',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 36,
                        vertical: 2,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(10),
                        ),
                        child: Material(
                          color: buildColor(Colors.black).withOpacity(0.2),
                          child: InkWell(
                            onTap: () async {
                              final List<PlayerTrack> queue = [];
                              for (Track albumTrack in tracks!) {
                                queue.add(
                                  YandexMusicTrack.fromYMToPlayerTrack(
                                    albumTrack,
                                  ),
                                );
                              }
                              await Player.player.playTemporaryQueue(
                                queue,
                                startsNow: true,
                                first: true,
                              );
                            },
                            child: SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    VerticalSection<Track>(
                      title: '',
                      items: tracks!,
                      itemBuilder: (track) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 2,
                        ),
                        child: TrackCard(
                          track: track,
                          size: '100x100',
                          accentColor: buildColor(Colors.black),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(artistColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [artistColor, artistColor.withOpacity(0.0)],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SizedBox(
                width: 180,
                height: 180,
                child: Stack(
                  children: [
                    ClipOval(
                      child: CachedImage(
                        coverUri:
                            'https://${widget.artist.covers[0].uri.replaceAll('%%', '300x300')}',
                        height: 180,
                        width: 180,
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (builder) => GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        height: MediaQuery.of(
                                          context,
                                        ).size.height,
                                        width: MediaQuery.of(
                                          context,
                                        ).size.width,
                                        child: ClipRect(
                                          child: AnimatedSwitcher(
                                            duration: Duration(
                                              milliseconds: (650).round(),
                                            ),
                                            transitionBuilder:
                                                (
                                                  Widget child,
                                                  Animation<double> animation,
                                                ) {
                                                  return FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  );
                                                },
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 95.0,
                                                sigmaY: 95.0,
                                              ),
                                              child: Container(
                                                color: Colors.transparent,
                                                child: AnimatedPadding(
                                                  duration: Duration(
                                                    milliseconds: (750).round(),
                                                  ),
                                                  curve: Curves.ease,
                                                  padding: EdgeInsets.only(),

                                                  child: LayoutBuilder(
                                                    builder: (context, constraints) {
                                                      final maxWidth =
                                                          constraints.maxWidth *
                                                          0.9;
                                                      final maxHeight =
                                                          constraints
                                                              .maxHeight *
                                                          0.9;
                                                      final size = min(
                                                        maxWidth,
                                                        maxHeight,
                                                      ).clamp(270.0, 1200.0);
                                                      return AnimatedContainer(
                                                        duration:
                                                            const Duration(
                                                              milliseconds: 500,
                                                            ),
                                                        curve:
                                                            Curves.easeOutQuint,
                                                        width: size,
                                                        height: size,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          child: CachedImage(
                                                            borderRadius: 15,
                                                            coverUri:
                                                                'https://${widget.artist.covers[0].uri.replaceAll('%%', '1000x1000')}',
                                                            height: 270,
                                                            width: 270,
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.artist.artist.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'noto',
                      fontSize: 48,
                      letterSpacing: -1.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 24,
                    runSpacing: 12,
                    children: [
                      _statistic(
                        icon: Icons.favorite,
                        label: 'Likes',
                        value: NumberFormat(
                          '#,##0',
                          'ru',
                        ).format(widget.artist.likesCount),
                      ),
                      if (widget.artist.lastMonthListeners != null)
                        _statistic(
                          icon: Icons.headphones,
                          label: 'Monthly Listeners',
                          value: NumberFormat(
                            '#,##0',
                            'ru',
                          ).format(widget.artist.lastMonthListeners),
                          showDelta:
                              widget.artist.lastMonthListenersDelta != null,
                          delta: widget.artist.lastMonthListenersDelta,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(10),
                        ),
                        child: Material(
                          color: artistColor.withOpacity(0.2),
                          child: InkWell(
                            onTap: () async {
                              final List<PlayerTrack> queue = tracks != null
                                  ? tracks!
                                        .map<PlayerTrack>(
                                          (e) =>
                                              YandexMusicTrack.fromYMToPlayerTrack(
                                                e,
                                              ),
                                        )
                                        .toList()
                                  : [];

                              await Player.player.playTemporaryQueue(
                                queue,
                                startsNow: true,
                                first: true,
                              );
                            },
                            child: SizedBox(
                              height: 40,
                              width: 100,
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      ClipOval(
                        child: Material(
                          color: artistColor.withOpacity(0.2),
                          child: InkWell(
                            onTap: () async {
                              final link =
                                  'https://music.yandex.ru/artist/${widget.artist.artist.id}';

                              await Clipboard.setData(
                                ClipboardData(text: link),
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Copied to clipboard!'),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Color.alphaBlend(
                                      Colors.black.withOpacity(0.6),
                                      artistColor,
                                    ),

                                    behavior: SnackBarBehavior.fixed,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: Icon(
                                Symbols.upload,
                                color: Colors.white,
                                size: 21,
                              ),
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
    );
  }

  Widget _statistic({
    required IconData icon,
    required String label,
    required String value,
    bool showDelta = false,
    int? delta,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white60, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (showDelta && delta != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: delta > 0
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          delta > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 10,
                          color: delta > 0 ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          NumberFormat('#,##0', 'ru').format(delta.abs()),
                          style: TextStyle(
                            color: delta > 0 ? Colors.green : Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _newRelease() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Release',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                final albums = await YandexMusicSingleton.getAlbumInfo(
                  newRelease!.id,
                );
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    maintainState: false,

                    builder: (builder) => AlbumInfoWidget(album: albums),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedImage(
                        coverUri: newRelease!.coverUri != null
                            ? 'https://${newRelease!.coverUri!.replaceAll('%%', '300x300')}'
                            : "https://none",
                        width: 120,
                        height: 120,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            newRelease!.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            newRelease!.artists.map((a) => a.title).join(', '),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            newRelease!.year,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white60,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AlbumInfoWidget extends StatefulWidget {
  final Album2 album;
  const AlbumInfoWidget({super.key, required this.album});

  @override
  State<StatefulWidget> createState() => _AlbumInfoWidget();
}

class _AlbumInfoWidget extends State<AlbumInfoWidget> {
  Album2 get album => widget.album;
  late final Color albumColor = album.colors != null
      ? Color(
          int.parse(album.colors!.accent.substring(1), radix: 16) + 0xFF000000,
        )
      : Colors.white;

  void setHeader() async {
    DynamicWindowColor.pause();
    Color solidColor = Color.lerp(
      Color.fromARGB(255, 10, 10, 10),
      albumColor,
      0.67,
    )!;

    await DynamicWindowColor.setHeaderColor([
      DynamicWindowColor.darken(solidColor),
    ]);
  }

  @override
  void initState() {
    super.initState();
    setHeader();
  }

  @override
  void dispose() {
    DynamicWindowColor.resume();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 55,
        color: albumColor.withAlpha(50),
        child: Center(
          child: MacroPlayer(
            maxWidth: MediaQuery.of(context).size.width - 30,
            height: 45,
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserLibraryBar(accentColor: albumColor),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  if (album.tracks.isNotEmpty) ...[
                    if (album.tracks.length > 1) ...[
                      for (List<Track> tracks in album.tracks) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Disc ${album.tracks.indexOf(tracks) + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(width: 10),
                              ClipOval(
                                child: Material(
                                  color: albumColor.withOpacity(0.2),
                                  child: InkWell(
                                    onTap: () async {
                                      final List<PlayerTrack> toQ = tracks
                                          .map(
                                            (e) =>
                                                YandexMusicTrack.fromYMToPlayerTrack(
                                                  e,
                                                ),
                                          )
                                          .toList();
                                          


                                      // await Player.player.playTemporaryQueue(
                                      //   toQ,
                                      //   startsNow: true,
                                      //   first: true,
                                      // );
                                    },
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                        size: 21,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        VerticalSection<Track>(
                          title: '',
                          items: tracks,
                          itemBuilder: (track) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 2,
                            ),
                            child: TrackCard(
                              track: track,
                              size: '100x100',
                              bestTrack: album.bestTracks
                                  .map((toElement) => toElement.toString())
                                  .toList()
                                  .contains(track.id),
                              accentColor: albumColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ],
                    if (album.tracks.length == 1) ...[
                      VerticalSection<Track>(
                        title: "Tracks",
                        items: album.tracks[0],
                        itemBuilder: (track) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 2,
                          ),
                          child: TrackCard(
                            track: track,
                            size: '100x100',
                            bestTrack: album.bestTracks
                                .map((toElement) => toElement.toString())
                                .toList()
                                .contains(track.id),
                            accentColor: albumColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [albumColor.withOpacity(0.4), albumColor.withOpacity(0.0)],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(top: 10),
                      child: CoverView(
                        smallCoverLink:
                            'https://${album.cover.uri.replaceAll('%%', '300x300')}',
                        bigCoverLink:
                            'https://${album.cover.uri.replaceAll('%%', '1000x1000')}',
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),

                const SizedBox(width: 32),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'ALBUM',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              album.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'noto',
                                fontSize: 42,
                                letterSpacing: -1.2,
                                height: 1.1,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (album.contentWarning != null) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                album.contentWarning!.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'noto',
                                  color: Colors.red,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 12),

                      InkWell(
                        onTap: () async {
                          int val = 0;
                          if (album.artists.length > 1) {
                            final value = await showDialog<int>(
                              context: context,
                              builder: (context) => WarningMessage(
                                messageHeader: 'Choose an artist',
                                messageDiscription: '',
                                buttons: album.artists
                                    .map((toElement) => toElement.title)
                                    .toList(),
                              ),
                            );

                            if (value == null) return;
                            val = value;
                          }

                          final artist =
                              await YandexMusicSingleton.getArtistInfo(
                                album.artists[val].id,
                              );
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              maintainState: false,
                              builder: (builder) =>
                                  ArtistInfoWidget(artist: artist!),
                            ),
                          );
                        },
                        child: Text(
                          album.artists
                              .map((artist) => artist.title)
                              .join(', '),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 24,
                        runSpacing: 12,
                        children: [
                          _itemInfo(
                            icon: Icons.calendar_today,
                            label: 'Year',
                            value: album.year.toString(),
                          ),
                          if (album.releaseDate != null)
                            _itemInfo(
                              icon: Icons.event,
                              label: 'Released',
                              value: DateFormat(
                                'MMM d, yyyy',
                              ).format(DateTime.parse(album.releaseDate!)),
                            ),
                          _itemInfo(
                            icon: Icons.music_note,
                            label: 'Tracks',
                            value: '${album.tracks.length}',
                          ),
                          _itemInfo(
                            icon: Icons.category,
                            label: 'Genre',
                            value: album.genre,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
                  child: Material(
                    color: albumColor.withOpacity(0.2),
                    child: InkWell(
                      onTap: () async {
                        final List<Track> allTracks = album.tracks
                            .expand((trackList) => trackList)
                            .toList();
                        final List<PlayerTrack> toQ = allTracks
                            .map((e) => YandexMusicTrack.fromYMToPlayerTrack(e))
                            .toList();

                        await Player.player.playTemporaryQueue(
                          toQ,
                          startsNow: true,
                          first: true,
                        );
                      },
                      child: SizedBox(
                        height: 40,
                        width: 180,
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                IconButton2(
                  accentColor: albumColor,
                  icon: Symbols.push_pin,
                  onTap: () async {
                    try {
                      await YandexMusicSingleton.instance.pin.album(
                        album.id.toString(),
                        YandexMusicSingleton.instance.pin.pin,
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pinned into your library!'),
                            duration: Duration(seconds: 1),
                            backgroundColor: Color.alphaBlend(
                              Colors.black.withOpacity(0.6),
                              albumColor,
                            ),

                            behavior: SnackBarBehavior.fixed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Fail! $e'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Color.alphaBlend(
                            Colors.black.withOpacity(0.6),
                            albumColor,
                          ),

                          behavior: SnackBarBehavior.fixed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                ),
                // const SizedBox(width: 5),
                // ClipOval(
                //   child: Material(
                //     color: albumColor.withOpacity(0.2),
                //     child: InkWell(

                //       child: SizedBox(
                //         height: 40,
                //         width: 40,
                //         child: Icon(
                //           Icons.favorite_sharp,
                //           color: Colors.white,
                //           size: 21,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 5),
                // ClipOval(
                //   child: Material(
                //     color: albumColor.withOpacity(0.2),
                //     child: InkWell(
                //       onTap: () async {},
                //       child: SizedBox(
                //         height: 40,
                //         width: 40,
                //         child: Icon(Icons.waves, color: Colors.white, size: 21),
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 5),
                // ClipOval(
                //   child: Material(
                //     color: albumColor.withOpacity(0.2),
                //     child: InkWell(
                //       onTap: () async {},
                //       child: SizedBox(
                //         height: 40,
                //         width: 40,
                //         child: Icon(
                //           Icons.download_done,
                //           color: Colors.white,
                //           size: 21,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(width: 5),
                IconButton2(
                  accentColor: albumColor,
                  icon: Symbols.upload,
                  onTap: () async {
                    final link = 'https://music.yandex.ru/album/${album.id}';

                    await Clipboard.setData(ClipboardData(text: link));

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied to clipboard!'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Color.alphaBlend(
                            Colors.black.withOpacity(0.6),
                            albumColor,
                          ),

                          behavior: SnackBarBehavior.fixed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white60, size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HorizontalSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final double height;

  const HorizontalSection({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: itemBuilder(items[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class VerticalSection<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final double? height;
  final bool shrinkWrap;

  const VerticalSection({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.height,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != '') ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        ListView.builder(
          shrinkWrap: shrinkWrap,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemBuilder(items[index]);
          },
        ),
      ],
    );
  }
}

class ConcertCard extends StatelessWidget {
  final Concert concert;

  const ConcertCard({super.key, required this.concert});

  @override
  Widget build(BuildContext context) {
    final dt = DateTime.parse(concert.dateTime);
    final monthNames = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    final dayNames = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SizedBox(
        width: 150,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: Column(
                children: [
                  Text(
                    monthNames[dt.month - 1],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    dt.day.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    dayNames[dt.weekday - 1],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              concert.concertTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              concert.city,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              concert.place,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w200,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final AlbumInfo album;
  final String size;

  const AlbumCard({super.key, required this.album, this.size = '300x300'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SizedBox(
        width: 150,
        child: InkWell(
          onTap: () async {
            final albums = await YandexMusicSingleton.getAlbumInfo(album.id);
            Navigator.push(
              context,
              CupertinoPageRoute(
                maintainState: false,

                builder: (builder) => AlbumInfoWidget(album: albums),
              ),
            );
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(15),
                child: Image.network(
                  'https://${album.cover!.uri.replaceAll('%%', size)}',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                album.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (album.releaseDate != null)
                Text(
                  '${DateTime.parse(album.releaseDate!).day}-${DateTime.parse(album.releaseDate!).month}-${DateTime.parse(album.releaseDate!).year}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w200,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final ShortPlaylistInfo playlist;
  final String size;

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.size = '300x300',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: SizedBox(
        width: 150,
        child: InkWell(
          onTap: () async {
            final playlistInfo = await YandexMusicSingleton.instance.playlists
                .getPlaylistByUuid(playlist.playlistUuid);
            Navigator.push(
              context,
              CupertinoPageRoute(
                maintainState: false,
                builder: (builder) =>
                    PlaylistInfoWidget(playlist: playlistInfo),
              ),
            );
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(15),
                child: Image.network(
                  'https://${playlist.coverUri.replaceAll('%%', size)}',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                playlist.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

PopupMenuItem<String> _buildMenuItem({
  required IconData icon,
  required String label,
  required String value,
  required VoidCallback onTap,
  Color? color,
  VoidCallback? onHover,
  VoidCallback? onExit,
}) {
  return PopupMenuItem<String>(
    onTap: onTap,
    value: value,
    child: MouseRegion(
      onEnter: (a) => onHover,
      onExit: (a) => onExit,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? Colors.white70),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(color: color ?? Colors.white, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}

class TrackCard extends StatelessWidget {
  final Track track;
  final String size;
  final bool bestTrack;
  final Color accentColor;

  const TrackCard({
    super.key,
    required this.track,
    this.size = '300x300',
    this.bestTrack = false,
    this.accentColor = Colors.grey,
  });

  List<PopupMenuEntry> popumItems(BuildContext context) {
    bool liked = YandexMusicSingleton.likedTracks
        .map((e) => e.trackID)
        .toList()
        .contains(track.id);
    final List<PopupMenuEntry> items = [];
    items.add(
      _buildMenuItem(
        icon: Icons.play_arrow,
        label: "Add to queue",
        value: 'queue',
        onTap: () async {
          Player.player.insertInQueue(
            YandexMusicTrack.fromYMToPlayerTrack(track),
          );
        },
      ),
    );

    items.add(const PopupMenuDivider(height: 1, color: Colors.white10));
    items.add(
      _buildMenuItem(
        icon: liked ? Icons.favorite : Icons.favorite_outline,
        label: liked ? 'Unlike' : "Like",
        value: 'favourite',
        onTap: () async {
          if (liked) {
            await YandexMusicSingleton.unlikeTrack(track.id);
          } else {
            await YandexMusicSingleton.likeTrack(track.id);
          }
        },
      ),
    );
    items.add(
      _buildMenuItem(
        icon: Icons.queue_outlined,
        label: "Add to yandex playlist",
        value: 'playlist',
        onTap: () async {
          int selected = 0;
          final value = await showDialog<int>(
            context: context,
            builder: (context) => WarningMessage(
              messageHeader: 'Choose playlist',
              messageDiscription: '',
              transparency: 255,
              borderColor: Colors.transparent,
              color: Color.alphaBlend(
                const Color.fromRGBO(0, 0, 0, 0.9),
                accentColor,
              ),
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
              track.id,
              albumId: track.albums[0].id.toString(),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Fail! $e'),
                duration: Duration(seconds: 1),
                backgroundColor: Color.alphaBlend(
                  Colors.black.withOpacity(0.6),
                  accentColor,
                ),

                behavior: SnackBarBehavior.fixed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      ),
    );
    items.add(const PopupMenuDivider(height: 1, color: Colors.white10));
    items.add(
      _buildMenuItem(
        icon: Symbols.person,
        label: 'Go to Artist',
        value: 'artist',
        onTap: () async {
          int selected = 0;
          if (track.artists.length > 1) {
            final value = await showDialog<int>(
              context: context,
              builder: (context) => WarningMessage(
                messageHeader: 'Choose an artist',
                messageDiscription: '',
                transparency: 255,
                borderColor: Colors.transparent,
                color: Color.alphaBlend(
                  const Color.fromRGBO(0, 0, 0, 0.9),
                  accentColor,
                ),
                buttons: track.artists
                    .map((toElement) => toElement.title)
                    .toList(),
              ),
            );

            if (value == null) return;
            selected = value;
          }
          final artist = await YandexMusicSingleton.instance.artists.getInfo(
            track.artists[selected],
          );
          Navigator.push(
            context,
            CupertinoPageRoute(
              maintainState: false,
              builder: (builder) => ArtistInfoWidget(artist: artist),
            ),
          );
        },
      ),
    );

    items.add(
      _buildMenuItem(
        icon: Icons.album,
        label: 'Go to Album',
        value: 'album',
        onTap: () async {
          final album = await YandexMusicSingleton.instance.albums.getInfo(
            track.albums[0].id,
          );
          if (context.mounted) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                maintainState: false,

                builder: (_) => AlbumInfoWidget(album: album),
              ),
            );
          }
        },
      ),
    );

    items.add(
      _buildMenuItem(
        icon: Icons.info_outline,
        label: 'View track info',
        value: 'info',
        onTap: () async {},
      ),
    );

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            Player.player.insertInQueue(
              YandexMusicTrack.fromYMToPlayerTrack(track),
            );
            await Player.player.playNext(forceNext: true, completed: false);
          },
          child: Row(
            children: [
              if (track.coverUri != null)
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(5),
                  child: Image.network(
                    'https://${track.coverUri!.replaceAll('%%', '100x100')}',
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(132, 158, 158, 158),
                  ),
                ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      track.artists.map((a) => a.title).join(', '),
                      style: TextStyle(color: Colors.white.withAlpha(160)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const Spacer(),
              if (bestTrack)
                Icon(
                  Icons.star,
                  color: const Color.fromARGB(182, 255, 255, 255),
                  size: 16,
                ),

              PopupMenuButton(
                color: Color.fromARGB(255, 34, 34, 38),
                iconColor: Colors.white,

                itemBuilder: (itemBuilder) {
                  return popumItems(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoverView extends StatelessWidget {
  final String smallCoverLink;
  final String bigCoverLink;
  const CoverView({
    super.key,
    required this.smallCoverLink,
    required this.bigCoverLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SizedBox(
        width: 180,
        height: 180,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedImage(
                coverUri: smallCoverLink,
                height: 180,
                width: 180,
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (builder) => GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Material(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: ClipRect(
                                  child: AnimatedSwitcher(
                                    duration: Duration(
                                      milliseconds: (650).round(),
                                    ),
                                    transitionBuilder:
                                        (
                                          Widget child,
                                          Animation<double> animation,
                                        ) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 95.0,
                                        sigmaY: 95.0,
                                      ),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: AnimatedPadding(
                                          duration: Duration(
                                            milliseconds: (750).round(),
                                          ),
                                          curve: Curves.ease,
                                          padding: EdgeInsets.only(),

                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final maxWidth =
                                                  constraints.maxWidth * 0.9;
                                              final maxHeight =
                                                  constraints.maxHeight * 0.9;
                                              final size = min(
                                                maxWidth,
                                                maxHeight,
                                              ).clamp(270.0, 1200.0);
                                              return AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 500,
                                                ),
                                                curve: Curves.easeOutQuint,
                                                width: size,
                                                height: size,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: CachedImage(
                                                    borderRadius: 15,
                                                    coverUri: bigCoverLink,
                                                    height: 270,
                                                    width: 270,
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
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback? onTap;

  const AnimatedIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
    this.onTap,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final double currentSize = _pressed
        ? widget.size - 1
        : _hovered
        ? widget.size + 2
        : widget.size;

    final Color currentColor = _pressed
        ? widget.color.withAlpha(100)
        : widget.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      cursor: SystemMouseCursors.click,
      onExit: (_) => setState(() {
        _hovered = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            style: const TextStyle(),
            child: Icon(widget.icon, color: currentColor, size: currentSize),
          ),
        ),
      ),
    );
  }
}

class IconButton2 extends StatelessWidget {
  final Color accentColor;
  final VoidCallback onTap;
  final IconData icon;
  final double width;
  final double height;
  final Color iconColor;
  final double iconSize;
  final BorderRadiusGeometry? borderRadius;

  const IconButton2({
    super.key,
    this.accentColor = Colors.white,
    this.height = 40,
    required this.icon,
    this.iconColor = Colors.white,
    this.iconSize = 21,
    required this.onTap,
    this.width = 40,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: Material(
          color: accentColor.withOpacity(0.2),
          child: InkWell(
            onTap: onTap,
            child: SizedBox(
              height: height,
              width: width,
              child: Icon(icon, color: iconColor, size: iconSize),
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: Material(
        color: accentColor.withOpacity(0.2),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: height,
            width: width,
            child: Icon(icon, color: iconColor, size: iconSize),
          ),
        ),
      ),
    );
  }
}

class UserLibraryBar extends StatelessWidget {
  final Color accentColor;

  const UserLibraryBar({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 55,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accentColor.withOpacity(0.4),
              accentColor.withOpacity(0.0),
            ],
            stops: const [0.0, 0.38],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            IconButton2(
              // borderRadius: BorderRadius.all(Radius.circular(10)),
              icon: Icons.arrow_back,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 10),
            IconButton2(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              icon: Icons.home,
              onTap: () {
                Navigator.popUntil(context, ModalRoute.withName('/player'));
              },
            ),
            for (PlaylistWShortTracks playlist
                in YandexMusicSingleton.playlists) ...[
              SizedBox(height: 10),
              Container(
                width: 40,
                // width: 260,
                // height: 260,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  image: DecorationImage(
                    image: CachedImageProvider(
                      '${YandexMusicSingleton.instance.playlists.getPlaylistCoverArtUrl(playlist.cover ?? {"type": "pic", "uri": "raw.githubusercontent.com/z3nsh0w/z3nsh0w.github.io/refs/heads/master/nocover.png", "custom": true})}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(5),

                  child: InkWell(
                    onTap: () async {
                      final playlist2 = await YandexMusicSingleton
                          .instance
                          .playlists
                          .getPlaylist(
                            playlist.kind,
                            accountId: playlist.ownerUid,
                          );
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          maintainState: false,
                          builder: (builder) =>
                              PlaylistInfoWidget(playlist: playlist2),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
