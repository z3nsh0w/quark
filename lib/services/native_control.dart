import 'dart:io';
import 'dart:async';
import 'audio_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:audio_service/audio_service.dart';
import 'package:smtc_windows/src/rust/frb_generated.dart';

// A collection of native media notifications for controlling the player from outside
class NativeControl {
  late final control;

  Function(bool) onPlay;
  Function(bool) onPause;
  Function() onNext;
  Function() onPrevious;
  Function() onSeek;

  NativeControl({
    required this.onPlay,
    required this.onPause,
    required this.onNext,
    required this.onPrevious,
    required this.onSeek,
  });

  Future<void> init() async {
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
          control.buttonPressStream.listen((event) {
            switch (event) {
              case PressedButton.play:
                onPlay(true);
                break;
              case PressedButton.pause:
                onPause(false);
                break;
              case PressedButton.next:
                onNext();
                break;
              case PressedButton.previous:
                onPrevious();
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
            onPlay: () => onPlay(true),
            onPause: () => onPause(false),
            onNext: () => onNext(),
            onPrevious: () => onPrevious(),
            onSeek: (position) => onSeek(),
          ),
          config: AudioServiceConfig(
            androidNotificationChannelId: 'quark.quarkaudio.app.channel.audio',
            androidNotificationChannelName: 'Audio playback',
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
