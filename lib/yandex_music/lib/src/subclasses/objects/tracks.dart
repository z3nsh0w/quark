import 'package:yandex_music/yandex_music.dart';
import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/src/objects/lyrics_format.dart';

class YandexMusicTrack {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicTrack(this._parentClass, this.api);

  /// V1
  ///
  /// Вовзвращает информацию о скачивании трека
  ///
  /// Ссылка downloadInfoUrl является ссылкой на XML документ
  ///
  /// Документ можно просмотреть только 1 раз, после чего downloadInfoUrl меняется
  Future<List<dynamic>> getDownloadInfo(
    String trackID, {
    CancelToken? cancelToken,
  }) async {
    var downloadInfo = await api.getTrackDownloadInfo(
      _parentClass.accountID,
      trackID,
      cancelToken: cancelToken,
    );
    return downloadInfo['result'];
  }

  /// Возвращает (скачивает) трек в байтовом формате
  ///
  /// Принимает уже готовую ссылку для скачивания
  Future<dynamic> getAsBytes(
    String downloadLink, {
    CancelToken? cancelToken,
  }) async {
    var result = await api.downloadTrack(
      downloadLink,
      cancelToken: cancelToken,
    );
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
  Future<dynamic> getDownloadLink(
    String trackId, {
    AudioQuality? quality,
    CancelToken? cancelToken,
  }) async {
    if (quality == null) {
      int downloadIndex = 0;
      var info = await getDownloadInfo(trackId);

      for (int i = 0; i < info.length; i++) {
        if (info[i]['bitrateInKbps'] == 320) {
          downloadIndex = i;
        }
      }

      var link = await api.getTrackDownloadLink(
        info[downloadIndex]['downloadInfoUrl'],
      );

      return link;
    } else {
      var result = await api.getTrackDownloadLinkV2(
        trackId,
        _parentClass.accountID,
        quality.value,
        cancelToken: cancelToken,
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
  Future<dynamic> download(
    String trackId, {
    AudioQuality? quality,
    CancelToken? cancelToken,
  }) async {
    if (quality == null) {
      var link = await getDownloadLink(trackId);
      var result = await getAsBytes(link);

      return result;
    } else {
      var result = await api.getTrackDownloadLinkV2(
        trackId,
        _parentClass.accountID,
        quality.value,
        cancelToken: cancelToken,
      );
      List links = result['downloadInfo']['urls'];
      links.insert(0, result['downloadInfo']['url']);
      var track = await getAsBytes(links[0]);
      return track;
    }
  }

  /// Возвращает дополнительную информацию о треке (например микроклип, текст песни итд)
  Future<Map<String, dynamic>> getAdditionalInfo(
    String trackId, {
    CancelToken? cancelToken,
  }) async {
    var info = await api.getAdditionalInformationOfTrack(
      _parentClass.accountID,
      trackId,
      cancelToken: cancelToken,
    );
    return info['result'];
  }

  /// Возвращает список похожих треков на определенный трек
  Future<List<Track>> getSimilar(
    String trackId, {
    CancelToken? cancelToken,
  }) async {
    var similar = await api.getSimilarTracks(
      _parentClass.accountID,
      trackId,
      cancelToken: cancelToken,
    );

    return similar['result']['similarTracks'] != null
        ? (similar['result']['similarTracks'] as List)
              .map((t) => Track(t))
              .toList()
        : <Track>[];
  }

  /// Выдает полную информацию о треках
  Future<List<Track>> getTracks(
    List trackIds, {
    CancelToken? cancelToken,
  }) async {
    var tracks = await api.getTracks(
      _parentClass.accountID,
      trackIds,
      cancelToken: cancelToken,
    );
    return tracks != null
        ? (tracks['result'] as List).map((t) => Track(t)).toList()
        : <Track>[];
  }

  // #ffffff

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
  Future<Lyrics> getLyrics(
    String trackId, {
    LyricsFormat? format,
    CancelToken? cancelToken,
  }) async {
    format ??= LyricsFormat.onlyText;
    var result = await api.getTrackLyrics(
      trackId,
      _parentClass.accountID,
      format.value,
      cancelToken: cancelToken,
    );
    return Lyrics(result['result']);
  }
}