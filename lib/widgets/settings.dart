import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'state_indicator.dart';
import 'package:flutter/material.dart';
import 'package:yandex_music/yandex_music.dart';
import '../services/database/database_engine.dart';
import 'package:quark/services/database/database.dart';
import 'package:quark/services/database/listen_logger.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:quark/services/native_controls/native_control.dart';

class Settings extends StatefulWidget {
  final Function() closeView;
  const Settings({required this.closeView});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int taps = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: min(size.width * 0.92, 800),
        height: min(size.height * 0.92, 510),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(0, 255, 255, 255),
        ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25),
                    Center(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          taps += 1;
                        }),
                        behavior: HitTestBehavior.opaque,
                        child: Text(
                          'Preferences',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    if (taps >= 5) ...[
                      const SizedBox(height: 15),

                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 35),
                        child: Text(
                          'Debug',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _DebugSettings(),
                    ],

                    Padding(
                      padding: EdgeInsetsGeometry.only(left: 35),
                      child: Text(
                        'Main',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _LocalSettings(),

                    const SizedBox(height: 15),

                    Padding(
                      padding: EdgeInsetsGeometry.only(left: 35),
                      child: Text(
                        'Yandex Music',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _YandexMusicSettings(),
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

class _LocalSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __LocalSettingsWidget();
}

class __LocalSettingsWidget extends State<_LocalSettings> {
  bool stateIndicatorState = true;
  bool playlistOpeningArea = true;
  bool recursiveFilesAdding = true;
  int clicks = 0;
  String restoreText = 'Restore';
  bool? databaseError;
  InteractiveSliderController transitionSpeedController =
      InteractiveSliderController(1.0);

  void initDatabase() async {
    try {
      bool indicator = DatabaseStreamerService().stateIndicator.value;
      double transitionSpeed = DatabaseStreamerService().transitionSpeed.value;
      bool playlistArea = DatabaseStreamerService().playlistOpeningArea.value;
      bool recursiveFilesAdding2 =
          DatabaseStreamerService().recursiveFilesAdding.value;
      if (!mounted) return;
      setState(() {
        stateIndicatorState = indicator;
        playlistOpeningArea = playlistArea;
        recursiveFilesAdding = recursiveFilesAdding2;
        transitionSpeedController.value = transitionSpeed;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        databaseError = true;
      });
    }
  }

  void restoreDefaults() async {
    await DatabaseStreamerService().reload();
  }

  void setIndicator(bool value) async {
    DatabaseStreamerService().stateIndicator.value = value;
  }

  void setPlaylistArea(bool value) async {
    DatabaseStreamerService().playlistOpeningArea.value = value;
  }

  void setRecursive(bool value) async {
    DatabaseStreamerService().recursiveFilesAdding.value = value;
  }

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = min(size.width * 0.92 * 0.92, 800 * 0.92);
    final rightPadding = 7.5;
    return Center(
      child: Column(
        children: [
          if (databaseError == true || Database.lastError != null)
            button(
              'WARNING',
              'The database is unavailable or contains errors. Changes may not be saved. Check the logs.',
              SizedBox.shrink(),
              maxWidth,
              rightPadding,
              ButtonPosition.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              nameColor: Colors.red,
            ),
          SizedBox(height: 1),
          button(
            'Recursively adding files',
            'The player will check not only the top folder, but also all subfolders to add local tracks.',
            Switch(
              value: recursiveFilesAdding,
              activeTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              onChanged: (a) {
                setState(() {
                  recursiveFilesAdding = a;
                });
                setRecursive(a);
              },
            ),
            maxWidth,
            rightPadding,
            databaseError == true
                ? ButtonPosition.center
                : ButtonPosition.start,
          ),

          SizedBox(height: 1),
          button(
            'Playlist opening area',
            'When you hover to the left side of the screen, the playlistView will automatically open.',
            Switch(
              value: playlistOpeningArea,
              activeTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              onChanged: (a) {
                setState(() {
                  playlistOpeningArea = a;
                });
                setPlaylistArea(a);
              },
            ),
            maxWidth,
            rightPadding,
            ButtonPosition.center,
          ),
          SizedBox(height: 1),

          button(
            'State indicator',
            'Turn on/off the status indicator that notifies you when network operations are being performed.',
            Switch(
              value: stateIndicatorState,
              activeTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              onChanged: (a) {
                setState(() {
                  stateIndicatorState = a;
                });
                setIndicator(a);
              },
            ),

            maxWidth,
            rightPadding,
            ButtonPosition.end,
          ),
          SizedBox(height: 1),
          button(
            'Transition speed',
            'Change the speed of most animations in the application.',
            SizedBox(
              width: 150,
              child: InteractiveSlider(
                padding: EdgeInsets.all(0),
                controller: transitionSpeedController,
                unfocusedHeight: 5,
                focusedHeight: 10,
                min: 0.0,
                max: 2.5,
                onProgressUpdated: (value) async {
                  DatabaseStreamerService().transitionSpeed.value = value;
                },
                onFocused: (value) {},

                brightness: Brightness.light,
                initialProgress: 1.0,
                iconColor: Colors.white,
                gradient: LinearGradient(colors: [Colors.white, Colors.white]),
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
            maxWidth,
            rightPadding,
            ButtonPosition.center,
          ),
          SizedBox(height: 1),
          button(
            'Restore defaults',
            'Reset player settings to factory defaults. After resetting, it is recommended to restart the player.',
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (clicks < 2) {
                    setState(() {
                      restoreText = 'Again';
                      clicks += 1;
                    });
                  } else {
                    restoreDefaults();
                    setState(() {
                      restoreText = 'Restore';
                      clicks = 0;
                    });
                  }
                },
                child: Container(
                  height: 30,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      restoreText,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            maxWidth,
            rightPadding,
            ButtonPosition.end,
          ),
        ],
      ),
    );
  }
}

class _YandexMusicSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __YandexMusicSettingsWidget();
}

class __YandexMusicSettingsWidget extends State<_YandexMusicSettings> {
  bool search = true;
  bool yandexMusicPreload = true;
  String quality = 'MP3 (320kbps)';
  List<String> qualityList = [
    'Lossless (Max)',
    'Normal (256kbps)',
    'Low (64kbps)',
  ];
  Map<String, String> qualityMap = {
    'lossless': 'Lossless (Max)',
    'nq': 'Normal (256kbps)',
    'lq': 'Low (64kbps)',
  };
  Timer? searchDebounceTimer;
  StateIndicatorOperation operation = StateIndicatorOperation.none;
  TextEditingController controller = TextEditingController(text: '');
  final Duration _searchDebounceDuration = const Duration(milliseconds: 500);
  final db = DatabaseStreamerService();

  void yandexMusicChecker(String value) async {
    searchDebounceTimer?.cancel();
    searchDebounceTimer = Timer(_searchDebounceDuration, () async {
      if (value.isEmpty) {
        return;
      }
      try {
        if (!mounted) return;
        setState(() {
          operation = StateIndicatorOperation.loading;
        });
        YandexMusic yandexMusic = YandexMusic(token: value);
        await yandexMusic.init();
        String email = await yandexMusic.account.getEmail();
        String displayName = await yandexMusic.account.getDisplayName();
        String fullName = await yandexMusic.account.getFullName();
        String login = await yandexMusic.account.getLogin();

        db.yandexMusicToken.value = value;
        db.yandexMusicLogin.value = login;
        db.yandexMusicFullName.value = fullName;
        db.yandexMusicDisplayName.value = displayName;
        db.yandexMusicUid.value = yandexMusic.accountID;
        db.yandexMusicEmail.value = email;

        if (!mounted) return;
        setState(() {
          operation = StateIndicatorOperation.success;
        });
      } on YandexMusicException {
        if (!mounted) return;
        setState(() {
          operation = StateIndicatorOperation.error;
        });
      }
    });
  }

  void setQuality(String value) async {
    final Map<String, String> qualityReverse = {
      for (var entry in qualityMap.entries) entry.value: entry.key,
    };
    String? quality2 = qualityReverse[value];
    db.yandexMusicQuality.value = quality2!;
    if (!mounted) return;
    setState(() {
      quality = value;
    });
  }

  void setSearch(bool value) async {
    db.yandexMusicSearch.value = value;
  }

  void setPreload(bool value) async {
    db.yandexMusicPreload.value = value;
  }

  void initDatabase() {
    setState(() {
      controller.text = db.yandexMusicToken.value;
      quality = qualityMap[db.yandexMusicQuality.value] ?? quality;
      search = db.yandexMusicSearch.value;
      yandexMusicPreload = db.yandexMusicPreload.value;
    });
    yandexMusicChecker(db.yandexMusicToken.value);
  }

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = min(size.width * 0.92 * 0.92, 800 * 0.92);
    final textFieldWidth = min(size.width * 0.3, 250.0);
    final rightPadding = 7.5;
    return Center(
      child: Column(
        children: [
          button(
            'Search',
            'Add tracks found in Yandex Music to the track search in the playlist',
            Switch(
              value: search,
              activeTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              // activeThumbColor: Colors.white,
              onChanged: (a) {
                setState(() {
                  search = a;
                });
                setSearch(a);
              },
            ),
            maxWidth,
            rightPadding,
            ButtonPosition.start,
          ),
          SizedBox(height: 1),

          button(
            'Yandex Music Preload',
            "When the player starts, Yandex Music will initialize during the player's loading to speed up the process of interacting.",
            Switch(
              value: yandexMusicPreload,
              activeTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: const Color.fromRGBO(77, 77, 77, 0.3),
              // activeThumbColor: const Color.fromARGB(255, 255, 255, 255),
              onChanged: (a) {
                setState(() {
                  yandexMusicPreload = a;
                });
                setPreload(a);
              },
            ),
            maxWidth,
            rightPadding,
            ButtonPosition.center,
          ),
          SizedBox(height: 1),
          button(
            'Quality',
            "Quality of downloaded tracks.",
            DropdownButton<String>(
              dropdownColor: const Color.fromRGBO(44, 44, 44, 0.2),
              value: qualityList.contains(quality) ? quality : 'Normal (256kbps)',
              borderRadius: BorderRadius.all(Radius.circular(5)),
              elevation: 16,
              focusColor: const Color.fromARGB(113, 255, 255, 255),
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              underline: SizedBox.shrink(),
              onChanged: (String? value) {
                if (value != null) {
                  setQuality(value);
                }
              },
              items: qualityList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            maxWidth,
            rightPadding,
            ButtonPosition.center,
          ),

          SizedBox(height: 1),
          button(
            'Token',
            "Your Yandex account token.",
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StateIndicator(operation: operation),
                const SizedBox(width: 10),
                Padding(
                  padding: EdgeInsets.only(right: rightPadding),
                  child: Row(
                    children: [
                      SizedBox(
                        width: textFieldWidth,
                        height: 40,

                        child: TextField(
                          onChanged: (value) => yandexMusicChecker(value),
                          style: TextStyle(
                            color: Colors.white.withAlpha(220),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Enter token here',
                            hintStyle: TextStyle(
                              color: Colors.white.withAlpha(178),
                              overflow: TextOverflow.ellipsis,

                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.white.withAlpha(155),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.white.withAlpha(155),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.white.withAlpha(155),
                                width: 1.5,
                              ),
                            ),
                            filled: false,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            maxWidth,
            rightPadding,
            ButtonPosition.end,
          ),
        ],
      ),
    );
  }
}

class _DebugSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __DebugSettingsWidget();
}

class __DebugSettingsWidget extends State<_DebugSettings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = min(size.width * 0.92 * 0.92, 800 * 0.92);
    final rightPadding = 7.5;
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (builder) => GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: maxWidth,
                      height: maxWidth,
                      child: Center(
                        child: Text(
                          Database.lastError.toString(),
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: button(
              'Database',
              'Inited: ${Database.isInited} || LastError: ${Database.lastError}',
              SizedBox.shrink(),
              maxWidth,
              rightPadding,
              ButtonPosition.start,
            ),
          ),
          // SizedBox(height: 1),
          // button(
          //   'ListenLogger',
          //   'Inited: ${ListenLogger().inited} || Init tries: ${NativeControl().initTries} || LastError: ${ListenLogger().lastError}',
          //   SizedBox.shrink(),
          //   maxWidth,
          //   rightPadding,
          //   ButtonPosition.center,
          // ),
          SizedBox(height: 1),
          InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (builder) => GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: maxWidth,
                      height: maxWidth,
                      child: Center(
                        child: Text(
                          NativeControl().lastError.toString(),
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: button(
              'NativeControl',
              'Inited: ${NativeControl().inited} || Init tries: ${NativeControl().initTries} || LastError: ${NativeControl().lastError}',
              SizedBox.shrink(),
              maxWidth,
              rightPadding,
              ButtonPosition.end,
            ),
          ),
        ],
      ),
    );
  }
}

enum ButtonPosition { start, center, end }

Container button(
  String name,
  String description,
  Widget widget,
  double width,
  double rightPadding,
  ButtonPosition buttonPosition, {
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  Color nameColor = Colors.white,
}) {
  return Container(
    width: width,
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(
          buttonPosition == ButtonPosition.start ? 10 : 0,
        ),
        topRight: Radius.circular(
          buttonPosition == ButtonPosition.start ? 10 : 0,
        ),
        bottomLeft: Radius.circular(
          buttonPosition == ButtonPosition.end ? 10 : 0,
        ),
        bottomRight: Radius.circular(
          buttonPosition == ButtonPosition.end ? 10 : 0,
        ),
      ),
      color: Color.fromRGBO(44, 44, 44, 0.2),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: nameColor,
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  color: const Color.fromARGB(125, 255, 255, 255),
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.only(right: rightPadding),
          child: Row(children: [widget, SizedBox(width: 5)]),
        ),
      ],
    ),
  );
}
