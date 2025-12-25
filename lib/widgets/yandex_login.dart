import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import '../services/database.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_music/yandex_music.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class YandexLogin extends StatefulWidget {
  final Function() closeView;
  YandexLogin({required this.closeView});

  @override
  State<StatefulWidget> createState() => _YandexLoginState();
}

class _YandexLoginState extends State<YandexLogin> {
  final log = Logger('YandexLogin');

  Timer? searchDebounceTimer;
  TextEditingController controller = TextEditingController(text: '');
  final Duration _searchDebounceDuration = const Duration(milliseconds: 500);
  Color borderColor = Colors.white.withAlpha(78);

  final Uri loginUrl = Uri.parse(
    'https://oauth.yandex.ru/authorize?response_type=token&client_id=23cabbbdc6cd418abb4b39c32c41195d',
  );

  InAppWebViewController? webViewController;

  YandexMusic yandexMusic = YandexMusic(token: '');

  void yandexMusicChecker(String value) async {
    searchDebounceTimer?.cancel();
    searchDebounceTimer = Timer(_searchDebounceDuration, () async {
      if (value.isEmpty) {
        return;
      }
      try {
        setState(() {
          borderColor = Colors.orange;
        });
        YandexMusic yandexMusic = YandexMusic(token: value);
        await yandexMusic.init();
        setState(() {
          borderColor = Colors.greenAccent;
        });
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
        widget.closeView();
      } on YandexMusicException {
        setState(() {
          borderColor = Colors.red;
        });
      }
    });
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(loginUrl)) {
      throw Exception('Could not launch $loginUrl');
    }
  }

  @override
  void initState() {
    super.initState();
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '${record.level.name}: ${record.time.toIso8601String()}: ${record.message} ${record.error}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (Platform.isLinux) {
      return Center(
        child: Container(
          alignment: AlignmentDirectional.center,
          width: min(480, size.width - 50),
          height: min(320, size.height - 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Color.fromARGB(15, 255, 255, 255),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
              child: Container(
                width: min(size.width * 0.92, 1040),
                height: min(size.height * 0.92, 1036),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(2),
                  border: Border.all(
                    color: Colors.white.withAlpha(51),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withAlpha(25),
                      Colors.white.withAlpha(12),
                    ],
                  ),
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

                    Padding(
                      padding: EdgeInsets.only(right: 7.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 400,
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
                                    color: borderColor,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: borderColor,
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

                    const SizedBox(height: 20),
                    Text(
                      'Read about how to obtain a token on our website',
                      style: TextStyle(color: Colors.white.withAlpha(200)),
                    ),
                  ],
                ),
              ),
            ),
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
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
            child: Container(
              width: min(size.width * 0.92, 1040),
              height: min(size.height * 0.92, 1036),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                border: Border.all(color: Colors.white.withAlpha(51), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withAlpha(25),
                    Colors.white.withAlpha(12),
                  ],
                ),
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
                      initialSettings: InAppWebViewSettings(
                        javaScriptEnabled: true,
                      ),
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
                              } on YandexMusicException catch (e) {
                                log.severe(
                                  "Failed to initialize the YandexMusic package during webview authorization",
                                  e,
                                );
                              }

                              String email = await yandexMusic.account
                                  .getEmail();
                              String displayName = await yandexMusic.account
                                  .getDisplayName();
                              String fullName = await yandexMusic.account
                                  .getFullName();
                              String login = await yandexMusic.account
                                  .getLogin();

                              Database.setValue(
                                DatabaseKeys.yandexMusicToken.value,
                                token,
                              );
                              Database.setValue(
                                DatabaseKeys.yandexMusicUid.value,
                                yandexMusic.accountID,
                              );
                              Database.setValue(
                                DatabaseKeys.yandexMusicEmail.value,
                                email,
                              );
                              Database.setValue(
                                DatabaseKeys.yandexMusicDisplayName.value,
                                displayName,
                              );
                              Database.setValue(
                                DatabaseKeys.yandexMusicFullName.value,
                                fullName,
                              );
                              Database.setValue(
                                DatabaseKeys.yandexMusicLogin.value,
                                login,
                              );
                              widget.closeView();
                            }
                          } catch (ex) {
                            log.severe(
                              "Failed to initialize the YandexMusic package during webview authorization",
                              ex,
                            );
                          }
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
    );
  }
}
