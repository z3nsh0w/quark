import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicPlaylists {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicPlaylists(this._parentClass, this.api);
  String privatePlaylist = 'private';
  String publicPlaylist = 'public';

  ///
  /// Returns the playlist's cover art (specifically, the custom cover art if it has one, or the cover art of the last track inside the playlist).
  ///
  /// You can choose the size of the cover. By default, it is 300x300. The cover size is specified in square format, multiple of 10 (50x50, 300x300, 1000x1000, etc.).
  String getPlaylistCoverArtUrl(
    Map<String, dynamic> org, {
    String imageSize = '300x300',
  }) {
    String? type = org['type'];

    if (type == 'pic' && org['uri'] != null) {
      String uri = org['uri'].toString();
      return 'https://${uri.replaceAll('%%', imageSize)}';
    } else if (type == 'mosaic' && org['itemsUri'] != null) {
      List<dynamic> itemsUri = org['itemsUri'];
      if (itemsUri.isNotEmpty) {
        String firstUri = itemsUri[0].toString();
        return 'https://${firstUri.replaceAll('%%', imageSize)}';
      }
    }
    return '';
  }

  /// Возвращает полную информацию вместе с треками о плейлисте по его kind.
  ///
  /// Если владелец плейлиста другой, нужно передать userId владельца плейлиста
  Future<Playlist> getPlaylist(
    int kind, {
    int? accountId,
    CancelToken? cancelToken,
  }) async {
    accountId ??= _parentClass.accountID;
    var playlistInfo = await api.getPlaylist(
      _parentClass.accountID,
      kind,
      cancelToken: cancelToken,
    );
    return Playlist(playlistInfo['result']);
  }

  /// Возвращает список со всеми плейлистами пользователя
  ///
  /// Не возвращает плейлист понравившихся треков
  ///
  /// Для получения понравившихся плейлистов используйте
  ///  ```getPlaylistsWithLikes```
  Future<List<Playlist>> getUsersPlaylists({CancelToken? cancelToken}) async {
    var playlists = await api.getUsersPlaylists(
      _parentClass.accountID,
      cancelToken: cancelToken,
    );
    return playlists != null
        ? (playlists['result'] as List).map((t) => Playlist(t)).toList()
        : <Playlist>[];
  }

  /// Возвращает список со всеми плейлистами пользователя вместе с треками внутри
  Future<List<Playlist2>> getPlaylistsWithLikes({
    bool? addPlaylistWithLikes,
    CancelToken? cancelToken,
  }) async {
    addPlaylistWithLikes = true;
    var playlists = await api.getUsersPlaylists(
      _parentClass.accountID,
      addPlaylistWithLikes: addPlaylistWithLikes,
      cancelToken: cancelToken,
    );

    // if (addPlaylistWithLikes != null) {
    //       return playlists != null
    //     ? (playlists['result'] as List).map((t) => Playlist2(t)).toList()
    //     : <Playlist2>[];
    // }

    return playlists != null
        ? (playlists['result'] as List).map((t) => Playlist2(t)).toList()
        : <Playlist2>[];
  }

  /// Возвращает информацию о нескольких плейлистах пользователя
  ///
  /// Example: getMultiplePlaylists([1011, 1009]);
  Future<List<Playlist>> getMultiplePlaylists(
    List kinds, {
    CancelToken? cancelToken,
  }) async {
    var playlists = await api.getMultiplePlaylists(
      _parentClass.accountID,
      kinds,
      cancelToken: cancelToken,
    );
    return playlists != null
        ? (playlists['result'] as List).map((t) => Playlist(t)).toList()
        : <Playlist>[];
  }

  /// Возвращает список треков, наиболее подходящих для данного плейлиста
  Future<List<Track>> getRecomendations(
    int kind, {
    CancelToken? cancelToken,
  }) async {
    var recomendations = await api.getPlaylistRecommendations(
      _parentClass.accountID,
      kind,
      cancelToken: cancelToken,
    );
    return recomendations != null
        ? (recomendations['result']['tracks'] as List)
              .map((t) => Track(t))
              .toList()
        : <Track>[];
  }

  /// Создает плейлист
  ///
  /// Visibility можно указать через playlists.privatePlaylist или playlist.publicPlaylist
  ///
  /// Возвращает информацию о созданном плейлисте после его создания
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> result = await yandexMusicInstance.playlists.createPlaylist('Example', 'public');
  /// print(result['kind']); // 12345
  /// print(result['title']); // Example
  /// print(result['visibility']); // public
  /// print(result['cover']); // {error: cover doesn't exist}
  /// // etc
  /// ```
  ///
  Future<Playlist> createPlaylist(
    String title,
    String visibility, {
    CancelToken? cancelToken,
  }) async {
    var result = await api.createPlaylist(
      _parentClass.accountID,
      title,
      visibility,
      cancelToken: cancelToken,
    );
    return Playlist(result['result']);
  }

  /// Переименовывает плейлист пользователя
  ///
  /// Возвращает информацию о плейлисте без треков
  Future<Map<String, dynamic>> renamePlaylist(
    int kind,
    String newName, {
    CancelToken? cancelToken,
  }) async {
    var result = await api.renamePlaylist(
      _parentClass.accountID,
      kind,
      newName,
      cancelToken: cancelToken,
    );
    return result['result'];
  }

  /// Удаляет плейлист пользователя
  ///
  /// Возвращает строку "ok"
  Future<dynamic> deletePlaylist(int kind, {CancelToken? cancelToken}) async {
    var result = await api.deletePlaylist(
      _parentClass.accountID,
      kind,
      cancelToken: cancelToken,
    );
    return result['result'];
  }

  /// Adds a track to the playlist
  ///
  /// Attention! Tracks must be in map format, containing the track ID and the album from which the track was taken.
  ///
  /// Example:
  /// ```dart
  /// Map<String, dynamic> track = {
  ///   'trackId': '12345678',
  ///   'albumId': '87654321',
  /// };
  /// Map<String, dynamic> track2 = {
  ///   'trackId': '87654321',
  ///   'albumId': '12345678',
  /// };
  /// Map<String, dynamic> track3 = {
  ///   'trackId': '123456',
  ///   'albumId': '874321',
  /// };
  /// await yandexMusicInstance.playlists.addTracksToPlaylist(12345, [track, track2, track3]);
  /// ```
  Future<Map<String, dynamic>> addTracks(
    int kind,
    List<Map<String, dynamic>> trackIds, {
    int? at,
    int? revision,
    CancelToken? cancelToken,
  }) async {
    int rvs = await getRevision(kind);
    revision ??= rvs;
    var result = await api.addTracksToPlaylist(
      _parentClass.accountID,
      kind,
      trackIds,
      revision,
      at: at,
      cancelToken: cancelToken,
    );
    return result['result'];
  }

  /// Добавляет трек в плейлист
  ///
  /// По умолчанию индекс вставки 0 (начало плейлиста), но можно указать иной
  ///
  /// Принимает:
  ///```
  /// kind плейлиста (уникальный локальный идентификатор)
  /// trackId и albumId
  /// revision - версия плейлиста. Указывается при вызове getPlaylist - result['revision']
  ///```
  /// При неверной версии плейлиста кидает wrongRevision exception (см. exception docs)
  Future<Map<String, dynamic>> insertTrack(
    int kind,
    String trackId,
    String albumId, {
    int? at,
    int? revision,
    CancelToken? cancelToken,
  }) async {
    int rvs = await getRevision(kind);
    revision ??= rvs;
    var result = await api.insertTrackIntoPlaylist(
      _parentClass.accountID,
      kind,
      trackId,
      albumId,
      revision,
      at: at,
      cancelToken: cancelToken,
    );
    return result['result'];
  }

  /// Удаляет треки из плейлиста
  ///
  /// Удаление происходит по индексу (начиная с 0)
  ///```
  /// from - индекс, с которого начнется удаление (включительно)
  /// to - индекс, по который будут удаляться треки (включительно)
  ///```
  /// Индексы - положение треков внутри плейлиста, начиная сверху (с 0), заканчивая низом
  Future<dynamic> deleteTracks(
    int kind,
    int from,
    int to, {
    int? revision,
    CancelToken? cancelToken,
  }) async {
    revision ??= await getRevision(kind);
    final responce = await api.deleteTracksFromPlaylist(
      _parentClass.accountID,
      kind,
      from,
      to,
      revision,
      cancelToken: cancelToken,
    );
    return responce['result'];
  }

  /// Меняет видимость плейлиста
  ///
  /// visibility указывается через playlists.publicPlaylist и playlists.privatePlaylist
  ///
  /// Возвращает всю информацию о плейлисте
  Future<Map<String, dynamic>> changeVisibility(
    int kind,
    String visibility, {
    CancelToken? cancelToken,
  }) async {
    final responce = await api.changeVisibility(
      _parentClass.accountID,
      kind,
      visibility,
      cancelToken: cancelToken,
    );
    return responce['result'];
  }

  /// Возвращает информацию о нескольких плейлистах (без треков)
  ///
  /// Плейлисты указываются в формате "uid:kind" внутри списка
  /// ```
  /// uid - идентификатор владельца плейлиста
  /// kind - идентификатор плейлиста
  /// ```
  Future<List<Playlist>> getInfo(
    List<String> playlistsInfo, {
    CancelToken? cancelToken,
  }) async {
    final responce = await api.getPlaylistsInformation(
      playlistsInfo,
      cancelToken: cancelToken,
    );
    return responce != null
        ? (responce['result'] as List).map((t) => Playlist(t)).toList()
        : <Playlist>[];
  }

  Future<int> getRevision(int kind, {CancelToken? cancelToken}) async {
    final responce = await getPlaylist(kind);

    return responce.revision;
  }

  /// Меняет положение трека в плейлисте
  ///
  /// ```
  /// Не поддерживает смену положения в плейлисте лайкнутых треков. Кидает 500 RequestException
  /// Если неправильно указаны trackId + albumId, кидает 400 BadRequest
  /// Если неправильно указаны from или to, кидает 412 WrongRevision (Precondition Failed)
  /// ```
  Future<dynamic> moveTrack(
    int kind,
    String trackId,
    String albumId,
    int from,
    int to, {
    int? revision,
    CancelToken? cancelToken,
  }) async {
    int rvs = await getRevision(kind);
    revision ??= rvs;
    final responce = await api.moveTrack(
      _parentClass.accountID,
      kind,
      from,
      to,
      [
        {'id': trackId, 'albumId': albumId},
      ],
      revision,
      cancelToken: cancelToken,
    );
    return responce['result'];
  }
}