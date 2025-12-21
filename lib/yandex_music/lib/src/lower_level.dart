import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import './requests/requests.dart';
import 'package:xml/xml.dart' as xml;
import 'package:yandex_music/src/signs/signs.dart';
import 'package:yandex_music/src/objects/wave.dart';
import 'package:yandex_music/src/objects/track.dart';

// Yup, That's Me.
// You're probably wondering how I ended up in this situation

class YandexMusicApiAsync {
  final String token;

  static const baseUrl = 'https://api.music.yandex.net';

  final dio = Dio(BaseOptions(validateStatus: (status) => true));

  late final Requests requests;

  YandexMusicApiAsync({required this.token}) {
    requests = Requests(token: token);
  }

  Future<Map<String, dynamic>> getAccountInformation({
    CancelToken? cancelToken,
  }) async {
    final response = await requests.basicGet('/account/status');
    return response;
  }

  Future<Map<String, dynamic>> getAccountSettings({
    CancelToken? cancelToken,
  }) async {
    final response = await requests.basicGet(
      '/account/settings',
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<dynamic> getUsersPlaylists(
    int userId, {
    bool? addPlaylistWithLikes,
    CancelToken? cancelToken,
  }) async {
    if (addPlaylistWithLikes != null) {
      final responce = await requests.basicGet(
        '/users/$userId/playlists/list/kinds?addPlaylistWithLikes=true',
        cancelToken: cancelToken,
      );
      final result = getMultiplePlaylists(userId, responce['result']);
      return result;
    }

    final responce = await requests.basicGet(
      '/users/$userId/playlists/list',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getUsersDislikedTracks(
    int userId, {
    CancelToken? cancelToken,
  }) async {
    final response = await requests.basicGet(
      '/users/$userId/dislikes/tracks',
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<dynamic> getPlaylist(
    int userId,
    int playlistKind, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.basicGet(
      '/users/$userId/playlists/$playlistKind',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getMultiplePlaylists(
    int userId,
    List kinds, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.customGet('/users/$userId/playlists', {
      'userId': userId,
      'kinds': kinds.join(','),
      'mixed': true,
      'rich-tracks': false,
    }, cancelToken: cancelToken);
    return responce;
  }

  Future<dynamic> moveTrack(
    int userId,
    int kind,
    int from,
    int to,
    List tracks,
    int revision, {
    CancelToken? cancelToken,
  }) async {
    final diffString = jsonEncode([
      {"op": "move", "from": from, "to": to, "tracks": tracks},
    ]);
    final data = {'revision': revision.toString(), 'diff': diffString};
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/change-relative',
      data: data,
      cancelToken: cancelToken,
    );

    return responce;
  }

  Future<dynamic> renameTrack(
    String trackId,
    String trackName,
    String artist, {
    String? contentType,
    CancelToken? cancelToken,
  }) async {
    var data = {'title': trackName, 'artist': artist};

    final responce = await requests.post(
      '/ugc/tracks/$trackId/change',
      data: data,
      contentType: contentType,
      cancelToken: cancelToken,
    );

    return responce;
  }

  Future<dynamic> getPlaylistRecommendations(
    int userId,
    int playlistKind, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.basicGet(
      '/users/$userId/playlists/$playlistKind/recommendations',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getUsersLikedTracks(
    int userId, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.basicGet(
      '/users/$userId/likes/tracks',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getTrackDownloadInfo(
    int userId,
    String trackID, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.basicGet(
      '/tracks/$trackID/download-info',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getTrackDownloadLink(String downloadInfoUrl) async {
    // final responce = await requests.customUrlRequest(downloadInfoUrl);
    final responce = await requests.basicGet(
      'route',
      fullRoute: downloadInfoUrl,
    );
    final xmlDoc = xml.XmlDocument.parse(responce.toString());

    final host = xmlDoc.findAllElements('host').first.text;
    final path = xmlDoc.findAllElements('path').first.text;
    final ts = xmlDoc.findAllElements('ts').first.text;
    final sign = getMp3Sign(xmlDoc: xmlDoc);

    final directLink = 'https://$host/get-mp3/$sign/$ts$path';
    return directLink;
  }

  Future<dynamic> getTrackDownloadLinkV2(
    String trackId,
    int userId,
    String requestedQuality, {
    CancelToken? cancelToken,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    List<String> codecs = [
      'flac',
      'aac',
      'he-aac',
      'mp3',
      'flac-mp4',
      'aac-mp4',
      'he-aac-mp4',
    ];
    String quality = requestedQuality.toString();
    String transport = 'raw';
    var sign = getFileInfoSign(
      trackId: trackId,
      quality: quality,
      codecs: codecs,
      transport: transport,
      timestamp: timestamp,
    );
    print(codecs.join(','));

    Map<String, dynamic> query = {
      'ts': timestamp,
      'trackId': trackId,
      'quality': quality,
      'codecs': codecs.join(','),
      'transports': transport,
      'sign': sign,
    };

    Map<String, dynamic> headerss = {
      'Authorization': 'OAuth $token',
      'Content-Type': 'application/json',
      'User-Agent': 'YandexMusicAPI/1.0.0',
      'x-yandex-music-client': 'YandexMusicWebNext/1.0.0',
      'x-yandex-music-without-invocation-info': '1',
      'x-yandex-music-multi-auth-user-id': '$userId',
      'Referer': 'https://music.yandex.ru/',
      'Origin': 'https://music.yandex.ru',
    };
    var request = await requests.customGet(
      '/get-file-info',
      query,
      fullRoute: 'https://api.music.yandex.net/get-file-info',
      headers: headerss,
      cancelToken: cancelToken,
    );
    return request;
  }

  Future<dynamic> getTrackLyrics(
    String trackId,
    int userId,
    String format, {
    CancelToken? cancelToken,
  }) async {
    final sign = getLyricsSign(trackId: trackId);

    Map<String, dynamic> headerss = {
      'Authorization': 'OAuth $token',
      'X-Yandex-Music-Client': 'YandexMusicAndroid/24023621',
      'Accept-Language': 'ru',
      'User-Agent': 'Yandex-Music-API',
    };

    var responce = await requests.customGet(
      '/tracks/$trackId/lyrics',
      {
        'format': format,
        'timeStamp': sign['timestamp'],
        'sign': sign['signature'],
      },
      fullRoute: 'https://api.music.yandex.net/tracks/$trackId/lyrics',
      headers: headerss,
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> downloadTrack(
    String downloadLink, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.basicGet(
      'route',
      fullRoute: downloadLink,
      responceType: ResponseType.bytes,
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getAdditionalInformationOfTrack(
    int userId,
    String trackID, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.basicGet(
      '/tracks/$trackID/supplement',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getSimilarTracks(
    int userId,
    String trackID, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.basicGet(
      '/tracks/$trackID/similar',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getTracks(
    int userId,
    List trackIds, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.customGet('/tracks', {
      'track-ids': trackIds,
      'with-positions': 'false',
    }, cancelToken: cancelToken);
    return responce;
  }

  Future<dynamic> search(
    String query,
    int page,
    String type,
    bool noCorrect, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.customGet('/search', {
      'text': query,
      'page': page,
      'type': type,
      'nocorrect': noCorrect,
    }, cancelToken: cancelToken);
    return responce;
  }

  // ohhh.. okay... ill doit

  // Post requests entertainment

  Future<dynamic> createPlaylist(
    int userId,
    String title,
    String visibility, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.post(
      '/users/$userId/playlists/create',
      queryParameters: {'title': title, 'visibility': visibility},
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> renamePlaylist(
    int userId,
    int kind,
    String newName, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/name',
      queryParameters: {'value': newName},
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> deletePlaylist(
    int userId,
    int kind, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/delete',
      cancelToken: cancelToken,
    );
    return responce;
  }
  // Сюда было потрачено > 5-6 часов реального времени. питон рулит

  Future<dynamic> addTracksToPlaylist(
    int userId,
    int kind,
    List<Map<String, dynamic>> tracks,
    int revision, {
    int? at,
    CancelToken? cancelToken,
  }) async {
    at ??= 0;
    final diffString = jsonEncode([
      {"op": "insert", "at": at, "tracks": tracks},
    ]);
    final data = {
      'kind': kind.toString(),
      'revision': revision.toString(),
      'diff': diffString,
    };
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/change',
      data: data,
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> insertTrackIntoPlaylist(
    int userId,
    int kind,
    String trackId,
    String albumId,
    int revision, {
    int? at,
    CancelToken? cancelToken,
  }) async {
    at ??= 0;
    List tracks = [
      {"id": trackId, albumId: albumId},
    ];
    final diffString = jsonEncode([
      {"op": "insert", "at": at, "tracks": tracks},
    ]);
    final data = {
      'kind': kind.toString(),
      'revision': revision.toString(),
      'diff': diffString,
    };
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/change',
      data: data,
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> deleteTracksFromPlaylist(
    int userId,
    int kind,
    int from,
    int to,
    int revision, {
    CancelToken? cancelToken,
  }) async {
    final diffString = jsonEncode([
      {"op": "delete", "from": from, "to": to},
    ]);
    final data = {
      'kind': kind.toString(),
      'revision': revision.toString(),
      'diff': diffString,
    };
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/change',
      data: data,
      cancelToken: cancelToken,
    );

    return responce;
  }

  Future<dynamic> changeVisibility(
    int userId,
    int kind,
    String visibility, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/visibility',
      queryParameters: {'value': visibility},
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> likeTracks(
    int userId,
    List trackIds, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.post(
      '/users/$userId/likes/tracks/add-multiple',
      queryParameters: {'track-ids': trackIds},
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> unlikeTracks(
    int userId,
    List trackIds, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.post(
      '/users/$userId/likes/tracks/remove',
      queryParameters: {'track-ids': trackIds},
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getPlaylistsInformation(
    List playlistIds, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.post(
      '/playlists/list',
      data: {'playlistIds': playlistIds},
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getAlbum(int albumId, {CancelToken? cancelToken}) async {
    final responce = await requests.basicGet(
      '/albums/$albumId',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getAlbumWithTracks(
    int albumId, {
    CancelToken? cancelToken,
  }) async {
    final responce = await requests.basicGet(
      '/albums/$albumId/with-tracks',
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getAlbums(List albumIds, {CancelToken? cancelToken}) async {
    final responce = await requests.post(
      '/albums',
      data: {'album-ids': albumIds},
      cancelToken: cancelToken,
    );
    return responce;
  }

  Future<dynamic> getLangingBlocks({CancelToken? cancelToken}) async {
    final responce = await requests.customGet('/landing3', {
      'blocks':
          'personalplaylists,promotions,new-releases,new-playlists,mixes,chart,artists,albums,playlists,play_contexts,podcasts',
    }, cancelToken: cancelToken);
    return responce;
  }

  Future<dynamic> getBlock(String block, {CancelToken? cancelToken}) async {
    final responce = await requests.customGet('/landing3/$block', {
      'blocks': block,
    }, cancelToken: cancelToken);
    return responce;
  }

  Future<dynamic> put(
    String route,
    Map<String, dynamic> body, {
    String? fullRoute,
    CancelToken? cancelToken,
  }) async {
    final response = await requests.put(
      route,
      body,
      customRoute: fullRoute,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<dynamic> delete(
    String route,
    Map<String, dynamic> body, {
    String? fullRoute,
    CancelToken? cancelToken,
  }) async {
    final response = await requests.delete(
      route,
      body,
      customRoute: fullRoute,
      cancelToken: cancelToken,
    );
    return response;
  }

  // Future<dynamic> getUploadLink(String )

  Future<dynamic> getUploadLink(
    int userId,
    String fileName,
    String playlistId, {
    CancelToken? cancelToken,
  }) async {

    final response = await requests.post(
      '/loader/upload-url',
      queryParameters: {
        'uid': '$userId',
        'playlist-id': playlistId,
        'path': fileName,
      },
      data: '/loader/upload-url',
      cancelToken: cancelToken,
    );

    return response;
  }

  Future<Response> uploadFile(
    String url,
    File file, {
    CancelToken? cancelToken,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    return await dio.post(
      url,
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      cancelToken: cancelToken,
    );
  }

  Future<dynamic> getAvailableSettings() async {
    return await requests.basicGet('/rotor/wave/settings');
  }

  Future<dynamic> createWave(
    List seeds, {
    bool? includeTracksInResponce,
    bool? includeWaveModel,
    bool? interactive,
    List? queue,
  }) async {
    return await requests.post(
      '/rotor/session/new',
      data: {
        'includeTracksInResponse': includeTracksInResponce ??= true,
        'includeWaveModel': includeWaveModel ??= true,
        'interactive': interactive ??= true,
        'queue': queue ??= [],
        'seeds': seeds,
      },
    );
  }

  Future<dynamic> trackFinishedFeedback(
    Wave wave,
    List<Track> queue,
    double totalPlayedSeconds,
    Track track,
  ) async {
    await _feedbacker(wave, queue, totalPlayedSeconds, track, 'trackFinished');
  }

  Future<dynamic> skipFeedback(
    Wave wave,
    List<Track> queue,
    double totalPlayedSeconds,
    Track track,
  ) async {
    await _feedbacker(wave, queue, totalPlayedSeconds, track, 'skip');
  }

  Future<dynamic> trackStartedFeedBack(Wave wave, Track track) async {
    final timestamp = DateTime.now().toUtc().toIso8601String();
    return await requests.post(
      '/rotor/session/${wave.sessionId}/feedback',
      data: {
        'batchId': wave.batchId,
        'from': 'web-home-rup_main-radio-default',
        'event': {
          'timestamp': timestamp,
          'trackId': '${track.id}:${track.albums[0].id}',
          'type': 'trackStarted',
        },
      },
    );
  }

  Future<dynamic> _feedbacker(
    Wave wave,
    List<Track> queue,
    double totalPlayedSeconds,
    Track track,
    String feedbackType,
  ) async {
    List<String> b = queue.map((e) => '${e.id}:${e.albums[0].id}').toList();
    final timestamp = DateTime.now().toUtc().toIso8601String();

    return await requests.post(
      '/rotor/session/${wave.sessionId}/tracks',
      data: {
        'queue': b,
        'feedbacks': [
          {
            'batchId': wave.batchId,
            'from': 'web-home-rup_main-radio-default',
            'event': {
              'timestamp': timestamp,
              'type': feedbackType,
              'totalPlayedSeconds': totalPlayedSeconds,
              'trackId': '${track.id}:${track.albums[0].id}',
            },
          },
        ],
      },
    );
  }
}
