import 'dart:ui';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:quark/objects/track.dart';
import 'package:quark/services/cached_images.dart';
import 'package:quark/services/player/player.dart';
import 'package:quark/widgets/players_widgets/macro_player.dart';
import '../../services/yandex_music_singleton.dart';

/// yandex_music LIBRARY UI EXAMPLE

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

  @override
  void initState() {
    super.initState();
    setState(() {
      visibility = widget.playlist.visibility == 'public';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        title: Row(
          children: [
            Text(
              'Playlist',
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
            if (widget.playlist.tracks.isNotEmpty) ...[
              VerticalSection<Track>(
                title: 'Tracks',
                items: widget.playlist.tracks,
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
    );
  }

  Widget _header() {
    final Color playlistColor = Colors.white;
    final bool isOwner =
        widget.playlist.ownerUid == YandexMusicSingleton.instance.accountID;

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(top: 10),
              child: CoverView(
                smallCoverLink: widget.playlist.cover != null
                    ? YandexMusicSingleton.instance.playlists
                          .getPlaylistCoverArtUrl(widget.playlist.cover!)
                    : 'none',
                bigCoverLink: widget.playlist.cover != null
                    ? YandexMusicSingleton.instance.playlists
                          .getPlaylistCoverArtUrl(
                            widget.playlist.cover!,
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
                    widget.playlist.title,
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
                    'by ${widget.playlist.owner.name ?? 'Unknown'}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 24,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _itemInfo(
                        icon: Icons.music_note,
                        label: 'Tracks',
                        value: '${widget.playlist.tracks.length}',
                      ),
                      _itemInfo(
                        icon: visibility ? Icons.public : Icons.lock,
                        label: 'Visibility',
                        value: visibility ? 'Public' : 'Private',
                      ),
                      if (isOwner) _visibilitySwitch(),
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

  Widget _visibilitySwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.settings, color: Colors.white60, size: 16),
          const SizedBox(width: 8),
          const Text(
            'Toggle',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: visibility,
              activeColor: Colors.green,
              activeTrackColor: Colors.green.withOpacity(0.3),
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
              onChanged: (value) async {
                if (isProcessing) return;
                setState(() {
                  isProcessing = true;
                });

                try {
                  await YandexMusicSingleton.instance.playlists
                      .changeVisibility(
                        widget.playlist.kind,
                        value
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
                    visibility = value;
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
            ),
          ),
        ],
      ),
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
    try {
      final concertsS = await YandexMusicSingleton.instance.artists.getConcerts(
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
      final newReleaseInfo = await YandexMusicSingleton.instance.artists
          .getNewRelease(widget.artist.artist.id);

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
      final studioAlbumsInfo = await YandexMusicSingleton.instance.artists
          .getStudioAlbums(widget.artist.artist.id);

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
      final albums2 = await YandexMusicSingleton.instance.artists.getAlbums(
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
      final playlistss = await YandexMusicSingleton.instance.artists
          .getPlaylists(widget.artist.artist.id);

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
      final trackss = await YandexMusicSingleton.instance.artists.getTracks(
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

  @override
  void initState() {
    super.initState();
    initAll();
  }

  @override
  Widget build(BuildContext context) {
    Color buildColor(Color default2) {
      return widget.artist.covers.isNotEmpty
          ? Color(
              int.parse(widget.artist.covers[0].color.substring(1), radix: 16) +
                  0xFF000000,
            )
          : default2;
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        surfaceTintColor: buildColor(Colors.black),
        shadowColor: buildColor(Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        title: Row(
          children: [
            const Text(
              'Artist',
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
              VerticalSection<Track>(
                title: 'Popular Tracks',
                items: tracks!,
                itemBuilder: (track) => Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 2,
                  ),
                  child: TrackCard(track: track, size: '100x100'),
                ),
              ),
            ],
          ],
        ),
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
                      fontSize: 48,
                      letterSpacing: -1.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 20),

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
                final albums = await YandexMusicSingleton.instance.albums
                    .getInfo(newRelease!.id);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
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
                      child: Image.network(
                        'https://${newRelease!.coverUri.replaceAll('%%', '300x300')}',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
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

class AlbumInfoWidget extends StatelessWidget {
  final Album2 album;

  const AlbumInfoWidget({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        title: Row(
          children: [
            Text(
              'Album',
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
            _header(context),
            if (album.tracks.isNotEmpty) ...[
              VerticalSection<Track>(
                title: 'Tracks',
                items: album.tracks,
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
                  ),
                ),
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final Color albumColor = album.colors != null
        ? Color(
            int.parse(album.colors!.accent.substring(1), radix: 16) +
                0xFF000000,
          )
        : Colors.white;

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    children: [
                      Flexible(
                        child: Text(
                          album.title,
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

                  Text(
                    album.artists.map((artist) => artist.title).join(', '),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 20),

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
            final albums = await YandexMusicSingleton.instance.albums.getInfo(
              album.id,
            );
            Navigator.push(
              context,
              CupertinoPageRoute(
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

class TrackCard extends StatelessWidget {
  final Track track;
  final String size;
  final bool bestTrack;

  const TrackCard({
    super.key,
    required this.track,
    this.size = '300x300',
    this.bestTrack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final path = await getTrackPath(track.id);
            final track2 = YandexMusicTrack(
              track: track,
              title: track.title,
              artists: track.artists
                  .map((toElement) => toElement.title)
                  .toList(),
              albums: track.albums.map((toElement) => toElement.title).toList(),
              filepath: path,
            );
            track2.cover = track.coverUri ?? 'none';
            await Player.player.playCustom(track2);
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
                  final List<PopupMenuEntry> items = [];
                  for (Artist artist in track.artists) {
                    if (artist is! UGCArtist) {
                      items.add(
                        PopupMenuItem(
                          child: Text(
                            'Go to ${artist.title}',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () async {
                            final artists = await YandexMusicSingleton
                                .instance
                                .artists
                                .getInfo((artist as OfficialArtist).id);
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (builder) =>
                                    ArtistInfoWidget(artist: artists),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                  return items;
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
              borderRadius: BorderRadius.circular(5),
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
