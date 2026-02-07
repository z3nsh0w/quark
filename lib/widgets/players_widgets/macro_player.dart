import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';
import '../../services/cached_images.dart';
import 'package:quark/services/player/player.dart';
import 'package:quark/services/yandex_music_singleton.dart';

class MacroPlayer extends StatefulWidget {
  final double? maxWidth;
  final double height;
  const MacroPlayer({super.key, this.height = 55, this.maxWidth});

  @override
  State<StatefulWidget> createState() => _MacroPlayerState();
}

class _MacroPlayerState extends State<MacroPlayer> {
  late VoidCallback updateListener;

  ValueKey key = ValueKey(0);

  @override
  void initState() {
    super.initState();
    updateListener = () async {
      setState(() {});
    };
    Player.player.playingNotifier.addListener(updateListener);
    Player.player.shuffleModeNotifier.addListener(updateListener);
    Player.player.repeatModeNotifier.addListener(updateListener);
    Player.player.trackChangeNotifier.addListener(updateListener);
  }

  @override
  void deactivate() {
    Player.player.playingNotifier.removeListener(updateListener);
    Player.player.shuffleModeNotifier.removeListener(updateListener);
    Player.player.repeatModeNotifier.removeListener(updateListener);
    Player.player.trackChangeNotifier.removeListener(updateListener);
    super.deactivate();
  }

  @override
  void activate() {
    Player.player.playingNotifier.addListener(updateListener);
    Player.player.shuffleModeNotifier.addListener(updateListener);
    Player.player.repeatModeNotifier.addListener(updateListener);
    Player.player.trackChangeNotifier.addListener(updateListener);
    super.activate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screehHeight = MediaQuery.of(context).size.width;

    return SizedBox(
      width: widget.maxWidth ?? double.infinity,
      height: widget.height,
      child: Padding(
        padding: EdgeInsetsGeometry.all(5),
        child: Row(
          children: [
            SizedBox(width: 5),
            (Player.player.nowPlayingTrack is LocalTrack &&
                    !listEquals(
                      Player.player.nowPlayingTrack.coverByted,
                      Uint8List(0),
                    ))
                ? ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(3),
                    child: Image.memory(
                      Player.player.nowPlayingTrack.coverByted,
                      height: widget.height - 10,
                      width: widget.height - 10,
                    ),
                  )
                : CachedImage(
                    borderRadius: 3,
                    coverUri:
                        'https://${Player.player.nowPlayingTrack.cover.replaceAll('%%', '300x300')}',
                    height: widget.height - 10,
                    width: widget.height - 10,
                  ),
            SizedBox(width: 5),
            Expanded (child: 
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  Player.player.nowPlayingTrack.title,
                  style: TextStyle(
                    fontFamily: 'noto',
                    decoration: TextDecoration.none,
                    fontSize: min(screehHeight * 0.28, 12),
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),

                Text(
                  Player.player.nowPlayingTrack.artists.join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'noto',
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: min(screehHeight * 0.28, 12),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),),

            SizedBox(width: 2),
            if (Player.player.nowPlayingTrack is YandexMusicTrack)
              Button(
                enabledIcon: Icons.favorite_outlined,
                disabledIcon: Icons.favorite_outlined,
                isEnable: YandexMusicSingleton.likedTracks
                    .map((e) => e.trackID)
                    .toList()
                    .contains(
                      (Player.player.nowPlayingTrack as YandexMusicTrack)
                          .track
                          .id
                          .toString(),
                    ),
                onTap: () => {},
              ),
            SizedBox(width: 2),
            if (screenWidth > 600) ...[
              Button(
                enabledIcon: Icons.shuffle,
                disabledIcon: Icons.shuffle_outlined,
                isEnable: Player.player.isShuffle,
                onTap: () async => Player.player.isShuffle
                    ? await Player.player.unShuffle()
                    : await Player.player.shuffle(null),
              ),
              SizedBox(width: 2),
            ],
            if (screenWidth > 500) ...[
              Button(
                enabledIcon: Icons.skip_previous,
                disabledIcon: Icons.play_arrow,
                isEnable: true,
                onTap: () async => await Player.player.playPrevious(),
              ),
              SizedBox(width: 2),
            ],
            SizedBox(width: 2),
            Button(
              size: 40,
              enabledIcon: !Player.player.isPlaying
                  ? Icons.play_arrow
                  : Icons.pause,
              disabledIcon: Icons.play_arrow,
              isEnable: true,
              onTap: () async =>
                  await Player.player.playPause(!Player.player.isPlaying),
            ),
            SizedBox(width: 2),
            Button(
              enabledIcon: Icons.skip_next,
              disabledIcon: Icons.play_arrow,
              isEnable: true,
              onTap: () async => await Player.player.playNext(),
            ),
            SizedBox(width: 2),
            if (screenWidth > 600) ...[
              Button(
                enabledIcon: Icons.repeat_one_outlined,
                disabledIcon: Icons.repeat_one_outlined,
                isEnable: Player.player.isRepeat,
                onTap: () async => Player.player.isRepeat
                    ? await Player.player.disableRepeat()
                    : await Player.player.enableRepeat(),
              ),
              SizedBox(width: 2),
            ],
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final IconData enabledIcon;
  final IconData disabledIcon;
  final bool isEnable;
  final Function()? onTap;
  final Function(TapDownDetails)? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final Color? color;
  final double size;

  const Button({
    super.key,
    required this.enabledIcon,
    required this.disabledIcon,
    required this.isEnable,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.color,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(30)),

      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        onTapUp: onTapUp,
        onTapDown: onTapDown,
        child: Container(
          height: size,
          width: size,

          decoration: BoxDecoration(
            color: color ?? Color.fromARGB(31, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 120),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  alignment: Alignment.center,
                  children: [
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                ),
                child: Icon(
                  isEnable ? enabledIcon : disabledIcon,
                  key: ValueKey<bool>(isEnable),
                  color: isEnable
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(255, 255, 255, 0.5),
                  size: size / 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
