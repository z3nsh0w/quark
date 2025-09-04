import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart' as xml;
import 'package:crypto/crypto.dart';
import './requests/requests.dart';

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
    final response = await requests.basicRequest('/account/status');
    return response; 
  }

  Future<Map<String, dynamic>> getAccountSettings() async {
    final response = await requests.basicRequest('/account/settings');
    return response;
  }

  Future<dynamic> getUsersPlaylists(int userId) async {
    final responce = await requests.basicRequest('/users/$userId/playlists/list');
    return responce;
  }

  Future<dynamic> getUsersDislikedTracks(int userId) async {
    final response = await requests.basicRequest('/users/$userId/dislikes/tracks');
    return response;

  }

  Future<dynamic> getPlaylist(int userId, int playlistKind) async {
    final responce = await requests.basicRequest('/users/$userId/playlists/$playlistKind');
    return responce;
  }

  Future<dynamic> getMultiplePlaylists(int userId, List kinds) async {
    final responce = await requests.requestWithParameters('/users/$userId/playlists', {
          'userId': userId,
          'kinds': kinds.join(','),
          'mixed': true,
          'rich-tracks': false,
        });
    return responce;
  }

  Future<dynamic> getPlaylistRecommendations(int userId, int playlistKind) async {
    final responce = await requests.basicRequest('/users/$userId/playlists/$playlistKind/recommendations');
    return responce;
  }

  Future<dynamic> getUsersLikedTracks(int userId) async {
    final responce = await requests.basicRequest('/users/$userId/likes/tracks');
    return responce;
  }

  Future<dynamic> getTrackDownloadInfo(int userId, String trackID) async {
    final responce = await requests.basicRequest('/tracks/$trackID/download-info');
    return responce;
  }

  Future<dynamic> getTrackDownloadLink(String downloadInfoUrl) async {
    final responce = await requests.customUrlRequest(downloadInfoUrl);
    final xmlDoc = xml.XmlDocument.parse(responce.toString());

    final host = xmlDoc.findAllElements('host').first.text;
    final path = xmlDoc.findAllElements('path').first.text;
    final ts = xmlDoc.findAllElements('ts').first.text;
    final s = xmlDoc.findAllElements('s').first.text;

    const signSalt = 'XGRlBW9FXlekgbPrRHuSiA';
    final signData = signSalt + path.substring(1) + s;
    final signBytes = utf8.encode(signData);
    final sign = md5.convert(signBytes).toString();

    final directLink = 'https://$host/get-mp3/$sign/$ts$path';
    return directLink;
  }

  Future<dynamic> downloadTrack(String downloadLink) async {
    final responce = await requests.basicRequest('route', downloadLink, ResponseType.bytes);
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

  Future<dynamic> getAdditionalInformationOfTrack(int userId, String trackID) async {
    final responce = await requests.basicRequest('/tracks/$trackID/supplement');
    return responce;
  }

  Future<dynamic> getSimilarTracks(int userId, String trackID) async {
    final responce = await requests.basicRequest('/tracks/$trackID/similar');
    return responce;
  }

  Future<dynamic> getTracks(int userId, List trackIds) async {
    final responce = await requests.requestWithParameters('/tracks', {
          'track-ids': trackIds,
          'with-positions': 'false'
                  });
                  return responce;
  }

  Future<dynamic> search(String query, int page, String type, bool noCorrect, [CancelToken? cancelToken]) async {
    final responce = await requests.requestWithParameters('/search', {
          'text': query,
          'page': page,
          'type': type,
          'nocorrect': noCorrect,
                  }, cancelToken);
    return responce;
  }

  // ohhh.. okay... ill doit

  // Post requests entertainment

  Future<dynamic> createPlaylist(int userId, String title, String visibility) async {
    final responce = await requests.postRequest('/users/$userId/playlists/create', {
          'title': title,
          'visibility': visibility,
        });
    return responce;
  }

  Future<dynamic> renamePlaylist(int userId, int kind, String newName) async {
    final responce = await requests.postRequest('/users/$userId/playlists/$kind/name', {'value' : newName});
    return responce;
  }

  Future<dynamic> deletePlaylist(int userId, int kind) async {
    final responce = await requests.postRequest('/users/$userId/playlists/$kind/delete');
    return responce;
  }
// Сюда было потрачено > 5-6 часов реального времени. питон рулит

  Future<dynamic> addTracksToPlaylist(int userId, int kind, List<Map<String, dynamic>> tracks, int revision, [int? at]) async {
    at ??= 0;
    final diffString = jsonEncode([{"op": "insert", "at": at, "tracks": tracks}]);
    final data = {
      'kind': kind.toString(),
      'revision': revision.toString(),
      'diff': diffString,
    };
    final responce = await requests.postRequest('/users/$userId/playlists/$kind/change', null, data);
    return responce;
  }

  Future<dynamic> insertTrackIntoPlaylist(int userId, int kind, String trackId, String albumId, int revision, [int? at]) async {
    at ??= 0;
    List tracks = [
        {"id": trackId, albumId: albumId},
      ];
    final diffString = jsonEncode([{"op": "insert", "at": at, "tracks": tracks}]);
    final data = {
      'kind': kind.toString(),
      'revision': revision.toString(),
      'diff': diffString,
    };
    final responce = await requests.postRequest('/users/$userId/playlists/$kind/change', null, data);
    return responce;
  }

  Future<dynamic> deleteTracksFromPlaylist(int userId, int kind, String from, String to, String revision) async {
    final diffString = jsonEncode([{"op": "delete", "from": from, "to": to}]);
    final data = {
      'kind': kind.toString(),
      'revision': revision.toString(),
      'diff': diffString,
    };
    final responce = await requests.postRequest('/users/$userId/playlists/$kind/change', null, data);

    return responce;
  }

  Future<dynamic> changeVisibility(int userId, int kind, String visibility) async {
    final responce = await requests.postRequest('/users/$userId/playlists/$kind/visibility', null, {'value': visibility});
    return responce;
  }


  Future<dynamic> likeTracks(int userId, List trackIds) async {
    final responce = await requests.postRequest('/users/$userId/likes/tracks/add-multiple', null, {'track-ids': trackIds});
    return responce;

  }

  Future<dynamic> unlikeTracks(int userId, List trackIds) async {

    final responce = await requests.postRequest('/users/$userId/likes/tracks/remove', null, {'track-ids': trackIds});
    return responce;
  }


  Future<dynamic> getPlaylistsInformation(List playlistIds) async {
    final responce = await requests.postRequest('/playlists/list', null, {'playlistIds': playlistIds});
    return responce;

  }


  Future<dynamic> getAlbum(int albumId) async {
    final responce = await requests.basicRequest('/albums/$albumId');
    return responce;

  }


  Future<dynamic> getAlbumWithTracks(int albumId) async {
    final responce = await requests.basicRequest('/albums/$albumId/with-tracks');
    return responce;
  }

  Future<dynamic> getAlbums(List albumIds) async {
    final responce = await requests.postRequest('/albums', null, {'album-ids': albumIds});
    return responce;
  }

  Future<dynamic> getLangingBlocks() async {
    final responce = await requests.requestWithParameters('/landing3', {'blocks': 'personalplaylists,promotions,new-releases,new-playlists,mixes,chart,artists,albums,playlists,play_contexts,podcasts'});
    return responce;
  }

  Future<dynamic> getBlock(String block) async {
    final responce = await requests.requestWithParameters('/landing3/$block', {'blocks': block});
    return responce;
  }
}