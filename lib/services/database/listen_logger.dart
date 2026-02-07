// import 'dart:io';
// import 'dart:math';
// import 'package:logging/logging.dart';
// import 'package:path/path.dart';

// import '../objects/track.dart';
// import 'package:isar/isar.dart';
// import 'package:crypto/crypto.dart';
// import 'package:quark/services/player/player.dart';
// import 'package:path_provider/path_provider.dart';

// export 'package:isar/isar.dart';

// part 'listen_logger.g.dart';

// // MAIN SERVICE

// class ListenLogger {
//   static final ListenLogger _instance = ListenLogger._internal();

//   factory ListenLogger() => _instance;

//   ListenLogger._internal();
//   bool inited = false;
//   int initTries = 0;
//   Object? lastError;

//   Future<void> init() async {
//     initTries += 1;
//     try {
//       final dir = await getApplicationCacheDirectory();
//       await Directory(join(dir.path, 'stats')).create(recursive: true);
//       isar = await Isar.open(
//         [PlayerTrack1Schema, PlayerTrackStatSchema],
//         directory: join(dir.path, 'stats'),
//         name: 'listen_stats',
//         maxSizeMiB: 128,
//       );

//       Player.player.trackChangeNotifier.addListener(trackListen);
//       Player.player.durationNotifier.addListener(totalDurationListener);
//       Player.player.playedNotifier.addListener(playedListener);

//       lastTrack = Player.player.trackNotifier.value;
//       lastPosition = Player.player.playedNotifier.value;
//       lastCountedSecond = lastPosition.inSeconds;
//       lastDuration = Player.player.durationNotifier.value;
//       ListenStats().init(isar);
//     } catch (e) {
//       Logger(
//         'ListenLogger',
//       ).severe('Failed to initialize the ListenLogger module.', e);
//       lastError = e;
//       return;
//     }
//     inited = true;
//   }

//   late Isar isar;
//   int lastCountedSecond = 0;
//   int totalPlayedSeconds = 0;
//   late PlayerTrack lastTrack;
//   late Duration lastDuration;
//   Duration lastPosition = Duration.zero;
//   Duration totalDuration = Duration.zero;

//   // Cache
//   final Map<String, String> hashes = {}; // Filepath => Hash

//   static const int seekThreshold = 2;

//   void saveListen(PlayerTrack1 track, PlayerTrackStat stat, String hash) async {
//     await isar.writeTxn(() async {
//       final collection = isar.collection<PlayerTrack1>();
//       PlayerTrack1? existingTrack = await collection.getByMd5Hash(hash);

//       if (existingTrack == null) {
//         await collection.put(track);
//         existingTrack = track;
//       }

//       stat.track.value = existingTrack;

//       await isar.playerTrackStats.put(stat);

//       await stat.track.save();
//     });
//   }

//   void trackListen() async {
//     final int tps = totalPlayedSeconds;
//     final PlayerTrack lt = lastTrack;
//     final Duration ld = lastDuration;

//     totalDuration = Player.player.durationNotifier.value;
//     totalPlayedSeconds = 0;
//     lastPosition = Duration.zero;
//     lastCountedSecond = 0;
//     lastTrack = Player.player.trackNotifier.value;

//     if (tps > 10) {
//       final trackFile = File(lt.filepath);
//       TrackChange track = Player.player.trackChangeNotifier.value;
//       String hash;
//       if (hashes.containsKey(lt.filepath)) {
//         hash = hashes[lt.filepath]!;
//       } else {
//         if (!(await trackFile.exists())) {
//           return;
//         }
//         hash = await getMd5(trackFile);
//         hashes[lt.filepath] = hash;
//       }
//       final insertTrack = await PlayerTrack1.createFromTrack(lt, hash: hash);
//       if (insertTrack != null) {
//         saveListen(
//           insertTrack,
//           PlayerTrackStat(
//             playedSeconds: tps,
//             totalTrackDuration: ld.inSeconds,
//             progressPercent: min(((tps / ld.inSeconds) * 100).round(), 100),
//             changeType: PlayedType.fromChangeReason(track.reason),
//             time: DateTime.now(),
//           ),
//           hash,
//         );
//       }
//     }
//   }

//   void totalDurationListener() async {
//     totalDuration = lastDuration = Player.player.durationNotifier.value;
//   }

//   void playedListener() async {
//     Duration currentPosition = Player.player.playedNotifier.value;
//     int currentSecond = currentPosition.inSeconds;

//     int diff = currentSecond - lastCountedSecond;

//     if (diff > 0 && diff <= seekThreshold) {
//       totalPlayedSeconds += diff;
//       lastCountedSecond = currentSecond;
//     } else if (diff > seekThreshold || diff < 0) {
//       lastCountedSecond = currentSecond;
//     }

//     lastPosition = currentPosition;
//   }

//   void dispose() async {
//     Player.player.trackChangeNotifier.removeListener(trackListen);
//     Player.player.durationNotifier.removeListener(totalDurationListener);
//     Player.player.playedNotifier.removeListener(playedListener);
//     inited = false;
//     await isar.close();
//   }
// }

// class ListenStats {
//   static final ListenStats _instance = ListenStats._internal();

//   factory ListenStats() => _instance;

//   ListenStats._internal();

//   late final Isar isar;
//   bool inited = false;

//   void init(Isar isarInstance) {
//     isar = isarInstance;
//     inited = true;
//   }

//   Future<List<Map<PlayerTrack1, PlayerTrackStat>>> getAllStats({
//     DateTime? time,
//   }) async {
//     late List<PlayerTrackStat> stats;
//     if (time != null) {
//       stats = await isar.playerTrackStats
//           .where()
//           .filter()
//           .timeGreaterThan(time)
//           .findAll();
//     } else {
//       stats = await isar.playerTrackStats.where().findAll();
//     }

//     for (var stat in stats) {
//       await stat.track.load();
//     }
//     return stats.where((stat) => stat.track.value != null).map((stat) {
//       return {stat.track.value!: stat};
//     }).toList();
//   }

//   Future<MapEntry<PlayerTrack1, int>?> getMostPlayedTrack({
//     DateTime? time,
//   }) async {
//     late List<PlayerTrackStat> stats;
//     if (time != null) {
//       stats = await isar.playerTrackStats
//           .where()
//           .filter()
//           .timeGreaterThan(time)
//           .findAll();
//     } else {
//       stats = await isar.playerTrackStats.where().findAll();
//     }

//     final Map<PlayerTrack1, int> playDurationMap = {};

//     for (var stat in stats) {
//       await stat.track.load();
//       final track = stat.track.value;
//       if (track != null) {
//         bool founded = false;
//         for (var entr in playDurationMap.entries) {
//           if (entr.key.md5Hash == track.md5Hash) {
//             playDurationMap.update(entr.key, (a) => a + stat.playedSeconds);
//             founded = true;
//             break;
//           }
//         }
//         if (!founded) {
//           playDurationMap[track] =
//               (playDurationMap[track] ?? 0) + stat.playedSeconds;
//         }
//       }
//     }

//     if (playDurationMap.isEmpty) return null;
//     final a = playDurationMap.entries.reduce(
//       (a, b) => a.value > b.value ? a : b,
//     );

//     return a;
//   }

//   Future<MapEntry<String, int>?> getMostPlayedArtist({
//     DateTime? time,
//   }) async {
//     late List<PlayerTrackStat> stats;
//     if (time != null) {
//       stats = await isar.playerTrackStats
//           .where()
//           .filter()
//           .timeGreaterThan(time)
//           .findAll();
//     } else {
//       stats = await isar.playerTrackStats.where().findAll();
//     }

//     final Map<String, int> artistMap = {};

//     for (var stat in stats) {
//       await stat.track.load();
//       final track = stat.track.value;
//       if (track != null) {
//         bool founded = false;
//         for (String artist in track.artists) {
//           for (var a in artistMap.entries) {
//             if (artist == a.key) {
//               founded = true;
//               artistMap.update(a.key, (a) => a + stat.playedSeconds);
//             }
//           }
//           if (!founded) {
//             artistMap[artist] = (artistMap[artist] ?? 0) + stat.playedSeconds;
//           }
//         }
//       }
//     }

//     if (artistMap.isEmpty) return null;
//     final a = artistMap.entries.reduce((a, b) => a.value > b.value ? a : b);
//     return a;
//   }
// }

// Future<String> getMd5(File file) async {
//   final fileSize = await file.length();
//   final stream = file.openRead(0, min(1024 * 1024, fileSize));
//   final digest = await md5.bind(stream).first;
//   return digest.toString();
// }

// // DATABASE SETTINGS

// enum Source {
//   yandexMusic,
//   local;

//   factory Source.getFromPlayerTrack(PlayerTrack track) {
//     if (track is YandexMusicTrack) {
//       return Source.yandexMusic;
//     }

//     return Source.local;
//   }
// }

// @collection
// class PlayerTrack1 {
//   Id id = Isar.autoIncrement;
//   @Index(unique: true, replace: true)
//   final String md5Hash;
//   final String title;
//   final String cover;
//   final String filepath;
//   @enumerated
//   final Source source;
//   final List<String> artists;
//   final List<String> albums;
//   // final List<int> coverByted;

//   PlayerTrack1({
//     required this.title,
//     required this.artists,
//     required this.albums,
//     required this.filepath,
//     required this.cover,
//     required this.md5Hash,
//     required this.source,
//     // required this.coverByted,
//   });
//   static Future<PlayerTrack1?> createFromTrack(
//     PlayerTrack track, {
//     String? hash,
//   }) async {
//     final trackFile = File(track.filepath);
//     if (await trackFile.exists()) {
//       hash ??= await getMd5(File(track.filepath));
//       return PlayerTrack1(
//         title: track.title,
//         artists: track.artists,
//         albums: track.albums,
//         filepath: track.filepath,
//         cover: track.cover,
//         // coverByted: track.coverByted.toList(),
//         source: Source.getFromPlayerTrack(track),
//         md5Hash: hash,
//       );
//     }
//     return null;
//   }
// }

// enum PlayedType {
//   completed,
//   skipped;

//   static PlayedType fromChangeReason(ChangeReason reason) {
//     return (reason == ChangeReason.completed)
//         ? PlayedType.completed
//         : PlayedType.skipped;
//   }
// }

// @collection
// class PlayerTrackStat {
//   Id id = Isar.autoIncrement;
//   final track = IsarLink<PlayerTrack1>();
//   @Index()
//   DateTime time;
//   int playedSeconds;
//   int totalTrackDuration;
//   @Index()
//   int progressPercent;
//   @enumerated
//   PlayedType changeType;

//   PlayerTrackStat({
//     required this.playedSeconds,
//     required this.totalTrackDuration,
//     required this.changeType,
//     required this.time,
//     required this.progressPercent,
//   });
// }
