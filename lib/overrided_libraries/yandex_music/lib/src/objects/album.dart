import 'artist.dart';
import 'label.dart';
import 'devired_colors.dart';
import 'track.dart';
import 'wave.dart';
import 'package:yandex_music/src/objects/cover.dart';


class Album {
  /// Album ID
  final int id;

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
    : id = json['id'],
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


class AlbumInfo {
  final int id;
  final String title;

  /// Album release date in ISO8601 format
  final String? releaseDate;
  final Cover2? cover;
  final List<OfficialArtist2> artists;

  AlbumInfo(Map<String, dynamic> fromJson)
    : id = fromJson['album']['id'],
      releaseDate = fromJson['releaseDate'],
      title = fromJson['album']['title'],
      cover = Cover2(fromJson['album']['cover']),
      artists = fromJson['cover'] != null
          ? (fromJson['artists'] as List)
                .map((t) => OfficialArtist2(t))
                .toList()
          : <OfficialArtist2>[];
}


class Album2 {
  final int id;
  final String title;
  final String? type;
  final String? metaType;
  final String? contentWarning;
  final int year;
  /// ISO8601
  final String? releaseDate;
  final String coverUri;
  final String? ogImage;
  final String genre;
  final String? metaTagId;
  final int trackCount;
  final int? likesCount;
  final bool recent;
  final bool veryImportant;
  final bool available;
  final bool hasTrailer;
  final String? sortOrder;
  final List<Label>? labels;

  final List<Track> tracks;
  final List bestTracks;
  final DerivedColors? colors;
  final List? disclaimers;
  final List<OfficialArtist> artists;
  final bool? trailerAvailable;
  final CustomWave? customWave;
  final Cover2 cover;

  Album2(Map<String, dynamic> fromJson)
    : id = fromJson['id'],
      type = fromJson['type'],
      title = fromJson['title'],
      metaTagId = fromJson['metaTagId'],
      metaType = fromJson['metaType'],
      contentWarning = fromJson['contentWarning'],
      year = fromJson['year'],
      releaseDate = fromJson['releaseDate'],
      coverUri = fromJson['coverUri'],
      ogImage = fromJson['ogImage'],
      genre = fromJson['genre'],
      trackCount = fromJson['trackCount'],
      likesCount = fromJson['likesCount'],
      recent = fromJson['recent'],
      veryImportant = fromJson['veryImportant'],
      available = fromJson['available'],
      sortOrder = fromJson['sortOrder'],
      hasTrailer = fromJson['hasTrailer'],
      colors = fromJson['derivedColors'] != null
          ? DerivedColors(fromJson['derivedColors'])
          : null,
      cover = Cover2(fromJson['cover']),
      artists = (fromJson['artists'] as List)
          .map((toElement) => OfficialArtist(toElement))
          .toList(),
      labels = fromJson['labels'] != null ?(fromJson['labels'] as List)
          .map((toElement) => Label.fromJson(toElement))
          .toList() : null,
      bestTracks = fromJson['bests'],
      disclaimers = fromJson['disclaimers'],
      trailerAvailable = fromJson['trailer']?['available'],
      customWave = fromJson['customWave'] != null
          ? CustomWave(fromJson['customWave'])
          : null,
      tracks = (fromJson['volumes'][0] as List).map((toElement) => Track(toElement)).toList();
}

