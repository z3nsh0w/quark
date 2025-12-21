import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicSearch {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicSearch(this._parentClass, this.api);

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found tracks       : search.tracks()['total']
  ///
  /// number of tracks per page    : search.tracks()['perPage']
  ///
  /// query result (found tracks)  : search.tracks()['results']
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

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found artists      : search.artists()['total']
  ///
  /// number of artists per page    : search.artists()['perPage']
  ///
  /// query result (found artists)  : search.artists()['results']
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
              .map((t) => Artist(t))
              .toList()
        : <Artist>[];
  }

  /// Provides a track search by a custom query.
  ///
  /// Accepts a query string, page number (from 0 to *) and correction.
  ///
  /// ---
  ///
  /// Returns:
  ///
  /// number of found albums       : search.albums()['total']
  ///
  /// number of albums per page    : search.albums()['perPage']
  ///
  /// query result (found albums)  : search.albums()['results']
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

  /// Combines all search classes (tracks, podcasts, artists, albums)
  ///
  /// ---
  ///
  /// Returns:
  /// best - the most relevant search result with type track
  ///
  /// search.all()['best']['type'] - type of the best result ('track' in this case)
  ///
  /// search.all()['best']['result'] - complete track data (id, title, artists, albums, coverUri, duration, etc.)
  ///
  /// search.all()['best']['result']['albums'] - array of albums containing this track
  ///
  /// ---
  ///
  /// Other search results:
  ///
  /// search.all()['artists'] - array of found artists
  ///
  /// search.all()['artists']['total'] - total number of found artists
  ///
  /// search.all()['artists']['perPage'] - number per page
  ///
  /// search.all()['artists']['results'] - array of artists with data (name, genres, counts, ratings, etc.)
  ///
  /// search.all()['podcast_episodes'] - array of found podcast episodes
  ///
  /// search.all()['podcast_episodes']['total'] - total number of found episodes
  ///
  /// search.all()['podcast_episodes']['perPage'] - number per page
  ///
  /// search.all()['podcast_episodes']['results'] - array of episodes with data (title, duration, description, etc.)
  ///
  ///  ---
  ///
  ///  /// Eg.
  /// ```dart
  /// try {
  ///   Map result = await YandexMusicInstance.search.all(''); // This request will return error code 400
  /// } on YandexMusicRequestException catch (error) {
  ///   switch (error.code) {
  ///   case 400:
  ///     logger.e('Bad request. The request was not completed correctly.');
  ///
  ///   case 404:
  ///     logger.e('But nobody came...');
  /// }
  /// // You can also get the message returned by the library
  ///   logger.e(error.message);
  /// } on YandexMusicException catch (error) {
  ///   logger.e('${error.type}');
  /// }
  /// ```
  ///
  Future<dynamic> all(
    String query, {
    int? page,
    noCorrent = false,
    CancelToken? cancelToken,
  }) async {
    page ??= 0;

    var result = await api.search(
      query,
      page,
      'all',
      noCorrent,
      cancelToken: cancelToken,
    );
    return result['result'];
  }
}
