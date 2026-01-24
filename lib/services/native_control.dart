import 'dart:io';
import 'dart:async';
import 'linux_audio_control.dart';
import 'package:flutter/material.dart';
import 'package:quark/objects/track.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:audio_service/audio_service.dart';
import 'package:smtc_windows/src/rust/frb_generated.dart';
import 'player.dart';

// A collection of native media notifications for controlling the player from outside
class NativeControl {
  static final NativeControl _instance = NativeControl._internal();

  factory NativeControl() => _instance;

  late Function() onSeek;

  NativeControl._internal() {
    print('MyService initialized once');
  }

  late final control;
  late final VoidCallback _playingListener;
  late final VoidCallback _nowPlayingListener;
  Future<void> listeners() async {
    _playingListener = () async {
      await setPlaybackStatus(Player.player.isPlaying);
    };
    _nowPlayingListener = () async {
      await updateData(Player.player.nowPlayingTrack);
    };
    Player.player.playingNotifier.addListener(_playingListener);
    Player.player.trackNotifier.addListener(_nowPlayingListener);
  }

  Future<void> init(
  ) async {
    listeners();
    if (Platform.isWindows) {
      try {
        await RustLib.init();
        control = SMTCWindows(
          metadata: MusicMetadata(
            title: 'Unknown',
            album: 'Unknown',
            albumArtist: 'Unknown',
            artist: 'Unknown',
          ),
          config: const SMTCConfig(
            fastForwardEnabled: true,
            nextEnabled: true,
            pauseEnabled: true,
            playEnabled: true,
            rewindEnabled: true,
            prevEnabled: true,
            stopEnabled: true,
          ),
        );
      } catch (e) {}

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          control.buttonPressStream.listen((event) async {
            switch (event) {
              case PressedButton.play:
                await Player.player.resume();
                break;
              case PressedButton.pause:
                await Player.player.pause();
                break;
              case PressedButton.next:
                await Player.player.playNext(forceNext: true);
                break;
              case PressedButton.previous:
                await Player.player.playPrevious();
                break;
              case PressedButton.stop:
                control.disableSmtc();
                break;
              default:
                break;
            }
          });
        } catch (e) {
          debugPrint("Error: $e");
        }
      });
    } else {
      try {
        control = await AudioService.init(
          builder: () => MyAudioHandler(
            onPlay: () async => await Player.player.resume(),
            onPause: () async => await Player.player.pause(),
            onNext: () async => await Player.player.playNext(forceNext: true),
            onPrevious: () async => await Player.player.playPrevious(),
            onSeek: (position) => onSeek(),
          ),
          config: AudioServiceConfig(
            androidNotificationChannelId: 'quark.quarkaudio.app.channel.audio',
            androidNotificationChannelName: 'quark',
            androidNotificationOngoing: true,
          ),
        );
      } catch (e) {}
    }
  }

  Future<void> setPlaybackStatus(bool status) async {
    if (Platform.isWindows) {
      status
          ? await control.setPlaybackStatus(PlaybackStatus.playing)
          : await control.setPlaybackStatus(PlaybackStatus.paused);
    } else {
    }
  }

  Future<void> updateData(PlayerTrack track) async {
    if (Platform.isWindows) {
      try {
        await control.updateMetadata(
          MusicMetadata(
            title: track.title,
            album: 'Unknown',
            albumArtist: track.artists.join(','),
            artist: track.artists.join(','),
            thumbnail: 'https://${track.cover.replaceAll('%%', '300x300')}',
          ),
        );
      } catch (e) {}
    } else {
      try {
        Duration duration = Duration.zero;
        await (control as MyAudioHandler).setPlayback(
          track.title,
          track.artists.join(','),
          track.albums.join(','),
          duration,
          'https://${track.cover.replaceAll('%%', '300x300')}',
          '#TODO',
        );
      } catch (e) {}
    }
  }
}
