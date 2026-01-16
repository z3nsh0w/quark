import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/src/objects/search_result.dart';
import 'package:yandex_music/yandex_music.dart';

// #TODO: search without authorization

class YandexMusicSearch {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicSearch(this._parentClass, this.api);

  Future<SearchResult> search(
    String query, {
    List<SearchTypes> types = const [SearchTypes.track],
    int page = 0,
    int pageSize = 36,
    bool withLikesCount = false,
    bool withBestResults = true,
    CancelToken? cancelToken
  }) async {
    if (query == '') {
      throw YandexMusicException.argumentError('Request not specified');
    }
    final result = await api.searchV2(
      query,
      types: types,
      page: page,
      pageSize: pageSize,
      withBestResults: withBestResults,
      withLikesCount: withLikesCount,
      cancelToken: cancelToken
    );
    return SearchResult(result['result']);
  }

  /// Provides a track search by a custom query.
  Future<List<Track>> tracks(
    String query, {
    int? page,
    noCorrent = false,
    CancelToken? cancelToken,
  }) async {
    page ??= 0;
    var result = await api.search(
      query,
      page,
      'track',
      noCorrent,
      cancelToken: cancelToken,
    );
    return result != null
        ? (result['result']['tracks']['results'] as List)
              .map((t) => Track(t))
              .toList()
        : <Track>[];
  }

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found podcasts       : search.podcasts()['total']
  ///
  /// number of podcasts per page    : search.podcasts()['perPage']
  ///
  /// query result (found podcasts)  : search.podcasts()['results']
  Future<dynamic> podcasts(
    String query, {
    int? page,
    noCorrent = false,
    CancelToken? cancelToken,
  }) async {
    page ??= 0;

    var result = await api.search(
      query,
      page,
      'podcast',
      noCorrent,
      cancelToken: cancelToken,
    );
    return result['result']['podcasts'];
  }

  Future<List<Artist>> artists(
    String query, {
    int? page,
    noCorrent = false,
    CancelToken? cancelToken,
  }) async {
    page ??= 0;
    var result = await api.search(
      query,
      page,
      'artist',
      noCorrent,
      cancelToken: cancelToken,
    );
    return result != null
        ? (result['result']['artists']['results'] as List)
              .map((t) => OfficialArtist(t))
              .toList()
        : <Artist>[];
  }

  Future<List<Album>> albums(
    String query, {
    int? page,
    noCorrent = false,
    CancelToken? cancelToken,
  }) async {
    page ??= 0;

    var result = await api.search(
      query,
      page,
      'album',
      noCorrent,
      cancelToken: cancelToken,
    );
    // return result['result']['albums'];
    return result != null
        ? (result['result']['albums']['results'] as List)
              .map((t) => Album(t))
              .toList()
        : <Album>[];
  }
}
