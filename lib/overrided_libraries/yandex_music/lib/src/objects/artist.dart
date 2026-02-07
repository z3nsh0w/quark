import 'package:yandex_music/src/objects/cover.dart';

abstract class Artist {
  final String title;
  Artist(this.title);
}

/// UGC artist obtained from tracks uploaded by the user
class UGCArtist extends Artist {
  UGCArtist(Map<String, dynamic> json) : super(json['name'] as String);
}

/// Official artist class obtained from official tracks.
class OfficialArtist extends Artist {
  final String id;
  final bool various;
  final bool composer;
  final bool available;
  final String? coverUri;

  OfficialArtist(Map<String, dynamic> json)
    : id = (json['id'] is int) ? json['id'].toString() : json['id'] as String,
      various = json['various'] as bool? ?? false,
      composer = json['composer'] as bool? ?? false,
      available = json['available'] as bool? ?? true,
      coverUri = json['cover']?['uri'] as String?,
      super(json['name'] as String);
}

class OfficialArtist2 {
  final String id;
  final String title;
  final bool? various;
  final Cover2? cover;

  OfficialArtist2(Map<String, dynamic> json)
    : id = (json['id'] is int) ? json['id'].toString() : json['id'] as String,
      various = json['various'] as bool? ?? false,
      cover = json['cover'] != null ? Cover2(json['cover']) : null,
      title = json['name'] as String;
}

class ArtistInfo {
  final int likesCount;
  final String artistType;
  final List<Cover2> covers;
  final OfficialArtist2 artist;
  final int? lastMonthListeners;
  final int? lastMonthListenersDelta;

  ArtistInfo(Map<String, dynamic> fromJson)
    : likesCount = fromJson['likesCount'],
      artistType = fromJson['artistType'],
      artist = OfficialArtist2(fromJson['artist']),
      lastMonthListeners = fromJson['stats'] != null
          ? fromJson['stats']['lastMonthListeners']
          : null,
      lastMonthListenersDelta = fromJson['stats'] != null
          ? fromJson['stats']['lastMonthListenersDelta']
          : null,
      covers = (fromJson['covers'] as List).isEmpty
          ? []
          : (fromJson['covers'] as List)
                .map((toElement) => Cover2(toElement))
                .toList();
}
