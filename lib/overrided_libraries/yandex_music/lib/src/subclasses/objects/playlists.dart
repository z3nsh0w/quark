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
  /// ""
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

  /// Returns complete information along with the tracks about the playlist by its kind.
  ///
  /// If the playlist owner is different, you need to pass the userId of the playlist owner
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

  /// Returns complete information along with the tracks about the playlist by its Uuid.
    Future<Playlist> getPlaylistByUuid(
    String uuid, {
    CancelToken? cancelToken,
  }) async {
    var playlistInfo = await api.getAnotherPlaylist(
      uuid,
      cancelToken: cancelToken,
    );
    return Playlist(playlistInfo['result']);
  }

  /// Returns a list with all of the user's playlists
  ///
  /// Doesn't return playlist of favorite tracks
  ///
  /// To get the playlists you like, use
  ///  ```getPlaylistsWithLikes``` or ```getPlaylist[3] // 3 - kind of liked```
  Future<List<Playlist>> getUsersPlaylists({CancelToken? cancelToken}) async {
    var playlists = await api.getUsersPlaylists(
      _parentClass.accountID,
      cancelToken: cancelToken,
    );
    return playlists != null
        ? (playlists['result'] as List).map((t) => Playlist(t)).toList()
        : <Playlist>[];
  }

  /// Returns a list with all of the user's playlists along with the tracks inside
  Future<List<PlaylistWShortTracks>> getPlaylistsWithLikes({
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
        ? (playlists['result'] as List).map((t) => PlaylistWShortTracks(t)).toList()
        : <PlaylistWShortTracks>[];
  }

  /// Returns information about multiple user playlists
  ///
  /// Example: getMultiplePlaylists([1011, 1009]);
  Future<List<PlaylistWShortTracks>> getMultiplePlaylists(
    // TODO: Rich tracks settings 
    List kinds, {
    int? userId,
    CancelToken? cancelToken,
  }) async {
    var playlists = await api.getMultiplePlaylists(
      userId ?? _parentClass.accountID,
      kinds,
      cancelToken: cancelToken,
    );
    return playlists != null
        ? (playlists['result'] as List).map((t) => PlaylistWShortTracks(t)).toList()
        : <PlaylistWShortTracks>[];
  }

  /// Returns a list of tracks that are most suitable for a given playlist
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

  /// Creates a playlist
  ///
  /// Visibility can be specified via playlists.privatePlaylist or playlist.publicPlaylist
  ///
  /// Returns information about the created playlist after it has been created
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

  /// Renames a user's playlist
  ///
  /// Returns information about a playlist without tracks
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

  /// Deletes a user's playlist
  ///
  /// Returns the string "ok"
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
    int at = 0,
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

  /// Adds a track to a playlist
  ///
  /// On the default index in index 0 (begnish playlist), but you can specify it
  ///
  /// Accepts:
  ///```
  /// kind of playlist (unique local identifier)
  /// trackId и albumId
  /// revision -playlist version. Specified when calling getPlaylist -result['revision']
  ///```
  /// If the playlist version is incorrect, it throws a wrongRevision exception (see exception docs)
  Future<Map<String, dynamic>> insertTrack(
    int kind,
    String trackId,
    String albumId, {
    int at = 0,
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

  /// Removes tracks from a playlist
  ///
  /// Deletion occurs by index (starting from 0)
  ///```
  /// from -index from which deletion will begin (inclusive)
  /// to -index at which tracks will be deleted (inclusive)
  ///```
  /// Indexes -the position of tracks within the playlist, starting from the top (0) and ending at the bottom
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

  /// Changes the visibility of the playlist
  ///
  /// visibility is specified via playlists.publicPlaylist and playlists.privatePlaylist
  ///
  /// Returns all information about the playlist
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

  /// Returns information about multiple playlists (without tracks)
  ///
  /// Playlists are specified in the format "uid:kind" inside the list
  /// ```
  /// uid - playlist owner ID
  /// kind - the playlist identifier
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

  /// Changes the position of a track in the playlist
  ///
  /// ```
  /// Does not support changing the position in the playlist of liked tracks. Throws 500 RequestException
  /// If trackId + albumId are specified incorrectly, it throws 400 BadRequest
  /// If from or to are specified incorrectly, throws 412 WrongRevision (Precondition Failed)
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