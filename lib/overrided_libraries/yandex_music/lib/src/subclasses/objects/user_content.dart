import 'dart:typed_data';
import 'package:yandex_music/yandex_music.dart';
import 'package:yandex_music/src/lower_level.dart';

class YandexMusicUserTracks {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicUserTracks(this._parentClass, this.api);

  /// Returns all the user's disliked tracks
  Future<List<ShortTrack>> getDisliked({CancelToken? cancelToken}) async {
    var dislikedTracks = await api.getUsersDislikedTracks(
      _parentClass.accountID,
      cancelToken: cancelToken,
    );
    List result = dislikedTracks['result']['library']['tracks'];
    return result
        .map((track) => ShortTrack(track as Map<String, dynamic>))
        .toList();
  }

  /// Returns all the user's liked tracks
  Future<List<ShortTrack>> getLiked({CancelToken? cancelToken}) async {
    var likedTracks = await api.getUsersLikedTracks(
      _parentClass.accountID,
      cancelToken: cancelToken,
    );
    List result = likedTracks['result']['library']['tracks'];
    return result
        .map((track) => ShortTrack(track as Map<String, dynamic>))
        .toList();
  }

  /// Marks tracks as liked
  ///
  /// If the track was already in your favorites, it will rise to index 0
  ///
  /// Returns the current revision of the playlist of liked tracks
  Future<int> like(List trackIds, {CancelToken? cancelToken}) async {
    var responce = await api.likeTracks(
      _parentClass.accountID,
      trackIds,
      cancelToken: cancelToken,
    );
    return responce['result']['revision'];
  }

  /// Removes tracks from favorites
  ///
  /// Returns the current revision of the playlist of your favorite tracks
  Future<int> unlike(List trackIds, {CancelToken? cancelToken}) async {
    var responce = await api.unlikeTracks(
      _parentClass.accountID,
      trackIds,
      cancelToken: cancelToken,
    );
    return responce['result']['revision'];
  }

  /// Removes a track from recommendations
  ///
  /// Returns the current revision of the playlist of ... idk
  Future<int> dislike(String trackId, {CancelToken? cancelToken}) async {
    var responce = await api.dislikeTracks(
      _parentClass.accountID,
      trackId,
      cancelToken: cancelToken,
    );
    return responce['result']['revision'];
  }

  /// Returns the track to recommendations
  ///
  /// Returns the current revision of the playlist of ... idk
  Future<int> removeFromDisliked(
    String trackId, {
    CancelToken? cancelToken,
  }) async {
    var responce = await api.removeFromDislikedTracks(
      _parentClass.accountID,
      trackId,
      cancelToken: cancelToken,
    );
    return responce['result']['revision'];
  }

  /// Returns a list with all of the user's playlists along with the tracks inside
  ///
  /// Similar to ```ymInstance.playlists.getPlaylistsWithLikes```
  Future<List<PlaylistWShortTracks>> getPlaylistsWithLikes({
    CancelToken? cancelToken,
  }) async {
    bool addPlaylistWithLikes = true;
    var playlists = await api.getUsersPlaylists(
      _parentClass.accountID,
      addPlaylistWithLikes: addPlaylistWithLikes,
      cancelToken: cancelToken,
    );

    List<PlaylistWShortTracks> result = playlists != null
        ? (playlists['result'] as List)
              .map((t) => PlaylistWShortTracks(t))
              .toList()
        : <PlaylistWShortTracks>[];

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

  /// Renames a user uploaded track
  /// ```
  /// If trackId/title/artist is incorrect - 400 BadRequest exception
  /// If successful - True
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

  /// Uploads your track to Yandex
  ///
  /// Returns a string with trackID
  ///
  /// Usage:
  /// ```dart
  /// File file = File(r'ourFile.flac');
  /// final newTrackId = await ym.usertracks.upload(1000, file); // You can also specify a playlist with your favorite tracks - Kind 3
  /// final info = await ym.tracks.getTracks([newTrackId]);
  /// print('${info[0].title} ${info[0].id}');
  /// ```
  ///
  /// After use, rename the track if there was no metadata there
  /// ```dart
  /// await ymInstance.usertracks.rename(result, 'Рыжая продавщица', 'Пророк СанБой')
  /// ```
  Future<dynamic> uploadUGCTrack(
    int kind,
    Uint8List file,
    String fileName, {
    CancelToken? cancelToken,
  }) async {
    String playlistId = '${_parentClass.accountID}:$kind';
    var result = await api.getUploadLink(
      _parentClass.accountID,
      fileName,
      playlistId,
      cancelToken: cancelToken,
    );

    await api.uploadFile(result['post-target'], file, fileName, cancelToken: cancelToken);

    return result['ugc-track-id'];
  }
}
