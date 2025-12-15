import 'dart:typed_data';
import 'package:yandex_music/src/objects/track.dart';

abstract class PlayerTrack {
  final String title;
  final List<String> artists;
  final List<String> albums;
  final String filepath;
  String cover;
  Uint8List coverByted = Uint8List(0);

  PlayerTrack({
    required this.title,
    required this.artists,
    required this.albums,
    required this.filepath,
    this.cover = 'raw.githubusercontent.com/z3nsh0w/z3nsh0w.github.io/refs/heads/master/nocover.png',
    Uint8List? coverByted,
  }) : coverByted = coverByted ?? Uint8List(0);
}

class LocalTrack extends PlayerTrack {
   LocalTrack({
    required super.title,
    required super.artists,
    required super.albums,
    required super.filepath,
    super.cover,
    super.coverByted,
  });
}

class YandexMusicTrack extends PlayerTrack {
  final Track track;

   YandexMusicTrack({
    required this.track,
    required super.title,
    required super.artists,
    required super.albums,
    required super.filepath,
    super.cover,
    super.coverByted,
  });
}
