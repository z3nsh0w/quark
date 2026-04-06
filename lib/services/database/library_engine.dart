// import 'dart:io';
// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:quark/objects/track.dart';

// part 'library_engine.g.dart';

// @TableIndex(name: 'idx_known_tracks_title', columns: {#title})
// @TableIndex(name: 'idx_known_tracks_artists', columns: {#artists})
// @DataClassName("KnownTrack")
// class KnownTracks extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get path => text().unique()();
//   // UI info without relation
//   TextColumn get title => text()();
//   // UI info without relation
//   TextColumn get artists => text()();
//   // UI info without relation
//   TextColumn get album => text()();
//   TextColumn get coverUrl => text().nullable()();
//   TextColumn get coverPath => text().nullable()();
//   TextColumn get blurCoverPath => text().nullable()();
//   TextColumn get md5 => text().nullable()();
//   TextColumn get source => text().withDefault(const Constant("local"))();
//   TextColumn get sourceid => text().nullable()();
//   BoolColumn get downloaded => boolean()();
// }

// @DataClassName("Playlist")
// class Playlists extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text()();
//   TextColumn get coverUrl => text().nullable()();
//   TextColumn get coverPath => text().nullable()();
//   TextColumn get description => text().nullable()();
//   TextColumn get blurCoverPath => text().nullable()();
//   // Album / Playlist
//   TextColumn get type => text().withDefault(const Constant("Playlist"))();
// }

// @TableIndex(
//   name: 'idx_playlist_tracks_playlist_pos',
//   columns: {#playlist, #position},
// )
// @DataClassName("PlaylistTrack")
// class PlaylistTracks extends Table {
//   @override
//   Set<Column> get primaryKey => {playlist, track};
//   IntColumn get track => integer().references(KnownTracks, #id)();
//   IntColumn get playlist => integer().references(Playlists, #id)();
//   IntColumn get position => integer()();
// }

// @TableIndex(name: 'idx_cover_colors_md5', columns: {#md5})
// @DataClassName("CoverColor")
// class CoverColors extends Table {
//   TextColumn get md5 => text()();

//   /// JSON FORMAT => ```List<int>```
//   TextColumn get colors => text()();

//   @override
//   Set<Column> get primaryKey => {md5};
// }

// @TableIndex(name: 'idx_listen_stats_track', columns: {#track})
// @TableIndex(name: 'idx_listen_stats_time', columns: {#time})
// @DataClassName("ListenStat")
// class ListenStats extends Table {
//   IntColumn get track => integer().references(KnownTracks, #id)();

//   /// ISO8601
//   DateTimeColumn get time => dateTime()();
//   IntColumn get playedSeconds => integer()();
//   IntColumn get totalTrackDuration => integer()();
//   IntColumn get progressPercent => integer()();
//   BoolColumn get isSkipped => boolean()();
// }

// @DriftDatabase(
//   tables: [Playlists, PlaylistTracks, KnownTracks, CoverColors, ListenStats],
// )
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 1;

//   Future<void> saveTrack(PlayerTrack track) async {
//     await 
//   }
// }

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationCacheDirectory();
//     final file = File(p.join(dbFolder.path, 'quark.db'));
//     return NativeDatabase.createInBackground(file);
//   });
// }
