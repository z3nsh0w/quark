import 'src/lower_level.dart' as main_library;
import 'src/exceptions/exceptions.dart';
export 'src/exceptions/exceptions.dart';
import 'src/operations/operations.dart';
import 'package:dio/dio.dart';

// This file is a header for the main API which is located in lower_level.dart

/// yandex_music
/// ---
/// 
/// CHANGED!
/// _token variable replaced on token (non private)
///
/// Основной класс библиотеки.
///
/// Отныне вся документация будет на русском языке.
///
///
/// Пример использования:
///```dart
/// import 'package:yandex_music/yandex_music.dart';
///
/// YandexMusic ymInstance = YandexMusic(token: ‘’)
///
/// await ymInstance.init();
/// // Usage eg
///
/// int accountID = ymInstance.account.getAccountID();
/// List playlists = ymInstance.playlists.getUsersPlaylists();
///
///```
/// Для обработки ошибок смотрите класс YandexMusicException
///
/// Все методы класса account (кроме getSettings) используют кешированные данные, то это значит что будут возвращены данные, которые были получены во время инициализации библиотеки
///
/// Для обновления кеша используйте метод updateCache
class YandexMusic {
  final String token;

  YandexMusic({required String token}) : this.token = token;

  bool initalize = false;

  late var _api;
  late Map<String, dynamic> _userInfo;
  late int accountID;

  late _YandexMusicAccount account;
  late _YandexMusicPlaylists playlists;
  late _YandexMusicTracks usertracks;
  late _YandexMusicTrack tracks;
  late _YandexMusicSearch search;
  late _YandexMusicAlbums albums;
  late _YandexMusicLanding landing;
  late Operations operations;

  Future<dynamic> init() async {
    _api = main_library.YandexMusicApiAsync(token: token);
    _userInfo = await _api.getAccountInformation();
    try {
      accountID = _userInfo['result']['account']['uid'];
      initalize = true;
    } on TypeError {
      throw YandexMusicException.initialization(
        'Account ID was not found, but it is required. The token is most likely invalid. Server raw: $_userInfo',
      );
    }
    account = _YandexMusicAccount(this);
    playlists = _YandexMusicPlaylists(this);
    usertracks = _YandexMusicTracks(this);
    tracks = _YandexMusicTrack(this);
    search = _YandexMusicSearch(this);
    albums = _YandexMusicAlbums(this);
    landing = _YandexMusicLanding(this);
    operations = Operations();
  }

  // Future<void> _checkInit() async {
  //   if (!_initalize) {
  //     throw _api.YandexMusicInitalizationError(
  //       'The class was not initialized before it was used!',
  //     );
  //   }
  // }

  Future<void> updateCache() async {
    _api = main_library.YandexMusicApiAsync(token: token);
    _userInfo = await _api.getAccountInformation();
    try {
      accountID = _userInfo['result']['account']['uid'];
      initalize = true;
    } on TypeError {
      throw YandexMusicException.initialization(
        'Account ID was not found, but it is required. The token is most likely invalid. Server raw: $_userInfo',
      );
    }
    account = _YandexMusicAccount(this);
    playlists = _YandexMusicPlaylists(this);
    usertracks = _YandexMusicTracks(this);
    tracks = _YandexMusicTrack(this);
    search = _YandexMusicSearch(this);
    operations = Operations();
  }
}

class _YandexMusicAccount {
  final YandexMusic _parentClass;
  _YandexMusicAccount(this._parentClass);

  /// Выдает уникальный идентификатор аккаунта
  Future<int> getAccountID() async {
    return _parentClass.accountID;
  }

  /// Выдает логин аккаунта.
  Future<String> getLogin() async {
    return _parentClass._userInfo['result']['account']['login'];
  }

  /// Выдает полное имя пользователя (Имя + Фамилия)
  Future<String> getFullName() async {
    return _parentClass._userInfo['result']['account']['fullName'];
  }

  /// Выдает никнейм пользователя
  Future<String> getDisplayName() async {
    return _parentClass._userInfo['result']['account']['displayName'];
  }

  /// Выдает всю доступную информацию об аккаунте в сыром виде
  Future<Map<String, dynamic>> getAccountInformation() async {
    var _userInfo = await _parentClass._api.getAccountInformation();

    return _userInfo['result'];
  }

  /// Выдает состояние подписки плюс
  Future<bool?> hasPlusSubscription() async {
    return _parentClass._userInfo['result']['plus']['hasPlus'];
  }

  /// Выдает полный дефолтный email пользователя
  Future<String> getEmail() async {
    return _parentClass._userInfo['result']['defaultEmail'];
  }

  /// Выдает настройки пользователя в сыром виде
  Future<Map<String, dynamic>> getAccountSettings() async {
    var a = await _parentClass._api.getAccountSettings();
    return a['result'];
  }
}

class _YandexMusicPlaylists {
  final YandexMusic _parentClass;
  _YandexMusicPlaylists(this._parentClass);
  String privatePlaylist = 'private';
  String publicPlaylist = 'public';

  ///
  /// Returns the playlist's cover art (specifically, the custom cover art if it has one, or the cover art of the last track inside the playlist).
  ///
  /// You can choose the size of the cover. By default, it is 300x300. The cover size is specified in square format, multiple of 10 (50x50, 300x300, 1000x1000, etc.).
  Future<String> getPlaylistCoverArtUrl(
    int kind, [
    String imageSize = '300x300',
  ]) async {
    var playlistInfo = await _parentClass._api.getPlaylist(
      _parentClass.accountID,
      kind,
    );
    var cover = playlistInfo['result']['cover'];

    if (cover == null) return '';

    String? type = cover['type'];

    if (type == 'pic' && cover['uri'] != null) {
      String uri = cover['uri'].toString();
      return 'https://${uri.replaceAll('%%', imageSize)}';
    } else if (type == 'mosaic' && cover['itemsUri'] != null) {
      List<dynamic> itemsUri = cover['itemsUri'];
      if (itemsUri.isNotEmpty) {
        String firstUri = itemsUri[0].toString();
        return 'https://${firstUri.replaceAll('%%', imageSize)}';
      }
    }

    return '';
  }

  /// Возвращает полную информацию вместе с треками о плейлисте по его kind.
  ///
  /// Если вы хотите получить информацию о плейлисте другого человека, нужно передать userId владельца плейлиста
  Future<Map<String, dynamic>> getPlaylist(int kind, [int? accountId]) async {
    accountId ??= _parentClass.accountID;
    var playlistInfo = await _parentClass._api.getPlaylist(
      _parentClass.accountID,
      kind,
    );
    return playlistInfo['result'];
  }

  /// Возвращает список со всеми плейлистами пользователя без треков
  ///
  /// ! Не возвращает плейлист с понравившимися треками
  Future<List<dynamic>> getUsersPlaylists() async {
    var playlists = await _parentClass._api.getUsersPlaylists(
      _parentClass.accountID,
    );
    return playlists['result'];
  }

  /// Возвращает информацию о нескольких плейлистах пользователя
  ///
  /// Example: getMultiplePlaylists([1011, 1009]);
  Future<List<dynamic>> getMultiplePlaylists(List kinds) async {
    var playlists = await _parentClass._api.getMultiplePlaylists(
      _parentClass.accountID,
      kinds,
    );
    return playlists['result'];
  }

  /// Возвращает список треков, наиболее подходящих для данного плейлиста
  Future<List<dynamic>> getRecomendationsForPlaylist(int kind) async {
    var recomendations = await _parentClass._api.getPlaylistRecommendations(
      _parentClass.accountID,
      kind,
    );
    return recomendations['result']['tracks'];
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
  Future<Map<String, dynamic>> createPlaylist(
    String title,
    String visibility,
  ) async {
    var result = await _parentClass._api.createPlaylist(
      _parentClass.accountID,
      title,
      visibility,
    );
    return result['result'];
  }

  /// Переименовывает плейлист пользователя
  ///
  /// Возвращает информацию о плейлисте без треков
  Future<Map<String, dynamic>> renamePlaylist(int kind, String newName) async {
    var result = await _parentClass._api.renamePlaylist(
      _parentClass.accountID,
      kind,
      newName,
    );
    return result['result'];
  }

  /// Удаляет плейлист пользователя
  ///
  /// Возвращает строку "ok"
  Future<dynamic> deletePlaylist(int kind) async {
    var result = await _parentClass._api.deletePlaylist(
      _parentClass.accountID,
      kind,
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
  Future<Map<String, dynamic>> addTracksToPlaylist(
    int kind,
    List<Map<String, dynamic>> trackIds, [
    int? at,
    int? revision,
  ]) async {
    int rvs = await getRevision(kind);
    revision ??= rvs;
    var result = await _parentClass._api.addTracksToPlaylist(
      _parentClass.accountID,
      kind,
      trackIds,
      revision,
      at,
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
  Future<Map<String, dynamic>> insertTrackIntoPlaylist(
    int kind,
    String trackId,
    String albumId, [
    int? at,
    int? revision,
  ]) async {
    int rvs = await getRevision(kind);
    revision ??= rvs;
    var result = await _parentClass._api.insertTrackIntoPlaylist(
      _parentClass.accountID,
      kind,
      trackId,
      albumId,
      revision,
      at,
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
  Future<dynamic> deleteTracksFromPlaylist(
    int kind,
    int from,
    int to, [
    int? revision,
  ]) async {
    int rvs = await getRevision(kind);
    revision ??= rvs;
    final responce = await _parentClass._api.deleteTracksFromPlaylist(
      _parentClass.accountID,
      kind,
      from,
      to,
      revision,
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
    String visibility,
  ) async {
    final responce = await _parentClass._api.changeVisibility(
      _parentClass.accountID,
      kind,
      visibility,
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
  Future<List<dynamic>> getPlaylists(List<String> playlistsInfo) async {
    final responce = await _parentClass._api.getPlaylistsInformation(
      playlistsInfo,
    );
    return responce['result'];
  }

  Future<int> getRevision(int kind) async {
    final responce = await getPlaylist(kind);

    return responce['revision'];
  }
}

class _YandexMusicTracks {
  final YandexMusic _parentClass;

  _YandexMusicTracks(this._parentClass);

  /// Возвращает все дизлайкнутые треки пользователя
  Future<List<dynamic>> getDislikedTracks() async {
    var dislikedTracks = await _parentClass._api.getUsersDislikedTracks(
      _parentClass.accountID,
    );
    return dislikedTracks['result']['library']['tracks'];
  }

  /// Вовзвращает все лайкнутые треки пользователя
  Future<List<dynamic>> getLikedTracks() async {
    var likedTracks = await _parentClass._api.getUsersLikedTracks(
      _parentClass.accountID,
    );
    return likedTracks['result']['library']['tracks'];
  }

  /// Помечает треки как понравившееся
  ///
  /// Если трек уже был в понравившихся то он поднимется на 0 индекс
  ///
  /// Возвращает актуальную ревизию плейлиста понравившихся треков
  Future<Map<String, dynamic>> likeTracks(List trackIds) async {
    var responce = await _parentClass._api.likeTracks(
      _parentClass.accountID,
      trackIds,
    );
    return responce['result'];
  }

  /// Убирает треки из понравившихся
  ///
  /// Возвращает актуальную ревизию плейлиста понравивишихся треков
  Future<Map<String, dynamic>> unlikeTracks(List trackIds) async {
    var responce = await _parentClass._api.unlikeTracks(
      _parentClass.accountID,
      trackIds,
    );
    return responce['result'];
  }
}

class _YandexMusicTrack {
  final YandexMusic _parentClass;
  _YandexMusicTrack(this._parentClass);

  /// Вовзвращает информацию о скачивании трека
  ///
  /// Ссылка downloadInfoUrl является ссылкой на XML документ
  ///
  /// Документ можно просмотреть только 1 раз, после чего downloadInfoUrl меняется
  Future<List<dynamic>> getTrackDownloadInfo(String trackID) async {
    var downloadInfo = await _parentClass._api.getTrackDownloadInfo(
      _parentClass.accountID,
      trackID,
    );
    return downloadInfo['result'];
  }

  /// Вовзвращает полноценную ссылку для скачивания/потокового прослушивания трека
  ///
  /// Ссылка действует ограниченное кол-во времени, исходя из длительности трека!
  ///
  /// Для использования нужно передать downloadInfoUrl, который вы получили в методе getTrackDownloadInfo.
  Future<dynamic> getTrackDownloadLink(String downloadInfoURL) async {
    var downloadLink = await _parentClass._api.getTrackDownloadLink(
      downloadInfoURL,
    );
    return downloadLink;
  }

  // Downloads track automatically in highest quality
  // не входит в прод
  // Example:
  // ```dart
  // final file = File('track.mp3');
  // await yandexMusicInstance.tracks.downloadTrack('12345', file);
  // ```
  //
  // Throws [YandexMusicRequestException] if track not found
  // Throws [YandexMusicNetworkException] if network error occurs
  //

  /// Возвращает трек в байтовом формате
  ///
  /// Использование:
  /// ```dart
  /// final result15 = await ym.tracks.getTrackDownloadInfo('43127'); - Получаем информацию о скачивании
  ///
  /// // Формат возврата информации: [{codec: .String., gain: .bool., preview: .bool., downloadInfoUrl: .String., direct: .bool., bitrateInKbps: .int.}, etc]
  ///
  /// logger.d('result15: $result15');
  /// final result16 = await ym.tracks.getTrackDownloadLink(result15[0]['downloadInfoUrl']);
  /// logger.d('result16: $result16');
  /// ```
  Future<dynamic> getTrackAsBytes(String downloadLink) async {
    var result = await _parentClass._api.downloadTrack(downloadLink);
    return result['result'];
  }

  /// Возвращает ссылку для скачивания трека в 320 kbps
  Future<dynamic> autoGetTrackLink(String trackId) async {
    int downloadIndex = 0;
    var info = await getTrackDownloadInfo(trackId);

    for (int i = 0; i < info.length; i++) {
      if (info[i]['bitrateInKbps'] == 320) {
        downloadIndex = i;
      }
    }

    var link = await getTrackDownloadLink(
      info[downloadIndex]['downloadInfoUrl'],
    );
    return link;
  }

  /// Автоматически скачивает трек в высоком качестве
  ///
  /// Возвращает данные в байтовом формате!
  Future<dynamic> autoDownloadTrack(String trackId) async {
    var link = await autoGetTrackLink(trackId);
    var result = await getTrackAsBytes(link);

    return result;
  }

  /// Возвращает дополнительную информацию о треке (например микроклип, текст песни итд)
  Future<Map<String, dynamic>> getAdditionalTrackInfo(String trackId) async {
    var info = await _parentClass._api.getAdditionalInformationOfTrack(
      _parentClass.accountID,
      trackId,
    );
    return info['result'];
  }

  /// Возвращает список похожих треков на определенный трек
  Future<List<dynamic>> getSimilarTracks(String trackId) async {
    var similar = await _parentClass._api.getSimilarTracks(
      _parentClass.accountID,
      trackId,
    );
    return similar['result']['similarTracks'];
  }

  /// Выдает полную информацию о треках
  Future<List<dynamic>> getTracks(List trackIds) async {
    var tracks = await _parentClass._api.getTracks(
      _parentClass.accountID,
      trackIds,
    );
    return tracks['result'];
  }
}

class _YandexMusicSearch {
  final YandexMusic _parentClass;
  _YandexMusicSearch(this._parentClass);

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found tracks       : search.tracks()['total']
  ///
  /// number of tracks per page    : search.tracks()['perPage']
  ///
  /// query result (found tracks)  : search.tracks()['results']
  Future<dynamic> tracks(String query, [int? page, bool? noCorrent, CancelToken? cancelToken]) async {
    noCorrent ??= false;
    page ??= 0;
    var result = await _parentClass._api.search(
      query,
      page,
      'track',
      noCorrent,
      cancelToken
    );
    return result['result']['tracks'];
  }

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found podcasts       : search.podcasts()['total']
  ///
  /// number of podcasts per page    : search.podcasts()['perPage']
  ///
  /// query result (found podcasts)  : search.podcasts()['results']
  Future<dynamic> podcasts(String query, [int? page, noCorrent = false]) async {
    page ??= 0;

    var result = await _parentClass._api.search(
      query,
      page,
      'podcast',
      noCorrent,
    );
    return result['result']['podcasts'];
  }

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found artists      : search.artists()['total']
  ///
  /// number of artists per page    : search.artists()['perPage']
  ///
  /// query result (found artists)  : search.artists()['results']
  Future<dynamic> artists(String query, [int? page, noCorrent = false]) async {
    page ??= 0;

    var result = await _parentClass._api.search(
      query,
      page,
      'artist',
      noCorrent,
    );
    return result['result']['artists'];
  }

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found albums       : search.albums()['total']
  ///
  /// number of albums per page    : search.albums()['perPage']
  ///
  /// query result (found albums)  : search.albums()['results']
  Future<dynamic> albums(String query, [int? page, noCorrent = false]) async {
    page ??= 0;

    var result = await _parentClass._api.search(
      query,
      page,
      'album',
      noCorrent,
    );
    return result['result']['albums'];
  }

  /// Combines all search classes (tracks, podcasts, artists, albums)
  ///
  /// ---
  ///
  /// Returns:
  /// best - the most relevant search result with type track
  ///
  /// search.all()['best']['type'] - type of the best result ('track' in this case)
  ///
  /// search.all()['best']['result'] - complete track data (id, title, artists, albums, coverUri, duration, etc.)
  ///
  /// search.all()['best']['result']['albums'] - array of albums containing this track
  ///
  /// ---
  ///
  /// Other search results:
  ///
  /// search.all()['artists'] - array of found artists
  ///
  /// search.all()['artists']['total'] - total number of found artists
  ///
  /// search.all()['artists']['perPage'] - number per page
  ///
  /// search.all()['artists']['results'] - array of artists with data (name, genres, counts, ratings, etc.)
  ///
  /// search.all()['podcast_episodes'] - array of found podcast episodes
  ///
  /// search.all()['podcast_episodes']['total'] - total number of found episodes
  ///
  /// search.all()['podcast_episodes']['perPage'] - number per page
  ///
  /// search.all()['podcast_episodes']['results'] - array of episodes with data (title, duration, description, etc.)
  ///
  ///  ---
  /// Raises
  ///
  /// YandexMusicRequestException - Error related to request.
  /// The error code can be obtained using the method Error.code
  /// The error code is the state of the html request
  ///
  ///
  ///  YandexMusicNetworkException - Request failed. Network problem.
  ///
  ///  /// Eg.
  /// ```dart
  /// try {
  ///   Map result = await YandexMusicInstance.search.all(''); // This request will return error code 400
  /// } on YandexMusicRequestException catch (error) {
  ///   switch (error.code) {
  ///   case 400:
  ///     logger.e('Bad request. The request was not completed correctly.');
  ///
  ///   case 404:
  ///     logger.e('But nobody came...');
  /// }
  /// // You can also get the message returned by the library
  ///   logger.e(error.message);
  /// } on YandexMusicNetworkException catch (error) {
  ///   logger.e('Request failed. Network problem.');
  ///   logger.e('${error.message} ${error.code}');
  /// }
  /// ```
  ///
  Future<dynamic> all(String query, [int? page, noCorrent = false]) async {
    page ??= 0;

    var result = await _parentClass._api.search(query, page, 'all', noCorrent);
    return result['result'];
  }
}

class _YandexMusicAlbums {
  final YandexMusic _parentClass;
  _YandexMusicAlbums(this._parentClass);

  Future<dynamic> getAlbumInformation(int albumId) async {
    final responce = await _parentClass._api.getAlbum(albumId);
    return responce['result'];
  }

  Future<dynamic> getAlbum(int albumId) async {
    final responce = await _parentClass._api.getAlbumWithTracks(albumId);
    return responce['result'];
  }

  Future<dynamic> getAlbums(List albumIds) async {
    final responce = await _parentClass._api.getAlbums(albumIds);
    return responce['result'];
  }
}

class _YandexMusicLanding {
  final YandexMusic _parentClass;
  _YandexMusicLanding(this._parentClass);

  /// Возвращает новые популярные релизы (треки, альбомы итд)
  ///
  /// Возвращает список с релизами
  /// result['newReleases']
  String newReleases = 'new-releases';

  /// Возвращает персонализированные плейлисты для пользователя
  ///
  /// Возвращает список с плейлистами (uid и kind)
  /// result['newPlaylists']
  String newPlaylists = 'new-playlists';

  /// Возвращает чарты
  String chart = 'chart';

  /// Возвращает подкасты
  String podcasts = 'podcasts';

  /// Возвращает все блоки лендинга, а именно:
  /// ```
  /// Персональные плейлисты
  /// Акции
  /// Новые релизы
  /// Новые плейлисты
  /// Миксы
  /// Чарты
  /// Артисты
  /// Альбомы
  /// Плейлисты
  /// Контексты проигрывания трека
  /// Подкасты
  /// ```
  Future<dynamic> getAllLangingBlocks() async {
    final responce = await _parentClass._api.getLangingBlocks();
    return responce['result'];
  }

  /// Возвращает отдельный блок лендинга
  ///
  /// Поддерживает только:
  /// ```
  /// landing.newReleases
  /// landing.newPlaylists
  /// landing.chart
  /// landing.podcasts
  Future<dynamic> getBlock(String block) async {
    final responce = await _parentClass._api.getBlock(block);
    return responce['result'];
  }
}


// GETTING TRACK LYRICS
// POST REQUESTS
// CREATING PLAYLISTS, ADDING TRACKS ETC
// UPLOADING CUSTOM TRACKS ON YM SERVERS
// MORE DETAILED ERRORS (
// YandexMusicInvalidTokenException
// YandexMusicUnauthorizedException
// YandexMusicNotFoundException
// YandexMusicBadRequestException etc. 
// Maybe errors like this: YandexMusicException.InvalidToken, YandexMusicException.BadRequest ETC
//)
// 
// MORE CORRECT IMPLEMENTAION OF LOWER_LEVEL
// REVISED RETURN FORMAT (
// There will no longer be raw returns from the server. All results will be rewritten and accessible by class.
// EG Instance.account.getUserAccountSettings().theme or Instance.account.settings.theme
//)
// AND MORE, AND MORE, AND MORE
// Provides full lyrics with timecodes for a specific trac
// Will be implemented later
// Future<dynamic> getTrackLyrics(String trackId) async {
//   var lyrics = await api.getTrackLyrics(trackId);
//   return lyrics;
// 