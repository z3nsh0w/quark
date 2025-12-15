// Flutter & Dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quark/objects/track.dart';
import 'dart:math';

// Additional packages
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

// Local files
import 'package:quark/objects/playlist.dart';
import 'database.dart';
import 'playlist_page.dart';

// TODO: ! ADD LOGGER
// TODO: ADD LAST PLAYLIST
// TODO: REMOVE SETSTATE FROM BUILD METHODS

void main() async {
  runApp(const Quark());
}

class Quark extends StatelessWidget {
  const Quark({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Files {
  Future<List<PlayerTrack>> getFilesFromDirectory(String directoryPath) async {
    try {
      final dir = Directory(directoryPath);
      final List<PlayerTrack> fileNames = [];

      await for (final entity in dir.list()) {
        if (entity is File) {
          if (entity.path.toLowerCase().endsWith('.mp3') ||
              entity.path.toLowerCase().endsWith('.wav') ||
              entity.path.toLowerCase().endsWith('.flac') ||
              entity.path.toLowerCase().endsWith('.dsf') ||
              entity.path.toLowerCase().endsWith('.aac') ||
              entity.path.toLowerCase().endsWith('.ogg') ||
              entity.path.toLowerCase().endsWith('.alac') ||
              entity.path.toLowerCase().endsWith('.pcm') ||
              entity.path.toLowerCase().endsWith('.m4a')) {
            try {
              final tagsFromFile = readMetadata(
                File(entity.path),
                getImage: true,
              );

              String trackName = tagsFromFile.title ??= 'Unknown';
              Uint8List? cover = tagsFromFile.pictures.isNotEmpty
                  ? tagsFromFile.pictures.first.bytes
                  : null;

              LocalTrack track = LocalTrack(
                title: trackName,
                artists: [tagsFromFile.artist ??= 'Unknown'],
                filepath: entity.path,
                albums: ['Unknown'],
              );

              track.coverByted = cover!;

              fileNames.add(track);
            } catch (e) {
              String trackName = path.basename(path.normalize(entity.path));
              LocalTrack track = LocalTrack(
                title: trackName,
                artists: ['Unknown'],
                filepath: entity.path,
                albums: ['Unknown'],
              );
              fileNames.add(track);
            }
          }
        }
      }

      return fileNames;
    } catch (e) {}
    return [];
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool loginView = false;
  bool playlistView = false;
  bool inited = false;
  YandexMusic yandexMusic = YandexMusic(token: '');
  List<Playlist2> userPlaylists = [];

  Future<void> pickFolder() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        List<PlayerTrack> result = await Files().getFilesFromDirectory(
          selectedDirectory,
        );
        if (result.isNotEmpty) {
          playlistRoute(PlayerPlaylist(0, 0, "Local", result));
        }
      }
    } catch (e) {}
  }

  void closeLogin([bool? openPlaylists]) {
    setState(() {
      loginView = false;
      playlistView = true;
    });
  }

  void closePlaylist([bool? openPlaylists]) async {
    setState(() {
      playlistView = false;
    });
  }

  void playlistRoute(PlayerPlaylist playlist) async {
    await Database.setValue('last_playlist', playlist);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PlaylistPage(playlist: playlist, yandexMusic: yandexMusic),
      ),
    );
  }

  void playlistRestore() async {
    // TODO: finish
    PlayerPlaylist? lastPlaylist = await Database.getValue('last_playlist');
    String? token = await Database.getValue('yandex_music_token');
    if (lastPlaylist == null) {
      return;
    } else {
      bool inited = await checkYmInit();

      if (!inited) {
        yandexMusic = YandexMusic(token: token ?? '');
      }
      playlistRoute(lastPlaylist);
    }
  }

  Future<bool> checkYmInit() async {
    try {
      await yandexMusic.account.getAccountID();
      return true;
    } catch (e) {
      return false;
    }
  }

  void precacheTracks() async {
    Future.delayed(Duration(milliseconds: 50), () async {
      var cacheDirectory = await getApplicationCacheDirectory();
      if (userPlaylists.isNotEmpty) {
        for (Playlist2 playlist in userPlaylists) {
          if (playlist.tracks.isNotEmpty) {
            try {
              var track = await yandexMusic.tracks.download(
                playlist.tracks[0].trackID,
              );
              var file = File(
                '${cacheDirectory.path}/cisum_xednay_krauq${playlist.tracks[0].trackID}.flac',
              );
              bool exist = await file.exists();
              if (!exist) {
                file.writeAsBytes(track);
              }
            } on YandexMusicException {}
          }
        }
      }
    });
  }

  void ymUpdate() async {
    try {
      String? token = await Database.getValue('yandex_music_token');
      if (token != null) {
        yandexMusic = YandexMusic(token: token);
        await yandexMusic.init();
        inited = true;

        if (userPlaylists.isEmpty) {
          yandexMusic.usertracks.getPlaylistsWithLikes().then((playlists) {
            setState(() {
              userPlaylists = playlists;

              playlistView = true;
            });
          });
        } else {
          setState(() {
            playlistView = true;
          });
          precacheTracks();
        }
        precacheTracks();
      } else {
        setState(() {
          loginView = true;
        });
      }
    } on YandexMusicException catch (e) {
      switch (e.type) {
        case YandexMusicException.unauthorized:
          setState(() {
            loginView = true;
          });
        default:
          return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Database.init();
    Future.delayed(Duration(milliseconds: 50), () async {
      try {
        String? token = await Database.getValue('yandex_music_token');
        if (token != null) {
          yandexMusic = YandexMusic(token: token);

          await yandexMusic.init();
          inited = true;
        }
      } on YandexMusicException {
        inited = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: Stack(
        children: [
          Center(
            child: Container(
              width: size.width,
              height: size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(24, 24, 26, 1),
                    Color.fromRGBO(18, 18, 20, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/icon512.png', height: 150, width: 150),
                  const SizedBox(height: 15),
                  const Text(
                    'quark: where sound begins',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      decoration: TextDecoration.none,
                      fontFamily: 'noto',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const SizedBox(
                    width: 400,
                    child: Text(
                      'Select the folder with tracks. \nYou can also link your streaming account to use it.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,

                        fontSize: 16,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'noto',
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),
                  // button(() async {playlistRestore();}, 'Restore playlist'),
                  // SizedBox(height: 12.5),
                  button(() async {
                    await pickFolder();
                  }, 'Add folder'),
                  const SizedBox(height: 12.5),
                  button(() async {
                    if (inited) {
                      if (userPlaylists.isEmpty) {
                        yandexMusic.usertracks.getPlaylistsWithLikes().then((
                          playlists,
                        ) {
                          setState(() {
                            userPlaylists = playlists;

                            playlistView = true;
                          });
                        });
                      } else {
                        setState(() {
                          playlistView = true;
                        });
                        precacheTracks();
                      }
                    } else {
                      ymUpdate();
                    }
                  }, 'Yandex Music'),
                  // SizedBox(height: 12.5),
                  // button(() {}, 'Spotify'),
                ],
              ),
            ),
          ),

          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: loginView
                ? Container(
                    key: ValueKey('login'),
                    color: Colors.black.withOpacity(0.99),
                    child: Stack(
                      children: [
                        yandexLogin(context, closeLogin),
                        Positioned(
                          right: 0,
                          child: IconButton(
                            onPressed: () => setState(() => loginView = false),
                            icon: Icon(Icons.close, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(key: ValueKey('empty')),
          ),

          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: playlistView
                ? GestureDetector(
                    onTap: () => setState(() => playlistView = false),
                    child: Container(
                      key: ValueKey('playlist'),
                      color: Colors.black.withOpacity(0.99),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: YandexPlaylists(
                              closeView: closePlaylist,
                              yandexMusic: yandexMusic,
                              playlists: userPlaylists,
                              playlistRouter: playlistRoute,
                            ),
                          ),
                          // Positioned(
                          //   right: 30,
                          //   child: IconButton(
                          //     onPressed: () => ymUpdate(),
                          //     icon: Icon(
                          //       Icons.refresh,
                          //       color: Colors.white70,
                          //     ),
                          //   ),
                          // ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () =>
                                  setState(() => playlistView = false),
                              icon: Icon(Icons.close, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(key: ValueKey('empty')),
          ),
        ],
      ),
    );
  }
}

Material button(Function() onTap, String text) {
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(15),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 45,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(6, 255, 255, 255),
          border: Border.all(width: 1, color: Colors.white.withAlpha(50)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    ),
  );
}

//
//
//
//
// YANDEX WIDGETS
//
//
//
//

Widget yandexLogin(BuildContext context, Function() closeView) {
  final Uri loginUrl = Uri.parse(
    'https://oauth.yandex.ru/authorize?response_type=token&client_id=23cabbbdc6cd418abb4b39c32c41195d',
  );

  InAppWebViewController? webViewController;

  YandexMusic yandexMusic = YandexMusic(token: '');

  final TextEditingController _tokenController = TextEditingController();

  final size = MediaQuery.of(context).size;

  Future<void> _launchUrl() async {
    if (!await launchUrl(loginUrl)) {
      throw Exception('Could not launch $loginUrl');
    }
  }

  if (Platform.isLinux) {
    return Center(
      child: Container(
        alignment: AlignmentDirectional.center,
        width: min(480, size.width - 50),
        height: min(382, size.height - 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(30, 255, 255, 255),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              'We apologize, but webview is currently unavailable for logging in on Linux.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 420,
              child: Text(
                'Enter the token received via the quarkaudio.ru website \nor manually copied from the',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w100,
                ),

                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 420,
              child: InkWell(
                onTap: _launchUrl,
                child: Text(
                  'Yandex Music web Page',
                  style: TextStyle(
                    color: Color.fromARGB(255, 184, 203, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w100,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 400,
              child: TextField(
                style: TextStyle(
                  color: Colors.white.withAlpha(220),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                controller: _tokenController,
                decoration: InputDecoration(
                  hintText: 'Enter token here',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.key,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  filled: false,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            button(() async {
              String token = _tokenController.text;
              yandexMusic = YandexMusic(token: token);
              try {
                await yandexMusic.init();
              } on YandexMusicException {
                _tokenController.text = 'Authorization error. Invalid token.';
              }

              String email = await yandexMusic.account.getEmail();
              String displayName = await yandexMusic.account.getDisplayName();
              String fullName = await yandexMusic.account.getFullName();
              String login = await yandexMusic.account.getLogin();

              Database.setValue('yandex_music_token', token);
              Database.setValue('yandex_music_uid', yandexMusic.accountID);
              Database.setValue('yandex_music_email', email);
              Database.setValue('yandex_music_displayname', displayName);
              Database.setValue('yandex_music_fullname', fullName);
              Database.setValue('yandex_music_login', login);
              closeView();
            }, 'Continue'),
            const SizedBox(height: 20),
            Text(
              'Read about how to obtain a token on our website',
              style: TextStyle(color: Colors.white.withAlpha(200)),
            ),
          ],
        ),
      ),
    );
  }

  return Center(
    child: Container(
      alignment: AlignmentDirectional.center,
      width: min(390, size.width - 50),
      height: min(650, size.height - 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Color.fromARGB(30, 255, 255, 255),
      ),
      child: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(
                  'https://oauth.yandex.ru/authorize?response_type=token&client_id=23cabbbdc6cd418abb4b39c32c41195d',
                ),
              ),
              initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                if (url.toString().contains('access_token')) {
                  try {
                    String token = url
                        .toString()
                        .split('#')[1]
                        .split('&')[0]
                        .replaceAll('access_token=', '');
                    if (token.length > 3) {
                      yandexMusic = YandexMusic(token: token);
                      try {
                        await yandexMusic.init();
                      } on YandexMusicException {
                        _tokenController.text =
                            'Authorization error. Invalid token.';
                      }

                      String email = await yandexMusic.account.getEmail();
                      String displayName = await yandexMusic.account
                          .getDisplayName();
                      String fullName = await yandexMusic.account.getFullName();
                      String login = await yandexMusic.account.getLogin();

                      Database.setValue('yandex_music_token', token);
                      Database.setValue(
                        'yandex_music_uid',
                        yandexMusic.accountID,
                      );
                      Database.setValue('yandex_music_email', email);
                      Database.setValue(
                        'yandex_music_displayname',
                        displayName,
                      );
                      Database.setValue('yandex_music_fullname', fullName);
                      Database.setValue('yandex_music_login', login);
                      closeView();
                    }
                  } catch (ex) {}
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class YandexPlaylists extends StatefulWidget {
  final Function() closeView;
  final YandexMusic yandexMusic;
  final List<Playlist2> playlists;
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
      child: Container(
        alignment: AlignmentDirectional.center,
        width: min(size.width * 0.92, 1040),
        height: min(size.height * 0.92, 1036),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(30, 255, 255, 255),
        ),
        child: Column(
          children: [
            Expanded(
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
                            final playlistTracks = await widget
                                .yandexMusic
                                .tracks
                                .getTracks(trackIds);
                            var cacheDirectory =
                                await getApplicationCacheDirectory();

                            List<YandexMusicTrack> output = [];

                            playlistTracks.forEach((track) {
                              YandexMusicTrack tr = YandexMusicTrack(
                                filepath:
                                    '${cacheDirectory.path}/cisum_xednay_krauq${track.id}.flac',
                                title: track.title,
                                albums: track.albums.isNotEmpty
                                    ? track.albums
                                          .map(
                                            (album) =>
                                                album.title ?? 'Unknown album',
                                          )
                                          .toList()
                                    : ['Unknown album'],
                                artists: track.artists
                                    .map(
                                      (album) => album.title ?? 'Unknown album',
                                    )
                                    .toList(),
                                track: track
                              );
                              String? cover = track.coverUri;
                              cover ??= tr.cover;
                              tr.cover = cover;
                              
                              output.add(tr);
                              print(tr.cover);
                            });
                            output.removeWhere(
                              (track) => track.track.available != true,
                            );

                            await widget.closeView();

                            widget.playlistRouter(
                              PlayerPlaylist(
                                widget.playlists[index].ownerUid,
                                widget.playlists[index].kind,
                                widget.playlists[index].title,
                                output,
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
          ],
        ),
      ),
    );
  }
}
