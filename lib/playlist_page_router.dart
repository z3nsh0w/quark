// Flutter packages
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quark/widgets/players_widgets/android_player.dart';
import 'package:quark/widgets/players_widgets/macro_player.dart';

// Additional packages
import 'package:quark/widgets/players_widgets/main_player.dart';
import 'package:quark/widgets/players_widgets/mini_player.dart';
import 'package:yandex_music/yandex_music.dart';

// Local components&modules
import 'services/player/player.dart';
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

    final bool isCompactState = size.height <= 300;
    final bool isAndroid = Platform.isAndroid;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: isAndroid
          ? AndroidWidget(
              playlist: widget.playlist,
              yandexMusic: widget.yandexMusic,
            )
          : isCompactState
          ? size.height < 80 ? MacroPlayer() : MiniPlayerWidget(
              playlist: widget.playlist,
            )
          : MainPlayer(
              playlist: widget.playlist,
              yandexMusic: widget.yandexMusic,
            ),
    );
  }
}
