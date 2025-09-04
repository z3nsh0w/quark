// Dart
import 'dart:ui';
import 'dart:io';
import 'dart:math' as math;
// Flutter
import 'package:flutter/material.dart';
// Libraries
import 'package:logging/logging.dart';
import 'package:file_picker/file_picker.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// Local modules
import 'package:quark/src/pages/playlist_page.dart';
import 'package:quark/src/pages/yandex_music_playlist_page.dart';
import 'package:quark/src/services/database.dart';
import 'package:quark/src/yandex_music_modified/yandex_music_interface.dart';
import 'package:quark/src/widgets/box_decorations.dart';
// Temp folder at this app is a Local/quark/quarkaudio or .local/quark/quarkaudio for linux

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database.init();
  // await SMTCWindows.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'quark',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool reloginNeed = false;
  String lastSong = '';
  String? selectedFolderPath;

  List userPlaylists = [];
  List<String> files = [];
  List<String> selectedFiles = [];
  Map<String, dynamic> playlistInfo = {};

  late File logFile;
  late YandexMusic yandexMusic;
  late YandexMusicInterface musicInterface;
  final logger = Logger('mainlogger');
  final TextEditingController _tokenController = TextEditingController();

  void navigateToPlaylist() {
    if (selectedFiles.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  PlaylistPage(songs: selectedFiles, lastSong: lastSong),
        ),
      );
    }
  }

  void navigateToYMPlaylistPage(List<String> songs, List ymTrackInfo) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => YmPlaylistPage(
              songs: songs,
              ymTracksInfo: ymTrackInfo,
              yandexMusicInstance: yandexMusic,
              musicInterface: musicInterface,
              playlistInfo: playlistInfo,
            ),
      ),
    );
  }

  Future<void> pickFolder() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        setState(() {
          selectedFolderPath = selectedDirectory;
          files = [];
          selectedFiles = [];
        });
        await getFilesFromDirectory(selectedDirectory);
        navigateToPlaylist();
      }
    } catch (e) {
      logger.severe('An error occurred while retrieving the file folder: $e');
    }
  }

  Future<void> getFilesFromDirectory(String directoryPath) async {
    try {
      final dir = Directory(directoryPath);
      final List<String> fileNames = [];

      await for (final entity in dir.list()) {
        if (entity is File) {
          if (entity.path.toLowerCase().endsWith('.mp3') ||
              entity.path.toLowerCase().endsWith('.wav') ||
              entity.path.toLowerCase().endsWith('.flac') ||
              entity.path.toLowerCase().endsWith('.aac') ||
              entity.path.toLowerCase().endsWith('.alac') ||
              entity.path.toLowerCase().endsWith('.pcm') ||
              entity.path.toLowerCase().endsWith('.m4a')) {
            fileNames.add(entity.path);
          }
        }
        print(entity);
      }

      setState(() {
        files = fileNames.map((path) => path.split('/').last).toList();
        selectedFiles = fileNames;
      });
    } catch (e) {
      logger.severe(
        'An error occurred while retrieving the selected multiple file: $e',
      );
    }
  }

  Future<void> restorePlaylist() async {
    try {
      final dynamic lastPlaylist = await Database.getValue('lastPlaylist');
      final dynamic lastSong2 = await Database.getValue('lastPlaylistTrack');

      if (lastPlaylist != null && lastPlaylist is List<dynamic>) {
        setState(() {
          selectedFiles = List<String>.from(lastPlaylist);
          restorePlaylistButtonText = 'Restore playlist';
        });

        if (lastSong2 != null) {
          setState(() {
            lastSong = lastSong2;
          });
        }

        navigateToPlaylist();
      } else {
        setState(() {
          restorePlaylistButtonText =
              'Ooops... Your previous playlist is empty.';
        });
      }
    } catch (e) {
      setState(() {
        restorePlaylistButtonText = 'Ooops... Your previous playlist is empty.';
      });
      logger.severe('Error: $e');
    }
  }

  Future<void> loadYMPlaylist(List tracks) async {
    logger.info('Loading Yandex Music playlist: $tracks');
    List<String> fileMap = [];
    getApplicationCacheDirectory().then((direc) {
      logger.info('Cache directory: $direc');
    });
    getApplicationCacheDirectory().then((directory) {
      String tempDir = directory.path;
      for (var track in tracks) {
        fileMap.add('${tempDir}/quarkaudiotemptrack${track['id']}.mp3');
      }
    });

    hideYMInterface().then((_) {
      navigateToYMPlaylistPage(fileMap, tracks);
    });
  }

  void showYMInterface() async {
    Future.delayed(Duration(seconds: 1), () async {
      await musicInterface
          .downloadFirstTracksFromAllUsersPlaylistsIntoTempFolder();
    });

    getYMInterfaceOverlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            child: SlideTransition(
              position: getYMInterfaceOffsetAnimation,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity!.abs() > 500) {
                        if (details.primaryVelocity! < -500 ||
                            details.primaryVelocity! > 500) {
                          hideYMInterface();
                        }
                      }
                    },

                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                        child: Container(
                          width: math.min(
                            MediaQuery.of(context).size.width * 0.92,
                            1040,
                          ),
                          height: math.min(
                            MediaQuery.of(context).size.height * 0.92,
                            1036,
                          ),
                          decoration: overlayBoxDecoration(),
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(36.0),
                            child: Wrap(
                              spacing: 16.0,
                              runSpacing: 16.0,
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              children: List.generate(userPlaylists.length, (
                                index,
                              ) {
                                return InkWell(
                                  onHover: (value) {},
                                  onTap: () async {
                                    List trackList = [];
                                    if (index != 0) {
                                      trackList = await musicInterface
                                          .getPlaylist(
                                            userPlaylists[index]['kind'],
                                          );
                                      playlistInfo = {
                                        'liked': false,
                                        'kind': userPlaylists[index]['kind'],
                                        'owner': userPlaylists[index]['owner'],
                                      };
                                    } else {
                                      trackList =
                                          await musicInterface.getLikedSongs();
                                      playlistInfo = {
                                        'liked': true,
                                        'kind': null,
                                        'owner': null,
                                      };
                                    }

                                    hideYMInterface();
                                    loadYMPlaylist(trackList);
                                  },
                                  child: Container(
                                    width: 310,
                                    height: 310,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          userPlaylists[index]['picture'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
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
                                                bottomRight: Radius.circular(
                                                  15,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              userPlaylists[index]['title'],
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
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(getYMInterfaceOverlayEntry!);
    getYMInterfaceAnimationController.forward();
  }

  Future<void> hideYMInterface() {
    return getYMInterfaceAnimationController.reverse().then((_) {
      getYMInterfaceOverlayEntry?.remove();
      getYMInterfaceOverlayEntry = null;
    });
  }

  void showYMLoginWebview() {
    if (Platform.isLinux) {
      getYMLoginOverlayEntry = OverlayEntry(
        builder:
            (context) => Positioned(
              child: SlideTransition(
                position: getYMTokenOffsetAnimation,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity!.abs() > 500) {
                          if (details.primaryVelocity! < -500 ||
                              details.primaryVelocity! > 500) {
                            hideYMLoginWebview();
                          }
                        }
                      },

                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                          child: Container(
                            width: 400,
                            height: 520,
                            decoration: overlayBoxDecoration(),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    Text(
                                      "Native connection of Yandex Music through a browser window is currently unavailable.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "So you can manually enter the Yandex Music access token.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),

                                    SizedBox(height: 70),

                                    TextField(
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(
                                              0.3,
                                            ),
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

                                    SizedBox(height: 15),

                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 175,
                                          sigmaY: 175,
                                        ),
                                        child: Container(
                                          height: 45,
                                          width: 250,
                                          decoration: overlayBoxDecoration(),
                                          child: InkWell(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            onTap: () async {
                                              logger.info(
                                                'Token input: ${_tokenController.value.text}',
                                              );
                                              try {
                                                String token =
                                                    _tokenController.value.text;
                                                if (token.length > 3) {
                                                  logger.info(
                                                    'Yandex Music API token: $token',
                                                  );
                                                  yandexMusic = YandexMusic(
                                                    token: token,
                                                  );
                                                  await yandexMusic.init();
                                                  musicInterface =
                                                      YandexMusicInterface(
                                                        yandexMusic,
                                                      );
                                                  int ymuid =
                                                      yandexMusic.accountID;
                                                  String defaultEmail =
                                                      await yandexMusic.account
                                                          .getEmail();

                                                  Database.setValue(
                                                    "ymtoken",
                                                    token,
                                                  );
                                                  Database.setValue(
                                                    "ymuid",
                                                    ymuid.toString(),
                                                  );
                                                  Database.setValue(
                                                    "ymemail",
                                                    defaultEmail.toString(),
                                                  );

                                                  var playlists =
                                                      await musicInterface
                                                          .getUsersPlaylists();
                                                  userPlaylists = playlists;
                                                  getYMTokenAnimationController
                                                      .reverse();
                                                  showYMInterface();
                                                }
                                              } catch (ex) {}
                                            },
                                            child: Center(
                                              child: Text(
                                                'Submit',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 75),
                                    Text(
                                      "Read about how to obtain a token on our GitHub.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
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
                  ),
                ),
              ),
            ),
      );
    } else {
      getYMLoginOverlayEntry = OverlayEntry(
        builder:
            (context) => Positioned(
              child: SlideTransition(
                position: getYMTokenOffsetAnimation,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity!.abs() > 500) {
                          if (details.primaryVelocity! < -500 ||
                              details.primaryVelocity! > 500) {
                            hideYMLoginWebview();
                          }
                        }
                      },

                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                          child: Container(
                            width: 400,
                            height: 650,
                            decoration: overlayBoxDecoration(),
                            child: Column(
                              children: [
                                Expanded(
                                  child: InAppWebView(
                                    initialUrlRequest: URLRequest(
                                      url: WebUri(
                                        'https://oauth.yandex.ru/authorize?response_type=token&client_id=23cabbbdc6cd418abb4b39c32c41195d',
                                      ),
                                    ),
                                    initialSettings: InAppWebViewSettings(
                                      javaScriptEnabled: true,
                                    ),
                                    onWebViewCreated: (controller) {
                                      webViewController = controller;
                                    },
                                    onLoadStop: (controller, url) async {
                                      if (url.toString().contains(
                                        'access_token',
                                      )) {
                                        try {
                                          String token = url
                                              .toString()
                                              .split('#')[1]
                                              .split('&')[0]
                                              .replaceAll('access_token=', '');
                                          if (token.length > 3) {
                                            logger.info(
                                              'Yandex Music API token: $token',
                                            );
                                            yandexMusic = YandexMusic(
                                              token: token,
                                            );
                                            await yandexMusic.init();
                                            musicInterface =
                                                YandexMusicInterface(
                                                  yandexMusic,
                                                );
                                            int ymuid = yandexMusic.accountID;
                                            String defaultEmail =
                                                await yandexMusic.account
                                                    .getEmail();

                                            Database.setValue("ymtoken", token);
                                            Database.setValue(
                                              "ymuid",
                                              ymuid.toString(),
                                            );
                                            Database.setValue(
                                              "ymemail",
                                              defaultEmail.toString(),
                                            );

                                            var playlists =
                                                await musicInterface
                                                    .getUsersPlaylists();
                                            userPlaylists = playlists;
                                            getYMTokenAnimationController
                                                .reverse();
                                            showYMInterface();
                                          }
                                        } catch (ex) {}
                                      }
                                    },
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
              ),
            ),
      );
    }

    Overlay.of(context).insert(getYMLoginOverlayEntry!);
    getYMTokenAnimationController.forward();
  }

  void hideYMLoginWebview() {
    getYMTokenAnimationController.reverse().then((_) {
      getYMLoginOverlayEntry?.remove();
      getYMLoginOverlayEntry = null;
    });
  }

  Future<void> initLogger() async {
    final dir = await getApplicationCacheDirectory();
    logFile = File('${dir.path}/main_page.log');
    if (await logFile.exists()) {
      await logFile.delete();
    }
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      final logLine =
          '${DateTime.now()} - ${record.level.name}: ${record.message}';
      logFile.writeAsStringSync('$logLine\n', mode: FileMode.append);
    });
  }

  @override
  void initState() {
    super.initState();
    getYMTokenAnimationController = AnimationController(
      duration: Duration(milliseconds: (650).round()),
      vsync: this,
    );

    getYMTokenOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: getYMTokenAnimationController,
        curve: Curves.ease,
      ),
    );
    getYMInterfaceAnimationController = AnimationController(
      duration: Duration(milliseconds: (650).round()),
      vsync: this,
    );

    getYMInterfaceOffsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: getYMInterfaceAnimationController,
        curve: Curves.ease,
      ),
    );

    Future.delayed(Duration(seconds: 1), () async {
      var token = await Database.getValue('ymtoken');
      yandexMusic = YandexMusic(token: token);
      yandexMusic.init();
      musicInterface = YandexMusicInterface(yandexMusic);
    });

    
  }

  String restorePlaylistButtonText = 'Restore playlist';
  InAppWebViewController? webViewController;

  late AnimationController getYMTokenAnimationController;
  late Animation<Offset> getYMTokenOffsetAnimation;
  OverlayEntry? getYMLoginOverlayEntry;

  late AnimationController getYMInterfaceAnimationController;
  late Animation<Offset> getYMInterfaceOffsetAnimation;
  OverlayEntry? getYMInterfaceOverlayEntry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          // MAIN CONTAINER THAT CONTAINS MAIN PAGE
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(24, 24, 26, 1),
                Color.fromRGBO(18, 18, 20, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: Color.fromRGBO(40, 40, 40, 1),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 95.0, sigmaY: 95.0),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/play.png', width: 150, height: 150),
                    SizedBox(height: 25),
                    SizedBox(
                      width: 400,
                      child: Text(
                        'quark',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 400,
                      child: Text(
                        'Select a file or folder, or drag files from the file manager into the application window to add songs to the playlist.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 30),

                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 175, sigmaY: 175),
                        child: Container(
                          height: 45,
                          width: 350,
                          decoration: overlayBoxDecoration(),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              onTap: restorePlaylist,
                              child: Center(
                                child: Text(
                                  restorePlaylistButtonText,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 175, sigmaY: 175),
                        child: Container(
                          height: 45,
                          width: 350,
                          decoration: overlayBoxDecoration(),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              onTap: pickFolder,
                              child: Center(
                                child: Text(
                                  'Add folder',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 175, sigmaY: 175),
                        child: Container(
                          height: 45,
                          width: 350,
                          decoration: overlayBoxDecoration(),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: InkWell(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              onTap: () async {
                                if (yandexMusic.initalize) {
                                  musicInterface.getUsersPlaylists().then((
                                    playlists,
                                  ) {
                                    userPlaylists = playlists;
                                    showYMInterface();
                                  });
                                } else {


                                Database.getValue("ymuid").then((uid) async {
                                  Database.getValue("ymtoken").then((
                                    token,
                                  ) async {
                                    if (uid != null && token != null) {
                                      try {
                                        yandexMusic = YandexMusic(token: token);
                                        yandexMusic.init().then((a) {
                                          musicInterface = YandexMusicInterface(
                                            yandexMusic,
                                          );
                                          
                                          logger.info('Yandex music didnt initialized. Retrying...');

                                          musicInterface
                                              .getUsersPlaylists()
                                              .then((playlists) {
                                                userPlaylists = playlists;
                                                showYMInterface();
                                              });
                                        });

                                        // var playlists =
                                        //     await musicInterface
                                        //         .getUsersPlaylists();
                                      } catch (e) {
                                        showYMLoginWebview();
                                      }
                                    } else {
                                      showYMLoginWebview();
                                    }
                                  });
                                });
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Yandex Music',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
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
          ),
        ),
      ),
    );
  }
}
