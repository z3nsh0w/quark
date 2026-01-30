// import 'package:quark/services/player.dart';

// import '../objects/track.dart';
// import 'dart:typed_data';
// import 'package:isar/isar.dart';
// part 'listen_logger.g.dart';

// // abstract class PlayerTrack {
// //   final String title;
// //   final List<String> artists;
// //   final List<String> albums;
// //   final String filepath;
// //   String cover;
// //   Uint8List coverByted = Uint8List(0);
// //   PlayerTrack({
// //     required this.title,
// //     required this.artists,
// //     required this.albums,
// //     required this.filepath,
// //     // this.cover =
// //         // 'raw.githubusercontent.com/z3nsh0w/quark/refs/heads/main/assets/nocover.png',
// //     this.cover =
// //         'none',
// //     Uint8List? coverByted,
// //     // this.cover22 = const NoCover(source: CoverSource.no)
// //   }) : coverByted = coverByted ?? Uint8List(0);
// // }
// enum Source {
//   yandexMusic,
//   local;

//   factory Source.getFromPlayerTrack(PlayerTrack track) {
//     switch (track) {
//       case YandexMusicTrack():
//         return Source.yandexMusic;
//       case LocalTrack():
//         return Source.local;
//       default:
//         return Source.local;
//     }
//   }
// }

// @collection
// class PlayerTrack1 {
//   Id id = Isar.autoIncrement;
//   final String title;
//   final String cover;
//   final String filepath;
//   final Source yandexMusic;
//   final List<String> artists;
//   final List<String> albums;
//   final Uint8List coverByted;

//   PlayerTrack1({
//     required this.title,
//     required this.artists,
//     required this.albums,
//     required this.filepath,
//     required this.cover,
//     required this.yandexMusic,
//     Uint8List? coverByted,
//   }) : coverByted = coverByted ?? Uint8List(0);
//   factory PlayerTrack1.fromPlayerTrack(PlayerTrack track) {
//     return PlayerTrack1(
//       title: track.title,
//       artists: track.artists,
//       albums: track.albums,
//       filepath: track.filepath,
//       cover: track.cover,
//       coverByted: track.coverByted,
//       yandexMusic: Source.getFromPlayerTrack(track),
//     );
//   }
// }

// @collection
// class PlayerTrackStat {
//   Id id = Isar.autoIncrement;
//   final track = IsarLink<PlayerTrack1>();
//   @Index()
//   late DateTime playedAt;
//   late int durationSeconds;
//   late int progressPercent;
//   late bool completed;
//   late bool skipped;
// }

// class ListenLogger {
//   static final ListenLogger _instance = ListenLogger._internal();

//   factory ListenLogger() => _instance;

//   ListenLogger._internal();

//   Future<void> init() async {
//     Player.player.trackNotifier.addListener(listener);
//   }

//   void listener() async {}
// }
