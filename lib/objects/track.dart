import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:yandex_music/src/objects/track.dart';

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
    this.cover =
        'raw.githubusercontent.com/z3nsh0w/z3nsh0w.github.io/refs/heads/master/nocover.png',
    Uint8List? coverByted,
  }) : coverByted = coverByted ?? Uint8List(0);
}

class LocalTrack extends PlayerTrack {
  LocalTrack({
    required super.title,
    required super.artists,
    required super.albums,
    required super.filepath,
    super.cover,
    super.coverByted,
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
  });
}

Future<String> getTrackPath(String appendName) async {
  Directory cacheDirectory = await getApplicationCacheDirectory();
  return '${cacheDirectory.path}/cisum_xednay_krauq$appendName.flac';
}

Map<String, dynamic> serializedLocalTrack(PlayerTrack track) {
  return {
    'title': track.title,
    'artists': track.artists,
    'albums': track.albums,
    'filepath': track.filepath,
    'cover': track.cover,
    'coverByted': track.coverByted,
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
  Uint8List? coverByted = Uint8List.fromList(
    List<int>.from(trackData['coverByted']),
  );

  return LocalTrack(
    title: trackData['title'],
    artists: artists,
    albums: albums,
    filepath: trackData['filepath'],
    cover: trackData['cover'],
    coverByted: coverByted,
  );
}
