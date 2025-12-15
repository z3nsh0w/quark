import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicUserTracks {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicUserTracks(this._parentClass, this.api);

  /// Возвращает все дизлайкнутые треки пользователя
  Future<List<dynamic>> getDisliked({CancelToken? cancelToken}) async {
    var dislikedTracks = await api.getUsersDislikedTracks(
      _parentClass.accountID,
      cancelToken: cancelToken,
    );
    return dislikedTracks['result']['library']['tracks'];
  }

  /// Вовзвращает все лайкнутые треки пользователя
  Future<List<Track2>> getLiked({CancelToken? cancelToken}) async {
    var likedTracks = await api.getUsersLikedTracks(
      _parentClass.accountID,
      cancelToken: cancelToken,
    );
    List result = likedTracks['result']['library']['tracks'];
    return result
        .map((track) => Track2(track as Map<String, dynamic>))
        .toList();
  }

  /// Помечает треки как понравившееся
  ///
  /// Если трек уже был в понравившихся то он поднимется на 0 индекс
  ///
  /// Возвращает актуальную ревизию плейлиста понравившихся треков
  Future<Map<String, dynamic>> like(
    List trackIds, {
    CancelToken? cancelToken,
  }) async {
    var responce = await api.likeTracks(
      _parentClass.accountID,
      trackIds,
      cancelToken: cancelToken,
    );
    return responce['result'];
  }

  /// Убирает треки из понравившихся
  ///
  /// Возвращает актуальную ревизию плейлиста понравивишихся треков
  Future<Map<String, dynamic>> unlike(
    List trackIds, {
    CancelToken? cancelToken,
  }) async {
    var responce = await api.unlikeTracks(
      _parentClass.accountID,
      trackIds,
      cancelToken: cancelToken,
    );
    return responce['result'];
  }

  /// Возвращает список со всеми плейлистами пользователя вместе с треками внутри
  ///
  /// Аналогичен ```ymInstance.playlists.getPlaylistsWithLikes```
  Future<List<Playlist2>> getPlaylistsWithLikes({
    CancelToken? cancelToken,
  }) async {
    bool addPlaylistWithLikes = true;
    var playlists = await api.getUsersPlaylists(
      _parentClass.accountID,
      addPlaylistWithLikes: addPlaylistWithLikes,
      cancelToken: cancelToken,
    );

    List<Playlist2> result = playlists != null
        ? (playlists['result'] as List).map((t) => Playlist2(t)).toList()
        : <Playlist2>[];

    int likedIndex = result.indexWhere(
      (playlist) => playlist.title == 'Мне нравится',
    );
    if (likedIndex != -1) {
      var liked = result.removeAt(likedIndex);
      liked.title = 'Liked';
      liked.cover = {
        "type": "pic",
        "uri":
            "avatars.yandex.net/get-music-user-playlist/11418140/favorit-playlist-cover.bb48fdb9b9f4/300x300",
        "custom": true,
      };
      result.insert(0, liked);
    }
    return result;
  }

  /// Переименовывает загруженный пользователем трек
  /// ```
  /// При неверном trackId/title/artist - 400 BadRequest exception
  /// При успешном выполнении - True
  /// ```
  Future<bool> renameUGCTrack(
    String trackId,
    String title,
    String artist, {
    CancelToken? cancelToken,
  }) async {
    var result = await api.renameTrack(
      trackId,
      title,
      artist,
      contentType: 'application/json',
      cancelToken: cancelToken,
    );
    return result['result'] == 'ok' ? true : false;
  }

  /// Загружает ваш трек в яндекс
  ///
  /// Возвращает строку с trackID
  ///
  /// Использование:
  /// ```dart
  /// File file = File(r'ourFile.flac');
  /// final newTrackId = await ym.usertracks.upload(1000, file); // Также можно указать плейлист с понравившимися треками
  /// final info = await ym.tracks.getTracks([newTrackId]);
  /// print('${info[0].title} ${info[0].id}');
  /// ```
  ///
  /// После использования переименуйте трек, если там не было метаданных
  /// ```dart
  /// await ymInstance.usertracks.rename(result, 'Рыжая продавщица', 'Пророк СанБой')
  /// ```
  Future<dynamic> uploadUGCTrack(
    int kind,
    File file, {
    CancelToken? cancelToken,
  }) async {
    String playlistId = '${_parentClass.accountID}:$kind';
    var result = await api.getUploadLink(
      _parentClass.accountID,
      'fileName.wav',
      playlistId,
      cancelToken: cancelToken,
    );

    await api.uploadFile(result['post-target'], file);

    return result['ugc-track-id'];
  }
}
