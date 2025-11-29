// Asynchronous Yandex Music library based on the DIO library
// Version 1.0.2
// Made by zenar56

import 'dart:io';

import 'src/exceptions/exceptions.dart';
import 'src/objects/album.dart';
import 'src/objects/track.dart';
import 'src/objects/artist.dart';
import 'src/objects/playlist.dart';
import 'src/objects/other_objects.dart';
import 'src/objects/lyrics.dart';
import 'src/lower_level.dart' as main_library;

export 'src/exceptions/exceptions.dart';
export 'src/objects/album.dart';
export 'src/objects/track.dart';
export 'src/objects/artist.dart';
export 'src/objects/playlist.dart';
export 'src/objects/lyrics.dart';
export 'src/objects/other_objects.dart';

// TODO: ADD MYWAVE, DAILY PLAYLISTS. ABILITY TO UPLOAD/EDIT USER'S UPLOADED TRACKS. TEST CREATING, EDITING, DELETING PLAYLISTS. 
// TODO: ADD CANCEL TOKEN
// TODO: ADD INIT CHECKER
// TODO: add partial (range) real-time audio capture. 


// This file is a header for the main API which is located in lower_level.dart

class YandexMusic {
  final String token;

  /// yandex_music
  /// ---
  ///
  /// Основной класс библиотеки.
  ///
  /// Пример использования:
  ///```dart
  /// import 'package:yandex_music/yandex_music.dart';
  ///
  /// YandexMusic ymInstance = YandexMusic(token: 'y0_5678');
  /// try {
  ///   await ymInstance.init();
  ///
  ///   int accountID = ymInstance.account.getAccountID();
  ///   var playlists = ymInstance.playlists.getUsersPlaylists();
  ///
  ///   for (Playlist playlist in playlists) {
  ///     print('---'*50);
  ///     print('Playlist name: ${playlist.title}');
  ///     print('Playlist kind: ${playlist.kind}');
  ///     print('Playlist owner name - uid : ${playlist.owner.name} - ${playlist.owner.uid}');
  ///     print('Playlist visibility: ${playlist.visibility}');
  ///  }
  /// }  on YandexMusicException catch (e) {
  ///     switch (e.type) {
  ///       case YandexMusicExceptionType.network:
  ///         print('Network exception: ${e.message}');
  ///         break;
  ///       case YandexMusicExceptionType.unauthorized:
  ///         print('Authorization exception: ${e.message}');
  ///         break;
  ///       case YandexMusicExceptionType.badRequest:
  ///         print('Bad request: ${e.message}');
  ///         break;
  ///       case YandexMusicExceptionType.notFound:
  ///         print('Not found: ${e.message}');
  ///         break;
  ///       default:
  ///         print('Another error: ${e.message}');
  /// }
  ///
  /// }
  ///```
  YandexMusic({required String token}) : this.token = token;

  late main_library.YandexMusicApiAsync _api;
  late Map<String, dynamic> _userInfo;
  late int accountID;

  /// Внутренний класс аккаунта
  ///
  /// Все методы кроме getAccountSettings() и getAccountInformation() выдают кэшированную информацию
  ///
  /// Для обновления кэша используйте
  /// ```dart
  /// await ymInstance.updateCache();
  /// ```

  late _YandexMusicAccount account;
  late _YandexMusicPlaylists playlists;
  late _YandexMusicUserTracks usertracks;
  late _YandexMusicTrack tracks;
  late _YandexMusicSearch search;
  late _YandexMusicAlbums albums;
  late _YandexMusicLanding landing;

  /// Класс для использования закреплений в лендинге
  late _YandexMusicPin pin;
  late Quality quality;
  late LyricsFormat lyrics;

  Future<dynamic> init() async {
    _api = main_library.YandexMusicApiAsync(token: token);
    _userInfo = await _api.getAccountInformation();
    try {
      accountID = _userInfo['result']['account']['uid'];
    } on TypeError {
      throw YandexMusicException.initialization(
        'Account ID was not found, but it is required. The token is most likely invalid. Server raw: $_userInfo',
      );
    }
    account = _YandexMusicAccount(this);
    playlists = _YandexMusicPlaylists(this);
    usertracks = _YandexMusicUserTracks(this);
    tracks = _YandexMusicTrack(this);
    search = _YandexMusicSearch(this);
    albums = _YandexMusicAlbums(this);
    landing = _YandexMusicLanding(this);
    pin = _YandexMusicPin(this);
    quality = Quality();
    lyrics = LyricsFormat();
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
    } on TypeError {
      throw YandexMusicException.initialization(
        'Account ID was not found, but it is required. The token is most likely invalid. Server raw: $_userInfo',
      );
    }
    account = _YandexMusicAccount(this);
    playlists = _YandexMusicPlaylists(this);
    usertracks = _YandexMusicUserTracks(this);
    tracks = _YandexMusicTrack(this);
    search = _YandexMusicSearch(this);
    albums = _YandexMusicAlbums(this);
    landing = _YandexMusicLanding(this);
    pin = _YandexMusicPin(this);
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

class _YandexMusicPin {
  final YandexMusic _parentClass;
  _YandexMusicPin(this._parentClass);

  String unPin = 'delete';
  String pin = 'put';

  Future<dynamic> album(String albumId, String operation) async {
    Map<String, dynamic> body = {'id': albumId};
    if (operation == pin) {
      final result = await _parentClass._api.put('/pin/artist', body);
      return result;
    } else if (operation == unPin) {
      final result = await _parentClass._api.delete('/pin/artist', body);
      return result;
    } else {
      throw YandexMusicException.badRequest('Incorrect action specified');
    }
  }

  Future<dynamic> playlist(int ownerUid, int kind, String operation) async {
    Map<String, dynamic> body = {'uid': ownerUid, 'kind': kind};
    if (operation == pin) {
      final result = await _parentClass._api.put('/pin/playlist', body);
      return result;
    } else if (operation == unPin) {
      final result = await _parentClass._api.delete('/pin/playlist', body);
      return result;
    } else {
      throw YandexMusicException.badRequest('Incorrect action specified');
    }
  }

  Future<dynamic> wave(List<String> seeds, String operation) async {
    Map<String, dynamic> body = {'seeds': seeds};
    if (operation == pin) {
      final result = await _parentClass._api.put('/pin/wave', body);
      return result;
    } else if (operation == unPin) {
      final result = await _parentClass._api.delete('/pin/wave', body);
      return result;
    } else {
      throw YandexMusicException.badRequest('Incorrect action specified');
    }
  }
}

class _YandexMusicUserLikes {
  final YandexMusic _parentClass;

  _YandexMusicUserLikes(this._parentClass);

  String add = 'add';
  String remove = 'remove';

  // Future<dynamic>
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
  String getPlaylistCoverArtUrl(
    Map<String, dynamic> org, [
    String imageSize = '300x300',
  ]) {
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
  Future<Playlist> getPlaylist(int kind, [int? accountId]) async {
    accountId ??= _parentClass.accountID;
    var playlistInfo = await _parentClass._api.getPlaylist(
      _parentClass.accountID,
      kind,
    );
    return Playlist(playlistInfo['result']);
  }

  /// Возвращает список со всеми плейлистами пользователя
  ///
  /// Не возвращает плейлист понравившихся треков
  ///
  /// Для получения понравившихся плейлистов используйте
  ///  ```getPlaylistsWithLikes```
  Future<List<Playlist>> getUsersPlaylists() async {
    var playlists = await _parentClass._api.getUsersPlaylists(
      _parentClass.accountID,
    );
    return playlists != null
        ? (playlists['result'] as List).map((t) => Playlist(t)).toList()
        : <Playlist>[];
  }

  /// Возвращает список со всеми плейлистами пользователя вместе с треками внутри
  Future<List<Playlist2>> getPlaylistsWithLikes([
    bool? addPlaylistWithLikes,
  ]) async {
    addPlaylistWithLikes = true;
    var playlists = await _parentClass._api.getUsersPlaylists(
      _parentClass.accountID,
      addPlaylistWithLikes,
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
  Future<List<Playlist>> getMultiplePlaylists(List kinds) async {
    var playlists = await _parentClass._api.getMultiplePlaylists(
      _parentClass.accountID,
      kinds,
    );
    return playlists != null
        ? (playlists['result'] as List).map((t) => Playlist(t)).toList()
        : <Playlist>[];
  }

  /// Возвращает список треков, наиболее подходящих для данного плейлиста
  Future<List<Track>> getRecomendations(int kind) async {
    var recomendations = await _parentClass._api.getPlaylistRecommendations(
      _parentClass.accountID,
      kind,
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
  Future<Map<String, dynamic>> addTracks(
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
  Future<Map<String, dynamic>> insertTrack(
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
  Future<dynamic> deleteTracks(
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
  Future<List<Playlist>> getInfo(List<String> playlistsInfo) async {
    final responce = await _parentClass._api.getPlaylistsInformation(
      playlistsInfo,
    );
    return responce != null
        ? (responce['result'] as List).map((t) => Playlist(t)).toList()
        : <Playlist>[];
  }

  Future<int> getRevision(int kind) async {
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
    int to, [
    int? revision,
  ]) async {
    int rvs = await getRevision(kind);
    revision ??= rvs;
    final responce = await _parentClass._api.moveTrack(
      _parentClass.accountID,
      kind,
      from,
      to,
      [
        {'id': trackId, 'albumId': albumId},
      ],
      revision,
    );
    return responce['result'];
  }
}

class _YandexMusicUserTracks {
  final YandexMusic _parentClass;

  _YandexMusicUserTracks(this._parentClass);

  /// Возвращает все дизлайкнутые треки пользователя
  Future<List<dynamic>> getDisliked() async {
    var dislikedTracks = await _parentClass._api.getUsersDislikedTracks(
      _parentClass.accountID,
    );
    return dislikedTracks['result']['library']['tracks'];
  }

  /// Вовзвращает все лайкнутые треки пользователя
  Future<List<dynamic>> getLiked() async {
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
  Future<Map<String, dynamic>> like(List trackIds) async {
    var responce = await _parentClass._api.likeTracks(
      _parentClass.accountID,
      trackIds,
    );
    return responce['result'];
  }

  /// Убирает треки из понравившихся
  ///
  /// Возвращает актуальную ревизию плейлиста понравивишихся треков
  Future<Map<String, dynamic>> unlike(List trackIds) async {
    var responce = await _parentClass._api.unlikeTracks(
      _parentClass.accountID,
      trackIds,
    );
    return responce['result'];
  }

  /// Возвращает список со всеми плейлистами пользователя вместе с треками внутри
  ///
  /// Аналогичен ```ymInstance.playlists.getPlaylistsWithLikes```
Future<List<Playlist2>> getPlaylistsWithLikes() async {
  bool addPlaylistWithLikes = true;
  var playlists = await _parentClass._api.getUsersPlaylists(
    _parentClass.accountID,
    addPlaylistWithLikes,
  );
  
  List<Playlist2> result = playlists != null
    ? (playlists['result'] as List).map((t) => Playlist2(t)).toList()
    : <Playlist2>[];
  
  int likedIndex = result.indexWhere((playlist) => playlist.title == 'Мне нравится');
  if (likedIndex != -1) {
    var liked = result.removeAt(likedIndex);
    liked.title = 'Liked';
    liked.cover = {"type": "pic", "uri": "avatars.yandex.net/get-music-user-playlist/11418140/favorit-playlist-cover.bb48fdb9b9f4/300x300", "custom": true};
    result.insert(0, liked);
  }
  print('api,');
  return result;
}

  /// Переименовывает загруженный пользователем трек
  /// ```
  /// При неверном trackId/title/artist кидает 400 BadRequest
  /// ```
  Future<dynamic> rename(String trackId, String title, String artist) async {
    var result = await _parentClass._api.renameTrack(
      trackId,
      title,
      artist,
      'application/json',
    );
    return result['result'];
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
  Future<dynamic> upload(int kind, File file) async {
    String playlistId = '${_parentClass.accountID}:$kind';
    var result = await _parentClass._api.getUploadLink(
      _parentClass.accountID,
      'fileName.wav',
      playlistId,
    );

    await _parentClass._api.uploadFile(result['post-target'], file);

    return result['ugc-track-id'];
  }
}

class _YandexMusicTrack {
  final YandexMusic _parentClass;
  _YandexMusicTrack(this._parentClass);

  /// V1
  ///
  /// Вовзвращает информацию о скачивании трека
  ///
  /// Ссылка downloadInfoUrl является ссылкой на XML документ
  ///
  /// Документ можно просмотреть только 1 раз, после чего downloadInfoUrl меняется
  Future<List<dynamic>> getDownloadInfo(String trackID) async {
    var downloadInfo = await _parentClass._api.getTrackDownloadInfo(
      _parentClass.accountID,
      trackID,
    );
    return downloadInfo['result'];
  }

  /// Возвращает (скачивает) трек в байтовом формате
  ///
  /// Принимает уже готовую ссылку для скачивания
  Future<dynamic> getAsBytes(String downloadLink) async {
    var result = await _parentClass._api.downloadTrack(downloadLink);
    return result['result'];
  }

  /// Возвращает ссылку для скачивания трека
  ///
  /// Скачивание делится на методы V1 и V2
  ///
  /// ```dart
  /// // Для вызова V1 передаем только trackID
  /// // Вернет MP3 320kbps (8-9 мбайт)
  /// String track = ymInstance.tracks.getDownloadLink('35724293');
  ///
  /// // Для вызова V2 передаем trackID и качество
  /// // Возвращает: lossless (>20мбайт), aac256 (7-8мбайт), aac64 (> 1 мбайт)
  /// // ! После скачивания в названии файла не будет расширения
  /// String track = ymInstance.tracks.getDownloadLink('47127', ymInstance.quality.lossless)
  /// ```
  Future<dynamic> getDownloadLink(String trackId, [String? quality]) async {
    if (quality == null) {
      int downloadIndex = 0;
      var info = await getDownloadInfo(trackId);

      for (int i = 0; i < info.length; i++) {
        if (info[i]['bitrateInKbps'] == 320) {
          downloadIndex = i;
        }
      }

      var link = await _parentClass._api.getTrackDownloadLink(
        info[downloadIndex]['downloadInfoUrl'],
      );

      return link;
    } else {
      var qualityList = ['lossless', 'nq', 'lq'];
      if (!qualityList.contains(quality)) {
        throw YandexMusicException.badRequest('quality not specified');
      }
      var result = await _parentClass._api.getTrackDownloadLinkV2(
        trackId,
        _parentClass.accountID,
        quality,
      );
      List links = result['downloadInfo']['urls'];
      links.insert(0, result['downloadInfo']['url']);
      return links[0];
    }
  }

  /// Возвращает (скачивает) трек в байтовом формате
  ///
  /// Скачивание делится на методы V1 и V2
  ///
  /// ```dart
  /// // Для вызова V1 передаем только trackID
  /// // Вернет MP3 320kbps (7-8 мбайт)
  /// var track = ymInstance.tracks.download('35724293');
  ///
  /// // Для вызова V2 передаем trackID и качество
  /// // Возвращает: lossless (>20мбайт), aac256 (7-8мбайт), aac64 (> 1 мбайт)
  /// var track = ymInstance.tracks.download('35724293', ymInstance.quality.lossless)
  /// ```
  Future<dynamic> download(String trackId, [String? quality]) async {
    if (quality == null) {
      var link = await getDownloadLink(trackId);
      var result = await getAsBytes(link);

      return result;
    } else {
      var qualityList = ['lossless', 'nq', 'lq'];
      if (!qualityList.contains(quality)) {
        throw YandexMusicException.badRequest('quality not specified');
      }
      var result = await _parentClass._api.getTrackDownloadLinkV2(
        trackId,
        _parentClass.accountID,
        quality,
      );
      List links = result['downloadInfo']['urls'];
      links.insert(0, result['downloadInfo']['url']);
      var track = await getAsBytes(links[0]);
      return track;
    }
  }

  /// Возвращает дополнительную информацию о треке (например микроклип, текст песни итд)
  Future<Map<String, dynamic>> getAdditionalInfo(String trackId) async {
    var info = await _parentClass._api.getAdditionalInformationOfTrack(
      _parentClass.accountID,
      trackId,
    );
    return info['result'];
  }

  /// Возвращает список похожих треков на определенный трек
  Future<List<dynamic>> getSimilar(String trackId) async {
    var similar = await _parentClass._api.getSimilarTracks(
      _parentClass.accountID,
      trackId,
    );

    return similar['result']['similarTracks'] != null
        ? (similar['result']['similarTracks'] as List).map((t) => Track(t)).toList()
        : <Track>[];
  }

  /// Выдает полную информацию о треках
  Future<List<Track>> getTracks(List trackIds) async {
    var tracks = await _parentClass._api.getTracks(
      _parentClass.accountID,
      trackIds,
    );
    return tracks != null
        ? (tracks['result'] as List).map((t) => Track(t)).toList()
        : <Track>[];
  }

  /// Возвращает ссылку на скачивание текста песен
  ///
  /// Тексты выдаются в формате txt
  ///
  /// Использование:
  /// ```dart
  /// // Для получения текста без time меток
  /// String link = await ymInstance.tracks.getLyrics('35724293')
  ///
  /// // Для получения с time метками
  /// // Пример строки - [00:25.65] A heart that's full up like a landfill
  /// Lyrics lyrics = await ymInstance.tracks.getLyrics('', ymInstance.lyrics.withTime)
  Future<Lyrics> getLyrics(String trackId, [String? format]) async {
    format ??= LyricsFormat().text;
    var result = await _parentClass._api.getTrackLyrics(
      trackId,
      _parentClass.accountID,
      format,
    );
    return Lyrics(result['result']);
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
  Future<List<Track>> tracks(
    String query, [
    int? page,
    noCorrent = false,
  ]) async {
    page ??= 0;
    var result = await _parentClass._api.search(
      query,
      page,
      'track',
      noCorrent,
    );
    return result != null
        ? (result['result']['tracks']['results'] as List)
              .map((t) => Track(t))
              .toList()
        : <Track>[];
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
  Future<List<Artist>> artists(
    String query, [
    int? page,
    noCorrent = false,
  ]) async {
    page ??= 0;
    var result = await _parentClass._api.search(
      query,
      page,
      'artist',
      noCorrent,
    );
    return result != null
        ? (result['result']['artists']['results'] as List)
              .map((t) => Artist(t))
              .toList()
        : <Artist>[];
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
  Future<List<Album>> albums(
    String query, [
    int? page,
    noCorrent = false,
  ]) async {
    page ??= 0;

    var result = await _parentClass._api.search(
      query,
      page,
      'album',
      noCorrent,
    );
    // return result['result']['albums'];
    return result != null
        ? (result['result']['albums']['results'] as List)
              .map((t) => Album(t))
              .toList()
        : <Album>[];
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
  /// } on YandexMusicException catch (error) {
  ///   logger.e('${error.type}');
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

  /// Возвращает информацию о альбоме
  Future<Album> getInformation(int albumId) async {
    final responce = await _parentClass._api.getAlbum(albumId);
    return Album(responce['result']);
  }

  /// Возвращает информацию с треками в raw
  Future<dynamic> getAlbum(int albumId) async {
    final responce = await _parentClass._api.getAlbumWithTracks(albumId);
    return responce['result'];
  }

  /// Возвращает информацию о нескольких альбомах
  Future<List<Album>> getAlbums(List albumIds) async {
    final responce = await _parentClass._api.getAlbums(albumIds);
    return responce != null
        ? (responce['result'] as List).map((t) => Album(t)).toList()
        : <Album>[];
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



// class _YandexMusicCustomMethods {
//   final YandexMusic _parentClass;
//   _YandexMusicCustomMethods(this._parentClass);

  

// }

// GETTING TRACK LYRICS - DONE!

// POST REQUESTS - DONE! 

// CREATING PLAYLISTS, ADDING TRACKS ETC - DONE!

// UPLOADING CUSTOM TRACKS ON YM SERVERS - DONE!
// MORE DETAILED ERRORS - DONE!

// MORE CORRECT IMPLEMENTAION OF LOWER_LEVEL
// REVISED RETURN FORMAT - DONE!

// AND MORE, AND MORE, AND MORE