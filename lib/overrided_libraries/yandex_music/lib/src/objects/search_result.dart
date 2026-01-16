import 'package:yandex_music/src/objects/track.dart';
import 'package:yandex_music/src/objects/devired_colors.dart';

enum SearchTypes {
  track('track'),
  album('album'),
  clip('clip'),
  artist('artist'),
  podcast('podcast'),
  podcastEpisode('podcast_episode');

  final String value;

  const SearchTypes(this.value);
}

class SearchArtist {
  final int id;
  final String name;
  final int? likesCount;
  final String coverUri;
  /// HEX format
  final String coverColor;
  final bool? trailerAvailable;
  final DerivedColors? deviredColors;

  SearchArtist(Map<String, dynamic> artist)
    : id = artist['artist']['id'],
      name = artist['artist']['name'],
      likesCount = artist['likesCount'],
      trailerAvailable = artist['trailer']['available'],
      coverColor = artist['artist']['cover']['color'],
      coverUri = artist['artist']['cover']['uri'],
      deviredColors = artist['cover'] != null ? DerivedColors(artist['cover']['derivedColors']) : null;
}

class SearchAlbum {
  final int id;
  final String title;
  final String coverUri;
  final String coverColor;
  final bool? available;
  final String? contentWarning;
  final List<String>? disclaimers;
  final List<SearchArtist> artists;

  SearchAlbum(Map<String, dynamic> album)
    : id = album['album']['id'],
      title = album['album']['title'],
      contentWarning = album['album']['contentWarning'],
      coverColor = album['album']['cover']['color'],
      coverUri = album['album']['cover']['uri'],
      disclaimers = album['album']['contentRestrictions']['disclaimers'],
      available = album['album']['contentRestrictions'],
      artists = (album['artists'] as List).map((t) {
        return SearchArtist(t);
      }).toList();
}

class SearchConcert {
  final String id;
  final String city;
  final String place;
  final String address;
  final String dateTime;
  final String imageUrl;
  final int minPrice;
  final String afishaUrl;
  final List images;
  final String concertTitle;
  final String? contentRaiting;
  final String? priceCurrency;
  final String? priceCurrencySymbol;

  SearchConcert(Map<String, dynamic> artist)
    : id = artist['id'],
      imageUrl = artist['imageUrl'],
      concertTitle = artist['concertTitle'],
      city = artist['city'],
      place = artist['place'],
      address = artist['address'],
      dateTime = artist['datetime'],
      afishaUrl = artist['afishaUrl'],
      contentRaiting = artist['contentRaiting'],
      images = artist['images'],
      minPrice = artist['minPrice']['value'],
      priceCurrencySymbol = artist['minPrice']['currencySymbol'],
      priceCurrency = artist['minPrice']['currencty'];
}

class SearchResult {
  final int total;
  final int perPage;
  final String query;
  final bool lastPage;
  final Track? bestTrack;
  final List<Track> tracks;
  final String? responseType;
  final bool misspellCorrected;
  final String? misspellResult;
  final SearchAlbum? bestAlbum;
  final SearchArtist? bestArtist;
  final SearchConcert? bestConcert;

  

  SearchResult(Map<String, dynamic> query)
    : tracks =
          (query['results'] as List?)
              ?.where((element) => element['type'] == 'track')
              .map((toElement) => Track(toElement['track']))
              .toList() ??
          [],
      total = query['total'] ?? 0,
      perPage = query['perPage'],
      lastPage = query['lastPage'] ?? false,
      misspellCorrected = query['misspellCorrected'] ?? false,
      misspellResult = query['misspellResult'] ?? '',
      responseType = query['responseType'],
      query = query['text'],
      bestTrack = (() {
        
        final bestResults = query['bestResults'] as List?;
        final match = bestResults?.firstWhere(
          (e) => e['type'] == 'best_result_track',
          orElse: () => null,
        );
        return match != null ? Track(match['best_result_track']) : null;
      }()),
      bestArtist = (() {
        final bestResults = query['bestResults'] as List?;
        final match = bestResults?.firstWhere(
          (e) => e['type'] == 'best_result_artist',
          orElse: () => null,
        );
        return match != null ? SearchArtist(match['best_result_artist']) : null;
      }()),
      bestAlbum = (() {
        final bestResults = query['bestResults'] as List?;
        final match = bestResults?.firstWhere(
          (e) => e['type'] == 'best_result_album',
          orElse: () => null,
        );
        return match != null ? SearchAlbum(match['best_result_album']) : null;
      }()),
      bestConcert = (() {
        final bestResults = query['bestResults'] as List?;
        final match = bestResults?.firstWhere(
          (e) => e['type'] == 'best_result_concert',
          orElse: () => null,
        );
        return match != null ? SearchConcert(match['best_result_concert']) : null;
      }());




          
}
