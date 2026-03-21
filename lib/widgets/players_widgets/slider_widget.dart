import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:interactive_slider/interactive_slider.dart';
import 'package:quark/services/player/player.dart';

class ProgressWidget extends StatefulWidget {
  final bool timings;
  final double? interactiveWidth;
  const ProgressWidget({
    super.key,
    required this.timings,
    this.interactiveWidth,
  });

  @override
  State<StatefulWidget> createState() => _SliderWidget();
}

class _SliderWidget extends State<ProgressWidget> {
  InteractiveSliderController positionController = InteractiveSliderController(
    0.0,
  );
  double songProgress = 0.0;
  String currentPosition = '0:00';
  String totalSongDuration = '0:00';
  bool isSliderActive = true;
  int getSecondsByValue(double value) {
    final duration = Player.player.durationNotifier.value;
    return ((value / 100.0) * duration.inSeconds).round();
  }

  void updateSlider() {
    setState(() {
      isSliderActive = false;
    });
  }

  void updateProgress(value) async {
    setState(() {
      isSliderActive = true;
    });
    final seconds = getSecondsByValue(value);
    await Player.player.seek(Duration(seconds: seconds));
  }

  void playedNotifier() {
    final duration = Player.player.durationNotifier.value;
    final position = Player.player.playedNotifier.value;
    String durationLocal = '';
    double currentPos = 0.0;

    int durationTimeInMinutes = duration.inSeconds ~/ 60;
    int durationTimeInSeconds = duration.inSeconds % 60;

    durationLocal += '$durationTimeInMinutes:';

    if (durationTimeInSeconds < 10) {
      durationLocal += '0$durationTimeInSeconds';
    } else {
      durationLocal += '$durationTimeInSeconds';
    }

    currentPos = position.inMicroseconds / duration.inMicroseconds * 100.0;
    if (currentPos > 100.0) {
      currentPos = 100.0;
    }

    int timeInMinutes = position.inSeconds ~/ 60;
    int timeInSeconds = position.inSeconds % 60;

    String timing = '';

    timing += '$timeInMinutes:';

    if (timeInSeconds < 10) {
      timing += '0$timeInSeconds';
    } else {
      timing += '$timeInSeconds';
    }

    if (mounted) {
      setState(() {
        currentPosition = timing;
        totalSongDuration = durationLocal;
        songProgress = currentPos;
        if (isSliderActive) {
          positionController.value = currentPos / 100;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Player.player.playedNotifier.addListener(playedNotifier);
  }

  @override
  void activate() {
    super.activate();
    Player.player.playedNotifier.addListener(playedNotifier);
  }

  @override
  void deactivate() {
    super.deactivate();
    Player.player.playedNotifier.removeListener(playedNotifier);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.timings) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentPosition,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'noto',
              fontSize: 15,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            width: widget.interactiveWidth,
            child: InteractiveSlider(
              controller: positionController,
              unfocusedHeight: 5,
              focusedHeight: 10,
              min: 0.0,
              max: 100.0,
              onProgressUpdated: (value) {
                isSliderActive = true;
                updateProgress(value);
              },
              onFocused: (value) {
                updateSlider();
              },

              brightness: Brightness.light,
              initialProgress: songProgress,
              iconColor: Colors.white,
              gradient: LinearGradient(colors: [Colors.white, Colors.white]),
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
          Text(
            totalSongDuration,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'noto',
              fontSize: 15,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      );
    }
    return SizedBox(
      width: widget.interactiveWidth,
      child: InteractiveSlider(
        controller: positionController,
        unfocusedHeight: 5,
        focusedHeight: 10,
        min: 0.0,
        max: 100.0,
        onProgressUpdated: (value) {
          isSliderActive = true;
          updateProgress(value);
        },
        onFocused: (value) {
          updateSlider();
        },

        brightness: Brightness.light,
        initialProgress: songProgress,
        iconColor: Colors.white,
        gradient: LinearGradient(colors: [Colors.white, Colors.white]),
        shapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}

class VolumeWidget extends StatefulWidget {
  final double? interactiveWidth;
  const VolumeWidget({super.key, this.interactiveWidth});

  @override
  State<StatefulWidget> createState() => _VolumeWidget();
}

class _VolumeWidget extends State<VolumeWidget> {
  late VoidCallback updateVolume;

  InteractiveSliderController volumeController = InteractiveSliderController(
    0.6,
  );
  void changeVolume(value) async {
    await Player.player.setVolume(value);
  }

  @override
  void initState() {
    super.initState();
    updateVolume = () {
      volumeController.value = Player.player.volumeNotifier.value;
    };
    updateVolume();
    Player.player.volumeNotifier.addListener(updateVolume);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.interactiveWidth,
      child: InteractiveSlider(
        controller: volumeController,
        startIcon: const Icon(Icons.volume_down),
        endIcon: const Icon(Icons.volume_up),
        min: 0.0,
        max: 1.0,
        brightness: Brightness.light,
        iconColor: Colors.white,
        gradient: LinearGradient(colors: [Colors.white, Colors.white]),
        onChanged: (value) => changeVolume(value),
      ),
    );
  }
}
