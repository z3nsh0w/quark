import 'dart:io';
import 'dart:async';
import 'linux_audio_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:audio_service/audio_service.dart';
import 'package:smtc_windows/src/rust/frb_generated.dart';

// A collection of native media notifications for controlling the player from outside
class NativeControl {
  static final NativeControl _instance = NativeControl._internal();

  factory NativeControl() => _instance;
  late Function({
    bool next,
    bool previous,
    bool playpause,
    bool reload,
    PlayerTrack? custom,
  })
  masterControl;

  late Function() onSeek;

  NativeControl._internal() {
    print('MyService initialized once');
  }

  late final control;

  Future<void> init(
    Function({
      bool next,
      bool previous,
      bool playpause,
      bool reload,
      PlayerTrack? custom,
    })
    masterControl2,
    Function() onSeek2,
  ) async {
    masterControl = masterControl2;
    onSeek = onSeek2;
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
                masterControl(playpause: true);
                break;
              case PressedButton.pause:
                masterControl(playpause: true);
                break;
              case PressedButton.next:
                masterControl(next: true);
                break;
              case PressedButton.previous:
                masterControl(previous: true);
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
            onPlay: () => masterControl(playpause: true),
            onPause: () => masterControl(playpause: true),
            onNext: () => masterControl(next: true),
            onPrevious: () => masterControl(previous: true),
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
