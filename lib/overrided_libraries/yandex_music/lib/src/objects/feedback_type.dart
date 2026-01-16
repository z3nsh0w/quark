import 'track.dart';

// TODO: Feedbacks

// abstract class PlaysFeedback {}
// enum TrackPlaysFrom {
//   artist,
//   album,
//   likedPlaylist,
//   nonLikedPlaylist,
// }

// class ClientPlaysFeedback extends PlaysFeedback {
// }

// class ClientChangeFeedback extends PlaysFeedback {
// }

// abstract class PlaysContext {}

// class ArtistContext extends PlaysContext {}
// class AlbumContext extends PlaysContext {}
// class PlaylistContext extends PlaysContext {}

abstract class MyVibeFeedback {}

class SkipFeedback extends MyVibeFeedback {
  final Track track;
  final double totalPlayedSeconds;
  final List<Track> queue;

  SkipFeedback({
    required this.track,
    required this.totalPlayedSeconds,
    required this.queue,
  });
}

class TrackStartedFeedback extends MyVibeFeedback {
  final Track track;

  TrackStartedFeedback({required this.track});
}

class TrackFinishedFeedback extends MyVibeFeedback {
  final Track track;
  final double totalPlayedSeconds;
  final List<Track> queue;

  TrackFinishedFeedback({
    required this.track,
    required this.totalPlayedSeconds,
    required this.queue,
  });
}
