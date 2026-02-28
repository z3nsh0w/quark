import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:yandex_music/yandex_music.dart';
export 'package:yandex_music/yandex_music.dart';

abstract class YandexMusicSingleton {
  static late YandexMusic instance;
  static bool inited = false;

  static List<ShortTrack> likedTracks = [];


  static List<PlaylistWShortTracks> playlists = [];

  static ValueNotifier<List<String>> likedTracksNotifier = ValueNotifier<List<String>>([]);

  static void init(YandexMusic _instance) {
    instance = _instance;
    inited = true;
    updateLiked();
    updateUserPlaylists();
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
