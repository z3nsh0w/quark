import 'package:audio_service/audio_service.dart';
import 'dart:ui';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final Function(Duration)? onSeek;

  MyAudioHandler({
    this.onPlay,
    this.onPause,
    this.onNext,
    this.onPrevious,
    this.onSeek,
  }) {
    // Инициализируем начальное состояние
    _updatePlaybackState(playing: false);
  }

  @override
  Future<void> play() async {
    onPlay?.call();
    _updatePlaybackState(playing: true);
  }

  @override
  Future<void> pause() async {
    onPause?.call();
    _updatePlaybackState(playing: false);
  }

  @override
  Future<void> stop() async {
    onPause?.call();
    _updatePlaybackState(playing: false);
  }

  @override
  Future<void> seek(Duration position) async {
    onSeek?.call(position);
  }

  @override
  Future<void> skipToQueueItem(int i) async {
    onPlay?.call();
  }

  @override
  Future<void> skipToNext() async {
    onNext?.call();
  }

  @override
  Future<void> skipToPrevious() async {
    onPrevious?.call();
  }

  Future<void> setPlayback(
    String title,
    String artist,
    String album,
    Duration duration,
    String artUri,
    String id,
  ) async {
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
    
    _updatePlaybackState(playing: true);
  }

  void _updatePlaybackState({required bool playing}) {
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: AudioProcessingState.ready,
        playing: playing,
        updatePosition: Duration.zero,
        bufferedPosition: Duration.zero,
        speed: 1.0,
        queueIndex: 0,
      ),
    );
  }

  Future<void> updatePlayingStatus(bool isPlaying) async {
    _updatePlaybackState(playing: isPlaying);
  }
}