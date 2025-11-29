import 'dart:typed_data';

import 'album.dart';
import 'artist.dart';
class Track {
  /// Название трека
  final String title;

  /// Идентификатор трека
  final String id;

  /// Реальный идентификатор трека
  final String? realId;

  /// Артисты
  final List<Artist> artists;

  /// Альбомы
  final List<Album> albums;

  /// Адрес обложки трека (без "https://")
  ///
  /// Для использования заменить %% на квадратный размер кратный 10
  ///
  /// Например 500x500
  final String coverUri;
  Uint8List? coverByted = null;

  /// Длительность трека в милисекундах
  final int? durationMs;

  final bool? available;

  final String? ogImage;
  String filepath = '';
  int customId = 0;

  /// Чистый ответ от сервера
  final Map<String, dynamic> raw;
  Track(Map<String, dynamic> json)
    : title = json['title'].toString(),
      id = json['id'].toString(),
      realId = json['realId']?.toString(),
      artists = json['artists'] != null
          ? (json['artists'] as List).map((t) => Artist(t)).toList()
          : <Artist>[],      
      albums = json['albums'] != null
          ? (json['albums'] as List).map((t) => Album(t)).toList()
          : <Album>[],
      coverUri = json['coverUri']??= 'raw.githubusercontent.com/z3nsh0w/z3nsh0w.github.io/refs/heads/master/nocover.png',
      durationMs = json['durationMs'],
      available = json['available']??= false,
      ogImage = json['ogImage']??= '',
      raw = json;
}

class Track2 {
  final String timestamp;
  final String trackID;
  final String? albumID;

  Track2(Map<String, dynamic> json) : albumID=json['albumId'] != null ? json['albumId'].toString() : null, trackID=json['id'].toString(), timestamp=json['timestamp'].toString();
}