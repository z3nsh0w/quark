import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:quark/services/player/net_player.dart';
import 'package:quark/services/player/player.dart';
import 'package:yandex_music/yandex_music.dart';
export 'package:yandex_music/yandex_music.dart';

abstract class YandexMusicSingleton {
  static late YandexMusic instance;
  static bool inited = false;

  static List<ShortTrack> likedTracks = [];

  static List<PlaylistWShortTracks> playlists = [];

  static ValueNotifier<List<String>> likedTracksNotifier =
      ValueNotifier<List<String>>([]);
  static ValueNotifier<Map<String, double>> uploadedTracksNotifier =
      ValueNotifier<Map<String, double>>({});
  static ValueNotifier<List<PlaylistWShortTracks>> userPlaylistsNotifier =
      ValueNotifier<List<PlaylistWShortTracks>>([]);

  static final Map<String, List<Map<Duration, String>>> _cachedLyrics = {};
  static final Map<String, Track> _cachedTracks = {};
  static final Map<String, Album2> _cachedAlbums = {};
  static final Map<String, ArtistInfo> _cachedArtists = {};
  static final Map<String, Playlist> _cachedPlaylists = {};
  static final Map<String, dynamic> _cachedConcerts = {};
  static final Map<String, dynamic> _cachedNewReleases = {};
  static final Map<String, dynamic> _cachedStudioAlbums = {};
  static final Map<String, dynamic> _cachedArtistAlbums = {};
  static final Map<String, dynamic> _cachedArtistPlaylists = {};
  static final Map<String, dynamic> _cachedArtistTracks = {};
  static final Map<String, dynamic> _cachedPlaylistsByKind = {};

  static void init(YandexMusic _instance) {
    instance = _instance;
    inited = true;
    updateLiked();
    updateUserPlaylists();
    NetConductor().init(Player.player, _instance);
    Logger('YandexMusicService').fine('Inited');
  }

  static Future<void> updateLiked() async {
    try {
      final tracks = await instance.usertracks.getLiked();
      likedTracks.clear();
      likedTracksNotifier.value = tracks
          .map((toElement) => toElement.trackID)
          .toList();
      likedTracks.addAll(tracks);
    } catch (e) {
      Logger('YandexMusicService').shout('Failed to update liked tracks', e);
    }
  }

  static void _updateProgress(String filePath, double progress) {
    final currentMap = uploadedTracksNotifier.value;

    if (currentMap[filePath] == progress) return;

    uploadedTracksNotifier.value = {...currentMap, filePath: progress};
  }

  static Future<dynamic> getConcerts(String artistId) async {
    if (_cachedConcerts.containsKey(artistId)) {
      return _cachedConcerts[artistId];
    }
    try {
      _cachedConcerts[artistId] = null;
      final result = await YandexMusicSingleton.instance.artists.getConcerts(
        artistId,
      );
      _cachedConcerts[artistId] = result;
      return result;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getNewRelease(String artistId) async {
    if (_cachedNewReleases.containsKey(artistId)) {
      return _cachedNewReleases[artistId];
    }
    try {
      _cachedNewReleases[artistId] = null;
      final result = await YandexMusicSingleton.instance.artists.getNewRelease(
        artistId,
      );
      _cachedNewReleases[artistId] = result;
      return result;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getStudioAlbums(String artistId) async {
    if (_cachedStudioAlbums.containsKey(artistId)) {
      return _cachedStudioAlbums[artistId];
    }
    try {
      _cachedStudioAlbums[artistId] = null;
      final result = await YandexMusicSingleton.instance.artists
          .getStudioAlbums(artistId);
      _cachedStudioAlbums[artistId] = result;
      return result;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getAlbums(String artistId) async {
    if (_cachedArtistAlbums.containsKey(artistId)) {
      return _cachedArtistAlbums[artistId];
    }
    try {
      _cachedArtistAlbums[artistId] = null;
      final result = await YandexMusicSingleton.instance.artists.getAlbums(
        artistId,
      );
      _cachedArtistAlbums[artistId] = result;
      return result;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getPlaylistsByArtist(String artistId) async {
    if (_cachedArtistPlaylists.containsKey(artistId)) {
      return _cachedArtistPlaylists[artistId];
    }
    final result = await YandexMusicSingleton.instance.artists.getPlaylists(
      artistId,
    );
    _cachedArtistPlaylists[artistId] = result;
    return result;
  }

  static Future<dynamic> getTracksByArtist(String artistId) async {
    if (_cachedArtistTracks.containsKey(artistId)) {
      return _cachedArtistTracks[artistId];
    }
    final result = await YandexMusicSingleton.instance.artists.getTracks(
      artistId,
    );
    _cachedArtistTracks[artistId] = result;
    return result;
  }

  static Future<Album2> getAlbumInfo(int id) async {
    if (_cachedAlbums.containsKey(id.toString())) {
      return Future.value(_cachedAlbums[id.toString()]);
    }
    final result = await YandexMusicSingleton.instance.albums.getInfo(id);
    _cachedAlbums[id.toString()] = result;
    return result;
  }

  static Future<ArtistInfo?> getArtistInfo(String id) async {
    if (_cachedArtists.containsKey(id)) {
      return _cachedArtists[id];
    }
    final result = await YandexMusicSingleton.instance.artists.getInfo(id);
    _cachedArtists[id] = result;
    return result;
  }

  static Future<Playlist> getPlaylistByUuid(String uuid) async {
    if (_cachedPlaylists.containsKey(uuid)) {
      return Future.value(_cachedPlaylists[uuid]);
    }
    final result = await YandexMusicSingleton.instance.playlists
        .getPlaylistByUuid(uuid);
    _cachedPlaylists[uuid] = result;
    return result;
  }

  static Future<dynamic> getPlaylistByKind(int kind) async {
    if (_cachedPlaylistsByKind.containsKey(kind.toString())) {
      return _cachedPlaylistsByKind[kind.toString()];
    }
    final result = await YandexMusicSingleton.instance.playlists.getPlaylist(
      kind,
    );
    _cachedPlaylistsByKind[kind.toString()] = result;
    return result;
  }

  static Future<List<Track>> getTracks(List<String> trackIds) async {
    if (trackIds.isEmpty) return [];

    final List<Track?> result = List<Track?>.filled(trackIds.length, null);
    final List<String> toRequest = [];

    for (int i = 0; i < trackIds.length; i++) {
      final id = trackIds[i];
      final cached = _cachedTracks[id];

      if (cached != null) {
        result[i] = cached;
      } else {
        toRequest.add(id);
      }
    }

    if (toRequest.isNotEmpty) {
      final List<Track> fetched = await instance.tracks.getTracks(toRequest);

      int fetchedIndex = 0;
      for (int i = 0; i < result.length; i++) {
        if (result[i] == null && fetchedIndex < fetched.length) {
          result[i] = fetched[fetchedIndex];
          fetchedIndex++;
          _cachedTracks[trackIds[i]] = result[i]!;
        }
      }
    }

    return result.cast<Track>();
  }

  static Future<List<Map<Duration, String>>> getLyrics(
    String trackId,
    LyricsFormat format,
  ) async {
    if (_cachedLyrics.containsKey(trackId)) {
      return _cachedLyrics[trackId]!;
    }
    try {
      final Lyrics result = await instance.tracks.getLyrics(
        trackId,
        format: format,
      );

      List<Map<Duration, String>> lyrics;

      if (format == LyricsFormat.withTimeStamp) {
        lyrics = await extractLyricsWTS(result.downloadUrl!);
      } else {
        lyrics = await extractLyricsOT(result.downloadUrl!);
      }

      if (lyrics.isNotEmpty) {
        _cachedLyrics[trackId] = lyrics;
      }

      return lyrics;
    } catch (e, stack) {
      Logger('YandexMusicSingleton').severe('Failed to load lyrics', e, stack);
      return [];
    }
  }

  static Future<void> uploadTracks(List<String> filePaths, int kind) async {
    final initialMap = {for (var path in filePaths) path: 0.0};
    uploadedTracksNotifier.value = {
      ...uploadedTracksNotifier.value,
      ...initialMap,
    };

    for (String filepath in filePaths) {
      try {
        await instance.usertracks.uploadUGCTrack(
          kind,
          await File(filepath).readAsBytes(),
          basename(filepath),
          onSendProgress: (sent, total) {
            if (total == 0) return;
            final percent = (sent / total * 100);
            _updateProgress(filepath, percent);
          },
        );
      } catch (e) {
        Logger(
          "YandexMusicSingletonSerivce",
        ).warning("Failed to upload tracks...", e);
      }
    }
  }

  static Future<void> updatePinned() async {
    // try {
    //   // final tracks = await instance.landing.;
    //   likedTracks.clear();
    //   likedTracksNotifier.value = tracks
    //       .map((toElement) => toElement.trackID)
    //       .toList();
    //   likedTracks.addAll(tracks);
    // } catch (e) {
    //   Logger('YandexMusicService').shout('Failed to update liked tracks', e);
    // }
  }

  static Future<void> unlikeTrack(String trackId) async {
    try {
      await instance.usertracks.unlike([trackId]);
      final ts = likedTracks.map((e) => e.trackID).toList().indexOf(trackId);
      likedTracks.removeAt(ts);
      likedTracksNotifier.value.remove(trackId);
    } catch (e) {
      Logger('YandexMusicService').shout('Failed to unlikeTrack', e);
    }
  }

  static Future<void> likeTrack(String trackId) async {
    try {
      await instance.usertracks.like([trackId]);
      updateLiked();
    } catch (e) {
      Logger('YandexMusicService').shout('Failed to likeTrack', e);
    }
  }

  static Future<void> updateUserPlaylists() async {
    try {
      final playlist = await instance.usertracks.getPlaylistsWithLikes();
      playlists.clear();
      playlists.addAll(playlist);
    } catch (e) {
      Logger('YandexMusicService').shout('Failed to update user playlists');
    }
  }
}

Future<List<Map<Duration, String>>> extractLyricsWTS(String link) async {
  final res = await Dio().get(link);

  final List<String> words = res.data.toString().split('\n');
  final List<Map<Duration, String>> nowStatedMapWithTimestampWithText = [];
  for (String word in words) {
    final word2 = word.split(' ');
    final timestamp = word2.first;
    word2.remove(timestamp);
    final words = word2.join(' ');

    final clean = timestamp.replaceAll(RegExp(r'[\[\]]'), '').split(':');
    if (clean.length > 1) {
      final mins = clean[0];
      final secs = clean[1].split('.').first;
      final millis = clean[1].split('.').last;

      final Duration duraton = Duration(
        minutes: int.parse(mins),
        seconds: int.parse(secs),
        milliseconds: int.parse(millis),
      );

      nowStatedMapWithTimestampWithText.add({duraton: words});
    }
  }
  if (nowStatedMapWithTimestampWithText.first.entries.first.key !=
      Duration(seconds: 0)) {
    nowStatedMapWithTimestampWithText.insert(0, {
      Duration(milliseconds: 0): '',
    });
  }

  return nowStatedMapWithTimestampWithText;
}

Future<List<Map<Duration, String>>> extractLyricsOT(String link) async {
  final res = await Dio().get(link);
  final List<String> words = res.data.toString().split('\n');
  final List<Map<Duration, String>> result = [];
  for (String word in words) {
    result.add({Duration.zero: word});
  }
  result.insert(0, {Duration(milliseconds: 0): ''});
  return result;
}
