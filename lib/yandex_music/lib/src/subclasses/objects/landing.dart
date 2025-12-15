import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicLanding {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicLanding(this._parentClass, this.api);

  /// Возвращает новые популярные релизы (треки, альбомы итд)
  ///
  /// Возвращает список с релизами
  /// result['newReleases']
  String newReleases = 'new-releases';

  /// Возвращает персонализированные плейлисты для пользователя
  ///
  /// Возвращает список с плейлистами (uid и kind)
  /// result['newPlaylists']
  String newPlaylists = 'new-playlists';

  /// Возвращает чарты
  String chart = 'chart';

  /// Возвращает подкасты
  String podcasts = 'podcasts';

  /// Возвращает все блоки лендинга, а именно:
  /// ```
  /// Персональные плейлисты
  /// Акции
  /// Новые релизы
  /// Новые плейлисты
  /// Миксы
  /// Чарты
  /// Артисты
  /// Альбомы
  /// Плейлисты
  /// Контексты проигрывания трека
  /// Подкасты
  /// ```
  Future<dynamic> getAllLangingBlocks({CancelToken? cancelToken}) async {
    final responce = await api.getLangingBlocks(
      cancelToken: cancelToken,
    );
    return responce['result'];
  }

  /// Возвращает отдельный блок лендинга
  ///
  /// Поддерживает только:
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
