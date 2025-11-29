import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:yandex_music/src/signs/signs.dart';
import './requests/requests.dart';
import 'dart:io';

class YandexMusicApiAsync {
  final String token;

  static const baseUrl = 'https://api.music.yandex.net';

  final dio = Dio(BaseOptions(validateStatus: (status) => true));

  late final Requests requests;

  YandexMusicApiAsync({required this.token}) {
    requests = Requests(token: token);
  }

  /// Provides full information about the user account
  Future<Map<String, dynamic>> getAccountInformation() async {
    final response = await requests.basicGet('/account/status');
    return response;
  }

  Future<Map<String, dynamic>> getAccountSettings() async {
    final response = await requests.basicGet('/account/settings');
    return response;
  }

  Future<dynamic> getUsersPlaylists(
    int userId, [
    bool? addPlaylistWithLikes,
  ]) async {
    if (addPlaylistWithLikes != null) {
      final responce = await requests.basicGet(
        '/users/$userId/playlists/list/kinds?addPlaylistWithLikes=true',
      );
      final result = getMultiplePlaylists(userId, responce['result']);
      return result;
    }

    final responce = await requests.basicGet(
      '/users/$userId/playlists/list',
    );
    return responce;
  }

  Future<dynamic> getUsersDislikedTracks(int userId) async {
    final response = await requests.basicGet(
      '/users/$userId/dislikes/tracks',
    );
    return response;
  }

  Future<dynamic> getPlaylist(int userId, int playlistKind) async {
    final responce = await requests.basicGet(
      '/users/$userId/playlists/$playlistKind',
    );
    return responce;
  }

  Future<dynamic> getMultiplePlaylists(int userId, List kinds) async {
    final responce = await requests.customGet(
      '/users/$userId/playlists',
      {
        'userId': userId,
        'kinds': kinds.join(','),
        'mixed': true,
        'rich-tracks': false,
      },
    );
    return responce;
  }

  Future<dynamic> moveTrack(
    int userId,
    int kind,
    int from,
    int to,
    List tracks,
    int revision,
  ) async {
    final diffString = jsonEncode([
      {"op": "move", "from": from, "to": to, "tracks": tracks},
    ]);
    final data = {
      'revision': revision.toString(),
      'diff': diffString,
    };
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/change-relative',
      null,
      data,
    );



    return responce;
  }

  Future<dynamic> renameTrack(
    String trackId,
    String trackName,
    String artist,
    [String? contentType]
  ) async {
    var data = {'title': trackName, 'artist': artist};

    final responce = await requests.post(
      '/ugc/tracks/$trackId/change',
      null,
      data,
      contentType
    );

    return responce;
  }

  Future<dynamic> getPlaylistRecommendations(
    int userId,
    int playlistKind,
  ) async {
    final responce = await requests.basicGet(
      '/users/$userId/playlists/$playlistKind/recommendations',
    );
    return responce;
  }

  Future<dynamic> getUsersLikedTracks(int userId) async {
    final responce = await requests.basicGet('/users/$userId/likes/tracks');
    return responce;
  }

  Future<dynamic> getTrackDownloadInfo(int userId, String trackID) async {
    final responce = await requests.basicGet(
      '/tracks/$trackID/download-info',
    );
    return responce;
  }

  Future<dynamic> getTrackDownloadLink(String downloadInfoUrl) async {
    // final responce = await requests.customUrlRequest(downloadInfoUrl);
    final responce = await requests.basicGet('route', downloadInfoUrl);
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
    String requestedQuality,
  ) async {
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
      'https://api.music.yandex.net/get-file-info',
      headerss,
    );
    return request;
  }

  Future<dynamic> getTrackLyrics(
    String trackId,
    int userId,
    String format,
  ) async {
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
      'https://api.music.yandex.net/tracks/$trackId/lyrics',
      headerss,
    );
    return responce;
  }

  Future<dynamic> downloadTrack(String downloadLink) async {
    final responce = await requests.basicGet(
      'route',
      downloadLink,
      ResponseType.bytes,
    );
    return responce;

    // try {
    //   final response = await dio.get(
    //     downloadLink,
    //     options: Options(
    //       headers: {
    //         'Authorization': 'OAuth $token',
    //       },
    //       responseType: ResponseType.bytes,
    //     ),
    //   );

    //   if (response.statusCode != 200) {
    //     throw YandexMusicRequestException(
    //       'Request Failed. Error: ${response.statusMessage}',
    //       code: response.statusCode,
    //     );
    //   } else {
    //     await trackFile.writeAsBytes(response.data);
    //   }
    // } on DioException catch (e) {
    //   throw YandexMusicNetworkException(
    //     'Request Failed. Network Error: ${e.message}',
    //     code: e.response?.statusCode,
    //   );
    // }
  }

  Future<dynamic> getAdditionalInformationOfTrack(
    int userId,
    String trackID,
  ) async {
    final responce = await requests.basicGet('/tracks/$trackID/supplement');
    return responce;
  }

  Future<dynamic> getSimilarTracks(int userId, String trackID) async {
    final responce = await requests.basicGet('/tracks/$trackID/similar');
    return responce;
  }

  Future<dynamic> getTracks(int userId, List trackIds) async {
    final responce = await requests.customGet('/tracks', {
      'track-ids': trackIds,
      'with-positions': 'false',
    });
    return responce;
  }

  Future<dynamic> search(
    String query,
    int page,
    String type,
    bool noCorrect,
  ) async {
    final responce = await requests.customGet('/search', {
      'text': query,
      'page': page,
      'type': type,
      'nocorrect': noCorrect,
    });
    return responce;
  }

  // ohhh.. okay... ill doit

  // Post requests entertainment

  Future<dynamic> createPlaylist(
    int userId,
    String title,
    String visibility,
  ) async {
    final responce = await requests.post(
      '/users/$userId/playlists/create',
      {'title': title, 'visibility': visibility},
    );
    return responce;
  }

  Future<dynamic> renamePlaylist(int userId, int kind, String newName) async {
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/name',
      {'value': newName},
    );
    return responce;
  }

  Future<dynamic> deletePlaylist(int userId, int kind) async {
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/delete',
    );
    return responce;
  }
  // Сюда было потрачено > 5-6 часов реального времени. питон рулит

  Future<dynamic> addTracksToPlaylist(
    int userId,
    int kind,
    List<Map<String, dynamic>> tracks,
    int revision, [
    int? at,
  ]) async {
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
      null,
      data,
    );
    return responce;
  }

  Future<dynamic> insertTrackIntoPlaylist(
    int userId,
    int kind,
    String trackId,
    String albumId,
    int revision, [
    int? at,
  ]) async {
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
      null,
      data,
    );
    return responce;
  }

  Future<dynamic> deleteTracksFromPlaylist(
    int userId,
    int kind,
    int from,
    int to,
    int revision,
  ) async {
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
      null,
      data,
    );

    return responce;
  }

  Future<dynamic> changeVisibility(
    int userId,
    int kind,
    String visibility,
  ) async {
    final responce = await requests.post(
      '/users/$userId/playlists/$kind/visibility',
      null,
      {'value': visibility},
    );
    return responce;
  }

  Future<dynamic> likeTracks(int userId, List trackIds) async {
    final responce = await requests.post(
      '/users/$userId/likes/tracks/add-multiple',
      null,
      {'track-ids': trackIds},
    );
    return responce;
  }

  Future<dynamic> unlikeTracks(int userId, List trackIds) async {
    final responce = await requests.post(
      '/users/$userId/likes/tracks/remove',
      null,
      {'track-ids': trackIds},
    );
    return responce;
  }

  Future<dynamic> getPlaylistsInformation(List playlistIds) async {
    final responce = await requests.post('/playlists/list', null, {
      'playlistIds': playlistIds,
    });
    return responce;
  }

  Future<dynamic> getAlbum(int albumId) async {
    final responce = await requests.basicGet('/albums/$albumId');
    return responce;
  }

  Future<dynamic> getAlbumWithTracks(int albumId) async {
    final responce = await requests.basicGet(
      '/albums/$albumId/with-tracks',
    );
    return responce;
  }

  Future<dynamic> getAlbums(List albumIds) async {
    final responce = await requests.post('/albums', null, {
      'album-ids': albumIds,
    });
    return responce;
  }

  Future<dynamic> getLangingBlocks() async {
    final responce = await requests.customGet('/landing3', {
      'blocks':
          'personalplaylists,promotions,new-releases,new-playlists,mixes,chart,artists,albums,playlists,play_contexts,podcasts',
    });
    return responce;
  }

  Future<dynamic> getBlock(String block) async {
    final responce = await requests.customGet('/landing3/$block', {
      'blocks': block,
    });
    return responce;
  }

  Future<dynamic> put(String route, Map<String, dynamic> body, [String? fullRoute]) async {
    final response = await requests.put(route, body, fullRoute);
    return response;
  }

  Future<dynamic> delete(String route, Map<String, dynamic> body, [String? fullRoute]) async {
    final response = await requests.delete(route, body, fullRoute);
    return response;
  }

  // Future<dynamic> getUploadLink(String )

  Future<dynamic> getUploadLink(
    int userId,
    String fileName,
    String playlistId,
  ) async {
    // Map<String, dynamic> headerss = {
    //   'Authorization': 'OAuth $token',
    //   'Content-Type': 'application/json',
    //   'User-Agent': 'YandexMusicAPI/1.0.0',
    //   'x-yandex-music-client': 'YandexMusicWebNext/1.0.0',
    //   'x-yandex-music-without-invocation-info': '1',
    //   'x-yandex-music-multi-auth-user-id': '$userId',
    //   'Referer': 'https://music.yandex.ru/',
    //   'Origin': 'https://music.yandex.ru',
    // };

    final response = await requests.post(
      '/loader/upload-url',
      {'uid': '$userId', 'playlist-id': playlistId, 'path': fileName},
      '/loader/upload-url',
      // headerss,
    );

    return response;
  }

  Future<Response> uploadFile(String url, File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    return await dio.post(
      url,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}
