import 'dart:typed_data';
import 'package:yandex_music/yandex_music.dart';
import 'package:yandex_music/src/lower_level.dart';
import 'dart:developer' as dev;

class YandexMusicTrack {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicTrack(this._parentClass, this.api);

  Future<List<dynamic>> _getDownloadInfo(
    String trackID, {
    CancelToken? cancelToken,
  }) async {
    var downloadInfo = await api.getTrackDownloadInfo(
      _parentClass.accountID,
      trackID,
      cancelToken: cancelToken,
    );
    return downloadInfo['result'];
  }

  Future<Uint8List> _getAsBytes(
    String downloadLink, {
    CancelToken? cancelToken,
  }) async {
    var result = await api.downloadTrack(
      downloadLink,
      cancelToken: cancelToken,
    );
    return result['result'];
  }

  /// Returns the link to download the track
  ///
  /// Downloading is divided into methods V1 and V2
  ///
  /// ```dart
  /// // To call V1 we pass only trackID
  /// // Return MP3 320kbps (8-9 MB)
  /// String track = ymInstance.tracks.getDownloadLink('35724293');
  ///
  /// // To call V2 we pass trackID and quality
  /// // Returns: lossless (>20мбайт), aac256 (7-8мбайт), aac64 (> 1 мбайт)
  /// // After downloading there will be no extension in the file name
  /// String track = ymInstance.tracks.getDownloadLink('47127', AudioQuality.lossless)
  /// ```
  Future<String> getDownloadLink(
    String trackId, {
    AudioQuality? quality,
    CancelToken? cancelToken,
  }) async {
    quality ??= AudioQuality.normal;
    if (quality == AudioQuality.mp3) {
      dev.log(
        'AudioQuality.mp3 is deprecated and will be removed in a future version.',
        name: 'yandex_music',
      );
      int downloadIndex = 0;
      var info = await _getDownloadInfo(trackId);

      for (int i = 0; i < info.length; i++) {
        if (info[i]['bitrateInKbps'] == 320) {
          downloadIndex = i;
        }
      }

      var link = await api.getTrackDownloadLink(
        info[downloadIndex]['downloadInfoUrl'],
      );

      return link;
    } else {
      var result = await api.getTrackDownloadLinkV2(
        trackId,
        _parentClass.accountID,
        quality.value,
        cancelToken: cancelToken,
      );
      List links = result['downloadInfo']['urls'];
      links.insert(0, result['downloadInfo']['url']);
      return links[0];
    }
  }

  /// Return (downloads) track as bytes
  ///
  /// Downloading is divided into methods V1 and V2
  ///
  /// ```dart
  /// // To call V1 we pass only trackID
  /// // Return MP3 320kbps (8-9 MB)
  /// String track = ymInstance.tracks.getDownloadLink('35724293');
  ///
  /// // To call V2 we pass trackID and quality
  /// // Returns: lossless (>20 MB), aac256 (7-8 MB), aac64 (> 1 MB)
  /// // After downloading there will be no extension in the file name
  /// String track = ymInstance.tracks.getDownloadLink('47127', AudioQuality.lossless)
  /// ```
  Future<Uint8List> download(
    String trackId, {
    AudioQuality? quality,
    CancelToken? cancelToken,
  }) async {
    quality ??= AudioQuality.normal;
    if (quality == AudioQuality.mp3) {
      dev.log(
        'AudioQuality.mp3 is deprecated and will be removed in a future version.',
        name: 'yandex_music',
      );

      var link = await getDownloadLink(trackId);
      var result = await _getAsBytes(link);

      return result;
    } else {
      var result = await api.getTrackDownloadLinkV2(
        trackId,
        _parentClass.accountID,
        quality.value,
        cancelToken: cancelToken,
      );
      List links = result['downloadInfo']['urls'];
      links.insert(0, result['downloadInfo']['url']);
      var track = await _getAsBytes(links[0]);
      return track;
    }
  }

  /// Returns additional information about the track (for example, microclip, song lyrics, etc.)
  /// # TODO
  // Future<Map<String, dynamic>> _getAdditionalInfo(
  //   String trackId, {
  //   CancelToken? cancelToken,
  // }) async {
  //   var info = await api.getAdditionalInformationOfTrack(
  //     _parentClass.accountID,
  //     trackId,
  //     cancelToken: cancelToken,
  //   );
  //   return info['result'];
  // }

  /// Returns a list of similar tracks to a specific track
  Future<List<Track>> getSimilar(
    String trackId, {
    CancelToken? cancelToken,
  }) async {
    var similar = await api.getSimilarTracks(
      _parentClass.accountID,
      trackId,
      cancelToken: cancelToken,
    );

    return similar['result']['similarTracks'] != null
        ? (similar['result']['similarTracks'] as List)
              .map((t) => Track(t))
              .toList()
        : <Track>[];
  }

  /// Provides complete information about tracks
  ///
  /// To use, you must pass either a List<String> with the ID of each track or a List<ShortTrack>
  ///
  /// E.G
  /// ```dart
  /// final List<ShortTrack> dislikedTracksInfo = await yandexMusic.usertracks.getDisliked();
  /// final List<Track> dislikedTracks = await yandexMusic.tracks.getTracks(dislikedTracksInfo);
  /// // OR
  /// dislikedTracks = await yandexMusic.tracks.getTracks((dislikedTracksInfo.map((track) => track.trackID.toString()).toList())); // OUTPUT: ['someid', ...]
  /// for (Track track in dislikedTracks) {
  ///   print('---'*30);
  ///   print(track.id);
  ///   print(track.title);
  /// }
  /// ```
  Future<List<Track>> getTracks(
    List trackIds, {
    CancelToken? cancelToken,
  }) async {
    final tracks;

    tracks = await api.getTracks(
      _parentClass.accountID,
      trackIds is List<ShortTrack>
          ? trackIds.map((ele) => ele.trackID.toString()).toList()
          : trackIds,
      cancelToken: cancelToken,
    );

    return tracks != null
        ? (tracks['result'] as List).map((t) => Track(t)).toList()
        : <Track>[];
  }

  /// Returns a link to download lyrics
  ///
  /// Texts are output in txt format
  ///
  /// Usage:
  /// ```dart
  /// // To get text without time stamps
  /// String link = await ymInstance.tracks.getLyrics('35724293')
  ///
  /// // For receiving with time stamps
  /// // Example line -[00:25.65] A heart that's full up like a landfill
  /// Lyrics lyrics = await ymInstance.tracks.getLyrics('', ymInstance.lyrics.withTime)
  Future<Lyrics> getLyrics(
    String trackId, {
    LyricsFormat? format,
    CancelToken? cancelToken,
  }) async {
    format ??= LyricsFormat.onlyText;
    var result = await api.getTrackLyrics(
      trackId,
      _parentClass.accountID,
      format.value,
      cancelToken: cancelToken,
    );
    return Lyrics(result['result']);
  }
}
