import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicLanding {
  final YandexMusicApiAsync api;

  YandexMusicLanding(this.api);

  /// Returns new popular releases (tracks, albums, etc.)
  ///
  /// Returns a list with releases
  /// result['newReleases']
  String newReleases = 'new-releases';

  /// Returns personalized playlists for the user
  ///
  /// Returns a list with playlists (uid и kind)
  /// result['newPlaylists']
  String newPlaylists = 'new-playlists';

  /// Возвращает чарты
  String chart = 'chart';

  /// Возвращает подкасты
  String podcasts = 'podcasts';

  /// Returns all landing blocks, namely:
  /// ```
  /// Personal playlists
  /// Stock
  /// New releases
  /// New playlists
  /// Mix
  /// Charts
  /// Artist
  /// Albums
  /// Playlists
  /// Track playback contexts
  /// Podcasts
  /// ```
  Future<dynamic> getAllLangingBlocks({CancelToken? cancelToken}) async {
    final responce = await api.getLangingBlocks(
      cancelToken: cancelToken,
    );
    return responce['result'];
  }

  /// Returns a separate landing block
  ///
  /// Only supports:
  /// ```
  /// landing.newReleases
  /// landing.newPlaylists
  /// landing.chart
  /// landing.podcasts
  Future<dynamic> getBlock(String block, {CancelToken? cancelToken}) async {
    final responce = await api.getBlock(
      block,
      cancelToken: cancelToken,
    );
    return responce['result'];
  }
}
