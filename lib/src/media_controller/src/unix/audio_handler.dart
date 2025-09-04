import 'package:audio_service/audio_service.dart';
import 'dart:ui';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final Function(Duration)? onSeek;

  // The most common callbacks:

  MyAudioHandler({
    this.onPlay,
    this.onPause,
    this.onNext,
    this.onPrevious,
    this.onSeek,
  }) {}

  @override
  Future<void> play() {
    onPlay?.call();
    return Future.value();
  }

  @override
  Future<void> pause() {
    onPause?.call();
    return Future.value();
  }

  @override
  Future<void> stop() {
    onPause?.call();
    return Future.value();
  }

  @override
  Future<void> seek(Duration position) {
    onSeek?.call(position);
    return Future.value();
  }

  @override
  Future<void> skipToQueueItem(int i) {
    onPlay?.call();
    return Future.value();
  }

  @override
  Future<void> skipToNext() {
    onNext?.call();
    return Future.value();
  }

  @override
  Future<void> skipToPrevious() {
    onPrevious?.call();
    return Future.value();
  }

  Future<void> setPlayback(
    String title,
    String artist,
    String album,
    Duration duration,
    String artUri,
    String id,
  ) async {
    // mediaItem.close();
    mediaItem.add(
      MediaItem(
        id: id,
        title: title,
        artist: artist,
        album: album,
        duration: duration,
        artUri: Uri.parse(artUri),
      ),
    );
  }
}