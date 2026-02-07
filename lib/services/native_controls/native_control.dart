import 'dart:io';
import 'dart:async';
import '../player/player.dart';
import 'linux_audio_control.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/track.dart';
import 'package:smtc_windows/smtc_windows.dart';
import 'package:audio_service/audio_service.dart';
import 'package:quark/services/cached_images.dart';
import 'package:smtc_windows/src/rust/frb_generated.dart';

// A collection of native media notifications for controlling the player from outside
class NativeControl {
  static final NativeControl _instance = NativeControl._internal();

  factory NativeControl() => _instance;

  late Function() onSeek;

  NativeControl._internal();

  bool inited = false;
  int initTries = 0;
  Object? lastError;

  late final control;
  late final VoidCallback _playingListener;
  late final VoidCallback _nowPlayingListener;
  Future<void> listeners() async {
    try {
      _playingListener = () async {
        await setPlaybackStatus(Player.player.isPlaying);
      };
      _nowPlayingListener = () async {
        String? path;
        if (Player.player.nowPlayingTrack is LocalTrack &&
            !listEquals(
              Player.player.nowPlayingTrack.coverByted,
              Uint8List(0),
            )) {
          path = await ImageCacheService().putImageBytes(
            ImageCacheService().getMd5(
              Player.player.nowPlayingTrack.coverByted,
            ),
            Player.player.nowPlayingTrack.coverByted,
          );
        }
        await updateData(
          Player.player.nowPlayingTrack,
          customImage: path != null ? 'file://$path' : null,
        );
      };
      Player.player.playingNotifier.addListener(_playingListener);
      Player.player.trackNotifier.addListener(_nowPlayingListener);
    } catch (e) {
      Logger(
        'NativeControl',
      ).severe('Failed to setup listeners on unix platform.', e);
      lastError = e;
    }
  }

  Future<void> init() async {
    initTries += 1;
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
      } catch (e) {
        await dispose();
        Logger('NativeControl').severe(
          'Failed to initialize the NativeControl module for Windows platform.',
          e,
        );
        lastError = e;
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          control.buttonPressStream.listen((event) async {
            switch (event) {
              case PressedButton.play:
                await Player.player.playPause(!Player.player.isPlaying);
                break;
              case PressedButton.pause:
                await Player.player.playPause(!Player.player.isPlaying);
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
          await dispose();
          Logger(
            'NativeControl',
          ).severe('Failed to add native callbacks for Windows platform.', e);
          lastError = e;
          return;
        }
      });
    } else {
      try {
        control = await AudioService.init(
          builder: () => MyAudioHandler(
            onPlay: () async =>
                await Player.player.playPause(!Player.player.isPlaying),
            onPause: () async =>
                await Player.player.playPause(!Player.player.isPlaying),
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
      } catch (e) {
        await dispose();
        Logger('NativeControl').severe(
          'Failed to initialize the NativeControl module for Unix platform.',
          e,
        );
        lastError = e;
        return;
      }
    }
    inited = true;
  }

Future<void> setPlaybackStatus(bool status) async {
  if (Platform.isWindows) {
    status
        ? await control.setPlaybackStatus(PlaybackStatus.paused)
        : await control.setPlaybackStatus(PlaybackStatus.playing);
  } else {
    await (control as MyAudioHandler).updatePlayingStatus(!status);
  }
}

  Future<void> updateData(PlayerTrack track, {String? customImage}) async {
    if (Platform.isWindows) {
      try {
        await control.updateMetadata(
          MusicMetadata(
            title: track.title,
            album: 'Unknown',
            albumArtist: track.artists.join(','),
            artist: track.artists.join(','),
            thumbnail:
                customImage ??
                'https://${track.cover.replaceAll('%%', '300x300')}',
          ),
        );
      } catch (e) {
        Logger(
          'NativeControl',
        ).severe('Failed to update playback on windows platform.', e);
        lastError = e;
      }
    } else {
      try {
        Duration duration = Duration.zero;
        await (control as MyAudioHandler).setPlayback(
          track.title,
          track.artists.join(','),
          track.albums.join(','),
          duration,
          customImage ?? 'https://${track.cover.replaceAll('%%', '300x300')}',
          '#TODO',
        );
      } catch (e) {
        Logger(
          'NativeControl',
        ).severe('Failed to update playback on unix platform.', e);
        lastError = e;
      }
    }
  }

  Future<void> dispose() async {
    Player.player.playingNotifier.removeListener(_playingListener);
    Player.player.trackNotifier.removeListener(_nowPlayingListener);
  }
}
