import 'album.dart';
import 'artist.dart';

enum TrackSource {
  /// Track from the official Yandex library
  OWN('OWN'),

  /// Track uploaded by user
  UGC('UGC');

  final String value;

  const TrackSource(this.value);

  static TrackSource tryFromString(String value) {
    for (final source in TrackSource.values) {
      if (source.value == value) {
        return source;
      }
    }
    return TrackSource.OWN;
  }
}

class LyricsInfo {
  /// Is Lyrics with timestamp available
  final bool hasAvailableSyncLyrics;

  /// Is Lyrics without timestamp available
  final bool hasAvailableTextLyrics;

  const LyricsInfo({
    required this.hasAvailableSyncLyrics,
    required this.hasAvailableTextLyrics,
  });

  static LyricsInfo fromJson(Map map) {
    return LyricsInfo(
      hasAvailableSyncLyrics: map['hasAvailableSyncLyrics'],
      hasAvailableTextLyrics: map['hasAvailableTextLyrics'],
    );
  }
}

class Track {
  /// Track name
  final String title;

  /// Track ID
  final String id;

  /// Real track ID
  final String? realId;

  /// Артисты
  final List<Artist> artists;

  /// Альбомы
  final List<Album> albums;

  /// If the track was uploaded by the user and the system recognized it as a track existing on the platform, then there will be a full-fledged Track object with the recognized track
  final Track? matchedTrack;

  /// Track cover address (without "https://")
  ///
  /// For use, replace %% with a square size divisible by 10
  ///
  /// For example 500x500
  /// ```dart
  /// Track track = await ymInstance.tracks.getTracks('43127')[0]
  /// print('https://${track.coverUri.replaceAll('%%', '500x500')}')
  /// ```
  final String? coverUri;

  /// Track duration in milliseconds
  final int? durationMs;

  /// Track availability status
  final bool? available;

  final String? ogImage;

  /// Always llnot be null if track is not UGC
  final LyricsInfo? lyricsInfo;

  /// Track source
  ///
  /// UGC -User uploaded content (The track was uploaded by the user)
  ///
  /// OWN -OWN (Track provided by the site)
  final TrackSource trackSource;

  /// Clean response from the server
  final Map<String, dynamic> raw;
  Track(Map<String, dynamic> json)
    : title = json['title'].toString(),
      id = json['id'].toString(),
      trackSource = TrackSource.tryFromString(json['trackSource'] ?? ''),
      realId = json['realId']?.toString(),
      lyricsInfo = json['trackSource'] != 'UGC'
          ? LyricsInfo.fromJson(json['lyricsInfo'])
          : null,
      artists = json['artists'] != null
          ? (json['artists'] as List).map((t) {
              if (json['trackSource'] == TrackSource.UGC.value) {
                return UGCArtist(t);
              }
              ;
              return OfficialArtist(t);
            }).toList()
          : <Artist>[],
      albums = json['albums'] != null
          ? (json['albums'] as List).map((t) => Album(t)).toList()
          : <Album>[],
      coverUri = json['coverUri'],
      durationMs = json['durationMs'],
      available = json['available'] ??= false,
      ogImage = json['ogImage'] ??= '',
      matchedTrack = json['matchedTrack'] != null
          ? Track(json['matchedTrack'])
          : null,
      raw = json;
}

class ShortTrack {
  final String timestamp;
  final String trackID;
  final String? albumID;

  ShortTrack(Map<String, dynamic> json)
    : albumID = json['albumId'] != null ? json['albumId'].toString() : null,
      trackID = json['id'].toString(),
      timestamp = json['timestamp'].toString();
}
