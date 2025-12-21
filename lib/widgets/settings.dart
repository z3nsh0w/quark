import 'dart:math';
import 'dart:async';
import 'state_indicator.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';
import 'package:yandex_music/yandex_music.dart';

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
        height: min(size.height * 0.92, 660),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color.fromARGB(30, 255, 255, 255),
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

  void initDatabase() async {
    bool? indicator = await Database.getValue(
      DatabaseKeys.stateIndicatorState.value,
    );
    bool? gradient = await Database.getValue(DatabaseKeys.gradientMode.value);
    bool? windowManager = await Database.getValue(
      DatabaseKeys.windowManager.value,
    );
    setState(() {
      stateIndicatorState = indicator ?? stateIndicatorState;
      gradientAsBackground = gradient ?? gradientAsBackground;
      windowManagerPlugin = windowManager ?? windowManagerPlugin;
    });
  }

  void setSetting(DatabaseKeys setting, dynamic value) async {}

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
          Container(
            width: maxWidth,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Color.fromRGBO(44, 44, 44, 1),
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
                        'Clear Database',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Reset player settings to factory defaults. Recommended if you are experiencing any problems.',
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
                  child: Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                'Drop',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 255, 0, 0),
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1),

          Container(
            width: maxWidth,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(),
              color: Color.fromRGBO(44, 44, 44, 1),
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
                        'State indicator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Turn on/off the status indicator that notifies you when network operations are being performed.',
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
                  child: Row(
                    children: [
                      Switch(
                        value: stateIndicatorState,
                        activeTrackColor: Color.fromRGBO(77, 77, 77, 1),
                        inactiveThumbColor: Colors.grey[300],
                        inactiveTrackColor: const Color.fromARGB(
                          255,
                          34,
                          34,
                          34,
                        ),
                        activeThumbColor: Colors.white,
                        onChanged: (a) {
                          setState(() {
                            stateIndicatorState = a;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1),

          Container(
            width: maxWidth,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(),
              color: Color.fromRGBO(44, 44, 44, 1),
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
                        'Local Playlists mode (Beta)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'You can display all your local folders with tracks as playlists, with the same appearance as in Yandex Music.',
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
                  child: Row(
                    children: [
                      Switch(
                        value: stateIndicatorState,
                        activeTrackColor: Color.fromRGBO(77, 77, 77, 1),
                        inactiveThumbColor: Colors.grey[300],
                        inactiveTrackColor: const Color.fromARGB(
                          255,
                          34,
                          34,
                          34,
                        ),
                        activeThumbColor: Colors.white,
                        onChanged: (a) {
                          setState(() {
                            stateIndicatorState = a;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1),

          Container(
            width: maxWidth,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(),
              color: Color.fromRGBO(44, 44, 44, 1),
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
                        'Gradient as background',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Instead of a blurred cover, you will see a gradient in the background, based on the accent colors of the cover..',
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
                  child: Row(
                    children: [
                      Switch(
                        value: gradientAsBackground,
                        activeTrackColor: Color.fromRGBO(77, 77, 77, 1),
                        inactiveThumbColor: Colors.grey[300],
                        inactiveTrackColor: const Color.fromARGB(
                          255,
                          34,
                          34,
                          34,
                        ),
                        activeThumbColor: Colors.white,
                        onChanged: (a) {
                          setState(() {
                            gradientAsBackground = a;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1),

          Container(
            width: maxWidth,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Color.fromRGBO(44, 44, 44, 1),
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
                        'Window_manager plugin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Removes the window frame and enables dragging the player across its area. Turn it off if you encounter any problems.',
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
                  child: Row(
                    children: [
                      Switch(
                        value: windowManagerPlugin,
                        activeTrackColor: Color.fromRGBO(77, 77, 77, 1),
                        inactiveThumbColor: Colors.grey[300],
                        inactiveTrackColor: const Color.fromARGB(
                          255,
                          34,
                          34,
                          34,
                        ),
                        activeThumbColor: Colors.white,
                        onChanged: (a) {
                          setState(() {
                            windowManagerPlugin = a;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
  bool search = false;
  bool yandexMusicPreload = false;
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
        await Database.setValue(DatabaseKeys.yandexMusicToken.value, value);
        await Database.setValue(DatabaseKeys.yandexMusicToken.value, value);
        await Database.setValue(
          DatabaseKeys.yandexMusicUid.value,
          yandexMusic.accountID,
        );
        await Database.setValue(DatabaseKeys.yandexMusicEmail.value, email);
        await Database.setValue(
          DatabaseKeys.yandexMusicDisplayName.value,
          displayName,
        );
        await Database.setValue(
          DatabaseKeys.yandexMusicFullName.value,
          fullName,
        );
        await Database.setValue(DatabaseKeys.yandexMusicLogin.value, login);
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

  void initDatabase() async {
    final token = await Database.getValue(DatabaseKeys.yandexMusicToken.value);
    setState(() {
      controller.text = token ?? '';
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
    final textFieldWidth = 250.0;
    final rightPadding = 7.5;
    return Center(
      child: Column(
        children: [
          button(
            'Export library',
            'Export the entire Yandex Music library to a folder',
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: 30,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Export',
                      style: TextStyle(
                        color: const Color.fromARGB(125, 255, 255, 255),
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
            ButtonPosition.start,
          ),

          SizedBox(height: 1),
          button(
            'Search',
            'Add tracks found in Yandex Music to the track search in the playlist',
            Switch(
              value: search,
              activeTrackColor: Color.fromRGBO(77, 77, 77, 1),
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: const Color.fromARGB(255, 34, 34, 34),
              activeThumbColor: Colors.white,
              onChanged: (a) {
                setState(() {
                  search = a;
                });
              },
            ),
            maxWidth,
            rightPadding,
            ButtonPosition.center,
          ),
          SizedBox(height: 1),

          button(
            'Yandex Music Preload',
            "When the player starts, Yandex Music will initialize during the player's loading to speed up the process of interacting.",
            Switch(
              value: yandexMusicPreload,
              activeTrackColor: Color.fromRGBO(77, 77, 77, 1),
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: const Color.fromARGB(255, 34, 34, 34),
              activeThumbColor: Colors.white,
              onChanged: (a) {
                setState(() {
                  yandexMusicPreload = a;
                });
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
              dropdownColor: const Color.fromRGBO(44, 44, 44, 1),
              value: 'MP3 (320kbps)',
              borderRadius: BorderRadius.all(Radius.circular(5)),
              elevation: 16,
              focusColor: const Color.fromARGB(113, 255, 255, 255),
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              underline: SizedBox.shrink(),
              onChanged: (String? value) {},
              items:
                  [
                    'Lossless (Max)',
                    'Normal (256kbps)',
                    'Low (64kbps)',
                    'MP3 (320kbps)',
                  ].map<DropdownMenuItem<String>>((String value) {
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
                              color: Colors.white.withOpacity(0.7),
                              overflow: TextOverflow.ellipsis,

                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.3),
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
  ButtonPosition buttonPosition,
) {
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
      color: Color.fromRGBO(44, 44, 44, 1),
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
