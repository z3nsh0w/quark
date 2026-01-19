// Asynchronous Yandex Music library based on the DIO library
// Version 1.2.2
// Made by zenar56

import 'src/exceptions/exceptions.dart';
import 'src/lower_level.dart' as main_library;
import 'src/subclasses/subclasses.dart' as sub_classes;
// ladder everywhere lol
export 'dart:io' show File;
export 'src/objects/wave.dart';
export 'src/objects/album.dart';
export 'src/objects/track.dart';
export 'src/objects/artist.dart';
export 'src/objects/lyrics.dart';
export 'src/objects/playlist.dart';
export 'src/objects/audio_quality.dart';
export 'src/objects/vibe_settings.dart';
export 'src/objects/feedback_type.dart';
export 'src/objects/lyrics_format.dart';
export 'src/objects/devired_colors.dart';
export 'src/objects/search_result.dart';
export 'src/exceptions/exceptions.dart';
export 'package:dio/dio.dart' show CancelToken;

class YandexMusic {

  final String token;

  /// yandex_music
  /// ---
  ///
  /// The main class of the library.
  ///
  /// Example of useя:
  ///```dart
  /// import 'package:yandex_music/yandex_music.dart';
  ///
  /// YandexMusic ymInstance = YandexMusic(token: 'y0_5678');
  /// try {
  ///   await ymInstance.init();
  ///
  ///   int accountID = ymInstance.account.getAccountID();
  ///   var playlists = ymInstance.playlists.getUsersPlaylists();
  ///
  ///   for (Playlist playlist in playlists) {
  ///     print('---'*50);
  ///     print('Playlist name: ${playlist.title}');
  ///     print('Playlist kind: ${playlist.kind}');
  ///     print('Playlist owner name - uid : ${playlist.owner.name} - ${playlist.owner.uid}');
  ///     print('Playlist visibility: ${playlist.visibility}');
  ///  }
  /// }  on YandexMusicException catch (e) {
  ///     switch (e.type) {
  ///       case YandexMusicExceptionType.network:
  ///         print('Network exception: ${e.message}');
  ///         break;
  ///       case YandexMusicExceptionType.unauthorized:
  ///         print('Authorization exception: ${e.message}');
  ///         break;
  ///       case YandexMusicExceptionType.badRequest:
  ///         print('Bad request: ${e.message}');
  ///         break;
  ///       case YandexMusicExceptionType.notFound:
  ///         print('Not found: ${e.message}');
  ///         break;
  ///       default:
  ///         print('Another error: ${e.message}');
  /// }
  ///
  /// }
  ///```
  YandexMusic({required String token}) : this.token = token;

  late int accountID;
  late Map<String, dynamic> rawUserInfo;
  late main_library.YandexMusicApiAsync _api;

  /// Account Inner Class
  ///
  /// All methods except getAccountSettings() and getAccountInformation() return cached information
  ///
  /// To update the cache, initialize the class again
  /// ```dart
  /// await ymInstance.init();
  /// ```

  late sub_classes.YandexMusicPin pin; 
  late sub_classes.YandexMusicTrack tracks;
  late sub_classes.YandexMusicMyVibe myVibe;
  late sub_classes.YandexMusicSearch search;
  late sub_classes.YandexMusicAlbums albums;
  late sub_classes.YandexMusicLanding landing;
  late sub_classes.YandexMusicAccount account;
  late sub_classes.YandexMusicPlaylists playlists;
  late sub_classes.YandexMusicUserTracks usertracks;


  Future<dynamic> init() async {
    _api = main_library.YandexMusicApiAsync(token: token);
    rawUserInfo = await _api.getAccountInformation();
    try {
      accountID = rawUserInfo['result']['account']['uid'];
    } on TypeError {
      throw YandexMusicException.initialization(
        'The token is most likely invalid. Account ID was not found, but it is required. Server raw: $rawUserInfo',
      );
    }

    pin = sub_classes.YandexMusicPin(this, _api);
    tracks = sub_classes.YandexMusicTrack(this, _api);
    search = sub_classes.YandexMusicSearch(this, _api);
    myVibe = sub_classes.YandexMusicMyVibe(this, _api);
    albums = sub_classes.YandexMusicAlbums(this, _api);
    landing = sub_classes.YandexMusicLanding(this, _api);
    account = sub_classes.YandexMusicAccount(this, _api);
    playlists = sub_classes.YandexMusicPlaylists(this, _api);
    usertracks = sub_classes.YandexMusicUserTracks(this, _api);
  }

  Future<bool> checkInit() async {
    try {
      await account.getAccountID();
      return true;
    } catch (e) {
      return false;
    }
  }
}

// TODO: add partial (range) real-time audio capture.
