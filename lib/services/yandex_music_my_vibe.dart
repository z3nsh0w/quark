import 'package:flutter/material.dart';
import 'package:quark/objects/playlist.dart';
import 'package:quark/objects/track.dart';
import 'package:quark/services/player/player.dart';

import 'yandex_music_singleton.dart';

abstract class YandexMusicMyVibe {
  static late YandexMusicMyVibe instance;

  static bool working = false;

  static void init() {
    ListenLogger().init();
    ListenLogger().notifier.addListener(listener);
  }

  static void startVibe(List<VibeSetting> vibes) async {

  }

  static void listener() async {
    
  }
}

class Changed {
  final PlayerTrack track;
  final int totalPlayedSeconds;
  final ChangeReason reason;
  const Changed(this.totalPlayedSeconds, this.track, this.reason);
}

class ListenLogger {
  static final ListenLogger _instance = ListenLogger._internal();

  factory ListenLogger() => _instance;

  ListenLogger._internal();

  static bool inited = false;

  Future<void> init() async {
    if (inited) {
      return;
    }
    Player.player.trackChangeNotifier.addListener(trackListen);
    Player.player.durationNotifier.addListener(totalDurationListener);
    Player.player.playedNotifier.addListener(playedListener);

    lastTrack = Player.player.trackNotifier.value;
    lastPosition = Player.player.playedNotifier.value;
    lastCountedSecond = lastPosition.inSeconds;
    lastDuration = Player.player.durationNotifier.value;
    inited = true;
  }

  int lastCountedSecond = 0;
  int totalPlayedSeconds = 0;
  late PlayerTrack lastTrack;
  late Duration lastDuration;
  Duration lastPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  ValueNotifier notifier = ValueNotifier<Changed>(
    Changed(2, PlayerTrack.getDummy(), ChangeReason.completed),
  );

  static const int seekThreshold = 2;

  void trackListen() async {
    final int tps = totalPlayedSeconds;
    final PlayerTrack lt = lastTrack;

    totalDuration = Player.player.durationNotifier.value;
    totalPlayedSeconds = 0;
    lastPosition = Duration.zero;
    lastCountedSecond = 0;
    lastTrack = Player.player.trackNotifier.value;

    notifier.value = Changed(tps, lt, Player.player.trackChangeNotifier.value.reason);
  }

  void totalDurationListener() async {
    totalDuration = lastDuration = Player.player.durationNotifier.value;
  }

  void playedListener() async {
    Duration currentPosition = Player.player.playedNotifier.value;
    int currentSecond = currentPosition.inSeconds;

    int diff = currentSecond - lastCountedSecond;

    if (diff > 0 && diff <= seekThreshold) {
      totalPlayedSeconds += diff;
      lastCountedSecond = currentSecond;
    } else if (diff > seekThreshold || diff < 0) {
      lastCountedSecond = currentSecond;
    }

    lastPosition = currentPosition;
  }

  void dispose() async {
    Player.player.trackChangeNotifier.removeListener(trackListen);
    Player.player.durationNotifier.removeListener(totalDurationListener);
    Player.player.playedNotifier.removeListener(playedListener);
  }
}
