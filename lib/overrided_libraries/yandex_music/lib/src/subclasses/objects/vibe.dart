import 'package:dio/dio.dart';
import 'package:yandex_music/src/objects/vibe_settings.dart';
import 'package:yandex_music/src/objects/wave.dart';
import 'package:yandex_music/src/objects/track.dart';
import 'package:yandex_music/src/subclasses/objects/lazy_wave.dart';
import 'package:yandex_music/src/lower_level.dart';

sealed class MyVibeFeedback {
  const MyVibeFeedback();
}

class TrackStartedFeedback extends MyVibeFeedback {
  final Track track;
  const TrackStartedFeedback({required this.track});
}

class TrackFinishedFeedback extends MyVibeFeedback {
  final Track track;
  final double totalPlayedSeconds;
  const TrackFinishedFeedback({
    required this.track,
    required this.totalPlayedSeconds,
  });
}

class SkipFeedback extends MyVibeFeedback {
  final Track track;
  final double totalPlayedSeconds;
  const SkipFeedback({required this.track, required this.totalPlayedSeconds});
}

class _FeedbackEntry {
  final String batchId;
  final Map<String, dynamic> event;

  const _FeedbackEntry({required this.batchId, required this.event});

  Map<String, dynamic> toJson(String from) => {
    'batchId': batchId,
    'event': event,
    'from': from,
  };
}

class YandexMusicMyVibe {
  final YandexMusicApiAsync _api;

  static const _from = 'web-home-rup_main-radio-default';

  WaveSession? _session;
  final List<String> _queue = [];
  final List<_FeedbackEntry> _feedbackHistory = [];

  WaveSession? get session => _session;

  YandexMusicMyVibe(this._api);

  Future<VibeSettings> getVibeSettings({CancelToken? cancelToken}) async {
    final response = await _api.getWaveSettings(cancelToken: cancelToken);
    return VibeSettings.fromJson(response['result'] as Map<String, dynamic>);
  }

  Future<WaveSession> createWave(
    List<VibeSetting> vibeSettings, {
    bool interactive = true,
    CancelToken? cancelToken,
  }) async {
    final seeds = vibeSettings.map((v) => v.seedName).toList();
    final response = await _api.createWaveSession(
      seeds,
      interactive: interactive,
      cancelToken: cancelToken,
    );
    _session = WaveSession.fromJson(response['result'] as Map<String, dynamic>);
    _queue.clear();
    _feedbackHistory.clear();
    _queue.addAll(_session!.tracks.map((t) => t.queueId));

    await _api.waveRadioStartedFeedback(
      _session!.sessionId,
      _session!.batchId,
      cancelToken: cancelToken,
    );

    return _session!;
  }

  Future<WaveSession> cloneWave(
    List<VibeSetting> vibeSettings, {
    bool interactive = false,
    CancelToken? cancelToken,
  }) async {
    _assertSession();
    final seeds = vibeSettings.map((v) => v.seedName).toList();
    final response = await _api.cloneWaveSession(
      _session!.sessionId,
      seeds: seeds,
      queue: List.unmodifiable(_queue),
      interactive: interactive,
      cancelToken: cancelToken,
    );
    _session = WaveSession.fromJson(response['result'] as Map<String, dynamic>);
    _queue.addAll(_session!.tracks.map((t) => t.queueId));
    return _session!;
  }

  Future<WaveSession> fetchMoreTracks({CancelToken? cancelToken}) async {
    _assertSession();
    final response = await _api.getWaveTracks(
      _session!.sessionId,
      queue: List.unmodifiable(_queue),
      feedbacks: _feedbackHistory.map((f) => f.toJson(_from)).toList(),
      cancelToken: cancelToken,
    );

    final result = response['result'] as Map<String, dynamic>;
    final newBatchId = result['batchId'] as String;
    final sequence = result['sequence'] as List? ?? [];
    final newTracks = sequence
        .map((e) => WaveTrack.fromJson(e as Map<String, dynamic>))
        .toList();

    _session = _session!.copyWithTracks(newTracks, newBatchId);
    _queue.addAll(newTracks.map((t) => t.queueId));
    return _session!;
  }

  Future<void> sendFeedback(
    MyVibeFeedback feedback, {
    CancelToken? cancelToken,
  }) async {
    _assertSession();

    switch (feedback) {
      case TrackStartedFeedback():
        final (trackId, albumId) = _extractIds(feedback.track);
        await _api.waveTrackStartedFeedback(
          _session!.sessionId,
          _session!.batchId,
          trackId,
          albumId,
          cancelToken: cancelToken,
        );

      case TrackFinishedFeedback():
        final (trackId, albumId) = _extractIds(feedback.track);
        final lengthSeconds = feedback.track.durationMs! / 1000.0;
        _feedbackHistory.add(_FeedbackEntry(
          batchId: _session!.batchId,
          event: {
            'type': 'trackFinished',
            'timestamp': DateTime.now().toUtc().toIso8601String(),
            'trackId': '$trackId:$albumId',
            'totalPlayedSeconds': feedback.totalPlayedSeconds,
            'trackLengthSeconds': lengthSeconds,
          },
        ));
        await _api.waveTrackFinishedFeedback(
          _session!.sessionId,
          _session!.batchId,
          trackId,
          albumId,
          totalPlayedSeconds: feedback.totalPlayedSeconds,
          trackLengthSeconds: lengthSeconds,
          cancelToken: cancelToken,
        );

      case SkipFeedback():
        final (trackId, albumId) = _extractIds(feedback.track);
        _feedbackHistory.add(_FeedbackEntry(
          batchId: _session!.batchId,
          event: {
            'type': 'skip',
            'timestamp': DateTime.now().toUtc().toIso8601String(),
            'trackId': '$trackId:$albumId',
            'totalPlayedSeconds': feedback.totalPlayedSeconds,
          },
        ));
        await _api.waveSkipFeedback(
          _session!.sessionId,
          _session!.batchId,
          trackId,
          albumId,
          totalPlayedSeconds: feedback.totalPlayedSeconds,
          cancelToken: cancelToken,
        );
    }
  }

  (String trackId, String albumId) _extractIds(Track track) {
    if (track.albums.isEmpty) {
      throw ArgumentError(
        'Track "${track.title}" (id: ${track.id}) has no album. '
        'Do not pass UGC tracks.',
      );
    }
    return (track.id, track.albums.first.id.toString());
  }

  void _assertSession() {
    if (_session == null) {
      throw StateError('No active wave session. Call createWave() first.');
    }
  }

  Future<LazyWave> createLazyWave(
    List<VibeSetting> vibeSettings, {
    bool interactive = true,
    CancelToken? cancelToken,
  }) async {
    final seeds = vibeSettings.map((v) => v.seedName).toList();
    final response = await _api.createWaveSession(
      seeds,
      interactive: interactive,
      cancelToken: cancelToken,
    );
    final session = WaveSession.fromJson(
      response['result'] as Map<String, dynamic>,
    );
    return LazyWave.create(_api, session, cancelToken: cancelToken);
  }

  void reset() {
    _session = null;
    _queue.clear();
    _feedbackHistory.clear();
  }
}