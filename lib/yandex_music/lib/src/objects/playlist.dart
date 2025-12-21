import 'track.dart';
import 'owner.dart';

class Playlist {
  /// Идентификатор плейлиста
  final int kind;

  /// Идентификатор владельца плейлиста
  final int ownerUid;

  final Owner owner;

  /// Уникальный идентификатор плейлиста
  final String playlistUuid;

  /// Название плейлиста
  final String title;

  /// Ревизия плейлиста
  final int revision;

  /// Приватность плейлиста
  ///
  /// Либо public либо private
  final String visibility;

  /// Лист с треками плейлиста которые являются объектами класса Track
  final List<Track> tracks;

  /// Мап с обложками
  final Map<String, dynamic>? cover;

  /// Чистый ответ от сервера
  final Map<String, dynamic> raw;

  Playlist(Map<String, dynamic> json)
    : kind = json['kind'],
      ownerUid = json['owner']?['uid'] ?? json['uid'],
      owner = json['owner'] != null ? Owner(json['owner']) : Owner({}),
      playlistUuid = json['playlistUuid'],
      title = json['title'],
      revision = json['revision'],
      visibility = json['visibility'],
      cover = json['cover'],
      tracks = json['tracks'] != null
          ? (json['tracks'] as List).map((t) => Track(t['track'] ?? t)).toList()
          : [],
      raw = json;
}


class Playlist2 {
  /// Идентификатор плейлиста
  final int kind;

  /// Идентификатор владельца плейлиста
  final int ownerUid;

  final Owner owner;

  /// Уникальный идентификатор плейлиста
  final String playlistUuid;

  /// Название плейлиста
  String title;

  /// Ревизия плейлиста
  final int revision;

  /// Приватность плейлиста
  ///
  /// Либо public либо private
  final String visibility;

  /// Лист с треками плейлиста которые являются объектами класса Track
  final List<Track2> tracks;

  /// Мап с обложками
  Map<String, dynamic>? cover;

  /// Чистый ответ от сервера
  final Map<String, dynamic> raw;

  Playlist2(Map<String, dynamic> json)
    : kind = json['kind'],
      ownerUid = json['owner']?['uid'] ?? json['uid'],
      owner = json['owner'] != null ? Owner(json['owner']) : Owner({}),
      playlistUuid = json['playlistUuid'],
      title = json['title'],
      revision = json['revision'],
      visibility = json['visibility'],
      cover = json['cover'],
      tracks = json['tracks'] != null
          ? (json['tracks'] as List).map((t) => Track2(t['track'] ?? t)).toList()
          : [],
      raw = json;
}
