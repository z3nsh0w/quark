import 'package:dio/dio.dart';
import 'package:yandex_music/src/objects/wave.dart';
import 'package:yandex_music/src/objects/track.dart';
import 'package:yandex_music/src/lower_level.dart';

class _FeedbackEntry {
  final String batchId;
  final Map<String, dynamic> event;

  const _FeedbackEntry({required this.batchId, required this.event});

  Map<String, dynamic> toJson() => {
    'batchId': batchId,
    'event': event,
    'from': LazyWave._from,
  };
}

class LazyWave {
  static const _from = 'web-home-rup_main-radio-default';

  final YandexMusicApiAsync _api;

  WaveSession _session;
  final List<String> _queue = [];
  final List<_FeedbackEntry> _feedbackHistory = [];
  final List<WaveTrack> _pendingTracks = [];

  int _currentIndex = 0;

  WaveSession get session => _session;
  List<WaveTrack> get pendingTracks => List.unmodifiable(_pendingTracks);
  WaveTrack? get currentTrack =>
      _pendingTracks.isNotEmpty ? _pendingTracks[_currentIndex] : null;
  bool get hasNext => _currentIndex < _pendingTracks.length - 1;

  LazyWave._(this._api, this._session) {
    _pendingTracks.addAll(_session.tracks);
    _queue.addAll(_session.tracks.map((t) => t.queueId));
  }

  static Future<LazyWave> create(
    YandexMusicApiAsync api,
    WaveSession session, {
    CancelToken? cancelToken,
  }) async {
    final wave = LazyWave._(api, session);
    await api.waveRadioStartedFeedback(
      session.sessionId,
      session.batchId,
      cancelToken: cancelToken,
    );
    return wave;
  }

  Future<WaveTrack> trackStarted({CancelToken? cancelToken}) async {
    final track = _requireCurrent();
    final (trackId, albumId) = _extractIds(track.track);
    await _api.waveTrackStartedFeedback(
      _session.sessionId,
      _session.batchId,
      trackId,
      albumId,
      cancelToken: cancelToken,
    );
    return track;
  }

  Future<WaveTrack> trackFinished(
    double totalPlayedSeconds, {
    CancelToken? cancelToken,
  }) async {
    final track = _requireCurrent();
    final (trackId, albumId) = _extractIds(track.track);
    final lengthSeconds = track.track.durationMs! / 1000.0;

    _feedbackHistory.add(
      _FeedbackEntry(
        batchId: _session.batchId,
        event: {
          'type': 'trackFinished',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'trackId': '$trackId:$albumId',
          'totalPlayedSeconds': totalPlayedSeconds,
          'trackLengthSeconds': lengthSeconds,
        },
      ),
    );

    await _api.waveTrackFinishedFeedback(
      _session.sessionId,
      _session.batchId,
      trackId,
      albumId,
      totalPlayedSeconds: totalPlayedSeconds,
      trackLengthSeconds: lengthSeconds,
      cancelToken: cancelToken,
    );

    return track;
  }

  Future<WaveTrack> skip(
    double totalPlayedSeconds, {
    CancelToken? cancelToken,
  }) async {
    final track = _requireCurrent();
    final (trackId, albumId) = _extractIds(track.track);

    _feedbackHistory.add(
      _FeedbackEntry(
        batchId: _session.batchId,
        event: {
          'type': 'skip',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'trackId': '$trackId:$albumId',
          'totalPlayedSeconds': totalPlayedSeconds,
        },
      ),
    );

    await _api.waveSkipFeedback(
      _session.sessionId,
      _session.batchId,
      trackId,
      albumId,
      totalPlayedSeconds: totalPlayedSeconds,
      cancelToken: cancelToken,
    );

    await _fetchMore(resetPending: true, cancelToken: cancelToken);
    return _requireCurrent();
  }

  Future<WaveTrack> next({CancelToken? cancelToken}) async {
    if (hasNext) {
      _currentIndex++;
    } else {
      await _fetchMore(cancelToken: cancelToken);
    }
    return _requireCurrent();
  }

  Future<List<WaveTrack>> getMoreTracks({CancelToken? cancelToken}) async {
    await _fetchMore(cancelToken: cancelToken);
    return List.unmodifiable(_pendingTracks);
  }

  Future<void> _fetchMore({
    bool resetPending = false,
    CancelToken? cancelToken,
  }) async {
    final response = await _api.getWaveTracks(
      _session.sessionId,
      queue: List.unmodifiable(_queue),
      feedbacks: _feedbackHistory.map((f) => f.toJson()).toList(),
      cancelToken: cancelToken,
    );

    final result = response['result'] as Map<String, dynamic>;
    final newBatchId = result['batchId'] as String;
    final sequence = result['sequence'] as List? ?? [];
    final newTracks = sequence
        .map((e) => WaveTrack.fromJson(e as Map<String, dynamic>))
        .toList();

    _queue.addAll(newTracks.map((t) => t.queueId));
    _session = _session.copyWithTracks(newTracks, newBatchId);

    if (resetPending) {
      _pendingTracks.clear();
      _currentIndex = 0;
    } else {
      _currentIndex = _pendingTracks.length;
    }

    _pendingTracks.addAll(newTracks);
  }

  WaveTrack _requireCurrent() {
    if (_pendingTracks.isEmpty) {
      throw StateError('No tracks available.');
    }
    return _pendingTracks[_currentIndex];
  }

  (String, String) _extractIds(Track track) {
    if (track.albums.isEmpty) {
      throw ArgumentError(
        'Track "${track.title}" (id: ${track.id}) has no album. '
        'Do not pass UGC tracks.',
      );
    }
    return (track.id, track.albums.first.id.toString());
  }
}
