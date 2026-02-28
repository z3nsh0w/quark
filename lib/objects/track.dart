import 'dart:typed_data';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:quark/services/files.dart';
import 'package:yandex_music/src/objects/track.dart';

// TODO:
// enum CoverSource {
//   uri,
//   bytes,
//   no
// }

// abstract class TrackCover {
//   final CoverSource source;

//   const TrackCover({required this.source});
// }

// class UriCover extends TrackCover {
//   final String uri;
//   const UriCover({required this.uri, required super.source});
// }

// class BytedCover extends TrackCover {
//   final Uint8List bytes;
//   const BytedCover({required this.bytes, required super.source});
// }

// class NoCover extends TrackCover {
//   const NoCover({required super.source});
// }

abstract class PlayerTrack {
  final String title;
  final List<String> artists;
  final List<String> albums;
  final String filepath;
  String cover;
  Uint8List coverByted = Uint8List(0);

  PlayerTrack({
    required this.title,
    required this.artists,
    required this.albums,
    required this.filepath,
    // this.cover =
    // 'raw.githubusercontent.com/z3nsh0w/quark/refs/heads/main/assets/nocover.png',
    this.cover = 'none',
    Uint8List? coverByted,
    // this.cover22 = const NoCover(source: CoverSource.no)
  }) : coverByted = coverByted ?? Uint8List(0);

  static PlayerTrack getDummy() {
    return LocalTrack(
      albums: ['Unknown album'],
      artists: ['Unknown artist'],
      filepath: '',
      title: 'Unknown',
    );
  }
}

class LocalTrack extends PlayerTrack {
  LocalTrack({
    required super.title,
    required super.artists,
    required super.albums,
    required super.filepath,
    super.cover,
    super.coverByted,
    // super.cover22,
  });
}

class YandexMusicTrack extends PlayerTrack {
  final Track track;

  YandexMusicTrack({
    required this.track,
    required super.title,
    required super.artists,
    required super.albums,
    required super.filepath,
    super.cover,
    super.coverByted,
    // super.cover22,
  });

  static YandexMusicTrack fromYMTtoLocalTrack(Track track) {
    final path = getTrackPath(track.id);
    final track2 = YandexMusicTrack(
      track: track,
      title: track.title,
      artists: track.artists.map((toElement) => toElement.title).toList(),
      albums: track.albums.isNotEmpty ? track.albums.map((toElement) => toElement.title).toList() : ["Unknown album"],
      filepath: path,
    );
    track2.cover = track.coverUri ?? 'none';
    return track2;
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
  };
}

// Map<String, dynamic> serializedLastTrack(
//   PlayerTrack track2Serialize,
//   PlayerPlaylist playlist,
// ) {
//   Map<String, dynamic> track = {};
//   if (track2Serialize is YandexMusicTrack) {
//     track = {
//       'source': 'yandex_music',
//       'playlist_kind': playlist.kind,
//       'data': track2Serialize.track.raw,
//     };
//   } else if (track2Serialize is LocalTrack) {
//     track = {'source': 'local', 'data': serializedLocalTrack(track2Serialize)};
//   }
//   return track;
// }
// Map<String, dynamic> _deepConvertMap(dynamic map) {
//   if (map is! Map) return {};

//   return map.map((key, value) {
//     dynamic convertedValue = value;

//     if (value is Map) {
//       convertedValue = _deepConvertMap(value);
//     } else if (value is List) {
//       convertedValue = value.map((item) {
//         if (item is Map) {
//           return _deepConvertMap(item);
//         }
//         return item;
//       }).toList();
//     }

//     return MapEntry(key.toString(), convertedValue);
//   });
// }

// Future<PlayerTrack?> deserializedLastTrack(
//   Map<String, dynamic> trackData,
// ) async {
//   trackData = _deepConvertMap(trackData);
//   PlayerTrack? trackOut;
//   if (trackData['source'] == 'local') {
//     trackOut = deserializedLocalTrack(trackData['data']);
//   } else if (trackData['source'] == 'yandex_music') {
//     Track track = Track(trackData['data']);
//     String trackPath = await getTrackPath(track.id);
//     YandexMusicTrack out = YandexMusicTrack(
//       filepath: trackPath,
//       title: track.title,
//       albums: track.albums.isNotEmpty
//           ? track.albums.map((album) => album.title ?? 'Unknown album').toList()
//           : ['Unknown album'],
//       artists: track.artists
//           .map((album) => album.title ?? 'Unknown album')
//           .toList(),
//       track: track,
//     );
//     String? cover = track.coverUri;
//     cover ??= out.cover;
//     out.cover = cover;
//     trackOut = out;
//   }
//   return trackOut;
// }

LocalTrack deserializedLocalTrack(Map<String, dynamic> trackData) {
  List<String> artists = List<String>.from(trackData['artists']);
  List<String> albums = List<String>.from(trackData['albums']);
  AudioMetadata? metadata = Files.getFileTags(
    trackData['filepath'],
    getImage: true,
  );
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
  );
}
