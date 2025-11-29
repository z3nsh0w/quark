import 'artist.dart';

class Album {
  /// Идентификатор альбома
  final String? id;

  /// Название альбома
  final String? title;

  /// Год выпуска
  final String? year;

  /// timestamp релизной даты
  final String? releaseDate;

  /// Адрес обложки альбома (без "https://")
  ///
  /// Для использования заменить %% на квадратный размер кратный 10
  ///
  /// Например 500x500
  final String? coverUri;

  /// Кол-во треков в альбоме
  final int? trackCount;

  /// Кол-во лайков
  final int? likesCount;

  final List<Artist> artists;

  /// Чистый ответ от сервера
  final Map<String, dynamic> raw;

  Album(Map<String, dynamic> json)
    : id = json['id']?.toString(),
      title = json['title'],
      year = json['year']?.toString(),
      releaseDate = json['releaseDate'],
      coverUri = json['coverUri'],
      trackCount = json['trackCount'],
      likesCount = json['likesCount'],
      artists = json['artists'] != null
          ? (json['artists'] as List).map((t) => Artist(t)).toList()
          : <Artist>[],
      raw = json;
}
