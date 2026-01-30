import 'package:quark/objects/track.dart';
import 'package:yandex_music/yandex_music.dart' as yandex_music_package;
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class YandexMusicS {
  // да здесь чинила нейронка
  // и че нахуй
  static YandexMusicS? _instance;

  final yandex_music_package.YandexMusic _client;
  final String _token;

  YandexMusicS._internal(this._token)
    : _client = yandex_music_package.YandexMusic(token: _token);

  yandex_music_package.YandexMusic get client => _client;

  static void init(String token) {
    if (_instance != null) {
    }
    _instance = YandexMusicS._internal(token);
  }

  static YandexMusicS get instance {
    if (_instance == null) {
    }
    return _instance!;
  }

  static bool get isInitialized => _instance != null;

  static void clear() {
    _instance = null;
  }

  final likedTracksNotifier =
      ValueNotifier<List<yandex_music_package.ShortTrack>>([]);

  final uploadingTracksNotifier = ValueNotifier<List<LocalTrack>>([]);
  final uploadedTracks =
      ValueNotifier<List<Map<LocalTrack, yandex_music_package.ShortTrack>>>([]);

  List<yandex_music_package.ShortTrack> likedTracks = [];

  Future<void> updateLiked() async {
    likedTracks = await _client.usertracks.getLiked();
    likedTracksNotifier.value = likedTracks;
  }

  Future<void> uploadTracks(List<LocalTrack> tracks, int playlistKind) async {
    if (tracks.isEmpty) return;

    uploadingTracksNotifier.value = [
      ...uploadingTracksNotifier.value,
      ...tracks,
    ];

    final currentList = uploadedTracks.value;
    for (LocalTrack track in tracks) {
      final String trackId = await _client.usertracks.uploadUGCTrack(
        playlistKind,
        File(track.filepath),
      );

      currentList.add({
        track: yandex_music_package.ShortTrack({
          'trackId': trackId,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      });

      uploadedTracks.value = currentList;
    }
  }
}
