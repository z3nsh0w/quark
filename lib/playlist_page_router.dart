// Flutter packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quark/widgets/android_player.dart';

// Additional packages
import 'package:quark/widgets/playlist_page_widget.dart';
import 'package:quark/widgets/mini_player.dart';
import 'package:yandex_music/yandex_music.dart';

// Local components&modules
import '/services/player.dart';
import '/objects/playlist.dart';

class PlaylistPage extends StatefulWidget {
  final PlayerPlaylist playlist;
  final YandexMusic yandexMusic;

  const PlaylistPage({
    super.key,
    required this.playlist,
    required this.yandexMusic,
  });

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  void dis() async {
    await Player.player.pause();
  }

  @override
  void dispose() {
    dis();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final bool isCompactState = size.width <= 400 && size.height <= 300;
    final bool isAndroid = Platform.isAndroid;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: isAndroid
          ? AndroidWidget(
              playlist: widget.playlist,
              yandexMusic: widget.yandexMusic,
            )
          : isCompactState
          ? MiniPlayerWidget(
              playlist: widget.playlist,
              yandexMusic: widget.yandexMusic,
            )
          : PlaylistPage1(
              playlist: widget.playlist,
              yandexMusic: widget.yandexMusic,
            ),
    );
  }
}
