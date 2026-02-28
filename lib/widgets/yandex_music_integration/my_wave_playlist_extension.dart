import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import '/widgets/state_indicator.dart';
import 'package:quark/services/player/player.dart';
import 'package:quark/widgets/yandex_music_integration/vibe_animation.dart';

class MyWaveView extends StatefulWidget {
  final Function(StateIndicatorOperation operation) showOperation;
  final VoidCallback closePlaylist;

  const MyWaveView({
    super.key,
    required this.showOperation,
    required this.closePlaylist,
  });

  @override
  State<MyWaveView> createState() => _MyWaveView();
}

class _MyWaveView extends State<MyWaveView> {
  void getDefaults() {}

  void playVibe() {}
  void newHue() {
    nowHue = random.nextDouble() * 360;
  }

  void changeSpeed() {
    setState(() {
      speed = Player.player.playingNotifier.value ? 1 : 0.2;
    });
  }

  final Random random = Random.secure();
  double nowHue = 100;
  double speed = 1;

  @override
  void initState() {
    super.initState();
    newHue();
    changeSpeed();
    Player.player.trackChangeNotifier.addListener(newHue);
    Player.player.playingNotifier.addListener(changeSpeed);
  }

  @override
  void dispose() {
    super.dispose();
    Player.player.trackChangeNotifier.removeListener(newHue);
    Player.player.playingNotifier.removeListener(changeSpeed);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 500) {
            widget.closePlaylist();
          }
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
            child: Container(
              width: 400,
              height: MediaQuery.of(context).size.height,
              decoration: overlayBoxDecoration(),
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(vertical: 4),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(bottom: 150),
                        child: VibeWidget(
                          size: 500,
                          hue: nowHue,
                          speed: speed,
                          scale: 0.8,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 390,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                  color: Color.fromARGB(50, 0, 0, 0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        'My Wave',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      InkWell(
                                        onTap: () {},
                                        child: Text(
                                          'Waking Up / Favourite / Energetic / Russian',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadiusGeometry.all(
                                                  Radius.circular(10),
                                                ),
                                            child: Material(
                                              color: const Color.fromARGB(
                                                50,
                                                74,
                                                74,
                                                77,
                                              ),
                                              child: InkWell(
                                                onTap: () async {},
                                                child: SizedBox(
                                                  height: 40,
                                                  width: 200,
                                                  child: Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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

Widget appBar(
  Function() togglePlaylist,
  Function() refreshPlaylist,
  Function() search,
) {
  return SizedBox.shrink();
}

BoxDecoration overlayBoxDecoration() {
  return BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
    borderRadius: const BorderRadius.only(
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomRight,
      colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)],
    ),
  );
}
