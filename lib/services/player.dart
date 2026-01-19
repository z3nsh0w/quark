import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';
import 'package:audioplayers/audioplayers.dart';

/// A standalone player running in the background, independent of the stream UI
class Player {
  final double startVolume;
  final trackNotifier = ValueNotifier<PlayerTrack>(
    LocalTrack(title: '', filepath: '', artists: [], albums: []),
  );
  final playedNotifier = ValueNotifier<Duration>(Duration());
  final durationNotifier = ValueNotifier<Duration>(Duration());

  List<PlayerTrack> playlist;
  PlayerTrack nowPlayingTrack;

  Player({
    required this.startVolume,
    required this.playlist,
    required this.nowPlayingTrack,
  });

  final player = AudioPlayer();
  bool isPlaying = false;
  bool isRepeat = false;
  StreamSubscription? onCompleteSubscription;
  StreamSubscription? onDurationChanged;
  StreamSubscription? onPlayedChanged;

  Future<void> init() async {
    trackNotifier.value = nowPlayingTrack;
    setupListeners();
  }

  Future<void> setupListeners() async {
    onCompleteSubscription?.cancel();
    onDurationChanged?.cancel();
    onPlayedChanged?.cancel();
    onCompleteSubscription = player.onPlayerComplete.listen((event) {
      playNext();
    });

    onDurationChanged = player.onDurationChanged.listen((event) async {
      durationNotifier.value = event;
    });

    onPlayedChanged = player.onPositionChanged.listen((event) async {
      playedNotifier.value = event;
    });
  }

  Future<Duration> getPosition() async {
    Duration? position = await player.getCurrentPosition();
    return position ?? Duration();
  }

  Future<Duration> getTrackDuration() async {
    Duration? duration = await player.getDuration();
    return duration ?? Duration();
  }

  Future<void> eventListener() async {
    player.onPlayerComplete.listen((onData) {
      playNext();
    });
  }

  Future<void> playNext({bool? forceNext}) async {
    int nowIndex = playlist.indexWhere((t) => t == nowPlayingTrack);

    int nextIndex = (isRepeat && forceNext == null)
        ? nowIndex
        : playlist.length - 1 != nowIndex
        ? nowIndex + 1
        : 0;
    nowPlayingTrack = playlist[nextIndex];
    trackNotifier.value = nowPlayingTrack;
    await player.stop();
    await _playIsPlaying();
  }

  Future<void> _playIsPlaying() async {
    bool exists = await File(nowPlayingTrack.filepath).exists();
    if (!exists) {
      return;
    }
    await player.setSource(DeviceFileSource(nowPlayingTrack.filepath));
    if (isPlaying) {
      await player.play(DeviceFileSource(nowPlayingTrack.filepath));
    }
  }

  Future<void> playPrevious() async {
    int nowIndex = playlist.indexWhere((t) => t == nowPlayingTrack);
    int nextIndex = nowIndex == 0
        ? playlist.length - 1
        : nowIndex > 0
        ? nowIndex - 1
        : 0;
    nowPlayingTrack = playlist[nextIndex];
    trackNotifier.value = nowPlayingTrack;
    await player.stop();
    await _playIsPlaying();
  }

  Future<void> playPause(bool play) async {
    isPlaying = play ? true : false;
    play ? await player.resume() : await player.pause();
  }

  Future<void> setVolume(double volume) async {
    await player.setVolume(volume);
  }

  Future<void> seek(Duration seek) async {
    await player.seek(seek);
  }

  Future<void> updatePlaylist(List<PlayerTrack> newPlaylist) async {
    playlist = newPlaylist;
  }

  Future<void> playNetTrack(String link, PlayerTrack track) async {
    nowPlayingTrack = track;
    trackNotifier.value = nowPlayingTrack;
    await player.stop();
    await player.setSource(UrlSource(link));
    if (isPlaying) {
      await player.play(UrlSource(link));
    }
  }

  Future<void> playCustom(PlayerTrack track) async {
    nowPlayingTrack = track;
    trackNotifier.value = nowPlayingTrack;
    await player.stop();
    await player.setSource(DeviceFileSource(track.filepath));
    await _playIsPlaying();
  }
}
