import 'package:yandex_music/yandex_music.dart';
import 'package:yandex_music/src/lower_level.dart';

class YandexMusicArtists {
  final YandexMusicApiAsync _api;

  YandexMusicArtists(this._api);

  /// Allows you to get all tracks of the artist
  Future<ArtistInfo> getInfo(dynamic artistId) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo('/artists/$artistId/info');
    return ArtistInfo(result);
  }

  /// Allows you to get all tracks of the artist
  Future<List<Track>> getTracks(
    dynamic artistId, {
    int page = 0,
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/tracks',
      page: page,
      cancelToken: cancelToken,
    );
    return result != null
        ? (result['result']['tracks'] as List).map((t) => Track(t)).toList()
        : <Track>[];
  }

  /// Returns the recent release (Album object) of the artist
  Future<Album> getNewRelease(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-release',
      cancelToken: cancelToken,
    );
    final rzt = await _api.getAlbum(
      result['release']['album']['id'],
      cancelToken: cancelToken,
    );
    return Album(rzt['result']);
  }

  /// Returns all studio albums of the artist
  Future<List<AlbumInfo>> getStudioAlbums(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-studio-albums',
      cancelToken: cancelToken,
    );

    return (result['items'] as List).map((t) => AlbumInfo(t['data'])).toList();
  }

  /// Returns all albums of the artist
  Future<List<AlbumInfo>> getAlbums(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-albums',
      cancelToken: cancelToken,
    );

    return (result['items'] as List).map((t) => AlbumInfo(t['data'])).toList();
  }

  /// Returns a list of the artist's upcoming concerts
  Future<List<Concert>> getConcerts(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-concerts',
      cancelToken: cancelToken,
    );

    return (result['concerts'] as List).map((t) => Concert(t)).toList();
  }

  /// Returns a list of similar artists
  Future<List<SearchArtist>> getSimilar(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/similar-artists',
      cancelToken: cancelToken,
    );

    return (result['items'] as List)
        .map((t) => SearchArtist(t['data']))
        .toList();
  }

  /// In this context, these are the albums that are similar to this artist's work
  Future<List<AlbumInfo>> getCompilations(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-compilations',
      cancelToken: cancelToken,
    );

    return (result['items'] as List).map((t) => AlbumInfo(t['data'])).toList();
  }

  /// Returns playlists with artist's tracks or similar tracks
  Future<List<ShortPlaylistInfo>> getPlaylists(
    dynamic artistId, {
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/blocks/artist-playlists',
      cancelToken: cancelToken,
    );

    return (result['items'] as List)
        .map((t) => ShortPlaylistInfo(t['data']))
        .toList();
  }

  /// TODO:
  /// Returns playlists with artist's tracks or similar tracks
  Future<List<ShortPlaylistInfo>> _getDiscographyAlbums(
    dynamic artistId, {
    int page = 0,
    int pageSize = 20,
    CancelToken? cancelToken,
  }) async {
    if (artistId is UGCArtist) {
      throw YandexMusicException.argumentError(
        "Artist's class methods cannot be used with UGCArtist",
      );
    }
    if (artistId is Artist) {
      artistId = (artistId as OfficialArtist).id;
    }
    artistId = artistId.toString();

    final result = await _api.getArtistInfo(
      '/artists/$artistId/discography-albums',
      params: {'page': page, 'pageSize': pageSize, 'sort-by': 'year'},
      cancelToken: cancelToken,
    );

    return (result['items'] as List)
        .map((t) => ShortPlaylistInfo(t['data']))
        .toList();
  }
}
