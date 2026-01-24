import 'dart:math';
import 'dart:ui';
import 'dart:async';
import 'state_indicator.dart';
import '../services/database_engine.dart';
import 'package:flutter/material.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:interactive_slider/interactive_slider.dart';

class Settings extends StatefulWidget {
  final Function() closeView;
  const Settings({required this.closeView});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
                      child: Text(
                        'Preferences',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

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
  bool gradientAsBackground = false;
  bool windowManagerPlugin = false;
  bool playlistOpeningArea = true;
  bool recursiveFilesAdding = true;
  int clicks = 0;
  String restoreText = 'Restore';
  bool? databaseError;
  InteractiveSliderController transitionSpeedController =
      InteractiveSliderController(1.0);

  void initDatabase() async {
    try {
      bool indicator = await Database.get(
        DatabaseKeys.stateIndicatorState.value,
        defaultValue: true,
      );
      bool gradient = await Database.get(
        DatabaseKeys.gradientMode.value,
        defaultValue: false,
      );
      bool windowManager = await Database.get(
        DatabaseKeys.windowManager.value,
        defaultValue: false,
      );
      double transitionSpeed = await Database.get(
        DatabaseKeys.transitionSpeed.value,
        defaultValue: 1.0,
      );
      bool playlistArea = await Database.get(
        DatabaseKeys.playlistOpeningArea.value,
        defaultValue: true,
      );
      bool recursiveFilesAdding2 = await Database.get(
        DatabaseKeys.recursiveFilesAdding.value,
        defaultValue: true,
      );
      setState(() {
        stateIndicatorState = indicator;
        gradientAsBackground = gradient;
        windowManagerPlugin = windowManager;
        playlistOpeningArea = playlistArea;
        recursiveFilesAdding = recursiveFilesAdding2;
        transitionSpeedController.value = transitionSpeed;
      });
    } catch (e) {
      print(e);
      setState(() {
        databaseError = true;
      });
    }
  }

  void restoreDefaults() async {
    await Database.clear();
  }

  void setIndicator(bool value) async {
    await Database.put(DatabaseKeys.stateIndicatorState.value, value);
  }

  void setPlaylistArea(bool value) async {
    await Database.put(DatabaseKeys.playlistOpeningArea.value, value);
  }

  void setRecursive(bool value) async {
    await Database.put(DatabaseKeys.recursiveFilesAdding.value, value);
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
          if (databaseError == true)
            button(
              'WARNING',
              'The database is unavailable. All changes will not be saved.',
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
                  await Database.put(
                    DatabaseKeys.transitionSpeed.value,
                    value,
                  );
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
    'MP3 (320kbps)',
  ];
  Map<String, String> qualityMap = {
    'lossless': 'Lossless (Max)',
    'nq': 'Normal (256kbps)',
    'lq': 'Low (64kbps)',
    'mp3': 'MP3 (320kbps)',
  };
  Timer? searchDebounceTimer;
  StateIndicatorOperation operation = StateIndicatorOperation.none;
  TextEditingController controller = TextEditingController(text: '');
  final Duration _searchDebounceDuration = const Duration(milliseconds: 500);

  void yandexMusicChecker(String value) async {
    searchDebounceTimer?.cancel();
    searchDebounceTimer = Timer(_searchDebounceDuration, () async {
      if (value.isEmpty) {
        return;
      }
      try {
        setState(() {
          operation = StateIndicatorOperation.loading;
        });
        YandexMusic yandexMusic = YandexMusic(token: value);
        await yandexMusic.init();
        String email = await yandexMusic.account.getEmail();
        String displayName = await yandexMusic.account.getDisplayName();
        String fullName = await yandexMusic.account.getFullName();
        String login = await yandexMusic.account.getLogin();

        await Database.putAll({
          DatabaseKeys.yandexMusicToken.value: value,
          DatabaseKeys.yandexMusicLogin.value: login,
          DatabaseKeys.yandexMusicFullName.value: fullName,
          DatabaseKeys.yandexMusicDisplayName.value: displayName,
          DatabaseKeys.yandexMusicUid.value: yandexMusic.accountID,
          DatabaseKeys.yandexMusicEmail.value: email,
        });
        setState(() {
          operation = StateIndicatorOperation.success;
        });
      } on YandexMusicException {
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
    await Database.put(
      DatabaseKeys.yandexMusicTrackQuality.value,
      quality2!,
    );
    setState(() {
      quality = value;
    });
  }

  void setSearch(bool value) async {
    await Database.put(DatabaseKeys.yandexMusicSearch.value, value);
  }

  void setPreload(bool value) async {
    await Database.put(DatabaseKeys.yandexMusicPreload.value, value);
  }

  void initDatabase() async {
    final token = await Database.get(DatabaseKeys.yandexMusicToken.value);
    final qualityl = await Database.get(
      DatabaseKeys.yandexMusicTrackQuality.value,
    );
    final search2 = await Database.get(
      DatabaseKeys.yandexMusicSearch.value,
    );
    final preload = await Database.get(
      DatabaseKeys.yandexMusicPreload.value,
    );
    setState(() {
      controller.text = token ?? '';
      quality = qualityl != null ? qualityMap[qualityl]! : quality;
      search = search2 ?? search;
      yandexMusicPreload = preload ?? yandexMusicPreload;
    });
    yandexMusicChecker(token ?? '');
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
              value: quality,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
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
