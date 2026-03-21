import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';


class YandexMusicAlbums {
  final YandexMusicApiAsync api;

  YandexMusicAlbums(this.api);

  // /// Returns information about the album
  // Future<Album> getInformation(int albumId, {CancelToken? cancelToken}) async {
  //   final responce = await api.getAlbum(albumId, cancelToken: cancelToken);
  //   return Album(responce['result']);
  // }
 
  /// Returns full album information with tracks
  Future<Album2> getInfo(int albumId, {CancelToken? cancelToken}) async {
    final responce = await api.getAlbumWithTracks(
      albumId,
      cancelToken: cancelToken,
    );
    return Album2(responce['result']);
  }

  /// Returns information about multiple albums
  Future<List<Album>> getAlbums(
    List albumIds, {
    CancelToken? cancelToken,
  }) async {
    final responce = await api.getAlbums(albumIds, cancelToken: cancelToken);
    return responce != null
        ? (responce['result'] as List).map((t) => Album(t)).toList()
        : <Album>[];
  }
}
