import 'track.dart';

abstract class Feedback {}

class SkipFeedback extends Feedback {
  final Track track;
  final double totalPlayedSeconds;
  final List<Track> queue;

  SkipFeedback({
    required this.track,
    required this.totalPlayedSeconds,
    required this.queue,
  });
}

class TrackStartedFeedback extends Feedback {
  final Track track;

  TrackStartedFeedback({required this.track});
}

class TrackFinishedFeedback extends Feedback {
  final Track track;
  final double totalPlayedSeconds;
  final List<Track> queue;

  TrackFinishedFeedback({
    required this.track,
    required this.totalPlayedSeconds,
    required this.queue,
  });

}