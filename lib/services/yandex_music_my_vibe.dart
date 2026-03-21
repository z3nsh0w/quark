import 'package:flutter/material.dart';
import 'package:quark/objects/playlist.dart';
import 'package:quark/objects/track.dart';
import 'package:quark/overrided_libraries/yandex_music/lib/src/subclasses/objects/lazy_wave.dart';
import 'package:quark/overrided_libraries/yandex_music/lib/src/subclasses/subclasses.dart'
    as subclasses;
import 'package:quark/services/player/net_player.dart';
import 'package:quark/services/player/player.dart';
import 'yandex_music_singleton.dart';

abstract class YandexMusicMyVibe {
  static late YandexMusicMyVibe instance;

  static ValueNotifier<bool> working = ValueNotifier(false);
  static subclasses.LazyWave? currentWave;
  static PlaylistInfo? backupInfo;
  static List<PlayerTrack> backupTracks = [];
  static ValueNotifier<double> currentHue = ValueNotifier(0.0);
  static int ingnoreListener = 0;

  static bool inited = false;

  static Future<void> init() async {
    await Vitalya2().init();
    Vitalya2().notifier.addListener(listener);
  }

  static Future<void> updatePlaylist() async {

  }

  static Future<void> startWave(List<VibeSetting> vibeSettings) async {

  }

  static Future<void> listener() async {

  }

  static Future<void> endWave() async {
    await Player.player.pause();
    Player.player.updatePlaylistInfo(backupInfo!);
    Player.player.updatePlaylist(backupTracks);
    await Player.player.playCustom(backupTracks[0]);
    Vitalya2().notifier.removeListener(listener);
    working.value = false;
    NetConductor().disabledCaching = false;
  }

  static void sync() async {
    if (currentWave!.currentTrack!.track.id !=
        (Player.player.nowPlayingTrack as YandexMusicTrack).track.id) {}
  }
}

class Changed {
  final PlayerTrack track;
  final int totalPlayedSeconds;
  final ChangeReason reason;
  const Changed(this.totalPlayedSeconds, this.track, this.reason);
}

class Vitalya2 {
  static final Vitalya2 _instance = Vitalya2._internal();

  factory Vitalya2() => _instance;

  Vitalya2._internal();

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

  ValueNotifier<Changed> notifier = ValueNotifier<Changed>(
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
    notifier.value = Changed(
      tps,
      lt,
      Player.player.trackChangeNotifier.value.reason,
    );
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
