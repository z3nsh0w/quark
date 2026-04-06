import 'dart:io';
import 'dart:typed_data';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:quark/services/files.dart';
import 'package:yandex_music/src/objects/track.dart';

enum CoverType {
  url("url"),
  builtIn("builtIn"),
  externalFile("external"),
  noCover("noCover");

  final String value;

  const CoverType(this.value);

  static CoverType parseString(String string) {
    switch (string) {
      case "url":
        return CoverType.url;
      case "buildIn":
        return CoverType.builtIn;
      case "external":
        return CoverType.externalFile;
      case "noCover":
        return CoverType.noCover;
      default:
        return CoverType.builtIn;
    }
  }
}

abstract class PlayerTrack {
  final String title;
  final List<String> artists;
  final List<String> albums;
  final String filepath;
  String cover;
  Uint8List coverByted = Uint8List(0);
  CoverType coverType;

  PlayerTrack({
    required this.title,
    required this.artists,
    required this.albums,
    required this.filepath,
    required this.coverType,
    this.cover = 'none',
    Uint8List? coverByted,
  }) : coverByted = coverByted ?? Uint8List(0);

  static PlayerTrack getDummy() {
    return LocalTrack(
      albums: ['Unknown album'],
      artists: ['Unknown artist'],
      filepath: '',
      title: 'Unknown',
      coverType: CoverType.noCover
    );
  }
}

class LocalTrack extends PlayerTrack {
  LocalTrack({
    required super.title,
    required super.artists,
    required super.albums,
    required super.filepath,
    required super.coverType,
    super.cover,
    super.coverByted,
  });

  /// Allows you to create a new runtime with the same data of the original class object
  static LocalTrack getNew(LocalTrack track) {
    return LocalTrack(
      title: track.title,
      artists: track.artists,
      albums: track.albums,
      filepath: track.filepath,
      cover: track.cover,
      coverByted: track.coverByted,
      coverType: track.coverType,
    );
  }
  
  static LocalTrack getDummy() {
    return LocalTrack(
      albums: ['Unknown album'],
      artists: ['Unknown artist'],
      filepath: '',
      title: 'Unknown',
      coverType: CoverType.noCover
    );
  }
}

class YandexMusicTrack extends PlayerTrack {
  final Track track;

  YandexMusicTrack({
    required this.track,
    required super.title,
    required super.artists,
    required super.albums,
    required super.filepath,
    required super.coverType,
    super.cover,
    super.coverByted,
  });

  static YandexMusicTrack fromYMTrack(Track track) {
    final path = getTrackPath(track.id).replaceAll('/', Platform.pathSeparator);
    final track2 = YandexMusicTrack(
      track: track,
      title: track.title,
      artists: track.artists.map((toElement) => toElement.title).toList(),
      albums: track.albums.isNotEmpty
          ? track.albums.map((toElement) => toElement.title).toList()
          : ["Unknown album"],
      filepath: path,
      coverType: CoverType.url,
    );
    track2.cover = track.coverUri ?? 'none';
    return track2;
  }

  /// Allows you to create a new runtime with the same data of the original class object
  static YandexMusicTrack getNew(YandexMusicTrack track) {
    return YandexMusicTrack(
      title: track.title,
      artists: track.artists,
      albums: track.albums,
      filepath: track.filepath,
      cover: track.cover,
      coverByted: track.coverByted,
      track: track.track,
      coverType: track.coverType,
    );
  }
}

String getTrackPath(String appendName) {
  return '${ApplicationCacheDirectory.instance.directory.path}/cisum_xednay_krauq$appendName.flac';
}

Map<String, dynamic> serializedLocalTrack(PlayerTrack track) {
  return {
    'title': track.title,
    'artists': track.artists,
    'albums': track.albums,
    'filepath': track.filepath,
    'cover': track.cover,
    'coverByted': Uint8List(0),
    "coverType": track.coverType.value
  };
}


Future<LocalTrack> deserializedLocalTrack(
  Map<String, dynamic> trackData,
) async {
  List<String> artists = List<String>.from(trackData['artists']);
  List<String> albums = List<String>.from(trackData['albums']);
  AudioMetadata? metadata = null;
  Uint8List? cover;
  if (metadata != null) {
    cover = metadata.pictures.isNotEmpty
        ? metadata.pictures!.first.bytes
        : null;
  }

  return LocalTrack(
    title: trackData['title'],
    artists: artists,
    albums: albums,
    filepath: trackData['filepath'],
    cover: trackData['cover'],
    coverByted: cover,
    coverType: CoverType.parseString(trackData['coverType'])
  );
}
