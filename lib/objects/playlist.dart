import 'package:quark/objects/track.dart';
import 'package:yandex_music/src/objects/track.dart';

enum PlaylistSource { yandexMusic, local, spotify }
// #TODO: create a LikedPlaylist variable for the playlist
class PlayerPlaylist {
  final int kind;
  final String name;
  final int ownerUid;
  final PlaylistSource source;
  final List<PlayerTrack> tracks;
  PlayerPlaylist({
    required this.ownerUid,
    required this.kind,
    required this.name,
    required this.tracks,
    required this.source,
  });
}

Future<Map<String, dynamic>> serializePlaylist(PlayerPlaylist playlist) async {
  List<Map<String, dynamic>> tracks = [];

  for (final element in playlist.tracks) {
    if (element is YandexMusicTrack) {
      tracks.add({'source': 'yandex_music', 'data': element.track.raw});
    } else if (element is LocalTrack) {
      tracks.add({'source': 'local', 'data': serializedLocalTrack(element)});
    }
  }

  final source = switch (playlist.source) {
    PlaylistSource.yandexMusic => 'yandex_music',
    PlaylistSource.local => 'local',
    PlaylistSource.spotify => 'spotify',
  };

  return {
    'name': playlist.name,
    'kind': playlist.kind,
    'ownerUid': playlist.ownerUid,
    'source': source,
    'tracks': tracks,
  };
}

Map<String, dynamic> _deepConvertMap(dynamic map) {
  if (map is! Map) return {};

  return map.map((key, value) {
    dynamic convertedValue = value;

    if (value is Map) {
      convertedValue = _deepConvertMap(value);
    } else if (value is List) {
      convertedValue = value.map((item) {
        if (item is Map) {
          return _deepConvertMap(item);
        }
        return item;
      }).toList();
    }

    return MapEntry(key.toString(), convertedValue);
  });
}

Future<PlayerPlaylist> deserializePlaylist(Map playlist) async {
  final playlistData = _deepConvertMap(playlist);
  List<PlayerTrack> tracks = [];

  for (final element in playlistData['tracks']) {
    if (element['source'] == 'local') {
      tracks.add(deserializedLocalTrack(element['data']));
    } else if (element['source'] == 'yandex_music') {
      Track track = Track(element['data']);
      String trackPath = await getTrackPath(track.id);
      YandexMusicTrack out = YandexMusicTrack(
        filepath: trackPath,
        title: track.title,
        albums: track.albums.isNotEmpty
            ? track.albums
                  .map((album) => album.title ?? 'Unknown album')
                  .toList()
            : ['Unknown album'],
        artists: track.artists
            .map((album) => album.title ?? 'Unknown album')
            .toList(),
        track: track,
      );
      String? cover = track.coverUri;
      cover ??= out.cover;
      out.cover = cover;
      tracks.add(out);
    }
  }

  PlaylistSource source = switch (playlist['source']) {
    'yandex_music' => PlaylistSource.yandexMusic,
    'local' => PlaylistSource.local,
    'spotify' => PlaylistSource.spotify,
    _ => PlaylistSource.local,
  };

  return PlayerPlaylist(
    ownerUid: playlist['ownerUid'],
    kind: playlist['kind'],
    name: playlist['name'],
    tracks: tracks,
    source: source,
  );
}
