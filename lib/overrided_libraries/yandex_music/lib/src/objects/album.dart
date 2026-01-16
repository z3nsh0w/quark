import 'artist.dart';

class Album {
  /// Album ID
  final String id;

  /// Album title
  final String title;

  /// Year of issue
  final String year;

  /// timestamp of release date
  final String? releaseDate;

  /// Album cover URL (without "https://")
  ///
  /// To use, replace %% with square size multiple of 10
  ///
  /// For example 500x500
  final String coverUri;

  /// Number of tracks in the album
  final int trackCount;

  /// Number of likes
  final int? likesCount;

  final List<Artist> artists;

  /// Clean response from the server
  final Map<String, dynamic> raw;

  Album(Map<String, dynamic> json)
    : id = json['id'].toString(),
      title = json['title'],
      year = json['year'].toString(),
      releaseDate = json['releaseDate'],
      coverUri = json['coverUri'],
      trackCount = json['trackCount'],
      likesCount = json['likesCount'],
      artists = json['artists'] != null
          ? (json['artists'] as List).map((t) => OfficialArtist(t)).toList()
          : <Artist>[],
      raw = json;
}
