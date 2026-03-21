import 'package:yandex_music/src/objects/track.dart';

class Wave {
  final String name;
  final String stationId;
  final List<String> seeds;
  final String idForFrom;
  final String description;

  const Wave({
    required this.name,
    required this.stationId,
    required this.seeds,
    required this.idForFrom,
    required this.description,
  });

  factory Wave.fromJson(Map<String, dynamic> json) => Wave(
    name: json['name'],
    stationId: json['stationId'],
    seeds: List<String>.from(json['seeds']),
    idForFrom: json['idForFrom'],
    description: json['description'],
  );
}

class WaveSession {
  final String sessionId;
  final String batchId;
  final bool pumpkin;
  final bool terminated;
  final bool interactive;
  final Wave? wave;
  final List<WaveTrack> tracks;

  const WaveSession({
    required this.sessionId,
    required this.batchId,
    required this.pumpkin,
    required this.terminated,
    required this.interactive,
    required this.tracks,
    this.wave,
  });

  factory WaveSession.fromJson(Map<String, dynamic> json, {String? sessionId}) {
    final sequence = json['sequence'] as List? ?? [];
    return WaveSession(
      sessionId: sessionId ?? json['radioSessionId'] as String,
      batchId: json['batchId'],
      pumpkin: json['pumpkin'] ?? false,
      terminated: json['terminated'] ?? false,
      interactive: json['interactive'] ?? true,
      wave: json['wave'] != null ? Wave.fromJson(json['wave']) : null,
      tracks: sequence
          .map((e) => WaveTrack.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  WaveSession copyWithTracks(List<WaveTrack> newTracks, String newBatchId) =>
      WaveSession(
        sessionId: sessionId,
        batchId: newBatchId,
        pumpkin: pumpkin,
        terminated: terminated,
        interactive: interactive,
        wave: wave,
        tracks: newTracks,
      );
}

class WaveTrack {
  final Track track;
  final TrackParameters trackParameters;
  final bool liked;

  const WaveTrack({
    required this.track,
    required this.trackParameters,
    required this.liked,
  });

  factory WaveTrack.fromJson(Map<String, dynamic> json) => WaveTrack(
    track: Track(json['track']),
    trackParameters: TrackParameters.fromJson(json['trackParameters']),
    liked: json['liked'] ?? false,
  );

  String get queueId =>
      '${track.id}:${track.albums.isNotEmpty ? track.albums.first.id : ""}';
}

class TrackParameters {
  final int bpm;
  final double hue;
  final double energy;
  final int userCollectionHue;

  const TrackParameters({
    required this.bpm,
    required this.hue,
    required this.energy,
    required this.userCollectionHue,
  });

  factory TrackParameters.fromJson(Map<String, dynamic> json) =>
      TrackParameters(
        bpm: json['bpm'],
        hue: (json['hue'] as num).toDouble(),
        energy: (json['energy'] as num).toDouble(),
        userCollectionHue: json['userCollectionHue'],
      );
}

class CustomWave {
  final String title;
  final String animationUrl;
  final String header;
  final String backgroundImageUri;

  CustomWave(Map<String, dynamic> fromJson)
    : title = fromJson['title'],
      animationUrl = fromJson['animationUrl'],
      header = fromJson['header'],
      backgroundImageUri = fromJson['backgroundImageUrl'];
}