import 'package:yandex_music/src/objects/cover.dart';
import 'package:yandex_music/src/objects/track.dart';
import 'package:yandex_music/src/objects/concert.dart';

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
  final Cover2 cover;
  final bool? trailerAvailable;

  SearchArtist(Map<String, dynamic> artist)
    : id = artist['artist']['id'],
      cover = Cover2(artist['artist']['cover']),
      name = artist['artist']['name'],
      likesCount = artist['likesCount'],
      trailerAvailable = artist['trailer']['available'];
}

class SearchAlbum {
  final int id;
  final String title;
  final String coverUri;
  final String coverColor;
  final bool? available;
  final String? contentWarning;
  final List? disclaimers;
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
        return match != null
            ? SearchConcert(match['best_result_concert'])
            : null;
      }());
}
