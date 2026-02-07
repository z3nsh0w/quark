import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:yandex_music/yandex_music.dart';
export 'package:yandex_music/yandex_music.dart';

abstract class YandexMusicSingleton {
  static late YandexMusic instance;
  static bool inited = false;

  static List<ShortTrack> likedTracks = [];

  static List<PlaylistWShortTracks> playlists = [];

  static ValueNotifier likedTracksNotifier = ValueNotifier([]);

  static void init(YandexMusic _instance) {
    instance = _instance;
    inited = true;
    updateLiked();
    updateUserPlaylists();
  }

  static void updateLiked() async {
    try {
      final tracks = await instance.usertracks.getLiked();
      likedTracks.clear();
      likedTracksNotifier.value = tracks;
      likedTracks.addAll(tracks);
    } catch (e) {
      Logger('YandexMusicService').shout('Failed to update liked tracks');
    }
  }

  static void updateUserPlaylists() async {
    try {
      final playlist = await instance.usertracks.getPlaylistsWithLikes();
      playlists.clear();
      playlists.addAll(playlist);
    } catch (e) {
      Logger('YandexMusicService').shout('Failed to update user playlists');
    }
  }
}
