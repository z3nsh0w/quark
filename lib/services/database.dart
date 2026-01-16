// import 'dart:io';
// import 'package:drift/drift.dart';
// import 'package:drift/native.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:yandex_music/yandex_music.dart';
// import 'package:yandex_music/src/objects/album.dart' as yandex_music_album;
// import 'package:yandex_music/src/objects/track.dart' as yandex_music_track;
// import 'package:yandex_music/src/objects/artist.dart' as yandex_music_artist;
// part 'database.g.dart';

// class Settings extends Table {
//   // Local player settings
//   IntColumn get id => integer()();
//   RealColumn get volume => real().withDefault(const Constant(0.7))();
//   BoolColumn get indicatorState =>
//       boolean().withDefault(const Constant(false))();
//   BoolColumn get albumArtAsBackground =>
//       boolean().withDefault(const Constant(true))();
//   BoolColumn get smartShuffle => boolean().withDefault(const Constant(false))();
//   BoolColumn get adwaitaTheme => boolean().withDefault(const Constant(false))();
//   BoolColumn get transparentMode =>
//       boolean().withDefault(const Constant(false))();
//   BoolColumn get windowManager =>
//       boolean().withDefault(const Constant(false))();
//   BoolColumn get logListenedTracks =>
//       boolean().withDefault(const Constant(true))();
//   BoolColumn get openPlaylistAtStart =>
//       boolean().withDefault(const Constant(false))();
//   BoolColumn get sendListenFeedbacksToYandexMusic =>
//       boolean().withDefault(const Constant(false))();
//   // Yandex account
//   TextColumn? get yandexMusicAccountToken => text().nullable()();
//   TextColumn? get yandexMusicAccountEmail => text().nullable()();
//   TextColumn? get yandexMusicAccountLogin => text().nullable()();
//   TextColumn? get yandexMusicAccountName => text().nullable()();
//   TextColumn? get yandexMusicAccountUid => text().nullable()();
//   TextColumn? get yandexMusicAccountFullname => text().nullable()();
//   // Yandex instance
//   TextColumn get yandexMusicDownloadQuality => text().nullable()();
//   BoolColumn get yandexMusicPreloadAtStart =>
//       boolean().withDefault(const Constant(true))();

//   IntColumn get lastTrack => integer().nullable().references(Tracks, #id)();
// }

// @DataClassName('Track')
// class Tracks extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get title => text().withDefault(const Constant('Unknown'))();
//   TextColumn? get date => text().nullable()();
//   TextColumn? get composer => text().nullable()();
//   TextColumn? get performer => text().nullable()();
//   TextColumn? get albumArtistName => text().nullable()();
//   IntColumn? get trackNumberInAlbum => integer().nullable()();
//   IntColumn? get totalTrackInAlbum => integer().nullable()();
//   IntColumn? get discNumber => integer().nullable()();
//   IntColumn? get totalDiscs => integer().nullable()();
//   TextColumn? get comment => text().nullable()();
//   TextColumn? get externalId => text().nullable().unique()();
//   // File info
//   IntColumn get durationMs => integer().withDefault(const Constant(0))();
//   IntColumn get sampleRate => integer().withDefault(const Constant(0))();
//   IntColumn get channels => integer().withDefault(const Constant(0))();
//   IntColumn get bitsPerSample => integer().withDefault(const Constant(0))();
//   IntColumn get bitrate => integer().withDefault(const Constant(0))();
//   TextColumn? get codec => text().nullable()();
//   TextColumn? get encoding => text().nullable()();
//   TextColumn? get tool => text().nullable()();

//   IntColumn get listenCount => integer().withDefault(const Constant(0))();

//   TextColumn? get audioMd5 => text().unique().nullable()();
//   TextColumn get filePath => text()();
//   TextColumn get source => text().withDefault(const Constant('local'))();
//   TextColumn? get coverUrl => text().nullable()();
//   TextColumn? get coverPath => text().nullable()();
// }

// class TrackArtist extends Table {
//   IntColumn get trackId => integer().references(Tracks, #id)();
//   IntColumn get artistId => integer().references(Artists, #id).unique()();
//   @override
//   Set<Column> get primaryKey => {trackId, artistId};
// }

// class TrackAlbum extends Table {
//   IntColumn get trackId => integer().references(Tracks, #id)();
//   IntColumn get albumId => integer().references(Albums, #id).unique()();
//   @override
//   Set<Column> get primaryKey => {trackId, albumId};
// }

// class TrackGenre extends Table {
//   IntColumn get trackId => integer().references(Tracks, #id)();
//   IntColumn get genreId => integer().references(Genres, #id).unique()();
//   @override
//   Set<Column> get primaryKey => {trackId, genreId};
// }

// class AlbumGenre extends Table {
//   IntColumn get albumId => integer().references(Albums, #id)();
//   IntColumn get genreId => integer().references(Genres, #id).unique()();
//   @override
//   Set<Column> get primaryKey => {albumId, genreId};
// }

// @DataClassName('Genre')
// class Genres extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name => text().unique()();
// }

// class YandexMusicAditionalTrackInfo extends Table {
//   IntColumn get id => integer().references(Tracks, #id)();
//   IntColumn? get realId => integer().nullable()();
//   TextColumn? get trackSharingFlag => text().nullable()();
//   TextColumn? get trackSource => text().nullable()();
//   RealColumn? get r128i => real().nullable()();
//   RealColumn? get r128tp => real().nullable()();
//   RealColumn? get fadeInStart => real().nullable()();
//   RealColumn? get fadeInStop => real().nullable()();
//   RealColumn? get fadeOutStart => real().nullable()();
//   RealColumn? get fadeOutStop => real().nullable()();
//   TextColumn? get averageColor => text().nullable()();
//   TextColumn? get waveTextColor => text().nullable()();
//   TextColumn? get miniPlayerColor => text().nullable()();
//   TextColumn? get accentColor => text().nullable()();
// }

// class YandexMusicTrackDisclaimer extends Table {
//   IntColumn get trackId => integer().references(Tracks, #id)();
//   IntColumn get disclaimerId =>
//       integer().references(Disclaimers, #id).unique()();
//   @override
//   Set<Column> get primaryKey => {trackId, disclaimerId};
// }

// @DataClassName('Disclaimer')
// class Disclaimers extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn get name => text().unique()();
// }

// @DataClassName('Artist')
// class Artists extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn? get externalId => text().nullable().unique()();
//   TextColumn get name => text().withDefault(const Constant('Unknown'))();
//   BoolColumn? get various => boolean().nullable()();
//   BoolColumn? get composer => boolean().nullable()();
//   TextColumn? get coverUrl => text().nullable()();
//   TextColumn? get coverPath => text().nullable()();

//   TextColumn get source => text().withDefault(const Constant('local'))();
// }

// @DataClassName('Album')
// class Albums extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn? get externalId => text().nullable().unique()();
//   TextColumn get title => text().withDefault(const Constant('Unknown'))();
//   TextColumn? get type => text().nullable()();
//   TextColumn? get metaType => text().nullable()();
//   IntColumn? get year => integer().nullable()();
//   TextColumn? get releaseDate => text().nullable()();
//   TextColumn? get coverUrl => text().nullable()();
//   TextColumn? get coverPath => text().nullable()();
//   IntColumn? get trackCount => integer().nullable()();

//   TextColumn get source => text().withDefault(const Constant('local'))();
// }

// @DataClassName('Playlist')
// class Playlists extends Table {
//   IntColumn get id => integer().autoIncrement()();
//   TextColumn? get externalId => text().nullable().unique()();
//   TextColumn? get externalId2 => text().nullable().unique()();
//   TextColumn get title => text().withDefault(const Constant('Unknown'))();
//   IntColumn get trackCount => integer().withDefault(const Constant(0))();
//   TextColumn get source => text().withDefault(const Constant('local'))();
//   TextColumn? get coverUrl => text().nullable()();
//   TextColumn? get coverPath => text().nullable()();
//   TextColumn? get description => text().nullable()();
//   TextColumn? get owner => text().nullable()();
//   IntColumn get listenCount => integer().withDefault(const Constant(0))();
//   IntColumn? get lastPlayedTrack =>
//       integer().nullable().references(Tracks, #id)();
//   IntColumn get durationMs => integer().withDefault(const Constant(0))();
// }

// class PlaylistTracks extends Table {
//   IntColumn get trackId => integer().references(Tracks, #id)();
//   IntColumn get playlistId => integer().references(Playlists, #id)();
//   @override
//   Set<Column> get primaryKey => {playlistId, trackId};
// }

// @DriftDatabase(
//   tables: [
//     Settings,
//     Playlists,
//     Tracks,
//     Artists,
//     Albums,
//     Genres,
//     TrackGenre,
//     AlbumGenre,
//     TrackArtist,
//     TrackAlbum,
//     Disclaimers,
//     YandexMusicAditionalTrackInfo,
//     YandexMusicTrackDisclaimer,
//     PlaylistTracks,
//   ],
// )
// class AppDatabase extends _$AppDatabase {
//   AppDatabase() : super(_openConnection());

//   @override
//   int get schemaVersion => 1;

//   Future<List<Track>> getAllTracks() => select(tracks).get();
//   Future<int> addTrack(yandex_music_track.Track track, String filePath) {
//     return into(tracks).insert(
//       TracksCompanion(
//         title: Value(track.title),
//         durationMs: Value(track.durationMs ?? 0),
//         filePath: Value(filePath),
//         sampleRate: Value(1),
//         channels: Value(1),
//         bitsPerSample: Value(1),
//         bitrate: Value(1),
//         codec: Value('FLAC'),
//         audioMd5: Value('42yjiwgm'),
//       ),
//     );
//   }

//   Future<int> addYandexMusicArtist(yandex_music_artist.Artist artist, {yandex_music_track.Track? track}) async {
//     final ArtistsCompanion toInsert;

//     if (artist is OfficialArtist) {
//       toInsert = ArtistsCompanion(
//         externalId: Value(artist.id),
//         name: Value(artist.title),
//         various: Value(artist.various),
//         composer: Value(artist.composer),
//         coverUrl: Value(artist.coverUri),
//         source: Value('yandex_music'),
//       );
//     } else {
//       if (track == null) {
//         throw ArgumentError('To add the ugc artist you need to pass the Track argument');
//       }
//       toInsert = ArtistsCompanion(
//         name: Value(artist.title),
//         externalId: Value(track.id),
//         source: Value('yandex_music_ugc'),
//       );
//     }

//     return await into(artists).insert(
//       toInsert,
//       onConflict: DoNothing(target: [artists.externalId]),
//     );
//   }

//   Future<int> addYandexMusicAlbum(yandex_music_album.Album album) async {
//     final toInsert = AlbumsCompanion(
//       externalId: Value(album.id),
//       title: Value(album.title),
//       year: Value(int.parse(album.year)),
//       releaseDate: Value(album.releaseDate),
//       coverUrl: Value(album.coverUri),
//       trackCount: Value(album.trackCount),
//       source: Value('yandex_music'),
//     );

//     return await into(albums).insert(
//       toInsert,
//       onConflict: DoUpdate(
//         (old) => toInsert,
//         target: [
//           albums.coverUrl,
//           albums.title,
//           albums.trackCount,
//           albums.year,
//           albums.releaseDate,
//         ],
//       ),
//     );
//   }

//   Future<int> addDisclaimer(String disclaimer) async {
//     return await into(disclaimers).insert(
//       DisclaimersCompanion(name: Value(disclaimer)),
//       onConflict: DoNothing(target: [disclaimers.name]),
//     );
//   }

//   /// Adds a track from Yandex music to the table
//   ///
//   /// If the track already exists, then information about it is updated without changing the primary key
//   // Future<int> addYandexMusicTrack(yandex_music_track.Track track) async {
//   //   for (yandex_music_artist.Artist artist in track.artists) {
//   //     int id = await addYandexMusicArtist(artist);
//   //     await into(trackArtist).insert(
//   //       TrackArtistCompanion(
//   //         trackId: Value(int.parse(track.id)),
//   //         artistId: Value(id),
//   //       ),
//   //       onConflict: DoNothing(),
//   //     );
//   //   }

//   //   for (yandex_music_album.Album album in track.albums) {
//   //     int id = await addYandexMusicAlbum(album);
//   //     await into(trackAlbum).insert(
//   //       TrackAlbumCompanion(
//   //         trackId: Value(int.parse(track.id)),
//   //         albumId: Value(id),
//   //       ),
//   //       onConflict: DoNothing(),
//   //     );
//   //   }

//   //   final filePath = await getYandexMusicTrackPath(track.id);

//   //   for (String disclaimer in track.raw['disclaimers']) {

//   //   }

//   //   final toInsert = TracksCompanion(
//   //     title: Value(track.title),
//   //     source: Value('yandex_music'),
//   //     durationMs: Value(track.durationMs ?? 0),
//   //     filePath: Value(filePath),
//   //     coverUrl: Value(track.coverUri)
//   //   );

//   //   final toInsert2 = YandexMusicAditionalTrackInfoCompanion(
//   //     realId: Value(int.tryParse(track.realId ?? '')),
//   //     trackSource: Value(track.trackSource),

//   //   );

//   //   await into(tracks).insert()

//   // }
// }

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dbFolder = await getApplicationCacheDirectory();
//     final file = File(p.join(dbFolder.path, 'quark.db'));
//     return NativeDatabase.createInBackground(file);
//   });
// }

// Future<bool> migrateFromHive() async {
//   // #TODO

//   return true;
// }

// Future<String> getYandexMusicTrackPath(String appendName) async {
//   Directory cacheDirectory = await getApplicationCacheDirectory();
//   return '${cacheDirectory.path}/cisum_xednay_krauq$appendName.flac';
// }
