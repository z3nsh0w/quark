import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quark/services/yandex_music_my_vibe.dart';
import 'package:quark/services/yandex_music_singleton.dart';
import 'package:quark/widgets/players_widgets/main_player.dart';
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
  List<VibeSetting> vibes = [];
  VibeSettings? possibleVibes;
  final Random random = Random();

  void getDefaults() {}

  void playVibe() async {
    // await YandexMusicMyVibe.startVibe(vibes)
  }

  void updateHue() async {
    setState(() {
      nowHue = YandexMusicMyVibe.currentHue.value;
    });
    print(nowHue);

  }
  void randomHue() async {
    setState(() {
      nowHue = random.nextDouble() * 360.round();
    });
  }

  void changeSpeed() {
    setState(() {
      speed = Player.player.playingNotifier.value ? 1 : 0.2;
    });
  }

  void getVibes() async {
    possibleVibes = await YandexMusicSingleton.instance.myVibe
        .getVibeSettings();
  }

  double nowHue = 100;
  double speed = 1;

  @override
  void initState() {
    super.initState();
    changeSpeed();
    updateHue();
    getVibes();
    // YandexMusicMyVibe.currentHue.addListener(updateHue);
    Player.player.playingNotifier.addListener(changeSpeed);
    Player.player.trackChangeNotifier.addListener(randomHue);
  }

  @override
  void dispose() {
    super.dispose();
    // YandexMusicMyVibe.currentHue.removeListener(updateHue);
    Player.player.playingNotifier.removeListener(changeSpeed);
    Player.player.trackChangeNotifier.removeListener(randomHue);
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
                                        onTap: () async {
                                          if (possibleVibes == null) {
                                            return;
                                          }
                                          if (YandexMusicMyVibe.working.value) {
                                            await YandexMusicMyVibe.endWave();
                                            return;
                                          }

                                          final List<VibeSetting> allVibes = [
                                            ...possibleVibes!.activities,
                                            ...possibleVibes!.character,
                                            ...possibleVibes!.language,
                                            ...possibleVibes!.mood,
                                          ];

                                          final Map<String, VibeSetting>
                                          vibesMap = {
                                            for (var vibe in allVibes)
                                              vibe.name: vibe,
                                          };

                                          final resultNames =
                                              await showDialog<List<String>?>(
                                                context: context,
                                                builder: (_) {
                                                  return Dialog(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    elevation: 0,
                                                    child: Chooser(
                                                      elements: vibesMap.keys
                                                          .toList(),
                                                    ),
                                                  );
                                                },
                                              );

                                          if (resultNames == null ||
                                              resultNames.isEmpty) {
                                            return;
                                          }
                                          final List<VibeSetting>
                                          selectedVibes = resultNames
                                              .map((name) => vibesMap[name]!)
                                              .toList();

                                          await YandexMusicMyVibe.startWave(
                                            selectedVibes,
                                          );
                                        },
                                        child: Text(
                                          possibleVibes != null
                                              ? vibes.isNotEmpty
                                                    ? vibes
                                                          .map((e) => e.name)
                                                          .toList()
                                                          .join(', ')
                                                    : "Choose your moods"
                                              : "An error has occured",
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
                                                onTap: () async {
                                                  await YandexMusicMyVibe.startWave(
                                                    vibes,
                                                  );
                                                },
                                                child: ValueListenableBuilder<bool>(
                                                  valueListenable:
                                                      YandexMusicMyVibe.working,
                                                  builder:
                                                      (
                                                        BuildContext context,
                                                        bool value,
                                                        Widget? child,
                                                      ) => SizedBox(
                                                        height: 40,
                                                        width: 200,
                                                        child: Icon(
                                                          value
                                                              ? Icons.pause
                                                              : Icons
                                                                    .play_arrow,
                                                          color: Colors.white,
                                                          size: 28,
                                                        ),
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

class Chooser extends StatefulWidget {
  final List<String> elements;
  const Chooser({super.key, required this.elements});

  @override
  State<StatefulWidget> createState() => _Chooser();
}

class _Chooser extends State<Chooser> {
  late List<String> allElements = widget.elements;
  List<String> choosed = [];

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400, minWidth: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
              color: Colors.white.withAlpha(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      "Choose waves",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 21,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop(choosed);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Ink(
                          width: 250,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(50, 74, 74, 77),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Start wave",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (String element in allElements)
                      Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (choosed.contains(element)) {
                                  choosed.remove(element);
                                } else {
                                  choosed.add(element);
                                }
                                setState(() {});
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Ink(
                                width: 250,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(50, 74, 74, 77),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (choosed.contains(element))
                                      Icon(Icons.check, color: Colors.white),

                                    Text(
                                      element,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}
