import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicAlbums {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicAlbums(this._parentClass, this.api);

  /// Возвращает информацию о альбоме
  Future<Album> getInformation(int albumId, {CancelToken? cancelToken}) async {
    final responce = await api.getAlbum(
      albumId,
      cancelToken: cancelToken,
    );
    return Album(responce['result']);
  }

  /// Возвращает информацию с треками в raw
  Future<dynamic> getAlbum(int albumId, {CancelToken? cancelToken}) async {
    final responce = await api.getAlbumWithTracks(
      albumId,
      cancelToken: cancelToken,
    );
    return responce['result'];
  }

  /// Возвращает информацию о нескольких альбомах
  Future<List<Album>> getAlbums(
    List albumIds, {
    CancelToken? cancelToken,
  }) async {
    final responce = await api.getAlbums(
      albumIds,
      cancelToken: cancelToken,
    );
    return responce != null
        ? (responce['result'] as List).map((t) => Album(t)).toList()
        : <Album>[];
  }
}
