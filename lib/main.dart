// Flutter & Dart
import 'dart:io';
import 'dart:async';
import 'package:audio_service_mpris/audio_service_mpris.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:quark/objects/track.dart';

// Additional packages
import 'package:logging/logging.dart';
import 'package:file_picker/file_picker.dart';
import 'package:quark/services/native_control.dart';
import 'package:quark/services/player.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

// Local files
import 'playlist_page_router.dart';
import '/services/files.dart';
import '/widgets/settings.dart';
import '/objects/playlist.dart';
import 'services/database_engine.dart';
import '/widgets/yandex_login.dart';
import '/widgets/yandex_playlists_widget.dart';

// #TODO: fix bug while closing playtlist with iconbutton then if playlist was opened by mouseArea it wont close
// TODO: REMOVE SETSTATE FROM BUILD METHODS
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WindowManager.instance.ensureInitialized();

  final path = await getApplicationCacheDirectory();
  Hive.init(path.path);
  WindowManager.instance.setMinimumSize(const Size(300, 200));
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

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool inited = false;
  bool loginView = false;
  bool playlistView = false;
  bool settingsView = false;
  PlayerPlaylist? lastPlaylist;
  String? lastTrackPath;
  final log = Logger('MainPage');
  List<PlaylistWShortTracks> userPlaylists = [];
  YandexMusic yandexMusic = YandexMusic(token: '');

  /// Reacting on pick folder button
  Future<void> pickFolder() async {
    try {
      final bool? recursiveFilesAdding = await Database.get(
        DatabaseKeys.recursiveFilesAdding.value,
      );
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        List<PlayerTrack> result = await Files().getFilesFromDirectory(
          directoryPath: selectedDirectory,
          recursiveEnable: recursiveFilesAdding,
        );
        if (result.isNotEmpty) {
          playlistRoute(
            PlayerPlaylist(
              kind: 0,
              ownerUid: 0,
              name: "Local",
              tracks: result,
              source: PlaylistSource.local,
            ),
          );
        }
      }
    } catch (e) {
      log.shout('Unexcepted error while pickFolder()', e);
    }
  }

  /// Reacting on close login button
  Future<void> closeLogin([bool? openPlaylists]) async {
    setState(() {
      loginView = false;
      ymUpdate();
      playlistView = true;
    });
  }

  /// Reacting on close playlist button
  Future<void> closePlaylist([bool? openPlaylists]) async {
    setState(() {
      playlistView = false;
    });
  }

  /// Reacting on close settings button
  Future<void> closeSettings() async {
    setState(() {
      settingsView = false;
    });
  }

  /// Routing to playlist page
  Future<void> playlistRoute(PlayerPlaylist playlist) async {
    Map play = await serializePlaylist(playlist);
    await Database.put(DatabaseKeys.lastPlaylist.value, play);
    lastPlaylist = playlist;
    await Player.player.updatePlaylist(playlist.tracks);

    PlayerTrack? foundTrack;

    if (lastTrackPath != null) {
      for (final track in playlist.tracks) {
        if (track.filepath == lastTrackPath) {
          foundTrack = track;
          break;
        }
      }
    }

    final trackToPlay = foundTrack ?? playlist.tracks[0];

    await Player.player.stop();
    Player.player.isPlaying = false;
    Player.player.nowPlayingTrack = trackToPlay;
    if (await File(trackToPlay.filepath).exists()) {
    await Player.player.playerInstance.setSource(
      DeviceFileSource(trackToPlay.filepath),
    );
    }


    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            PlaylistPage(playlist: playlist, yandexMusic: yandexMusic),
      ),
    );
  }

  /// Reaction on playlist restore button
  Future<void> playlistRestore() async {
    String? token = await Database.get(DatabaseKeys.yandexMusicToken.value);

    final playlist = await restoreLast();

    if (playlist == null) {
      return;
    }

    bool inited = await yandexMusic.checkInit();
    if (!inited) {
      yandexMusic = YandexMusic(token: token ?? '');
    }

    playlistRoute(playlist);
  }

  /// Preloading the first tracks of all playlists from yandex music
  Future<void> precacheTracks() async {
    Future.delayed(Duration(milliseconds: 50), () async {
      var cacheDirectory = await getApplicationCacheDirectory();
      if (userPlaylists.isNotEmpty) {
        for (PlaylistWShortTracks playlist in userPlaylists) {
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
            } on YandexMusicException catch (e) {
              log.shout('precacheTracks() error', e);
            }
          }
        }
      }
    });
  }

  /// Update playlists from yandex music
  Future<void> ymUpdate() async {
    if (inited && userPlaylists.isNotEmpty) {
      setState(() {
        playlistView = true;
      });
      return;
    }

    try {
      if (!inited) {
        String? token = await Database.get(DatabaseKeys.yandexMusicToken.value);
        if (token == null) {
          setState(() {
            loginView = true;
          });
          return;
        }
        yandexMusic = YandexMusic(token: token);
        log.warning('Trying to initialize yandex music instance...');

        await yandexMusic.init();
        inited = true;
      }

      if (userPlaylists.isEmpty) {
        yandexMusic.usertracks.getPlaylistsWithLikes().then((playlists) async {
          await Database.put(
            DatabaseKeys.yandexMusicPlaylists.value,
            playlists.map((toElement) => toElement.raw).toList(),
          );

          setState(() {
            userPlaylists = playlists;
            playlistView = true;
          });
        });
      } else {
        setState(() {
          playlistView = true;
        });
      }
      await precacheTracks();
    } on YandexMusicException catch (e) {
      switch (e.type) {
        case YandexMusicException.unauthorized:
          log.warning(
            'Yandex Music initizalization failed. Redirecting to login widget...',
          );
          setState(() {
            loginView = true;
          });
        default:
          log.shout('Unexcepted error while ymUpdate()', e);
          return;
      }
    }
  }

  /// Execute last playlist from database
  Future<PlayerPlaylist?> restoreLast() async {
    String? resl = await Database.get(DatabaseKeys.lastTrack.value);
    lastTrackPath = resl;

    final executed = await Database.get(DatabaseKeys.lastPlaylist.value);

    if (executed != null) {
      final ls = await deserializePlaylist(
        (executed as Map).cast<String, dynamic>(),
      );
      setState(() {
        lastPlaylist = ls;
      });

      return ls;
    } else {
      return null;
    }
  }

  /// Logger
  Future<void> initLogger() async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: ${record.time.toIso8601String()}: ${record.message} ${record.error ?? ''}',
      );
    });
    log.finest('Hello world!');
  }

  @override
  void initState() {
    super.initState();
    Player(
      playlist: [],
      nowPlayingTrack: LocalTrack(
        title: 'title',
        artists: ['artists'],
        albums: ['albums'],
        filepath: 'filepath',
      ),
    );
    Player.player.init();
    NativeControl().init();
    AudioServiceMpris.registerWith();
    initLogger();
    log.info('Trying to initialize database...');
    Database.init();
    log.fine('Database initialized successfully');
    Future.delayed(Duration(milliseconds: 15), () async {
      await restoreLast();
    });
    Future.delayed(Duration(milliseconds: 15), () async {
      bool? yandexPreload = await Database.get(
        DatabaseKeys.yandexMusicPreload.value,
      );

      if (yandexPreload != false) {
        log.info('Yandex preloading is enabled. Trying to initialize...');
        try {
          String? token = await Database.get(
            DatabaseKeys.yandexMusicToken.value,
          );
          if (token != null) {
            yandexMusic = YandexMusic(token: token);

            await yandexMusic.init();
            inited = true;
            log.fine('Yandex Music successfully initialized.');
          }
        } on YandexMusicException {
          log.warning('Yandex Music preloading initizalization failed...');
          inited = false;
        }
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
              decoration: BoxDecoration(color: Color.fromRGBO(24, 24, 26, 1)),
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
                  const SizedBox(height: 15),
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
                  if (lastPlaylist != null)
                    Column(
                      children: [
                        _mainPageButton(
                          () async => playlistRestore(),
                          'Restore playlist',
                        ),
                        SizedBox(height: 12.5),
                      ],
                    ),

                  _mainPageButton(() async {
                    await pickFolder();
                  }, 'Add folder'),
                  const SizedBox(height: 12.5),
                  _mainPageButton(
                    () async => await ymUpdate(),
                    'Yandex Music',
                  ),
                ],
              ),
            ),
          ),

          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: loginView
                ? GestureDetector(
                    onTap: () => setState(() {
                      if (Platform.isLinux) {
                        loginView = false;
                      }
                    }),
                    child: Container(
                      key: ValueKey('login'),
                      color: Colors.black.withAlpha(25),
                      child: Stack(
                        children: [
                          YandexLogin(closeView: closeLogin),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () =>
                                  setState(() => loginView = false),
                              icon: Icon(Icons.close, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
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
                      color: Colors.black.withAlpha(25),
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
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: settingsView
                ? GestureDetector(
                    onTap: () => setState(() => settingsView = false),
                    child: Container(
                      color: Colors.black.withAlpha(25),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Settings(closeView: closeSettings),
                          ),
                          Positioned(
                            right: 0,
                            child: IconButton(
                              onPressed: () =>
                                  setState(() => settingsView = false),
                              icon: Icon(Icons.close, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox.shrink(key: ValueKey('empty')),
          ),
          if (playlistView == false &&
              loginView == false &&
              settingsView == false)
            Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    settingsView = true;
                  });
                },
                icon: Icon(
                  Icons.settings,
                  color: Color.fromRGBO(255, 255, 255, 0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Material _mainPageButton(Function() onTap, String text) {
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
