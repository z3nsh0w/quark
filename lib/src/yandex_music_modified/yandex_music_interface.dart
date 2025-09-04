// import 'dart:js_interop';

import 'dart:convert';

import 'package:yandex_music/yandex_music.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// legacy...

/// Интерфейс который соединияет кастомные функции с основной библиотекой yandex_music
/// 
/// Требует уже инициализированный экземпляр класса
class YandexMusicInterface {
  final YandexMusic yandexMusicInstance;
  static const String imageSize = '300x300';
  static const String likedPlaylistPictureUrl =
      'https://avatars.yandex.net/get-music-user-playlist/11418140/favorit-playlist-cover.bb48fdb9b9f4/$imageSize';
  static const String noArt = 'raw.githubusercontent.com/z3nsh0w/z3nsh0w.github.io/refs/heads/master/no.png';

  YandexMusicInterface(this.yandexMusicInstance);

  Future<List> getUsersPlaylists() async {
    final responce = await yandexMusicInstance.playlists.getUsersPlaylists();
    print('responsed');
    List playlists = [];
    playlists.add({
      'title': 'Liked',
      'picture': likedPlaylistPictureUrl,
      'accountUuid': yandexMusicInstance.accountID,
      'accountToken': yandexMusicInstance.token,
    });

    for (var playlist in responce) {
      
    var coverInfo = playlist['cover'];
    var cover = noArt;

    String? type = coverInfo['type'];
    if (type == 'pic' && coverInfo['uri'] != null) {
      String uri = coverInfo['uri'].toString();
      cover = 'https://${uri.replaceAll('%%', imageSize)}';
    } else if (type == 'mosaic' && coverInfo['itemsUri'] != null) {
      List<dynamic> itemsUri = coverInfo['itemsUri'];
      if (itemsUri.isNotEmpty) {
        String firstUri = itemsUri[0].toString();
        cover = 'https://${firstUri.replaceAll('%%', imageSize)}';
      }
    }
      int duration = playlist['durationMs'];
      Map<String, dynamic> playlistData = {
        'playlistUuid': playlist['playlistUuid'],
        'available': playlist['available'],
        'title': playlist['title'],
        'trackCount': playlist['trackCount'],
        'visibility': playlist['visibility'],
        'duration': duration,
        'picture': cover,
        'accountUuid': yandexMusicInstance.accountID,
        'accountToken': yandexMusicInstance.token,
        'kind': playlist['kind'],
        'owner': playlist['owner']['uid']
      };
      playlists.add(playlistData);
    }
    return playlists;
  }

  Future<List> getPlaylist(int kind) async {
    List result = [];
    var playlist = await yandexMusicInstance.playlists.getPlaylist(kind);

    for (var track in playlist['tracks']) {
      var cover = noArt;
      if (track['track']['coverUri'] != null) {
        cover = track['track']['coverUri'].toString().replaceAll(
          "%%",
          "300x300",
        );
      }
      Map b = {
        'id': track['id'].toString(),
        'title': track['track']['title'] ?? '',
        'cover': cover,
        'artists':
            track['track']['artists'].isNotEmpty
                ? track['track']['artists'][0]['name']
                : 'Unknown',
      };
      result.add(b);
    }
    return result;
  }

  Future<String> getTrackDownloadLink(String trackId) async {
    var link = await yandexMusicInstance.tracks.autoGetTrackLink(trackId);
    return link;
  }

  Future<bool> downloadTrack(
    String filenameWithFilepath,
    String trackId, [
    String? downloadUrl,
  ]) async {
    List<int> responce = [];
    if (downloadUrl != null) {
      responce = await yandexMusicInstance.tracks.getTrackAsBytes(downloadUrl);
    } else {
      responce = await yandexMusicInstance.tracks.autoDownloadTrack(trackId);
    }

    final file = File(filenameWithFilepath);
    await file.writeAsBytes(responce);
    return true;
  }

  Future<List> getTracks(List trackIds) async {
    var track = await yandexMusicInstance.tracks.getTracks(trackIds);
    List tracks = [];
    for (var track in track) {
      var cover = noArt;

      if (track['coverUri'] != null) {
        cover = track['coverUri'].toString().replaceAll("%%", "300x300");
      }

      Map b = {
        'id': track['id'].toString(),
        'title': track['title'] ?? '',
        'cover': cover,
        'artists':
            track['artists'].isNotEmpty
                ? track['artists'][0]['name']
                : 'Unknown',
      };
      tracks.add(b);
    }
    return tracks;
  }

  Future<List> getLikedSongs() async {
    List query = [];
    List output = [];
    var tracks = await yandexMusicInstance.usertracks.getLikedTracks();
    for (var track in tracks) {
      query.add(track['id'].toString());
    }
    output = await getTracks(query);
    return output;
  }

  Future<List> downloadFirstTracksFromAllUsersPlaylistsIntoTempFolder() async {
    var playlists = await getUsersPlaylists();
    playlists.removeAt(0);

    var likedSongs = await getLikedSongs();
    var tempDirectory = await getApplicationCacheDirectory();

    var tempDir = tempDirectory.path;

    String filename =
        '${tempDir}/quarkaudiotemptrack${likedSongs[0]['id']}.mp3';
    var trackfile = File(filename);
    bool exist = await trackfile.exists();
    if (!exist) {
      downloadTrack(filename, likedSongs[0]['id']);
    }

    for (var playlist in playlists) {
      var onValue = await getPlaylist(playlist['kind']);

      var tempDir = tempDirectory.path;

      String filename = '${tempDir}/quarkaudiotemptrack${onValue[0]['id']}.mp3';
      var trackfile = File(filename);
      bool exist = await trackfile.exists();
      if (!exist) {
        downloadTrack(filename, onValue[0]['id']);
      }
    }

    return [];
  }
}
