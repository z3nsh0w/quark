// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'database.dart';

// // ignore_for_file: type=lint
// class $TracksTable extends Tracks with TableInfo<$TracksTable, Track> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $TracksTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//     'id',
//     aliasedName,
//     false,
//     hasAutoIncrement: true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'PRIMARY KEY AUTOINCREMENT',
//     ),
//   );
//   static const VerificationMeta _titleMeta = const VerificationMeta('title');
//   @override
//   late final GeneratedColumn<String> title = GeneratedColumn<String>(
//     'title',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant('Unknown'),
//   );
//   static const VerificationMeta _dateMeta = const VerificationMeta('date');
//   @override
//   late final GeneratedColumn<String> date = GeneratedColumn<String>(
//     'date',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _composerMeta = const VerificationMeta(
//     'composer',
//   );
//   @override
//   late final GeneratedColumn<String> composer = GeneratedColumn<String>(
//     'composer',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _performerMeta = const VerificationMeta(
//     'performer',
//   );
//   @override
//   late final GeneratedColumn<String> performer = GeneratedColumn<String>(
//     'performer',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _albumArtistNameMeta = const VerificationMeta(
//     'albumArtistName',
//   );
//   @override
//   late final GeneratedColumn<String> albumArtistName = GeneratedColumn<String>(
//     'album_artist_name',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _trackNumberInAlbumMeta =
//       const VerificationMeta('trackNumberInAlbum');
//   @override
//   late final GeneratedColumn<int> trackNumberInAlbum = GeneratedColumn<int>(
//     'track_number_in_album',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _totalTrackInAlbumMeta = const VerificationMeta(
//     'totalTrackInAlbum',
//   );
//   @override
//   late final GeneratedColumn<int> totalTrackInAlbum = GeneratedColumn<int>(
//     'total_track_in_album',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _discNumberMeta = const VerificationMeta(
//     'discNumber',
//   );
//   @override
//   late final GeneratedColumn<int> discNumber = GeneratedColumn<int>(
//     'disc_number',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _totalDiscsMeta = const VerificationMeta(
//     'totalDiscs',
//   );
//   @override
//   late final GeneratedColumn<int> totalDiscs = GeneratedColumn<int>(
//     'total_discs',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _commentMeta = const VerificationMeta(
//     'comment',
//   );
//   @override
//   late final GeneratedColumn<String> comment = GeneratedColumn<String>(
//     'comment',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _externalIdMeta = const VerificationMeta(
//     'externalId',
//   );
//   @override
//   late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
//     'external_id',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   static const VerificationMeta _durationMsMeta = const VerificationMeta(
//     'durationMs',
//   );
//   @override
//   late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
//     'duration_ms',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   static const VerificationMeta _sampleRateMeta = const VerificationMeta(
//     'sampleRate',
//   );
//   @override
//   late final GeneratedColumn<int> sampleRate = GeneratedColumn<int>(
//     'sample_rate',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   static const VerificationMeta _channelsMeta = const VerificationMeta(
//     'channels',
//   );
//   @override
//   late final GeneratedColumn<int> channels = GeneratedColumn<int>(
//     'channels',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   static const VerificationMeta _bitsPerSampleMeta = const VerificationMeta(
//     'bitsPerSample',
//   );
//   @override
//   late final GeneratedColumn<int> bitsPerSample = GeneratedColumn<int>(
//     'bits_per_sample',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   static const VerificationMeta _bitrateMeta = const VerificationMeta(
//     'bitrate',
//   );
//   @override
//   late final GeneratedColumn<int> bitrate = GeneratedColumn<int>(
//     'bitrate',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   static const VerificationMeta _codecMeta = const VerificationMeta('codec');
//   @override
//   late final GeneratedColumn<String> codec = GeneratedColumn<String>(
//     'codec',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _encodingMeta = const VerificationMeta(
//     'encoding',
//   );
//   @override
//   late final GeneratedColumn<String> encoding = GeneratedColumn<String>(
//     'encoding',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _toolMeta = const VerificationMeta('tool');
//   @override
//   late final GeneratedColumn<String> tool = GeneratedColumn<String>(
//     'tool',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _listenCountMeta = const VerificationMeta(
//     'listenCount',
//   );
//   @override
//   late final GeneratedColumn<int> listenCount = GeneratedColumn<int>(
//     'listen_count',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   static const VerificationMeta _audioMd5Meta = const VerificationMeta(
//     'audioMd5',
//   );
//   @override
//   late final GeneratedColumn<String> audioMd5 = GeneratedColumn<String>(
//     'audio_md5',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   static const VerificationMeta _filePathMeta = const VerificationMeta(
//     'filePath',
//   );
//   @override
//   late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
//     'file_path',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _sourceMeta = const VerificationMeta('source');
//   @override
//   late final GeneratedColumn<String> source = GeneratedColumn<String>(
//     'source',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant('local'),
//   );
//   static const VerificationMeta _coverUrlMeta = const VerificationMeta(
//     'coverUrl',
//   );
//   @override
//   late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
//     'cover_url',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _coverPathMeta = const VerificationMeta(
//     'coverPath',
//   );
//   @override
//   late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
//     'cover_path',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     id,
//     title,
//     date,
//     composer,
//     performer,
//     albumArtistName,
//     trackNumberInAlbum,
//     totalTrackInAlbum,
//     discNumber,
//     totalDiscs,
//     comment,
//     externalId,
//     durationMs,
//     sampleRate,
//     channels,
//     bitsPerSample,
//     bitrate,
//     codec,
//     encoding,
//     tool,
//     listenCount,
//     audioMd5,
//     filePath,
//     source,
//     coverUrl,
//     coverPath,
//   ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'tracks';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<Track> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('title')) {
//       context.handle(
//         _titleMeta,
//         title.isAcceptableOrUnknown(data['title']!, _titleMeta),
//       );
//     }
//     if (data.containsKey('date')) {
//       context.handle(
//         _dateMeta,
//         date.isAcceptableOrUnknown(data['date']!, _dateMeta),
//       );
//     }
//     if (data.containsKey('composer')) {
//       context.handle(
//         _composerMeta,
//         composer.isAcceptableOrUnknown(data['composer']!, _composerMeta),
//       );
//     }
//     if (data.containsKey('performer')) {
//       context.handle(
//         _performerMeta,
//         performer.isAcceptableOrUnknown(data['performer']!, _performerMeta),
//       );
//     }
//     if (data.containsKey('album_artist_name')) {
//       context.handle(
//         _albumArtistNameMeta,
//         albumArtistName.isAcceptableOrUnknown(
//           data['album_artist_name']!,
//           _albumArtistNameMeta,
//         ),
//       );
//     }
//     if (data.containsKey('track_number_in_album')) {
//       context.handle(
//         _trackNumberInAlbumMeta,
//         trackNumberInAlbum.isAcceptableOrUnknown(
//           data['track_number_in_album']!,
//           _trackNumberInAlbumMeta,
//         ),
//       );
//     }
//     if (data.containsKey('total_track_in_album')) {
//       context.handle(
//         _totalTrackInAlbumMeta,
//         totalTrackInAlbum.isAcceptableOrUnknown(
//           data['total_track_in_album']!,
//           _totalTrackInAlbumMeta,
//         ),
//       );
//     }
//     if (data.containsKey('disc_number')) {
//       context.handle(
//         _discNumberMeta,
//         discNumber.isAcceptableOrUnknown(data['disc_number']!, _discNumberMeta),
//       );
//     }
//     if (data.containsKey('total_discs')) {
//       context.handle(
//         _totalDiscsMeta,
//         totalDiscs.isAcceptableOrUnknown(data['total_discs']!, _totalDiscsMeta),
//       );
//     }
//     if (data.containsKey('comment')) {
//       context.handle(
//         _commentMeta,
//         comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
//       );
//     }
//     if (data.containsKey('external_id')) {
//       context.handle(
//         _externalIdMeta,
//         externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
//       );
//     }
//     if (data.containsKey('duration_ms')) {
//       context.handle(
//         _durationMsMeta,
//         durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
//       );
//     }
//     if (data.containsKey('sample_rate')) {
//       context.handle(
//         _sampleRateMeta,
//         sampleRate.isAcceptableOrUnknown(data['sample_rate']!, _sampleRateMeta),
//       );
//     }
//     if (data.containsKey('channels')) {
//       context.handle(
//         _channelsMeta,
//         channels.isAcceptableOrUnknown(data['channels']!, _channelsMeta),
//       );
//     }
//     if (data.containsKey('bits_per_sample')) {
//       context.handle(
//         _bitsPerSampleMeta,
//         bitsPerSample.isAcceptableOrUnknown(
//           data['bits_per_sample']!,
//           _bitsPerSampleMeta,
//         ),
//       );
//     }
//     if (data.containsKey('bitrate')) {
//       context.handle(
//         _bitrateMeta,
//         bitrate.isAcceptableOrUnknown(data['bitrate']!, _bitrateMeta),
//       );
//     }
//     if (data.containsKey('codec')) {
//       context.handle(
//         _codecMeta,
//         codec.isAcceptableOrUnknown(data['codec']!, _codecMeta),
//       );
//     }
//     if (data.containsKey('encoding')) {
//       context.handle(
//         _encodingMeta,
//         encoding.isAcceptableOrUnknown(data['encoding']!, _encodingMeta),
//       );
//     }
//     if (data.containsKey('tool')) {
//       context.handle(
//         _toolMeta,
//         tool.isAcceptableOrUnknown(data['tool']!, _toolMeta),
//       );
//     }
//     if (data.containsKey('listen_count')) {
//       context.handle(
//         _listenCountMeta,
//         listenCount.isAcceptableOrUnknown(
//           data['listen_count']!,
//           _listenCountMeta,
//         ),
//       );
//     }
//     if (data.containsKey('audio_md5')) {
//       context.handle(
//         _audioMd5Meta,
//         audioMd5.isAcceptableOrUnknown(data['audio_md5']!, _audioMd5Meta),
//       );
//     }
//     if (data.containsKey('file_path')) {
//       context.handle(
//         _filePathMeta,
//         filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_filePathMeta);
//     }
//     if (data.containsKey('source')) {
//       context.handle(
//         _sourceMeta,
//         source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
//       );
//     }
//     if (data.containsKey('cover_url')) {
//       context.handle(
//         _coverUrlMeta,
//         coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
//       );
//     }
//     if (data.containsKey('cover_path')) {
//       context.handle(
//         _coverPathMeta,
//         coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
//       );
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   Track map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return Track(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       title: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}title'],
//       )!,
//       date: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}date'],
//       ),
//       composer: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}composer'],
//       ),
//       performer: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}performer'],
//       ),
//       albumArtistName: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}album_artist_name'],
//       ),
//       trackNumberInAlbum: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track_number_in_album'],
//       ),
//       totalTrackInAlbum: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}total_track_in_album'],
//       ),
//       discNumber: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}disc_number'],
//       ),
//       totalDiscs: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}total_discs'],
//       ),
//       comment: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}comment'],
//       ),
//       externalId: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}external_id'],
//       ),
//       durationMs: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}duration_ms'],
//       )!,
//       sampleRate: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}sample_rate'],
//       )!,
//       channels: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}channels'],
//       )!,
//       bitsPerSample: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}bits_per_sample'],
//       )!,
//       bitrate: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}bitrate'],
//       )!,
//       codec: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}codec'],
//       ),
//       encoding: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}encoding'],
//       ),
//       tool: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}tool'],
//       ),
//       listenCount: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}listen_count'],
//       )!,
//       audioMd5: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}audio_md5'],
//       ),
//       filePath: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}file_path'],
//       )!,
//       source: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}source'],
//       )!,
//       coverUrl: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_url'],
//       ),
//       coverPath: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_path'],
//       ),
//     );
//   }

//   @override
//   $TracksTable createAlias(String alias) {
//     return $TracksTable(attachedDatabase, alias);
//   }
// }

// class Track extends DataClass implements Insertable<Track> {
//   final int id;
//   final String title;
//   final String? date;
//   final String? composer;
//   final String? performer;
//   final String? albumArtistName;
//   final int? trackNumberInAlbum;
//   final int? totalTrackInAlbum;
//   final int? discNumber;
//   final int? totalDiscs;
//   final String? comment;
//   final String? externalId;
//   final int durationMs;
//   final int sampleRate;
//   final int channels;
//   final int bitsPerSample;
//   final int bitrate;
//   final String? codec;
//   final String? encoding;
//   final String? tool;
//   final int listenCount;
//   final String? audioMd5;
//   final String filePath;
//   final String source;
//   final String? coverUrl;
//   final String? coverPath;
//   const Track({
//     required this.id,
//     required this.title,
//     this.date,
//     this.composer,
//     this.performer,
//     this.albumArtistName,
//     this.trackNumberInAlbum,
//     this.totalTrackInAlbum,
//     this.discNumber,
//     this.totalDiscs,
//     this.comment,
//     this.externalId,
//     required this.durationMs,
//     required this.sampleRate,
//     required this.channels,
//     required this.bitsPerSample,
//     required this.bitrate,
//     this.codec,
//     this.encoding,
//     this.tool,
//     required this.listenCount,
//     this.audioMd5,
//     required this.filePath,
//     required this.source,
//     this.coverUrl,
//     this.coverPath,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     map['title'] = Variable<String>(title);
//     if (!nullToAbsent || date != null) {
//       map['date'] = Variable<String>(date);
//     }
//     if (!nullToAbsent || composer != null) {
//       map['composer'] = Variable<String>(composer);
//     }
//     if (!nullToAbsent || performer != null) {
//       map['performer'] = Variable<String>(performer);
//     }
//     if (!nullToAbsent || albumArtistName != null) {
//       map['album_artist_name'] = Variable<String>(albumArtistName);
//     }
//     if (!nullToAbsent || trackNumberInAlbum != null) {
//       map['track_number_in_album'] = Variable<int>(trackNumberInAlbum);
//     }
//     if (!nullToAbsent || totalTrackInAlbum != null) {
//       map['total_track_in_album'] = Variable<int>(totalTrackInAlbum);
//     }
//     if (!nullToAbsent || discNumber != null) {
//       map['disc_number'] = Variable<int>(discNumber);
//     }
//     if (!nullToAbsent || totalDiscs != null) {
//       map['total_discs'] = Variable<int>(totalDiscs);
//     }
//     if (!nullToAbsent || comment != null) {
//       map['comment'] = Variable<String>(comment);
//     }
//     if (!nullToAbsent || externalId != null) {
//       map['external_id'] = Variable<String>(externalId);
//     }
//     map['duration_ms'] = Variable<int>(durationMs);
//     map['sample_rate'] = Variable<int>(sampleRate);
//     map['channels'] = Variable<int>(channels);
//     map['bits_per_sample'] = Variable<int>(bitsPerSample);
//     map['bitrate'] = Variable<int>(bitrate);
//     if (!nullToAbsent || codec != null) {
//       map['codec'] = Variable<String>(codec);
//     }
//     if (!nullToAbsent || encoding != null) {
//       map['encoding'] = Variable<String>(encoding);
//     }
//     if (!nullToAbsent || tool != null) {
//       map['tool'] = Variable<String>(tool);
//     }
//     map['listen_count'] = Variable<int>(listenCount);
//     if (!nullToAbsent || audioMd5 != null) {
//       map['audio_md5'] = Variable<String>(audioMd5);
//     }
//     map['file_path'] = Variable<String>(filePath);
//     map['source'] = Variable<String>(source);
//     if (!nullToAbsent || coverUrl != null) {
//       map['cover_url'] = Variable<String>(coverUrl);
//     }
//     if (!nullToAbsent || coverPath != null) {
//       map['cover_path'] = Variable<String>(coverPath);
//     }
//     return map;
//   }

//   TracksCompanion toCompanion(bool nullToAbsent) {
//     return TracksCompanion(
//       id: Value(id),
//       title: Value(title),
//       date: date == null && nullToAbsent ? const Value.absent() : Value(date),
//       composer: composer == null && nullToAbsent
//           ? const Value.absent()
//           : Value(composer),
//       performer: performer == null && nullToAbsent
//           ? const Value.absent()
//           : Value(performer),
//       albumArtistName: albumArtistName == null && nullToAbsent
//           ? const Value.absent()
//           : Value(albumArtistName),
//       trackNumberInAlbum: trackNumberInAlbum == null && nullToAbsent
//           ? const Value.absent()
//           : Value(trackNumberInAlbum),
//       totalTrackInAlbum: totalTrackInAlbum == null && nullToAbsent
//           ? const Value.absent()
//           : Value(totalTrackInAlbum),
//       discNumber: discNumber == null && nullToAbsent
//           ? const Value.absent()
//           : Value(discNumber),
//       totalDiscs: totalDiscs == null && nullToAbsent
//           ? const Value.absent()
//           : Value(totalDiscs),
//       comment: comment == null && nullToAbsent
//           ? const Value.absent()
//           : Value(comment),
//       externalId: externalId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(externalId),
//       durationMs: Value(durationMs),
//       sampleRate: Value(sampleRate),
//       channels: Value(channels),
//       bitsPerSample: Value(bitsPerSample),
//       bitrate: Value(bitrate),
//       codec: codec == null && nullToAbsent
//           ? const Value.absent()
//           : Value(codec),
//       encoding: encoding == null && nullToAbsent
//           ? const Value.absent()
//           : Value(encoding),
//       tool: tool == null && nullToAbsent ? const Value.absent() : Value(tool),
//       listenCount: Value(listenCount),
//       audioMd5: audioMd5 == null && nullToAbsent
//           ? const Value.absent()
//           : Value(audioMd5),
//       filePath: Value(filePath),
//       source: Value(source),
//       coverUrl: coverUrl == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverUrl),
//       coverPath: coverPath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverPath),
//     );
//   }

//   factory Track.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return Track(
//       id: serializer.fromJson<int>(json['id']),
//       title: serializer.fromJson<String>(json['title']),
//       date: serializer.fromJson<String?>(json['date']),
//       composer: serializer.fromJson<String?>(json['composer']),
//       performer: serializer.fromJson<String?>(json['performer']),
//       albumArtistName: serializer.fromJson<String?>(json['albumArtistName']),
//       trackNumberInAlbum: serializer.fromJson<int?>(json['trackNumberInAlbum']),
//       totalTrackInAlbum: serializer.fromJson<int?>(json['totalTrackInAlbum']),
//       discNumber: serializer.fromJson<int?>(json['discNumber']),
//       totalDiscs: serializer.fromJson<int?>(json['totalDiscs']),
//       comment: serializer.fromJson<String?>(json['comment']),
//       externalId: serializer.fromJson<String?>(json['externalId']),
//       durationMs: serializer.fromJson<int>(json['durationMs']),
//       sampleRate: serializer.fromJson<int>(json['sampleRate']),
//       channels: serializer.fromJson<int>(json['channels']),
//       bitsPerSample: serializer.fromJson<int>(json['bitsPerSample']),
//       bitrate: serializer.fromJson<int>(json['bitrate']),
//       codec: serializer.fromJson<String?>(json['codec']),
//       encoding: serializer.fromJson<String?>(json['encoding']),
//       tool: serializer.fromJson<String?>(json['tool']),
//       listenCount: serializer.fromJson<int>(json['listenCount']),
//       audioMd5: serializer.fromJson<String?>(json['audioMd5']),
//       filePath: serializer.fromJson<String>(json['filePath']),
//       source: serializer.fromJson<String>(json['source']),
//       coverUrl: serializer.fromJson<String?>(json['coverUrl']),
//       coverPath: serializer.fromJson<String?>(json['coverPath']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'title': serializer.toJson<String>(title),
//       'date': serializer.toJson<String?>(date),
//       'composer': serializer.toJson<String?>(composer),
//       'performer': serializer.toJson<String?>(performer),
//       'albumArtistName': serializer.toJson<String?>(albumArtistName),
//       'trackNumberInAlbum': serializer.toJson<int?>(trackNumberInAlbum),
//       'totalTrackInAlbum': serializer.toJson<int?>(totalTrackInAlbum),
//       'discNumber': serializer.toJson<int?>(discNumber),
//       'totalDiscs': serializer.toJson<int?>(totalDiscs),
//       'comment': serializer.toJson<String?>(comment),
//       'externalId': serializer.toJson<String?>(externalId),
//       'durationMs': serializer.toJson<int>(durationMs),
//       'sampleRate': serializer.toJson<int>(sampleRate),
//       'channels': serializer.toJson<int>(channels),
//       'bitsPerSample': serializer.toJson<int>(bitsPerSample),
//       'bitrate': serializer.toJson<int>(bitrate),
//       'codec': serializer.toJson<String?>(codec),
//       'encoding': serializer.toJson<String?>(encoding),
//       'tool': serializer.toJson<String?>(tool),
//       'listenCount': serializer.toJson<int>(listenCount),
//       'audioMd5': serializer.toJson<String?>(audioMd5),
//       'filePath': serializer.toJson<String>(filePath),
//       'source': serializer.toJson<String>(source),
//       'coverUrl': serializer.toJson<String?>(coverUrl),
//       'coverPath': serializer.toJson<String?>(coverPath),
//     };
//   }

//   Track copyWith({
//     int? id,
//     String? title,
//     Value<String?> date = const Value.absent(),
//     Value<String?> composer = const Value.absent(),
//     Value<String?> performer = const Value.absent(),
//     Value<String?> albumArtistName = const Value.absent(),
//     Value<int?> trackNumberInAlbum = const Value.absent(),
//     Value<int?> totalTrackInAlbum = const Value.absent(),
//     Value<int?> discNumber = const Value.absent(),
//     Value<int?> totalDiscs = const Value.absent(),
//     Value<String?> comment = const Value.absent(),
//     Value<String?> externalId = const Value.absent(),
//     int? durationMs,
//     int? sampleRate,
//     int? channels,
//     int? bitsPerSample,
//     int? bitrate,
//     Value<String?> codec = const Value.absent(),
//     Value<String?> encoding = const Value.absent(),
//     Value<String?> tool = const Value.absent(),
//     int? listenCount,
//     Value<String?> audioMd5 = const Value.absent(),
//     String? filePath,
//     String? source,
//     Value<String?> coverUrl = const Value.absent(),
//     Value<String?> coverPath = const Value.absent(),
//   }) => Track(
//     id: id ?? this.id,
//     title: title ?? this.title,
//     date: date.present ? date.value : this.date,
//     composer: composer.present ? composer.value : this.composer,
//     performer: performer.present ? performer.value : this.performer,
//     albumArtistName: albumArtistName.present
//         ? albumArtistName.value
//         : this.albumArtistName,
//     trackNumberInAlbum: trackNumberInAlbum.present
//         ? trackNumberInAlbum.value
//         : this.trackNumberInAlbum,
//     totalTrackInAlbum: totalTrackInAlbum.present
//         ? totalTrackInAlbum.value
//         : this.totalTrackInAlbum,
//     discNumber: discNumber.present ? discNumber.value : this.discNumber,
//     totalDiscs: totalDiscs.present ? totalDiscs.value : this.totalDiscs,
//     comment: comment.present ? comment.value : this.comment,
//     externalId: externalId.present ? externalId.value : this.externalId,
//     durationMs: durationMs ?? this.durationMs,
//     sampleRate: sampleRate ?? this.sampleRate,
//     channels: channels ?? this.channels,
//     bitsPerSample: bitsPerSample ?? this.bitsPerSample,
//     bitrate: bitrate ?? this.bitrate,
//     codec: codec.present ? codec.value : this.codec,
//     encoding: encoding.present ? encoding.value : this.encoding,
//     tool: tool.present ? tool.value : this.tool,
//     listenCount: listenCount ?? this.listenCount,
//     audioMd5: audioMd5.present ? audioMd5.value : this.audioMd5,
//     filePath: filePath ?? this.filePath,
//     source: source ?? this.source,
//     coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
//     coverPath: coverPath.present ? coverPath.value : this.coverPath,
//   );
//   Track copyWithCompanion(TracksCompanion data) {
//     return Track(
//       id: data.id.present ? data.id.value : this.id,
//       title: data.title.present ? data.title.value : this.title,
//       date: data.date.present ? data.date.value : this.date,
//       composer: data.composer.present ? data.composer.value : this.composer,
//       performer: data.performer.present ? data.performer.value : this.performer,
//       albumArtistName: data.albumArtistName.present
//           ? data.albumArtistName.value
//           : this.albumArtistName,
//       trackNumberInAlbum: data.trackNumberInAlbum.present
//           ? data.trackNumberInAlbum.value
//           : this.trackNumberInAlbum,
//       totalTrackInAlbum: data.totalTrackInAlbum.present
//           ? data.totalTrackInAlbum.value
//           : this.totalTrackInAlbum,
//       discNumber: data.discNumber.present
//           ? data.discNumber.value
//           : this.discNumber,
//       totalDiscs: data.totalDiscs.present
//           ? data.totalDiscs.value
//           : this.totalDiscs,
//       comment: data.comment.present ? data.comment.value : this.comment,
//       externalId: data.externalId.present
//           ? data.externalId.value
//           : this.externalId,
//       durationMs: data.durationMs.present
//           ? data.durationMs.value
//           : this.durationMs,
//       sampleRate: data.sampleRate.present
//           ? data.sampleRate.value
//           : this.sampleRate,
//       channels: data.channels.present ? data.channels.value : this.channels,
//       bitsPerSample: data.bitsPerSample.present
//           ? data.bitsPerSample.value
//           : this.bitsPerSample,
//       bitrate: data.bitrate.present ? data.bitrate.value : this.bitrate,
//       codec: data.codec.present ? data.codec.value : this.codec,
//       encoding: data.encoding.present ? data.encoding.value : this.encoding,
//       tool: data.tool.present ? data.tool.value : this.tool,
//       listenCount: data.listenCount.present
//           ? data.listenCount.value
//           : this.listenCount,
//       audioMd5: data.audioMd5.present ? data.audioMd5.value : this.audioMd5,
//       filePath: data.filePath.present ? data.filePath.value : this.filePath,
//       source: data.source.present ? data.source.value : this.source,
//       coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
//       coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('Track(')
//           ..write('id: $id, ')
//           ..write('title: $title, ')
//           ..write('date: $date, ')
//           ..write('composer: $composer, ')
//           ..write('performer: $performer, ')
//           ..write('albumArtistName: $albumArtistName, ')
//           ..write('trackNumberInAlbum: $trackNumberInAlbum, ')
//           ..write('totalTrackInAlbum: $totalTrackInAlbum, ')
//           ..write('discNumber: $discNumber, ')
//           ..write('totalDiscs: $totalDiscs, ')
//           ..write('comment: $comment, ')
//           ..write('externalId: $externalId, ')
//           ..write('durationMs: $durationMs, ')
//           ..write('sampleRate: $sampleRate, ')
//           ..write('channels: $channels, ')
//           ..write('bitsPerSample: $bitsPerSample, ')
//           ..write('bitrate: $bitrate, ')
//           ..write('codec: $codec, ')
//           ..write('encoding: $encoding, ')
//           ..write('tool: $tool, ')
//           ..write('listenCount: $listenCount, ')
//           ..write('audioMd5: $audioMd5, ')
//           ..write('filePath: $filePath, ')
//           ..write('source: $source, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hashAll([
//     id,
//     title,
//     date,
//     composer,
//     performer,
//     albumArtistName,
//     trackNumberInAlbum,
//     totalTrackInAlbum,
//     discNumber,
//     totalDiscs,
//     comment,
//     externalId,
//     durationMs,
//     sampleRate,
//     channels,
//     bitsPerSample,
//     bitrate,
//     codec,
//     encoding,
//     tool,
//     listenCount,
//     audioMd5,
//     filePath,
//     source,
//     coverUrl,
//     coverPath,
//   ]);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Track &&
//           other.id == this.id &&
//           other.title == this.title &&
//           other.date == this.date &&
//           other.composer == this.composer &&
//           other.performer == this.performer &&
//           other.albumArtistName == this.albumArtistName &&
//           other.trackNumberInAlbum == this.trackNumberInAlbum &&
//           other.totalTrackInAlbum == this.totalTrackInAlbum &&
//           other.discNumber == this.discNumber &&
//           other.totalDiscs == this.totalDiscs &&
//           other.comment == this.comment &&
//           other.externalId == this.externalId &&
//           other.durationMs == this.durationMs &&
//           other.sampleRate == this.sampleRate &&
//           other.channels == this.channels &&
//           other.bitsPerSample == this.bitsPerSample &&
//           other.bitrate == this.bitrate &&
//           other.codec == this.codec &&
//           other.encoding == this.encoding &&
//           other.tool == this.tool &&
//           other.listenCount == this.listenCount &&
//           other.audioMd5 == this.audioMd5 &&
//           other.filePath == this.filePath &&
//           other.source == this.source &&
//           other.coverUrl == this.coverUrl &&
//           other.coverPath == this.coverPath);
// }

// class TracksCompanion extends UpdateCompanion<Track> {
//   final Value<int> id;
//   final Value<String> title;
//   final Value<String?> date;
//   final Value<String?> composer;
//   final Value<String?> performer;
//   final Value<String?> albumArtistName;
//   final Value<int?> trackNumberInAlbum;
//   final Value<int?> totalTrackInAlbum;
//   final Value<int?> discNumber;
//   final Value<int?> totalDiscs;
//   final Value<String?> comment;
//   final Value<String?> externalId;
//   final Value<int> durationMs;
//   final Value<int> sampleRate;
//   final Value<int> channels;
//   final Value<int> bitsPerSample;
//   final Value<int> bitrate;
//   final Value<String?> codec;
//   final Value<String?> encoding;
//   final Value<String?> tool;
//   final Value<int> listenCount;
//   final Value<String?> audioMd5;
//   final Value<String> filePath;
//   final Value<String> source;
//   final Value<String?> coverUrl;
//   final Value<String?> coverPath;
//   const TracksCompanion({
//     this.id = const Value.absent(),
//     this.title = const Value.absent(),
//     this.date = const Value.absent(),
//     this.composer = const Value.absent(),
//     this.performer = const Value.absent(),
//     this.albumArtistName = const Value.absent(),
//     this.trackNumberInAlbum = const Value.absent(),
//     this.totalTrackInAlbum = const Value.absent(),
//     this.discNumber = const Value.absent(),
//     this.totalDiscs = const Value.absent(),
//     this.comment = const Value.absent(),
//     this.externalId = const Value.absent(),
//     this.durationMs = const Value.absent(),
//     this.sampleRate = const Value.absent(),
//     this.channels = const Value.absent(),
//     this.bitsPerSample = const Value.absent(),
//     this.bitrate = const Value.absent(),
//     this.codec = const Value.absent(),
//     this.encoding = const Value.absent(),
//     this.tool = const Value.absent(),
//     this.listenCount = const Value.absent(),
//     this.audioMd5 = const Value.absent(),
//     this.filePath = const Value.absent(),
//     this.source = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//   });
//   TracksCompanion.insert({
//     this.id = const Value.absent(),
//     this.title = const Value.absent(),
//     this.date = const Value.absent(),
//     this.composer = const Value.absent(),
//     this.performer = const Value.absent(),
//     this.albumArtistName = const Value.absent(),
//     this.trackNumberInAlbum = const Value.absent(),
//     this.totalTrackInAlbum = const Value.absent(),
//     this.discNumber = const Value.absent(),
//     this.totalDiscs = const Value.absent(),
//     this.comment = const Value.absent(),
//     this.externalId = const Value.absent(),
//     this.durationMs = const Value.absent(),
//     this.sampleRate = const Value.absent(),
//     this.channels = const Value.absent(),
//     this.bitsPerSample = const Value.absent(),
//     this.bitrate = const Value.absent(),
//     this.codec = const Value.absent(),
//     this.encoding = const Value.absent(),
//     this.tool = const Value.absent(),
//     this.listenCount = const Value.absent(),
//     this.audioMd5 = const Value.absent(),
//     required String filePath,
//     this.source = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//   }) : filePath = Value(filePath);
//   static Insertable<Track> custom({
//     Expression<int>? id,
//     Expression<String>? title,
//     Expression<String>? date,
//     Expression<String>? composer,
//     Expression<String>? performer,
//     Expression<String>? albumArtistName,
//     Expression<int>? trackNumberInAlbum,
//     Expression<int>? totalTrackInAlbum,
//     Expression<int>? discNumber,
//     Expression<int>? totalDiscs,
//     Expression<String>? comment,
//     Expression<String>? externalId,
//     Expression<int>? durationMs,
//     Expression<int>? sampleRate,
//     Expression<int>? channels,
//     Expression<int>? bitsPerSample,
//     Expression<int>? bitrate,
//     Expression<String>? codec,
//     Expression<String>? encoding,
//     Expression<String>? tool,
//     Expression<int>? listenCount,
//     Expression<String>? audioMd5,
//     Expression<String>? filePath,
//     Expression<String>? source,
//     Expression<String>? coverUrl,
//     Expression<String>? coverPath,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (title != null) 'title': title,
//       if (date != null) 'date': date,
//       if (composer != null) 'composer': composer,
//       if (performer != null) 'performer': performer,
//       if (albumArtistName != null) 'album_artist_name': albumArtistName,
//       if (trackNumberInAlbum != null)
//         'track_number_in_album': trackNumberInAlbum,
//       if (totalTrackInAlbum != null) 'total_track_in_album': totalTrackInAlbum,
//       if (discNumber != null) 'disc_number': discNumber,
//       if (totalDiscs != null) 'total_discs': totalDiscs,
//       if (comment != null) 'comment': comment,
//       if (externalId != null) 'external_id': externalId,
//       if (durationMs != null) 'duration_ms': durationMs,
//       if (sampleRate != null) 'sample_rate': sampleRate,
//       if (channels != null) 'channels': channels,
//       if (bitsPerSample != null) 'bits_per_sample': bitsPerSample,
//       if (bitrate != null) 'bitrate': bitrate,
//       if (codec != null) 'codec': codec,
//       if (encoding != null) 'encoding': encoding,
//       if (tool != null) 'tool': tool,
//       if (listenCount != null) 'listen_count': listenCount,
//       if (audioMd5 != null) 'audio_md5': audioMd5,
//       if (filePath != null) 'file_path': filePath,
//       if (source != null) 'source': source,
//       if (coverUrl != null) 'cover_url': coverUrl,
//       if (coverPath != null) 'cover_path': coverPath,
//     });
//   }

//   TracksCompanion copyWith({
//     Value<int>? id,
//     Value<String>? title,
//     Value<String?>? date,
//     Value<String?>? composer,
//     Value<String?>? performer,
//     Value<String?>? albumArtistName,
//     Value<int?>? trackNumberInAlbum,
//     Value<int?>? totalTrackInAlbum,
//     Value<int?>? discNumber,
//     Value<int?>? totalDiscs,
//     Value<String?>? comment,
//     Value<String?>? externalId,
//     Value<int>? durationMs,
//     Value<int>? sampleRate,
//     Value<int>? channels,
//     Value<int>? bitsPerSample,
//     Value<int>? bitrate,
//     Value<String?>? codec,
//     Value<String?>? encoding,
//     Value<String?>? tool,
//     Value<int>? listenCount,
//     Value<String?>? audioMd5,
//     Value<String>? filePath,
//     Value<String>? source,
//     Value<String?>? coverUrl,
//     Value<String?>? coverPath,
//   }) {
//     return TracksCompanion(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       date: date ?? this.date,
//       composer: composer ?? this.composer,
//       performer: performer ?? this.performer,
//       albumArtistName: albumArtistName ?? this.albumArtistName,
//       trackNumberInAlbum: trackNumberInAlbum ?? this.trackNumberInAlbum,
//       totalTrackInAlbum: totalTrackInAlbum ?? this.totalTrackInAlbum,
//       discNumber: discNumber ?? this.discNumber,
//       totalDiscs: totalDiscs ?? this.totalDiscs,
//       comment: comment ?? this.comment,
//       externalId: externalId ?? this.externalId,
//       durationMs: durationMs ?? this.durationMs,
//       sampleRate: sampleRate ?? this.sampleRate,
//       channels: channels ?? this.channels,
//       bitsPerSample: bitsPerSample ?? this.bitsPerSample,
//       bitrate: bitrate ?? this.bitrate,
//       codec: codec ?? this.codec,
//       encoding: encoding ?? this.encoding,
//       tool: tool ?? this.tool,
//       listenCount: listenCount ?? this.listenCount,
//       audioMd5: audioMd5 ?? this.audioMd5,
//       filePath: filePath ?? this.filePath,
//       source: source ?? this.source,
//       coverUrl: coverUrl ?? this.coverUrl,
//       coverPath: coverPath ?? this.coverPath,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (title.present) {
//       map['title'] = Variable<String>(title.value);
//     }
//     if (date.present) {
//       map['date'] = Variable<String>(date.value);
//     }
//     if (composer.present) {
//       map['composer'] = Variable<String>(composer.value);
//     }
//     if (performer.present) {
//       map['performer'] = Variable<String>(performer.value);
//     }
//     if (albumArtistName.present) {
//       map['album_artist_name'] = Variable<String>(albumArtistName.value);
//     }
//     if (trackNumberInAlbum.present) {
//       map['track_number_in_album'] = Variable<int>(trackNumberInAlbum.value);
//     }
//     if (totalTrackInAlbum.present) {
//       map['total_track_in_album'] = Variable<int>(totalTrackInAlbum.value);
//     }
//     if (discNumber.present) {
//       map['disc_number'] = Variable<int>(discNumber.value);
//     }
//     if (totalDiscs.present) {
//       map['total_discs'] = Variable<int>(totalDiscs.value);
//     }
//     if (comment.present) {
//       map['comment'] = Variable<String>(comment.value);
//     }
//     if (externalId.present) {
//       map['external_id'] = Variable<String>(externalId.value);
//     }
//     if (durationMs.present) {
//       map['duration_ms'] = Variable<int>(durationMs.value);
//     }
//     if (sampleRate.present) {
//       map['sample_rate'] = Variable<int>(sampleRate.value);
//     }
//     if (channels.present) {
//       map['channels'] = Variable<int>(channels.value);
//     }
//     if (bitsPerSample.present) {
//       map['bits_per_sample'] = Variable<int>(bitsPerSample.value);
//     }
//     if (bitrate.present) {
//       map['bitrate'] = Variable<int>(bitrate.value);
//     }
//     if (codec.present) {
//       map['codec'] = Variable<String>(codec.value);
//     }
//     if (encoding.present) {
//       map['encoding'] = Variable<String>(encoding.value);
//     }
//     if (tool.present) {
//       map['tool'] = Variable<String>(tool.value);
//     }
//     if (listenCount.present) {
//       map['listen_count'] = Variable<int>(listenCount.value);
//     }
//     if (audioMd5.present) {
//       map['audio_md5'] = Variable<String>(audioMd5.value);
//     }
//     if (filePath.present) {
//       map['file_path'] = Variable<String>(filePath.value);
//     }
//     if (source.present) {
//       map['source'] = Variable<String>(source.value);
//     }
//     if (coverUrl.present) {
//       map['cover_url'] = Variable<String>(coverUrl.value);
//     }
//     if (coverPath.present) {
//       map['cover_path'] = Variable<String>(coverPath.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('TracksCompanion(')
//           ..write('id: $id, ')
//           ..write('title: $title, ')
//           ..write('date: $date, ')
//           ..write('composer: $composer, ')
//           ..write('performer: $performer, ')
//           ..write('albumArtistName: $albumArtistName, ')
//           ..write('trackNumberInAlbum: $trackNumberInAlbum, ')
//           ..write('totalTrackInAlbum: $totalTrackInAlbum, ')
//           ..write('discNumber: $discNumber, ')
//           ..write('totalDiscs: $totalDiscs, ')
//           ..write('comment: $comment, ')
//           ..write('externalId: $externalId, ')
//           ..write('durationMs: $durationMs, ')
//           ..write('sampleRate: $sampleRate, ')
//           ..write('channels: $channels, ')
//           ..write('bitsPerSample: $bitsPerSample, ')
//           ..write('bitrate: $bitrate, ')
//           ..write('codec: $codec, ')
//           ..write('encoding: $encoding, ')
//           ..write('tool: $tool, ')
//           ..write('listenCount: $listenCount, ')
//           ..write('audioMd5: $audioMd5, ')
//           ..write('filePath: $filePath, ')
//           ..write('source: $source, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath')
//           ..write(')'))
//         .toString();
//   }
// }

// class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $SettingsTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//     'id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
//   @override
//   late final GeneratedColumn<double> volume = GeneratedColumn<double>(
//     'volume',
//     aliasedName,
//     false,
//     type: DriftSqlType.double,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0.7),
//   );
//   static const VerificationMeta _indicatorStateMeta = const VerificationMeta(
//     'indicatorState',
//   );
//   @override
//   late final GeneratedColumn<bool> indicatorState = GeneratedColumn<bool>(
//     'indicator_state',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("indicator_state" IN (0, 1))',
//     ),
//     defaultValue: const Constant(false),
//   );
//   static const VerificationMeta _albumArtAsBackgroundMeta =
//       const VerificationMeta('albumArtAsBackground');
//   @override
//   late final GeneratedColumn<bool> albumArtAsBackground = GeneratedColumn<bool>(
//     'album_art_as_background',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("album_art_as_background" IN (0, 1))',
//     ),
//     defaultValue: const Constant(false),
//   );
//   static const VerificationMeta _smartShuffleMeta = const VerificationMeta(
//     'smartShuffle',
//   );
//   @override
//   late final GeneratedColumn<bool> smartShuffle = GeneratedColumn<bool>(
//     'smart_shuffle',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("smart_shuffle" IN (0, 1))',
//     ),
//     defaultValue: const Constant(false),
//   );
//   static const VerificationMeta _adwaitaThemeMeta = const VerificationMeta(
//     'adwaitaTheme',
//   );
//   @override
//   late final GeneratedColumn<bool> adwaitaTheme = GeneratedColumn<bool>(
//     'adwaita_theme',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("adwaita_theme" IN (0, 1))',
//     ),
//     defaultValue: const Constant(false),
//   );
//   static const VerificationMeta _transparentModeMeta = const VerificationMeta(
//     'transparentMode',
//   );
//   @override
//   late final GeneratedColumn<bool> transparentMode = GeneratedColumn<bool>(
//     'transparent_mode',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("transparent_mode" IN (0, 1))',
//     ),
//     defaultValue: const Constant(false),
//   );
//   static const VerificationMeta _windowManagerMeta = const VerificationMeta(
//     'windowManager',
//   );
//   @override
//   late final GeneratedColumn<bool> windowManager = GeneratedColumn<bool>(
//     'window_manager',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("window_manager" IN (0, 1))',
//     ),
//     defaultValue: const Constant(false),
//   );
//   static const VerificationMeta _logListenedTracksMeta = const VerificationMeta(
//     'logListenedTracks',
//   );
//   @override
//   late final GeneratedColumn<bool> logListenedTracks = GeneratedColumn<bool>(
//     'log_listened_tracks',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("log_listened_tracks" IN (0, 1))',
//     ),
//     defaultValue: const Constant(true),
//   );
//   static const VerificationMeta _openPlaylistAtStartMeta =
//       const VerificationMeta('openPlaylistAtStart');
//   @override
//   late final GeneratedColumn<bool> openPlaylistAtStart = GeneratedColumn<bool>(
//     'open_playlist_at_start',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("open_playlist_at_start" IN (0, 1))',
//     ),
//     defaultValue: const Constant(false),
//   );
//   static const VerificationMeta _yandexMusicAccountTokenMeta =
//       const VerificationMeta('yandexMusicAccountToken');
//   @override
//   late final GeneratedColumn<String> yandexMusicAccountToken =
//       GeneratedColumn<String>(
//         'yandex_music_account_token',
//         aliasedName,
//         true,
//         type: DriftSqlType.string,
//         requiredDuringInsert: false,
//       );
//   static const VerificationMeta _yandexMusicAccountEmailMeta =
//       const VerificationMeta('yandexMusicAccountEmail');
//   @override
//   late final GeneratedColumn<String> yandexMusicAccountEmail =
//       GeneratedColumn<String>(
//         'yandex_music_account_email',
//         aliasedName,
//         true,
//         type: DriftSqlType.string,
//         requiredDuringInsert: false,
//       );
//   static const VerificationMeta _yandexMusicAccountLoginMeta =
//       const VerificationMeta('yandexMusicAccountLogin');
//   @override
//   late final GeneratedColumn<String> yandexMusicAccountLogin =
//       GeneratedColumn<String>(
//         'yandex_music_account_login',
//         aliasedName,
//         true,
//         type: DriftSqlType.string,
//         requiredDuringInsert: false,
//       );
//   static const VerificationMeta _yandexMusicAccountNameMeta =
//       const VerificationMeta('yandexMusicAccountName');
//   @override
//   late final GeneratedColumn<String> yandexMusicAccountName =
//       GeneratedColumn<String>(
//         'yandex_music_account_name',
//         aliasedName,
//         true,
//         type: DriftSqlType.string,
//         requiredDuringInsert: false,
//       );
//   static const VerificationMeta _yandexMusicAccountUidMeta =
//       const VerificationMeta('yandexMusicAccountUid');
//   @override
//   late final GeneratedColumn<String> yandexMusicAccountUid =
//       GeneratedColumn<String>(
//         'yandex_music_account_uid',
//         aliasedName,
//         true,
//         type: DriftSqlType.string,
//         requiredDuringInsert: false,
//       );
//   static const VerificationMeta _yandexMusicAccountFullnameMeta =
//       const VerificationMeta('yandexMusicAccountFullname');
//   @override
//   late final GeneratedColumn<String> yandexMusicAccountFullname =
//       GeneratedColumn<String>(
//         'yandex_music_account_fullname',
//         aliasedName,
//         true,
//         type: DriftSqlType.string,
//         requiredDuringInsert: false,
//       );
//   static const VerificationMeta _yandexMusicDownloadQualityMeta =
//       const VerificationMeta('yandexMusicDownloadQuality');
//   @override
//   late final GeneratedColumn<String> yandexMusicDownloadQuality =
//       GeneratedColumn<String>(
//         'yandex_music_download_quality',
//         aliasedName,
//         true,
//         type: DriftSqlType.string,
//         requiredDuringInsert: false,
//       );
//   static const VerificationMeta _yandexMusicPreloadAtStartMeta =
//       const VerificationMeta('yandexMusicPreloadAtStart');
//   @override
//   late final GeneratedColumn<bool> yandexMusicPreloadAtStart =
//       GeneratedColumn<bool>(
//         'yandex_music_preload_at_start',
//         aliasedName,
//         false,
//         type: DriftSqlType.bool,
//         requiredDuringInsert: false,
//         defaultConstraints: GeneratedColumn.constraintIsAlways(
//           'CHECK ("yandex_music_preload_at_start" IN (0, 1))',
//         ),
//         defaultValue: const Constant(true),
//       );
//   static const VerificationMeta _lastTrackMeta = const VerificationMeta(
//     'lastTrack',
//   );
//   @override
//   late final GeneratedColumn<int> lastTrack = GeneratedColumn<int>(
//     'last_track',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES tracks (id)',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     id,
//     volume,
//     indicatorState,
//     albumArtAsBackground,
//     smartShuffle,
//     adwaitaTheme,
//     transparentMode,
//     windowManager,
//     logListenedTracks,
//     openPlaylistAtStart,
//     yandexMusicAccountToken,
//     yandexMusicAccountEmail,
//     yandexMusicAccountLogin,
//     yandexMusicAccountName,
//     yandexMusicAccountUid,
//     yandexMusicAccountFullname,
//     yandexMusicDownloadQuality,
//     yandexMusicPreloadAtStart,
//     lastTrack,
//   ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'settings';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<Setting> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     } else if (isInserting) {
//       context.missing(_idMeta);
//     }
//     if (data.containsKey('volume')) {
//       context.handle(
//         _volumeMeta,
//         volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta),
//       );
//     }
//     if (data.containsKey('indicator_state')) {
//       context.handle(
//         _indicatorStateMeta,
//         indicatorState.isAcceptableOrUnknown(
//           data['indicator_state']!,
//           _indicatorStateMeta,
//         ),
//       );
//     }
//     if (data.containsKey('album_art_as_background')) {
//       context.handle(
//         _albumArtAsBackgroundMeta,
//         albumArtAsBackground.isAcceptableOrUnknown(
//           data['album_art_as_background']!,
//           _albumArtAsBackgroundMeta,
//         ),
//       );
//     }
//     if (data.containsKey('smart_shuffle')) {
//       context.handle(
//         _smartShuffleMeta,
//         smartShuffle.isAcceptableOrUnknown(
//           data['smart_shuffle']!,
//           _smartShuffleMeta,
//         ),
//       );
//     }
//     if (data.containsKey('adwaita_theme')) {
//       context.handle(
//         _adwaitaThemeMeta,
//         adwaitaTheme.isAcceptableOrUnknown(
//           data['adwaita_theme']!,
//           _adwaitaThemeMeta,
//         ),
//       );
//     }
//     if (data.containsKey('transparent_mode')) {
//       context.handle(
//         _transparentModeMeta,
//         transparentMode.isAcceptableOrUnknown(
//           data['transparent_mode']!,
//           _transparentModeMeta,
//         ),
//       );
//     }
//     if (data.containsKey('window_manager')) {
//       context.handle(
//         _windowManagerMeta,
//         windowManager.isAcceptableOrUnknown(
//           data['window_manager']!,
//           _windowManagerMeta,
//         ),
//       );
//     }
//     if (data.containsKey('log_listened_tracks')) {
//       context.handle(
//         _logListenedTracksMeta,
//         logListenedTracks.isAcceptableOrUnknown(
//           data['log_listened_tracks']!,
//           _logListenedTracksMeta,
//         ),
//       );
//     }
//     if (data.containsKey('open_playlist_at_start')) {
//       context.handle(
//         _openPlaylistAtStartMeta,
//         openPlaylistAtStart.isAcceptableOrUnknown(
//           data['open_playlist_at_start']!,
//           _openPlaylistAtStartMeta,
//         ),
//       );
//     }
//     if (data.containsKey('yandex_music_account_token')) {
//       context.handle(
//         _yandexMusicAccountTokenMeta,
//         yandexMusicAccountToken.isAcceptableOrUnknown(
//           data['yandex_music_account_token']!,
//           _yandexMusicAccountTokenMeta,
//         ),
//       );
//     }
//     if (data.containsKey('yandex_music_account_email')) {
//       context.handle(
//         _yandexMusicAccountEmailMeta,
//         yandexMusicAccountEmail.isAcceptableOrUnknown(
//           data['yandex_music_account_email']!,
//           _yandexMusicAccountEmailMeta,
//         ),
//       );
//     }
//     if (data.containsKey('yandex_music_account_login')) {
//       context.handle(
//         _yandexMusicAccountLoginMeta,
//         yandexMusicAccountLogin.isAcceptableOrUnknown(
//           data['yandex_music_account_login']!,
//           _yandexMusicAccountLoginMeta,
//         ),
//       );
//     }
//     if (data.containsKey('yandex_music_account_name')) {
//       context.handle(
//         _yandexMusicAccountNameMeta,
//         yandexMusicAccountName.isAcceptableOrUnknown(
//           data['yandex_music_account_name']!,
//           _yandexMusicAccountNameMeta,
//         ),
//       );
//     }
//     if (data.containsKey('yandex_music_account_uid')) {
//       context.handle(
//         _yandexMusicAccountUidMeta,
//         yandexMusicAccountUid.isAcceptableOrUnknown(
//           data['yandex_music_account_uid']!,
//           _yandexMusicAccountUidMeta,
//         ),
//       );
//     }
//     if (data.containsKey('yandex_music_account_fullname')) {
//       context.handle(
//         _yandexMusicAccountFullnameMeta,
//         yandexMusicAccountFullname.isAcceptableOrUnknown(
//           data['yandex_music_account_fullname']!,
//           _yandexMusicAccountFullnameMeta,
//         ),
//       );
//     }
//     if (data.containsKey('yandex_music_download_quality')) {
//       context.handle(
//         _yandexMusicDownloadQualityMeta,
//         yandexMusicDownloadQuality.isAcceptableOrUnknown(
//           data['yandex_music_download_quality']!,
//           _yandexMusicDownloadQualityMeta,
//         ),
//       );
//     }
//     if (data.containsKey('yandex_music_preload_at_start')) {
//       context.handle(
//         _yandexMusicPreloadAtStartMeta,
//         yandexMusicPreloadAtStart.isAcceptableOrUnknown(
//           data['yandex_music_preload_at_start']!,
//           _yandexMusicPreloadAtStartMeta,
//         ),
//       );
//     }
//     if (data.containsKey('last_track')) {
//       context.handle(
//         _lastTrackMeta,
//         lastTrack.isAcceptableOrUnknown(data['last_track']!, _lastTrackMeta),
//       );
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => const {};
//   @override
//   Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return Setting(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       volume: attachedDatabase.typeMapping.read(
//         DriftSqlType.double,
//         data['${effectivePrefix}volume'],
//       )!,
//       indicatorState: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}indicator_state'],
//       )!,
//       albumArtAsBackground: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}album_art_as_background'],
//       )!,
//       smartShuffle: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}smart_shuffle'],
//       )!,
//       adwaitaTheme: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}adwaita_theme'],
//       )!,
//       transparentMode: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}transparent_mode'],
//       )!,
//       windowManager: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}window_manager'],
//       )!,
//       logListenedTracks: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}log_listened_tracks'],
//       )!,
//       openPlaylistAtStart: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}open_playlist_at_start'],
//       )!,
//       yandexMusicAccountToken: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}yandex_music_account_token'],
//       ),
//       yandexMusicAccountEmail: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}yandex_music_account_email'],
//       ),
//       yandexMusicAccountLogin: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}yandex_music_account_login'],
//       ),
//       yandexMusicAccountName: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}yandex_music_account_name'],
//       ),
//       yandexMusicAccountUid: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}yandex_music_account_uid'],
//       ),
//       yandexMusicAccountFullname: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}yandex_music_account_fullname'],
//       ),
//       yandexMusicDownloadQuality: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}yandex_music_download_quality'],
//       ),
//       yandexMusicPreloadAtStart: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}yandex_music_preload_at_start'],
//       )!,
//       lastTrack: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}last_track'],
//       ),
//     );
//   }

//   @override
//   $SettingsTable createAlias(String alias) {
//     return $SettingsTable(attachedDatabase, alias);
//   }
// }

// class Setting extends DataClass implements Insertable<Setting> {
//   final int id;
//   final double volume;
//   final bool indicatorState;
//   final bool albumArtAsBackground;
//   final bool smartShuffle;
//   final bool adwaitaTheme;
//   final bool transparentMode;
//   final bool windowManager;
//   final bool logListenedTracks;
//   final bool openPlaylistAtStart;
//   final String? yandexMusicAccountToken;
//   final String? yandexMusicAccountEmail;
//   final String? yandexMusicAccountLogin;
//   final String? yandexMusicAccountName;
//   final String? yandexMusicAccountUid;
//   final String? yandexMusicAccountFullname;
//   final String? yandexMusicDownloadQuality;
//   final bool yandexMusicPreloadAtStart;
//   final int? lastTrack;
//   const Setting({
//     required this.id,
//     required this.volume,
//     required this.indicatorState,
//     required this.albumArtAsBackground,
//     required this.smartShuffle,
//     required this.adwaitaTheme,
//     required this.transparentMode,
//     required this.windowManager,
//     required this.logListenedTracks,
//     required this.openPlaylistAtStart,
//     this.yandexMusicAccountToken,
//     this.yandexMusicAccountEmail,
//     this.yandexMusicAccountLogin,
//     this.yandexMusicAccountName,
//     this.yandexMusicAccountUid,
//     this.yandexMusicAccountFullname,
//     this.yandexMusicDownloadQuality,
//     required this.yandexMusicPreloadAtStart,
//     this.lastTrack,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     map['volume'] = Variable<double>(volume);
//     map['indicator_state'] = Variable<bool>(indicatorState);
//     map['album_art_as_background'] = Variable<bool>(albumArtAsBackground);
//     map['smart_shuffle'] = Variable<bool>(smartShuffle);
//     map['adwaita_theme'] = Variable<bool>(adwaitaTheme);
//     map['transparent_mode'] = Variable<bool>(transparentMode);
//     map['window_manager'] = Variable<bool>(windowManager);
//     map['log_listened_tracks'] = Variable<bool>(logListenedTracks);
//     map['open_playlist_at_start'] = Variable<bool>(openPlaylistAtStart);
//     if (!nullToAbsent || yandexMusicAccountToken != null) {
//       map['yandex_music_account_token'] = Variable<String>(
//         yandexMusicAccountToken,
//       );
//     }
//     if (!nullToAbsent || yandexMusicAccountEmail != null) {
//       map['yandex_music_account_email'] = Variable<String>(
//         yandexMusicAccountEmail,
//       );
//     }
//     if (!nullToAbsent || yandexMusicAccountLogin != null) {
//       map['yandex_music_account_login'] = Variable<String>(
//         yandexMusicAccountLogin,
//       );
//     }
//     if (!nullToAbsent || yandexMusicAccountName != null) {
//       map['yandex_music_account_name'] = Variable<String>(
//         yandexMusicAccountName,
//       );
//     }
//     if (!nullToAbsent || yandexMusicAccountUid != null) {
//       map['yandex_music_account_uid'] = Variable<String>(yandexMusicAccountUid);
//     }
//     if (!nullToAbsent || yandexMusicAccountFullname != null) {
//       map['yandex_music_account_fullname'] = Variable<String>(
//         yandexMusicAccountFullname,
//       );
//     }
//     if (!nullToAbsent || yandexMusicDownloadQuality != null) {
//       map['yandex_music_download_quality'] = Variable<String>(
//         yandexMusicDownloadQuality,
//       );
//     }
//     map['yandex_music_preload_at_start'] = Variable<bool>(
//       yandexMusicPreloadAtStart,
//     );
//     if (!nullToAbsent || lastTrack != null) {
//       map['last_track'] = Variable<int>(lastTrack);
//     }
//     return map;
//   }

//   SettingsCompanion toCompanion(bool nullToAbsent) {
//     return SettingsCompanion(
//       id: Value(id),
//       volume: Value(volume),
//       indicatorState: Value(indicatorState),
//       albumArtAsBackground: Value(albumArtAsBackground),
//       smartShuffle: Value(smartShuffle),
//       adwaitaTheme: Value(adwaitaTheme),
//       transparentMode: Value(transparentMode),
//       windowManager: Value(windowManager),
//       logListenedTracks: Value(logListenedTracks),
//       openPlaylistAtStart: Value(openPlaylistAtStart),
//       yandexMusicAccountToken: yandexMusicAccountToken == null && nullToAbsent
//           ? const Value.absent()
//           : Value(yandexMusicAccountToken),
//       yandexMusicAccountEmail: yandexMusicAccountEmail == null && nullToAbsent
//           ? const Value.absent()
//           : Value(yandexMusicAccountEmail),
//       yandexMusicAccountLogin: yandexMusicAccountLogin == null && nullToAbsent
//           ? const Value.absent()
//           : Value(yandexMusicAccountLogin),
//       yandexMusicAccountName: yandexMusicAccountName == null && nullToAbsent
//           ? const Value.absent()
//           : Value(yandexMusicAccountName),
//       yandexMusicAccountUid: yandexMusicAccountUid == null && nullToAbsent
//           ? const Value.absent()
//           : Value(yandexMusicAccountUid),
//       yandexMusicAccountFullname:
//           yandexMusicAccountFullname == null && nullToAbsent
//           ? const Value.absent()
//           : Value(yandexMusicAccountFullname),
//       yandexMusicDownloadQuality:
//           yandexMusicDownloadQuality == null && nullToAbsent
//           ? const Value.absent()
//           : Value(yandexMusicDownloadQuality),
//       yandexMusicPreloadAtStart: Value(yandexMusicPreloadAtStart),
//       lastTrack: lastTrack == null && nullToAbsent
//           ? const Value.absent()
//           : Value(lastTrack),
//     );
//   }

//   factory Setting.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return Setting(
//       id: serializer.fromJson<int>(json['id']),
//       volume: serializer.fromJson<double>(json['volume']),
//       indicatorState: serializer.fromJson<bool>(json['indicatorState']),
//       albumArtAsBackground: serializer.fromJson<bool>(
//         json['albumArtAsBackground'],
//       ),
//       smartShuffle: serializer.fromJson<bool>(json['smartShuffle']),
//       adwaitaTheme: serializer.fromJson<bool>(json['adwaitaTheme']),
//       transparentMode: serializer.fromJson<bool>(json['transparentMode']),
//       windowManager: serializer.fromJson<bool>(json['windowManager']),
//       logListenedTracks: serializer.fromJson<bool>(json['logListenedTracks']),
//       openPlaylistAtStart: serializer.fromJson<bool>(
//         json['openPlaylistAtStart'],
//       ),
//       yandexMusicAccountToken: serializer.fromJson<String?>(
//         json['yandexMusicAccountToken'],
//       ),
//       yandexMusicAccountEmail: serializer.fromJson<String?>(
//         json['yandexMusicAccountEmail'],
//       ),
//       yandexMusicAccountLogin: serializer.fromJson<String?>(
//         json['yandexMusicAccountLogin'],
//       ),
//       yandexMusicAccountName: serializer.fromJson<String?>(
//         json['yandexMusicAccountName'],
//       ),
//       yandexMusicAccountUid: serializer.fromJson<String?>(
//         json['yandexMusicAccountUid'],
//       ),
//       yandexMusicAccountFullname: serializer.fromJson<String?>(
//         json['yandexMusicAccountFullname'],
//       ),
//       yandexMusicDownloadQuality: serializer.fromJson<String?>(
//         json['yandexMusicDownloadQuality'],
//       ),
//       yandexMusicPreloadAtStart: serializer.fromJson<bool>(
//         json['yandexMusicPreloadAtStart'],
//       ),
//       lastTrack: serializer.fromJson<int?>(json['lastTrack']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'volume': serializer.toJson<double>(volume),
//       'indicatorState': serializer.toJson<bool>(indicatorState),
//       'albumArtAsBackground': serializer.toJson<bool>(albumArtAsBackground),
//       'smartShuffle': serializer.toJson<bool>(smartShuffle),
//       'adwaitaTheme': serializer.toJson<bool>(adwaitaTheme),
//       'transparentMode': serializer.toJson<bool>(transparentMode),
//       'windowManager': serializer.toJson<bool>(windowManager),
//       'logListenedTracks': serializer.toJson<bool>(logListenedTracks),
//       'openPlaylistAtStart': serializer.toJson<bool>(openPlaylistAtStart),
//       'yandexMusicAccountToken': serializer.toJson<String?>(
//         yandexMusicAccountToken,
//       ),
//       'yandexMusicAccountEmail': serializer.toJson<String?>(
//         yandexMusicAccountEmail,
//       ),
//       'yandexMusicAccountLogin': serializer.toJson<String?>(
//         yandexMusicAccountLogin,
//       ),
//       'yandexMusicAccountName': serializer.toJson<String?>(
//         yandexMusicAccountName,
//       ),
//       'yandexMusicAccountUid': serializer.toJson<String?>(
//         yandexMusicAccountUid,
//       ),
//       'yandexMusicAccountFullname': serializer.toJson<String?>(
//         yandexMusicAccountFullname,
//       ),
//       'yandexMusicDownloadQuality': serializer.toJson<String?>(
//         yandexMusicDownloadQuality,
//       ),
//       'yandexMusicPreloadAtStart': serializer.toJson<bool>(
//         yandexMusicPreloadAtStart,
//       ),
//       'lastTrack': serializer.toJson<int?>(lastTrack),
//     };
//   }

//   Setting copyWith({
//     int? id,
//     double? volume,
//     bool? indicatorState,
//     bool? albumArtAsBackground,
//     bool? smartShuffle,
//     bool? adwaitaTheme,
//     bool? transparentMode,
//     bool? windowManager,
//     bool? logListenedTracks,
//     bool? openPlaylistAtStart,
//     Value<String?> yandexMusicAccountToken = const Value.absent(),
//     Value<String?> yandexMusicAccountEmail = const Value.absent(),
//     Value<String?> yandexMusicAccountLogin = const Value.absent(),
//     Value<String?> yandexMusicAccountName = const Value.absent(),
//     Value<String?> yandexMusicAccountUid = const Value.absent(),
//     Value<String?> yandexMusicAccountFullname = const Value.absent(),
//     Value<String?> yandexMusicDownloadQuality = const Value.absent(),
//     bool? yandexMusicPreloadAtStart,
//     Value<int?> lastTrack = const Value.absent(),
//   }) => Setting(
//     id: id ?? this.id,
//     volume: volume ?? this.volume,
//     indicatorState: indicatorState ?? this.indicatorState,
//     albumArtAsBackground: albumArtAsBackground ?? this.albumArtAsBackground,
//     smartShuffle: smartShuffle ?? this.smartShuffle,
//     adwaitaTheme: adwaitaTheme ?? this.adwaitaTheme,
//     transparentMode: transparentMode ?? this.transparentMode,
//     windowManager: windowManager ?? this.windowManager,
//     logListenedTracks: logListenedTracks ?? this.logListenedTracks,
//     openPlaylistAtStart: openPlaylistAtStart ?? this.openPlaylistAtStart,
//     yandexMusicAccountToken: yandexMusicAccountToken.present
//         ? yandexMusicAccountToken.value
//         : this.yandexMusicAccountToken,
//     yandexMusicAccountEmail: yandexMusicAccountEmail.present
//         ? yandexMusicAccountEmail.value
//         : this.yandexMusicAccountEmail,
//     yandexMusicAccountLogin: yandexMusicAccountLogin.present
//         ? yandexMusicAccountLogin.value
//         : this.yandexMusicAccountLogin,
//     yandexMusicAccountName: yandexMusicAccountName.present
//         ? yandexMusicAccountName.value
//         : this.yandexMusicAccountName,
//     yandexMusicAccountUid: yandexMusicAccountUid.present
//         ? yandexMusicAccountUid.value
//         : this.yandexMusicAccountUid,
//     yandexMusicAccountFullname: yandexMusicAccountFullname.present
//         ? yandexMusicAccountFullname.value
//         : this.yandexMusicAccountFullname,
//     yandexMusicDownloadQuality: yandexMusicDownloadQuality.present
//         ? yandexMusicDownloadQuality.value
//         : this.yandexMusicDownloadQuality,
//     yandexMusicPreloadAtStart:
//         yandexMusicPreloadAtStart ?? this.yandexMusicPreloadAtStart,
//     lastTrack: lastTrack.present ? lastTrack.value : this.lastTrack,
//   );
//   Setting copyWithCompanion(SettingsCompanion data) {
//     return Setting(
//       id: data.id.present ? data.id.value : this.id,
//       volume: data.volume.present ? data.volume.value : this.volume,
//       indicatorState: data.indicatorState.present
//           ? data.indicatorState.value
//           : this.indicatorState,
//       albumArtAsBackground: data.albumArtAsBackground.present
//           ? data.albumArtAsBackground.value
//           : this.albumArtAsBackground,
//       smartShuffle: data.smartShuffle.present
//           ? data.smartShuffle.value
//           : this.smartShuffle,
//       adwaitaTheme: data.adwaitaTheme.present
//           ? data.adwaitaTheme.value
//           : this.adwaitaTheme,
//       transparentMode: data.transparentMode.present
//           ? data.transparentMode.value
//           : this.transparentMode,
//       windowManager: data.windowManager.present
//           ? data.windowManager.value
//           : this.windowManager,
//       logListenedTracks: data.logListenedTracks.present
//           ? data.logListenedTracks.value
//           : this.logListenedTracks,
//       openPlaylistAtStart: data.openPlaylistAtStart.present
//           ? data.openPlaylistAtStart.value
//           : this.openPlaylistAtStart,
//       yandexMusicAccountToken: data.yandexMusicAccountToken.present
//           ? data.yandexMusicAccountToken.value
//           : this.yandexMusicAccountToken,
//       yandexMusicAccountEmail: data.yandexMusicAccountEmail.present
//           ? data.yandexMusicAccountEmail.value
//           : this.yandexMusicAccountEmail,
//       yandexMusicAccountLogin: data.yandexMusicAccountLogin.present
//           ? data.yandexMusicAccountLogin.value
//           : this.yandexMusicAccountLogin,
//       yandexMusicAccountName: data.yandexMusicAccountName.present
//           ? data.yandexMusicAccountName.value
//           : this.yandexMusicAccountName,
//       yandexMusicAccountUid: data.yandexMusicAccountUid.present
//           ? data.yandexMusicAccountUid.value
//           : this.yandexMusicAccountUid,
//       yandexMusicAccountFullname: data.yandexMusicAccountFullname.present
//           ? data.yandexMusicAccountFullname.value
//           : this.yandexMusicAccountFullname,
//       yandexMusicDownloadQuality: data.yandexMusicDownloadQuality.present
//           ? data.yandexMusicDownloadQuality.value
//           : this.yandexMusicDownloadQuality,
//       yandexMusicPreloadAtStart: data.yandexMusicPreloadAtStart.present
//           ? data.yandexMusicPreloadAtStart.value
//           : this.yandexMusicPreloadAtStart,
//       lastTrack: data.lastTrack.present ? data.lastTrack.value : this.lastTrack,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('Setting(')
//           ..write('id: $id, ')
//           ..write('volume: $volume, ')
//           ..write('indicatorState: $indicatorState, ')
//           ..write('albumArtAsBackground: $albumArtAsBackground, ')
//           ..write('smartShuffle: $smartShuffle, ')
//           ..write('adwaitaTheme: $adwaitaTheme, ')
//           ..write('transparentMode: $transparentMode, ')
//           ..write('windowManager: $windowManager, ')
//           ..write('logListenedTracks: $logListenedTracks, ')
//           ..write('openPlaylistAtStart: $openPlaylistAtStart, ')
//           ..write('yandexMusicAccountToken: $yandexMusicAccountToken, ')
//           ..write('yandexMusicAccountEmail: $yandexMusicAccountEmail, ')
//           ..write('yandexMusicAccountLogin: $yandexMusicAccountLogin, ')
//           ..write('yandexMusicAccountName: $yandexMusicAccountName, ')
//           ..write('yandexMusicAccountUid: $yandexMusicAccountUid, ')
//           ..write('yandexMusicAccountFullname: $yandexMusicAccountFullname, ')
//           ..write('yandexMusicDownloadQuality: $yandexMusicDownloadQuality, ')
//           ..write('yandexMusicPreloadAtStart: $yandexMusicPreloadAtStart, ')
//           ..write('lastTrack: $lastTrack')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(
//     id,
//     volume,
//     indicatorState,
//     albumArtAsBackground,
//     smartShuffle,
//     adwaitaTheme,
//     transparentMode,
//     windowManager,
//     logListenedTracks,
//     openPlaylistAtStart,
//     yandexMusicAccountToken,
//     yandexMusicAccountEmail,
//     yandexMusicAccountLogin,
//     yandexMusicAccountName,
//     yandexMusicAccountUid,
//     yandexMusicAccountFullname,
//     yandexMusicDownloadQuality,
//     yandexMusicPreloadAtStart,
//     lastTrack,
//   );
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Setting &&
//           other.id == this.id &&
//           other.volume == this.volume &&
//           other.indicatorState == this.indicatorState &&
//           other.albumArtAsBackground == this.albumArtAsBackground &&
//           other.smartShuffle == this.smartShuffle &&
//           other.adwaitaTheme == this.adwaitaTheme &&
//           other.transparentMode == this.transparentMode &&
//           other.windowManager == this.windowManager &&
//           other.logListenedTracks == this.logListenedTracks &&
//           other.openPlaylistAtStart == this.openPlaylistAtStart &&
//           other.yandexMusicAccountToken == this.yandexMusicAccountToken &&
//           other.yandexMusicAccountEmail == this.yandexMusicAccountEmail &&
//           other.yandexMusicAccountLogin == this.yandexMusicAccountLogin &&
//           other.yandexMusicAccountName == this.yandexMusicAccountName &&
//           other.yandexMusicAccountUid == this.yandexMusicAccountUid &&
//           other.yandexMusicAccountFullname == this.yandexMusicAccountFullname &&
//           other.yandexMusicDownloadQuality == this.yandexMusicDownloadQuality &&
//           other.yandexMusicPreloadAtStart == this.yandexMusicPreloadAtStart &&
//           other.lastTrack == this.lastTrack);
// }

// class SettingsCompanion extends UpdateCompanion<Setting> {
//   final Value<int> id;
//   final Value<double> volume;
//   final Value<bool> indicatorState;
//   final Value<bool> albumArtAsBackground;
//   final Value<bool> smartShuffle;
//   final Value<bool> adwaitaTheme;
//   final Value<bool> transparentMode;
//   final Value<bool> windowManager;
//   final Value<bool> logListenedTracks;
//   final Value<bool> openPlaylistAtStart;
//   final Value<String?> yandexMusicAccountToken;
//   final Value<String?> yandexMusicAccountEmail;
//   final Value<String?> yandexMusicAccountLogin;
//   final Value<String?> yandexMusicAccountName;
//   final Value<String?> yandexMusicAccountUid;
//   final Value<String?> yandexMusicAccountFullname;
//   final Value<String?> yandexMusicDownloadQuality;
//   final Value<bool> yandexMusicPreloadAtStart;
//   final Value<int?> lastTrack;
//   final Value<int> rowid;
//   const SettingsCompanion({
//     this.id = const Value.absent(),
//     this.volume = const Value.absent(),
//     this.indicatorState = const Value.absent(),
//     this.albumArtAsBackground = const Value.absent(),
//     this.smartShuffle = const Value.absent(),
//     this.adwaitaTheme = const Value.absent(),
//     this.transparentMode = const Value.absent(),
//     this.windowManager = const Value.absent(),
//     this.logListenedTracks = const Value.absent(),
//     this.openPlaylistAtStart = const Value.absent(),
//     this.yandexMusicAccountToken = const Value.absent(),
//     this.yandexMusicAccountEmail = const Value.absent(),
//     this.yandexMusicAccountLogin = const Value.absent(),
//     this.yandexMusicAccountName = const Value.absent(),
//     this.yandexMusicAccountUid = const Value.absent(),
//     this.yandexMusicAccountFullname = const Value.absent(),
//     this.yandexMusicDownloadQuality = const Value.absent(),
//     this.yandexMusicPreloadAtStart = const Value.absent(),
//     this.lastTrack = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   SettingsCompanion.insert({
//     required int id,
//     this.volume = const Value.absent(),
//     this.indicatorState = const Value.absent(),
//     this.albumArtAsBackground = const Value.absent(),
//     this.smartShuffle = const Value.absent(),
//     this.adwaitaTheme = const Value.absent(),
//     this.transparentMode = const Value.absent(),
//     this.windowManager = const Value.absent(),
//     this.logListenedTracks = const Value.absent(),
//     this.openPlaylistAtStart = const Value.absent(),
//     this.yandexMusicAccountToken = const Value.absent(),
//     this.yandexMusicAccountEmail = const Value.absent(),
//     this.yandexMusicAccountLogin = const Value.absent(),
//     this.yandexMusicAccountName = const Value.absent(),
//     this.yandexMusicAccountUid = const Value.absent(),
//     this.yandexMusicAccountFullname = const Value.absent(),
//     this.yandexMusicDownloadQuality = const Value.absent(),
//     this.yandexMusicPreloadAtStart = const Value.absent(),
//     this.lastTrack = const Value.absent(),
//     this.rowid = const Value.absent(),
//   }) : id = Value(id);
//   static Insertable<Setting> custom({
//     Expression<int>? id,
//     Expression<double>? volume,
//     Expression<bool>? indicatorState,
//     Expression<bool>? albumArtAsBackground,
//     Expression<bool>? smartShuffle,
//     Expression<bool>? adwaitaTheme,
//     Expression<bool>? transparentMode,
//     Expression<bool>? windowManager,
//     Expression<bool>? logListenedTracks,
//     Expression<bool>? openPlaylistAtStart,
//     Expression<String>? yandexMusicAccountToken,
//     Expression<String>? yandexMusicAccountEmail,
//     Expression<String>? yandexMusicAccountLogin,
//     Expression<String>? yandexMusicAccountName,
//     Expression<String>? yandexMusicAccountUid,
//     Expression<String>? yandexMusicAccountFullname,
//     Expression<String>? yandexMusicDownloadQuality,
//     Expression<bool>? yandexMusicPreloadAtStart,
//     Expression<int>? lastTrack,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (volume != null) 'volume': volume,
//       if (indicatorState != null) 'indicator_state': indicatorState,
//       if (albumArtAsBackground != null)
//         'album_art_as_background': albumArtAsBackground,
//       if (smartShuffle != null) 'smart_shuffle': smartShuffle,
//       if (adwaitaTheme != null) 'adwaita_theme': adwaitaTheme,
//       if (transparentMode != null) 'transparent_mode': transparentMode,
//       if (windowManager != null) 'window_manager': windowManager,
//       if (logListenedTracks != null) 'log_listened_tracks': logListenedTracks,
//       if (openPlaylistAtStart != null)
//         'open_playlist_at_start': openPlaylistAtStart,
//       if (yandexMusicAccountToken != null)
//         'yandex_music_account_token': yandexMusicAccountToken,
//       if (yandexMusicAccountEmail != null)
//         'yandex_music_account_email': yandexMusicAccountEmail,
//       if (yandexMusicAccountLogin != null)
//         'yandex_music_account_login': yandexMusicAccountLogin,
//       if (yandexMusicAccountName != null)
//         'yandex_music_account_name': yandexMusicAccountName,
//       if (yandexMusicAccountUid != null)
//         'yandex_music_account_uid': yandexMusicAccountUid,
//       if (yandexMusicAccountFullname != null)
//         'yandex_music_account_fullname': yandexMusicAccountFullname,
//       if (yandexMusicDownloadQuality != null)
//         'yandex_music_download_quality': yandexMusicDownloadQuality,
//       if (yandexMusicPreloadAtStart != null)
//         'yandex_music_preload_at_start': yandexMusicPreloadAtStart,
//       if (lastTrack != null) 'last_track': lastTrack,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   SettingsCompanion copyWith({
//     Value<int>? id,
//     Value<double>? volume,
//     Value<bool>? indicatorState,
//     Value<bool>? albumArtAsBackground,
//     Value<bool>? smartShuffle,
//     Value<bool>? adwaitaTheme,
//     Value<bool>? transparentMode,
//     Value<bool>? windowManager,
//     Value<bool>? logListenedTracks,
//     Value<bool>? openPlaylistAtStart,
//     Value<String?>? yandexMusicAccountToken,
//     Value<String?>? yandexMusicAccountEmail,
//     Value<String?>? yandexMusicAccountLogin,
//     Value<String?>? yandexMusicAccountName,
//     Value<String?>? yandexMusicAccountUid,
//     Value<String?>? yandexMusicAccountFullname,
//     Value<String?>? yandexMusicDownloadQuality,
//     Value<bool>? yandexMusicPreloadAtStart,
//     Value<int?>? lastTrack,
//     Value<int>? rowid,
//   }) {
//     return SettingsCompanion(
//       id: id ?? this.id,
//       volume: volume ?? this.volume,
//       indicatorState: indicatorState ?? this.indicatorState,
//       albumArtAsBackground: albumArtAsBackground ?? this.albumArtAsBackground,
//       smartShuffle: smartShuffle ?? this.smartShuffle,
//       adwaitaTheme: adwaitaTheme ?? this.adwaitaTheme,
//       transparentMode: transparentMode ?? this.transparentMode,
//       windowManager: windowManager ?? this.windowManager,
//       logListenedTracks: logListenedTracks ?? this.logListenedTracks,
//       openPlaylistAtStart: openPlaylistAtStart ?? this.openPlaylistAtStart,
//       yandexMusicAccountToken:
//           yandexMusicAccountToken ?? this.yandexMusicAccountToken,
//       yandexMusicAccountEmail:
//           yandexMusicAccountEmail ?? this.yandexMusicAccountEmail,
//       yandexMusicAccountLogin:
//           yandexMusicAccountLogin ?? this.yandexMusicAccountLogin,
//       yandexMusicAccountName:
//           yandexMusicAccountName ?? this.yandexMusicAccountName,
//       yandexMusicAccountUid:
//           yandexMusicAccountUid ?? this.yandexMusicAccountUid,
//       yandexMusicAccountFullname:
//           yandexMusicAccountFullname ?? this.yandexMusicAccountFullname,
//       yandexMusicDownloadQuality:
//           yandexMusicDownloadQuality ?? this.yandexMusicDownloadQuality,
//       yandexMusicPreloadAtStart:
//           yandexMusicPreloadAtStart ?? this.yandexMusicPreloadAtStart,
//       lastTrack: lastTrack ?? this.lastTrack,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (volume.present) {
//       map['volume'] = Variable<double>(volume.value);
//     }
//     if (indicatorState.present) {
//       map['indicator_state'] = Variable<bool>(indicatorState.value);
//     }
//     if (albumArtAsBackground.present) {
//       map['album_art_as_background'] = Variable<bool>(
//         albumArtAsBackground.value,
//       );
//     }
//     if (smartShuffle.present) {
//       map['smart_shuffle'] = Variable<bool>(smartShuffle.value);
//     }
//     if (adwaitaTheme.present) {
//       map['adwaita_theme'] = Variable<bool>(adwaitaTheme.value);
//     }
//     if (transparentMode.present) {
//       map['transparent_mode'] = Variable<bool>(transparentMode.value);
//     }
//     if (windowManager.present) {
//       map['window_manager'] = Variable<bool>(windowManager.value);
//     }
//     if (logListenedTracks.present) {
//       map['log_listened_tracks'] = Variable<bool>(logListenedTracks.value);
//     }
//     if (openPlaylistAtStart.present) {
//       map['open_playlist_at_start'] = Variable<bool>(openPlaylistAtStart.value);
//     }
//     if (yandexMusicAccountToken.present) {
//       map['yandex_music_account_token'] = Variable<String>(
//         yandexMusicAccountToken.value,
//       );
//     }
//     if (yandexMusicAccountEmail.present) {
//       map['yandex_music_account_email'] = Variable<String>(
//         yandexMusicAccountEmail.value,
//       );
//     }
//     if (yandexMusicAccountLogin.present) {
//       map['yandex_music_account_login'] = Variable<String>(
//         yandexMusicAccountLogin.value,
//       );
//     }
//     if (yandexMusicAccountName.present) {
//       map['yandex_music_account_name'] = Variable<String>(
//         yandexMusicAccountName.value,
//       );
//     }
//     if (yandexMusicAccountUid.present) {
//       map['yandex_music_account_uid'] = Variable<String>(
//         yandexMusicAccountUid.value,
//       );
//     }
//     if (yandexMusicAccountFullname.present) {
//       map['yandex_music_account_fullname'] = Variable<String>(
//         yandexMusicAccountFullname.value,
//       );
//     }
//     if (yandexMusicDownloadQuality.present) {
//       map['yandex_music_download_quality'] = Variable<String>(
//         yandexMusicDownloadQuality.value,
//       );
//     }
//     if (yandexMusicPreloadAtStart.present) {
//       map['yandex_music_preload_at_start'] = Variable<bool>(
//         yandexMusicPreloadAtStart.value,
//       );
//     }
//     if (lastTrack.present) {
//       map['last_track'] = Variable<int>(lastTrack.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('SettingsCompanion(')
//           ..write('id: $id, ')
//           ..write('volume: $volume, ')
//           ..write('indicatorState: $indicatorState, ')
//           ..write('albumArtAsBackground: $albumArtAsBackground, ')
//           ..write('smartShuffle: $smartShuffle, ')
//           ..write('adwaitaTheme: $adwaitaTheme, ')
//           ..write('transparentMode: $transparentMode, ')
//           ..write('windowManager: $windowManager, ')
//           ..write('logListenedTracks: $logListenedTracks, ')
//           ..write('openPlaylistAtStart: $openPlaylistAtStart, ')
//           ..write('yandexMusicAccountToken: $yandexMusicAccountToken, ')
//           ..write('yandexMusicAccountEmail: $yandexMusicAccountEmail, ')
//           ..write('yandexMusicAccountLogin: $yandexMusicAccountLogin, ')
//           ..write('yandexMusicAccountName: $yandexMusicAccountName, ')
//           ..write('yandexMusicAccountUid: $yandexMusicAccountUid, ')
//           ..write('yandexMusicAccountFullname: $yandexMusicAccountFullname, ')
//           ..write('yandexMusicDownloadQuality: $yandexMusicDownloadQuality, ')
//           ..write('yandexMusicPreloadAtStart: $yandexMusicPreloadAtStart, ')
//           ..write('lastTrack: $lastTrack, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $PlaylistsTable extends Playlists
//     with TableInfo<$PlaylistsTable, Playlist> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $PlaylistsTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//     'id',
//     aliasedName,
//     false,
//     hasAutoIncrement: true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'PRIMARY KEY AUTOINCREMENT',
//     ),
//   );
//   static const VerificationMeta _externalIdMeta = const VerificationMeta(
//     'externalId',
//   );
//   @override
//   late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
//     'external_id',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   static const VerificationMeta _externalId2Meta = const VerificationMeta(
//     'externalId2',
//   );
//   @override
//   late final GeneratedColumn<String> externalId2 = GeneratedColumn<String>(
//     'external_id2',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   static const VerificationMeta _titleMeta = const VerificationMeta('title');
//   @override
//   late final GeneratedColumn<String> title = GeneratedColumn<String>(
//     'title',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant('Unknown'),
//   );
//   static const VerificationMeta _trackCountMeta = const VerificationMeta(
//     'trackCount',
//   );
//   @override
//   late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
//     'track_count',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   static const VerificationMeta _sourceMeta = const VerificationMeta('source');
//   @override
//   late final GeneratedColumn<String> source = GeneratedColumn<String>(
//     'source',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant('local'),
//   );
//   static const VerificationMeta _coverUrlMeta = const VerificationMeta(
//     'coverUrl',
//   );
//   @override
//   late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
//     'cover_url',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _coverPathMeta = const VerificationMeta(
//     'coverPath',
//   );
//   @override
//   late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
//     'cover_path',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _descriptionMeta = const VerificationMeta(
//     'description',
//   );
//   @override
//   late final GeneratedColumn<String> description = GeneratedColumn<String>(
//     'description',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _ownerMeta = const VerificationMeta('owner');
//   @override
//   late final GeneratedColumn<String> owner = GeneratedColumn<String>(
//     'owner',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _listenCountMeta = const VerificationMeta(
//     'listenCount',
//   );
//   @override
//   late final GeneratedColumn<int> listenCount = GeneratedColumn<int>(
//     'listen_count',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   static const VerificationMeta _lastPlayedTrackMeta = const VerificationMeta(
//     'lastPlayedTrack',
//   );
//   @override
//   late final GeneratedColumn<int> lastPlayedTrack = GeneratedColumn<int>(
//     'last_played_track',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES tracks (id)',
//     ),
//   );
//   static const VerificationMeta _durationMsMeta = const VerificationMeta(
//     'durationMs',
//   );
//   @override
//   late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
//     'duration_ms',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultValue: const Constant(0),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     id,
//     externalId,
//     externalId2,
//     title,
//     trackCount,
//     source,
//     coverUrl,
//     coverPath,
//     description,
//     owner,
//     listenCount,
//     lastPlayedTrack,
//     durationMs,
//   ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'playlists';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<Playlist> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('external_id')) {
//       context.handle(
//         _externalIdMeta,
//         externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
//       );
//     }
//     if (data.containsKey('external_id2')) {
//       context.handle(
//         _externalId2Meta,
//         externalId2.isAcceptableOrUnknown(
//           data['external_id2']!,
//           _externalId2Meta,
//         ),
//       );
//     }
//     if (data.containsKey('title')) {
//       context.handle(
//         _titleMeta,
//         title.isAcceptableOrUnknown(data['title']!, _titleMeta),
//       );
//     }
//     if (data.containsKey('track_count')) {
//       context.handle(
//         _trackCountMeta,
//         trackCount.isAcceptableOrUnknown(data['track_count']!, _trackCountMeta),
//       );
//     }
//     if (data.containsKey('source')) {
//       context.handle(
//         _sourceMeta,
//         source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
//       );
//     }
//     if (data.containsKey('cover_url')) {
//       context.handle(
//         _coverUrlMeta,
//         coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
//       );
//     }
//     if (data.containsKey('cover_path')) {
//       context.handle(
//         _coverPathMeta,
//         coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
//       );
//     }
//     if (data.containsKey('description')) {
//       context.handle(
//         _descriptionMeta,
//         description.isAcceptableOrUnknown(
//           data['description']!,
//           _descriptionMeta,
//         ),
//       );
//     }
//     if (data.containsKey('owner')) {
//       context.handle(
//         _ownerMeta,
//         owner.isAcceptableOrUnknown(data['owner']!, _ownerMeta),
//       );
//     }
//     if (data.containsKey('listen_count')) {
//       context.handle(
//         _listenCountMeta,
//         listenCount.isAcceptableOrUnknown(
//           data['listen_count']!,
//           _listenCountMeta,
//         ),
//       );
//     }
//     if (data.containsKey('last_played_track')) {
//       context.handle(
//         _lastPlayedTrackMeta,
//         lastPlayedTrack.isAcceptableOrUnknown(
//           data['last_played_track']!,
//           _lastPlayedTrackMeta,
//         ),
//       );
//     }
//     if (data.containsKey('duration_ms')) {
//       context.handle(
//         _durationMsMeta,
//         durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
//       );
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   Playlist map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return Playlist(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       externalId: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}external_id'],
//       ),
//       externalId2: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}external_id2'],
//       ),
//       title: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}title'],
//       )!,
//       trackCount: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track_count'],
//       )!,
//       source: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}source'],
//       )!,
//       coverUrl: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_url'],
//       ),
//       coverPath: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_path'],
//       ),
//       description: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}description'],
//       ),
//       owner: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}owner'],
//       ),
//       listenCount: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}listen_count'],
//       )!,
//       lastPlayedTrack: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}last_played_track'],
//       ),
//       durationMs: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}duration_ms'],
//       )!,
//     );
//   }

//   @override
//   $PlaylistsTable createAlias(String alias) {
//     return $PlaylistsTable(attachedDatabase, alias);
//   }
// }

// class Playlist extends DataClass implements Insertable<Playlist> {
//   final int id;
//   final String? externalId;
//   final String? externalId2;
//   final String title;
//   final int trackCount;
//   final String source;
//   final String? coverUrl;
//   final String? coverPath;
//   final String? description;
//   final String? owner;
//   final int listenCount;
//   final int? lastPlayedTrack;
//   final int durationMs;
//   const Playlist({
//     required this.id,
//     this.externalId,
//     this.externalId2,
//     required this.title,
//     required this.trackCount,
//     required this.source,
//     this.coverUrl,
//     this.coverPath,
//     this.description,
//     this.owner,
//     required this.listenCount,
//     this.lastPlayedTrack,
//     required this.durationMs,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     if (!nullToAbsent || externalId != null) {
//       map['external_id'] = Variable<String>(externalId);
//     }
//     if (!nullToAbsent || externalId2 != null) {
//       map['external_id2'] = Variable<String>(externalId2);
//     }
//     map['title'] = Variable<String>(title);
//     map['track_count'] = Variable<int>(trackCount);
//     map['source'] = Variable<String>(source);
//     if (!nullToAbsent || coverUrl != null) {
//       map['cover_url'] = Variable<String>(coverUrl);
//     }
//     if (!nullToAbsent || coverPath != null) {
//       map['cover_path'] = Variable<String>(coverPath);
//     }
//     if (!nullToAbsent || description != null) {
//       map['description'] = Variable<String>(description);
//     }
//     if (!nullToAbsent || owner != null) {
//       map['owner'] = Variable<String>(owner);
//     }
//     map['listen_count'] = Variable<int>(listenCount);
//     if (!nullToAbsent || lastPlayedTrack != null) {
//       map['last_played_track'] = Variable<int>(lastPlayedTrack);
//     }
//     map['duration_ms'] = Variable<int>(durationMs);
//     return map;
//   }

//   PlaylistsCompanion toCompanion(bool nullToAbsent) {
//     return PlaylistsCompanion(
//       id: Value(id),
//       externalId: externalId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(externalId),
//       externalId2: externalId2 == null && nullToAbsent
//           ? const Value.absent()
//           : Value(externalId2),
//       title: Value(title),
//       trackCount: Value(trackCount),
//       source: Value(source),
//       coverUrl: coverUrl == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverUrl),
//       coverPath: coverPath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverPath),
//       description: description == null && nullToAbsent
//           ? const Value.absent()
//           : Value(description),
//       owner: owner == null && nullToAbsent
//           ? const Value.absent()
//           : Value(owner),
//       listenCount: Value(listenCount),
//       lastPlayedTrack: lastPlayedTrack == null && nullToAbsent
//           ? const Value.absent()
//           : Value(lastPlayedTrack),
//       durationMs: Value(durationMs),
//     );
//   }

//   factory Playlist.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return Playlist(
//       id: serializer.fromJson<int>(json['id']),
//       externalId: serializer.fromJson<String?>(json['externalId']),
//       externalId2: serializer.fromJson<String?>(json['externalId2']),
//       title: serializer.fromJson<String>(json['title']),
//       trackCount: serializer.fromJson<int>(json['trackCount']),
//       source: serializer.fromJson<String>(json['source']),
//       coverUrl: serializer.fromJson<String?>(json['coverUrl']),
//       coverPath: serializer.fromJson<String?>(json['coverPath']),
//       description: serializer.fromJson<String?>(json['description']),
//       owner: serializer.fromJson<String?>(json['owner']),
//       listenCount: serializer.fromJson<int>(json['listenCount']),
//       lastPlayedTrack: serializer.fromJson<int?>(json['lastPlayedTrack']),
//       durationMs: serializer.fromJson<int>(json['durationMs']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'externalId': serializer.toJson<String?>(externalId),
//       'externalId2': serializer.toJson<String?>(externalId2),
//       'title': serializer.toJson<String>(title),
//       'trackCount': serializer.toJson<int>(trackCount),
//       'source': serializer.toJson<String>(source),
//       'coverUrl': serializer.toJson<String?>(coverUrl),
//       'coverPath': serializer.toJson<String?>(coverPath),
//       'description': serializer.toJson<String?>(description),
//       'owner': serializer.toJson<String?>(owner),
//       'listenCount': serializer.toJson<int>(listenCount),
//       'lastPlayedTrack': serializer.toJson<int?>(lastPlayedTrack),
//       'durationMs': serializer.toJson<int>(durationMs),
//     };
//   }

//   Playlist copyWith({
//     int? id,
//     Value<String?> externalId = const Value.absent(),
//     Value<String?> externalId2 = const Value.absent(),
//     String? title,
//     int? trackCount,
//     String? source,
//     Value<String?> coverUrl = const Value.absent(),
//     Value<String?> coverPath = const Value.absent(),
//     Value<String?> description = const Value.absent(),
//     Value<String?> owner = const Value.absent(),
//     int? listenCount,
//     Value<int?> lastPlayedTrack = const Value.absent(),
//     int? durationMs,
//   }) => Playlist(
//     id: id ?? this.id,
//     externalId: externalId.present ? externalId.value : this.externalId,
//     externalId2: externalId2.present ? externalId2.value : this.externalId2,
//     title: title ?? this.title,
//     trackCount: trackCount ?? this.trackCount,
//     source: source ?? this.source,
//     coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
//     coverPath: coverPath.present ? coverPath.value : this.coverPath,
//     description: description.present ? description.value : this.description,
//     owner: owner.present ? owner.value : this.owner,
//     listenCount: listenCount ?? this.listenCount,
//     lastPlayedTrack: lastPlayedTrack.present
//         ? lastPlayedTrack.value
//         : this.lastPlayedTrack,
//     durationMs: durationMs ?? this.durationMs,
//   );
//   Playlist copyWithCompanion(PlaylistsCompanion data) {
//     return Playlist(
//       id: data.id.present ? data.id.value : this.id,
//       externalId: data.externalId.present
//           ? data.externalId.value
//           : this.externalId,
//       externalId2: data.externalId2.present
//           ? data.externalId2.value
//           : this.externalId2,
//       title: data.title.present ? data.title.value : this.title,
//       trackCount: data.trackCount.present
//           ? data.trackCount.value
//           : this.trackCount,
//       source: data.source.present ? data.source.value : this.source,
//       coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
//       coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
//       description: data.description.present
//           ? data.description.value
//           : this.description,
//       owner: data.owner.present ? data.owner.value : this.owner,
//       listenCount: data.listenCount.present
//           ? data.listenCount.value
//           : this.listenCount,
//       lastPlayedTrack: data.lastPlayedTrack.present
//           ? data.lastPlayedTrack.value
//           : this.lastPlayedTrack,
//       durationMs: data.durationMs.present
//           ? data.durationMs.value
//           : this.durationMs,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('Playlist(')
//           ..write('id: $id, ')
//           ..write('externalId: $externalId, ')
//           ..write('externalId2: $externalId2, ')
//           ..write('title: $title, ')
//           ..write('trackCount: $trackCount, ')
//           ..write('source: $source, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('description: $description, ')
//           ..write('owner: $owner, ')
//           ..write('listenCount: $listenCount, ')
//           ..write('lastPlayedTrack: $lastPlayedTrack, ')
//           ..write('durationMs: $durationMs')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(
//     id,
//     externalId,
//     externalId2,
//     title,
//     trackCount,
//     source,
//     coverUrl,
//     coverPath,
//     description,
//     owner,
//     listenCount,
//     lastPlayedTrack,
//     durationMs,
//   );
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Playlist &&
//           other.id == this.id &&
//           other.externalId == this.externalId &&
//           other.externalId2 == this.externalId2 &&
//           other.title == this.title &&
//           other.trackCount == this.trackCount &&
//           other.source == this.source &&
//           other.coverUrl == this.coverUrl &&
//           other.coverPath == this.coverPath &&
//           other.description == this.description &&
//           other.owner == this.owner &&
//           other.listenCount == this.listenCount &&
//           other.lastPlayedTrack == this.lastPlayedTrack &&
//           other.durationMs == this.durationMs);
// }

// class PlaylistsCompanion extends UpdateCompanion<Playlist> {
//   final Value<int> id;
//   final Value<String?> externalId;
//   final Value<String?> externalId2;
//   final Value<String> title;
//   final Value<int> trackCount;
//   final Value<String> source;
//   final Value<String?> coverUrl;
//   final Value<String?> coverPath;
//   final Value<String?> description;
//   final Value<String?> owner;
//   final Value<int> listenCount;
//   final Value<int?> lastPlayedTrack;
//   final Value<int> durationMs;
//   const PlaylistsCompanion({
//     this.id = const Value.absent(),
//     this.externalId = const Value.absent(),
//     this.externalId2 = const Value.absent(),
//     this.title = const Value.absent(),
//     this.trackCount = const Value.absent(),
//     this.source = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.description = const Value.absent(),
//     this.owner = const Value.absent(),
//     this.listenCount = const Value.absent(),
//     this.lastPlayedTrack = const Value.absent(),
//     this.durationMs = const Value.absent(),
//   });
//   PlaylistsCompanion.insert({
//     this.id = const Value.absent(),
//     this.externalId = const Value.absent(),
//     this.externalId2 = const Value.absent(),
//     this.title = const Value.absent(),
//     this.trackCount = const Value.absent(),
//     this.source = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.description = const Value.absent(),
//     this.owner = const Value.absent(),
//     this.listenCount = const Value.absent(),
//     this.lastPlayedTrack = const Value.absent(),
//     this.durationMs = const Value.absent(),
//   });
//   static Insertable<Playlist> custom({
//     Expression<int>? id,
//     Expression<String>? externalId,
//     Expression<String>? externalId2,
//     Expression<String>? title,
//     Expression<int>? trackCount,
//     Expression<String>? source,
//     Expression<String>? coverUrl,
//     Expression<String>? coverPath,
//     Expression<String>? description,
//     Expression<String>? owner,
//     Expression<int>? listenCount,
//     Expression<int>? lastPlayedTrack,
//     Expression<int>? durationMs,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (externalId != null) 'external_id': externalId,
//       if (externalId2 != null) 'external_id2': externalId2,
//       if (title != null) 'title': title,
//       if (trackCount != null) 'track_count': trackCount,
//       if (source != null) 'source': source,
//       if (coverUrl != null) 'cover_url': coverUrl,
//       if (coverPath != null) 'cover_path': coverPath,
//       if (description != null) 'description': description,
//       if (owner != null) 'owner': owner,
//       if (listenCount != null) 'listen_count': listenCount,
//       if (lastPlayedTrack != null) 'last_played_track': lastPlayedTrack,
//       if (durationMs != null) 'duration_ms': durationMs,
//     });
//   }

//   PlaylistsCompanion copyWith({
//     Value<int>? id,
//     Value<String?>? externalId,
//     Value<String?>? externalId2,
//     Value<String>? title,
//     Value<int>? trackCount,
//     Value<String>? source,
//     Value<String?>? coverUrl,
//     Value<String?>? coverPath,
//     Value<String?>? description,
//     Value<String?>? owner,
//     Value<int>? listenCount,
//     Value<int?>? lastPlayedTrack,
//     Value<int>? durationMs,
//   }) {
//     return PlaylistsCompanion(
//       id: id ?? this.id,
//       externalId: externalId ?? this.externalId,
//       externalId2: externalId2 ?? this.externalId2,
//       title: title ?? this.title,
//       trackCount: trackCount ?? this.trackCount,
//       source: source ?? this.source,
//       coverUrl: coverUrl ?? this.coverUrl,
//       coverPath: coverPath ?? this.coverPath,
//       description: description ?? this.description,
//       owner: owner ?? this.owner,
//       listenCount: listenCount ?? this.listenCount,
//       lastPlayedTrack: lastPlayedTrack ?? this.lastPlayedTrack,
//       durationMs: durationMs ?? this.durationMs,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (externalId.present) {
//       map['external_id'] = Variable<String>(externalId.value);
//     }
//     if (externalId2.present) {
//       map['external_id2'] = Variable<String>(externalId2.value);
//     }
//     if (title.present) {
//       map['title'] = Variable<String>(title.value);
//     }
//     if (trackCount.present) {
//       map['track_count'] = Variable<int>(trackCount.value);
//     }
//     if (source.present) {
//       map['source'] = Variable<String>(source.value);
//     }
//     if (coverUrl.present) {
//       map['cover_url'] = Variable<String>(coverUrl.value);
//     }
//     if (coverPath.present) {
//       map['cover_path'] = Variable<String>(coverPath.value);
//     }
//     if (description.present) {
//       map['description'] = Variable<String>(description.value);
//     }
//     if (owner.present) {
//       map['owner'] = Variable<String>(owner.value);
//     }
//     if (listenCount.present) {
//       map['listen_count'] = Variable<int>(listenCount.value);
//     }
//     if (lastPlayedTrack.present) {
//       map['last_played_track'] = Variable<int>(lastPlayedTrack.value);
//     }
//     if (durationMs.present) {
//       map['duration_ms'] = Variable<int>(durationMs.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('PlaylistsCompanion(')
//           ..write('id: $id, ')
//           ..write('externalId: $externalId, ')
//           ..write('externalId2: $externalId2, ')
//           ..write('title: $title, ')
//           ..write('trackCount: $trackCount, ')
//           ..write('source: $source, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('description: $description, ')
//           ..write('owner: $owner, ')
//           ..write('listenCount: $listenCount, ')
//           ..write('lastPlayedTrack: $lastPlayedTrack, ')
//           ..write('durationMs: $durationMs')
//           ..write(')'))
//         .toString();
//   }
// }

// class $ArtistsTable extends Artists with TableInfo<$ArtistsTable, Artist> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $ArtistsTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//     'id',
//     aliasedName,
//     false,
//     hasAutoIncrement: true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'PRIMARY KEY AUTOINCREMENT',
//     ),
//   );
//   static const VerificationMeta _externalIdMeta = const VerificationMeta(
//     'externalId',
//   );
//   @override
//   late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
//     'external_id',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   static const VerificationMeta _nameMeta = const VerificationMeta('name');
//   @override
//   late final GeneratedColumn<String> name = GeneratedColumn<String>(
//     'name',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant('Unknown'),
//   );
//   static const VerificationMeta _variousMeta = const VerificationMeta(
//     'various',
//   );
//   @override
//   late final GeneratedColumn<bool> various = GeneratedColumn<bool>(
//     'various',
//     aliasedName,
//     true,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("various" IN (0, 1))',
//     ),
//   );
//   static const VerificationMeta _composerMeta = const VerificationMeta(
//     'composer',
//   );
//   @override
//   late final GeneratedColumn<bool> composer = GeneratedColumn<bool>(
//     'composer',
//     aliasedName,
//     true,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("composer" IN (0, 1))',
//     ),
//   );
//   static const VerificationMeta _coverUrlMeta = const VerificationMeta(
//     'coverUrl',
//   );
//   @override
//   late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
//     'cover_url',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _coverPathMeta = const VerificationMeta(
//     'coverPath',
//   );
//   @override
//   late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
//     'cover_path',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _sourceMeta = const VerificationMeta('source');
//   @override
//   late final GeneratedColumn<String> source = GeneratedColumn<String>(
//     'source',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant('local'),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     id,
//     externalId,
//     name,
//     various,
//     composer,
//     coverUrl,
//     coverPath,
//     source,
//   ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'artists';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<Artist> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('external_id')) {
//       context.handle(
//         _externalIdMeta,
//         externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
//       );
//     }
//     if (data.containsKey('name')) {
//       context.handle(
//         _nameMeta,
//         name.isAcceptableOrUnknown(data['name']!, _nameMeta),
//       );
//     }
//     if (data.containsKey('various')) {
//       context.handle(
//         _variousMeta,
//         various.isAcceptableOrUnknown(data['various']!, _variousMeta),
//       );
//     }
//     if (data.containsKey('composer')) {
//       context.handle(
//         _composerMeta,
//         composer.isAcceptableOrUnknown(data['composer']!, _composerMeta),
//       );
//     }
//     if (data.containsKey('cover_url')) {
//       context.handle(
//         _coverUrlMeta,
//         coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
//       );
//     }
//     if (data.containsKey('cover_path')) {
//       context.handle(
//         _coverPathMeta,
//         coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
//       );
//     }
//     if (data.containsKey('source')) {
//       context.handle(
//         _sourceMeta,
//         source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
//       );
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   Artist map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return Artist(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       externalId: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}external_id'],
//       ),
//       name: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}name'],
//       )!,
//       various: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}various'],
//       ),
//       composer: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}composer'],
//       ),
//       coverUrl: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_url'],
//       ),
//       coverPath: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_path'],
//       ),
//       source: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}source'],
//       )!,
//     );
//   }

//   @override
//   $ArtistsTable createAlias(String alias) {
//     return $ArtistsTable(attachedDatabase, alias);
//   }
// }

// class Artist extends DataClass implements Insertable<Artist> {
//   final int id;
//   final String? externalId;
//   final String name;
//   final bool? various;
//   final bool? composer;
//   final String? coverUrl;
//   final String? coverPath;
//   final String source;
//   const Artist({
//     required this.id,
//     this.externalId,
//     required this.name,
//     this.various,
//     this.composer,
//     this.coverUrl,
//     this.coverPath,
//     required this.source,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     if (!nullToAbsent || externalId != null) {
//       map['external_id'] = Variable<String>(externalId);
//     }
//     map['name'] = Variable<String>(name);
//     if (!nullToAbsent || various != null) {
//       map['various'] = Variable<bool>(various);
//     }
//     if (!nullToAbsent || composer != null) {
//       map['composer'] = Variable<bool>(composer);
//     }
//     if (!nullToAbsent || coverUrl != null) {
//       map['cover_url'] = Variable<String>(coverUrl);
//     }
//     if (!nullToAbsent || coverPath != null) {
//       map['cover_path'] = Variable<String>(coverPath);
//     }
//     map['source'] = Variable<String>(source);
//     return map;
//   }

//   ArtistsCompanion toCompanion(bool nullToAbsent) {
//     return ArtistsCompanion(
//       id: Value(id),
//       externalId: externalId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(externalId),
//       name: Value(name),
//       various: various == null && nullToAbsent
//           ? const Value.absent()
//           : Value(various),
//       composer: composer == null && nullToAbsent
//           ? const Value.absent()
//           : Value(composer),
//       coverUrl: coverUrl == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverUrl),
//       coverPath: coverPath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverPath),
//       source: Value(source),
//     );
//   }

//   factory Artist.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return Artist(
//       id: serializer.fromJson<int>(json['id']),
//       externalId: serializer.fromJson<String?>(json['externalId']),
//       name: serializer.fromJson<String>(json['name']),
//       various: serializer.fromJson<bool?>(json['various']),
//       composer: serializer.fromJson<bool?>(json['composer']),
//       coverUrl: serializer.fromJson<String?>(json['coverUrl']),
//       coverPath: serializer.fromJson<String?>(json['coverPath']),
//       source: serializer.fromJson<String>(json['source']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'externalId': serializer.toJson<String?>(externalId),
//       'name': serializer.toJson<String>(name),
//       'various': serializer.toJson<bool?>(various),
//       'composer': serializer.toJson<bool?>(composer),
//       'coverUrl': serializer.toJson<String?>(coverUrl),
//       'coverPath': serializer.toJson<String?>(coverPath),
//       'source': serializer.toJson<String>(source),
//     };
//   }

//   Artist copyWith({
//     int? id,
//     Value<String?> externalId = const Value.absent(),
//     String? name,
//     Value<bool?> various = const Value.absent(),
//     Value<bool?> composer = const Value.absent(),
//     Value<String?> coverUrl = const Value.absent(),
//     Value<String?> coverPath = const Value.absent(),
//     String? source,
//   }) => Artist(
//     id: id ?? this.id,
//     externalId: externalId.present ? externalId.value : this.externalId,
//     name: name ?? this.name,
//     various: various.present ? various.value : this.various,
//     composer: composer.present ? composer.value : this.composer,
//     coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
//     coverPath: coverPath.present ? coverPath.value : this.coverPath,
//     source: source ?? this.source,
//   );
//   Artist copyWithCompanion(ArtistsCompanion data) {
//     return Artist(
//       id: data.id.present ? data.id.value : this.id,
//       externalId: data.externalId.present
//           ? data.externalId.value
//           : this.externalId,
//       name: data.name.present ? data.name.value : this.name,
//       various: data.various.present ? data.various.value : this.various,
//       composer: data.composer.present ? data.composer.value : this.composer,
//       coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
//       coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
//       source: data.source.present ? data.source.value : this.source,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('Artist(')
//           ..write('id: $id, ')
//           ..write('externalId: $externalId, ')
//           ..write('name: $name, ')
//           ..write('various: $various, ')
//           ..write('composer: $composer, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('source: $source')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(
//     id,
//     externalId,
//     name,
//     various,
//     composer,
//     coverUrl,
//     coverPath,
//     source,
//   );
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Artist &&
//           other.id == this.id &&
//           other.externalId == this.externalId &&
//           other.name == this.name &&
//           other.various == this.various &&
//           other.composer == this.composer &&
//           other.coverUrl == this.coverUrl &&
//           other.coverPath == this.coverPath &&
//           other.source == this.source);
// }

// class ArtistsCompanion extends UpdateCompanion<Artist> {
//   final Value<int> id;
//   final Value<String?> externalId;
//   final Value<String> name;
//   final Value<bool?> various;
//   final Value<bool?> composer;
//   final Value<String?> coverUrl;
//   final Value<String?> coverPath;
//   final Value<String> source;
//   const ArtistsCompanion({
//     this.id = const Value.absent(),
//     this.externalId = const Value.absent(),
//     this.name = const Value.absent(),
//     this.various = const Value.absent(),
//     this.composer = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.source = const Value.absent(),
//   });
//   ArtistsCompanion.insert({
//     this.id = const Value.absent(),
//     this.externalId = const Value.absent(),
//     this.name = const Value.absent(),
//     this.various = const Value.absent(),
//     this.composer = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.source = const Value.absent(),
//   });
//   static Insertable<Artist> custom({
//     Expression<int>? id,
//     Expression<String>? externalId,
//     Expression<String>? name,
//     Expression<bool>? various,
//     Expression<bool>? composer,
//     Expression<String>? coverUrl,
//     Expression<String>? coverPath,
//     Expression<String>? source,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (externalId != null) 'external_id': externalId,
//       if (name != null) 'name': name,
//       if (various != null) 'various': various,
//       if (composer != null) 'composer': composer,
//       if (coverUrl != null) 'cover_url': coverUrl,
//       if (coverPath != null) 'cover_path': coverPath,
//       if (source != null) 'source': source,
//     });
//   }

//   ArtistsCompanion copyWith({
//     Value<int>? id,
//     Value<String?>? externalId,
//     Value<String>? name,
//     Value<bool?>? various,
//     Value<bool?>? composer,
//     Value<String?>? coverUrl,
//     Value<String?>? coverPath,
//     Value<String>? source,
//   }) {
//     return ArtistsCompanion(
//       id: id ?? this.id,
//       externalId: externalId ?? this.externalId,
//       name: name ?? this.name,
//       various: various ?? this.various,
//       composer: composer ?? this.composer,
//       coverUrl: coverUrl ?? this.coverUrl,
//       coverPath: coverPath ?? this.coverPath,
//       source: source ?? this.source,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (externalId.present) {
//       map['external_id'] = Variable<String>(externalId.value);
//     }
//     if (name.present) {
//       map['name'] = Variable<String>(name.value);
//     }
//     if (various.present) {
//       map['various'] = Variable<bool>(various.value);
//     }
//     if (composer.present) {
//       map['composer'] = Variable<bool>(composer.value);
//     }
//     if (coverUrl.present) {
//       map['cover_url'] = Variable<String>(coverUrl.value);
//     }
//     if (coverPath.present) {
//       map['cover_path'] = Variable<String>(coverPath.value);
//     }
//     if (source.present) {
//       map['source'] = Variable<String>(source.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('ArtistsCompanion(')
//           ..write('id: $id, ')
//           ..write('externalId: $externalId, ')
//           ..write('name: $name, ')
//           ..write('various: $various, ')
//           ..write('composer: $composer, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('source: $source')
//           ..write(')'))
//         .toString();
//   }
// }

// class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $AlbumsTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//     'id',
//     aliasedName,
//     false,
//     hasAutoIncrement: true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'PRIMARY KEY AUTOINCREMENT',
//     ),
//   );
//   static const VerificationMeta _externalIdMeta = const VerificationMeta(
//     'externalId',
//   );
//   @override
//   late final GeneratedColumn<String> externalId = GeneratedColumn<String>(
//     'external_id',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   static const VerificationMeta _titleMeta = const VerificationMeta('title');
//   @override
//   late final GeneratedColumn<String> title = GeneratedColumn<String>(
//     'title',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant('Unknown'),
//   );
//   static const VerificationMeta _typeMeta = const VerificationMeta('type');
//   @override
//   late final GeneratedColumn<String> type = GeneratedColumn<String>(
//     'type',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _metaTypeMeta = const VerificationMeta(
//     'metaType',
//   );
//   @override
//   late final GeneratedColumn<String> metaType = GeneratedColumn<String>(
//     'meta_type',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _yearMeta = const VerificationMeta('year');
//   @override
//   late final GeneratedColumn<int> year = GeneratedColumn<int>(
//     'year',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _releaseDateMeta = const VerificationMeta(
//     'releaseDate',
//   );
//   @override
//   late final GeneratedColumn<String> releaseDate = GeneratedColumn<String>(
//     'release_date',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _coverUrlMeta = const VerificationMeta(
//     'coverUrl',
//   );
//   @override
//   late final GeneratedColumn<String> coverUrl = GeneratedColumn<String>(
//     'cover_url',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _coverPathMeta = const VerificationMeta(
//     'coverPath',
//   );
//   @override
//   late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
//     'cover_path',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _trackCountMeta = const VerificationMeta(
//     'trackCount',
//   );
//   @override
//   late final GeneratedColumn<int> trackCount = GeneratedColumn<int>(
//     'track_count',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _sourceMeta = const VerificationMeta('source');
//   @override
//   late final GeneratedColumn<String> source = GeneratedColumn<String>(
//     'source',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant('local'),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     id,
//     externalId,
//     title,
//     type,
//     metaType,
//     year,
//     releaseDate,
//     coverUrl,
//     coverPath,
//     trackCount,
//     source,
//   ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'albums';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<Album> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('external_id')) {
//       context.handle(
//         _externalIdMeta,
//         externalId.isAcceptableOrUnknown(data['external_id']!, _externalIdMeta),
//       );
//     }
//     if (data.containsKey('title')) {
//       context.handle(
//         _titleMeta,
//         title.isAcceptableOrUnknown(data['title']!, _titleMeta),
//       );
//     }
//     if (data.containsKey('type')) {
//       context.handle(
//         _typeMeta,
//         type.isAcceptableOrUnknown(data['type']!, _typeMeta),
//       );
//     }
//     if (data.containsKey('meta_type')) {
//       context.handle(
//         _metaTypeMeta,
//         metaType.isAcceptableOrUnknown(data['meta_type']!, _metaTypeMeta),
//       );
//     }
//     if (data.containsKey('year')) {
//       context.handle(
//         _yearMeta,
//         year.isAcceptableOrUnknown(data['year']!, _yearMeta),
//       );
//     }
//     if (data.containsKey('release_date')) {
//       context.handle(
//         _releaseDateMeta,
//         releaseDate.isAcceptableOrUnknown(
//           data['release_date']!,
//           _releaseDateMeta,
//         ),
//       );
//     }
//     if (data.containsKey('cover_url')) {
//       context.handle(
//         _coverUrlMeta,
//         coverUrl.isAcceptableOrUnknown(data['cover_url']!, _coverUrlMeta),
//       );
//     }
//     if (data.containsKey('cover_path')) {
//       context.handle(
//         _coverPathMeta,
//         coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
//       );
//     }
//     if (data.containsKey('track_count')) {
//       context.handle(
//         _trackCountMeta,
//         trackCount.isAcceptableOrUnknown(data['track_count']!, _trackCountMeta),
//       );
//     }
//     if (data.containsKey('source')) {
//       context.handle(
//         _sourceMeta,
//         source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
//       );
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   Album map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return Album(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       externalId: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}external_id'],
//       ),
//       title: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}title'],
//       )!,
//       type: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}type'],
//       ),
//       metaType: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}meta_type'],
//       ),
//       year: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}year'],
//       ),
//       releaseDate: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}release_date'],
//       ),
//       coverUrl: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_url'],
//       ),
//       coverPath: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_path'],
//       ),
//       trackCount: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track_count'],
//       ),
//       source: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}source'],
//       )!,
//     );
//   }

//   @override
//   $AlbumsTable createAlias(String alias) {
//     return $AlbumsTable(attachedDatabase, alias);
//   }
// }

// class Album extends DataClass implements Insertable<Album> {
//   final int id;
//   final String? externalId;
//   final String title;
//   final String? type;
//   final String? metaType;
//   final int? year;
//   final String? releaseDate;
//   final String? coverUrl;
//   final String? coverPath;
//   final int? trackCount;
//   final String source;
//   const Album({
//     required this.id,
//     this.externalId,
//     required this.title,
//     this.type,
//     this.metaType,
//     this.year,
//     this.releaseDate,
//     this.coverUrl,
//     this.coverPath,
//     this.trackCount,
//     required this.source,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     if (!nullToAbsent || externalId != null) {
//       map['external_id'] = Variable<String>(externalId);
//     }
//     map['title'] = Variable<String>(title);
//     if (!nullToAbsent || type != null) {
//       map['type'] = Variable<String>(type);
//     }
//     if (!nullToAbsent || metaType != null) {
//       map['meta_type'] = Variable<String>(metaType);
//     }
//     if (!nullToAbsent || year != null) {
//       map['year'] = Variable<int>(year);
//     }
//     if (!nullToAbsent || releaseDate != null) {
//       map['release_date'] = Variable<String>(releaseDate);
//     }
//     if (!nullToAbsent || coverUrl != null) {
//       map['cover_url'] = Variable<String>(coverUrl);
//     }
//     if (!nullToAbsent || coverPath != null) {
//       map['cover_path'] = Variable<String>(coverPath);
//     }
//     if (!nullToAbsent || trackCount != null) {
//       map['track_count'] = Variable<int>(trackCount);
//     }
//     map['source'] = Variable<String>(source);
//     return map;
//   }

//   AlbumsCompanion toCompanion(bool nullToAbsent) {
//     return AlbumsCompanion(
//       id: Value(id),
//       externalId: externalId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(externalId),
//       title: Value(title),
//       type: type == null && nullToAbsent ? const Value.absent() : Value(type),
//       metaType: metaType == null && nullToAbsent
//           ? const Value.absent()
//           : Value(metaType),
//       year: year == null && nullToAbsent ? const Value.absent() : Value(year),
//       releaseDate: releaseDate == null && nullToAbsent
//           ? const Value.absent()
//           : Value(releaseDate),
//       coverUrl: coverUrl == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverUrl),
//       coverPath: coverPath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverPath),
//       trackCount: trackCount == null && nullToAbsent
//           ? const Value.absent()
//           : Value(trackCount),
//       source: Value(source),
//     );
//   }

//   factory Album.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return Album(
//       id: serializer.fromJson<int>(json['id']),
//       externalId: serializer.fromJson<String?>(json['externalId']),
//       title: serializer.fromJson<String>(json['title']),
//       type: serializer.fromJson<String?>(json['type']),
//       metaType: serializer.fromJson<String?>(json['metaType']),
//       year: serializer.fromJson<int?>(json['year']),
//       releaseDate: serializer.fromJson<String?>(json['releaseDate']),
//       coverUrl: serializer.fromJson<String?>(json['coverUrl']),
//       coverPath: serializer.fromJson<String?>(json['coverPath']),
//       trackCount: serializer.fromJson<int?>(json['trackCount']),
//       source: serializer.fromJson<String>(json['source']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'externalId': serializer.toJson<String?>(externalId),
//       'title': serializer.toJson<String>(title),
//       'type': serializer.toJson<String?>(type),
//       'metaType': serializer.toJson<String?>(metaType),
//       'year': serializer.toJson<int?>(year),
//       'releaseDate': serializer.toJson<String?>(releaseDate),
//       'coverUrl': serializer.toJson<String?>(coverUrl),
//       'coverPath': serializer.toJson<String?>(coverPath),
//       'trackCount': serializer.toJson<int?>(trackCount),
//       'source': serializer.toJson<String>(source),
//     };
//   }

//   Album copyWith({
//     int? id,
//     Value<String?> externalId = const Value.absent(),
//     String? title,
//     Value<String?> type = const Value.absent(),
//     Value<String?> metaType = const Value.absent(),
//     Value<int?> year = const Value.absent(),
//     Value<String?> releaseDate = const Value.absent(),
//     Value<String?> coverUrl = const Value.absent(),
//     Value<String?> coverPath = const Value.absent(),
//     Value<int?> trackCount = const Value.absent(),
//     String? source,
//   }) => Album(
//     id: id ?? this.id,
//     externalId: externalId.present ? externalId.value : this.externalId,
//     title: title ?? this.title,
//     type: type.present ? type.value : this.type,
//     metaType: metaType.present ? metaType.value : this.metaType,
//     year: year.present ? year.value : this.year,
//     releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
//     coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
//     coverPath: coverPath.present ? coverPath.value : this.coverPath,
//     trackCount: trackCount.present ? trackCount.value : this.trackCount,
//     source: source ?? this.source,
//   );
//   Album copyWithCompanion(AlbumsCompanion data) {
//     return Album(
//       id: data.id.present ? data.id.value : this.id,
//       externalId: data.externalId.present
//           ? data.externalId.value
//           : this.externalId,
//       title: data.title.present ? data.title.value : this.title,
//       type: data.type.present ? data.type.value : this.type,
//       metaType: data.metaType.present ? data.metaType.value : this.metaType,
//       year: data.year.present ? data.year.value : this.year,
//       releaseDate: data.releaseDate.present
//           ? data.releaseDate.value
//           : this.releaseDate,
//       coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
//       coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
//       trackCount: data.trackCount.present
//           ? data.trackCount.value
//           : this.trackCount,
//       source: data.source.present ? data.source.value : this.source,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('Album(')
//           ..write('id: $id, ')
//           ..write('externalId: $externalId, ')
//           ..write('title: $title, ')
//           ..write('type: $type, ')
//           ..write('metaType: $metaType, ')
//           ..write('year: $year, ')
//           ..write('releaseDate: $releaseDate, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('trackCount: $trackCount, ')
//           ..write('source: $source')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(
//     id,
//     externalId,
//     title,
//     type,
//     metaType,
//     year,
//     releaseDate,
//     coverUrl,
//     coverPath,
//     trackCount,
//     source,
//   );
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Album &&
//           other.id == this.id &&
//           other.externalId == this.externalId &&
//           other.title == this.title &&
//           other.type == this.type &&
//           other.metaType == this.metaType &&
//           other.year == this.year &&
//           other.releaseDate == this.releaseDate &&
//           other.coverUrl == this.coverUrl &&
//           other.coverPath == this.coverPath &&
//           other.trackCount == this.trackCount &&
//           other.source == this.source);
// }

// class AlbumsCompanion extends UpdateCompanion<Album> {
//   final Value<int> id;
//   final Value<String?> externalId;
//   final Value<String> title;
//   final Value<String?> type;
//   final Value<String?> metaType;
//   final Value<int?> year;
//   final Value<String?> releaseDate;
//   final Value<String?> coverUrl;
//   final Value<String?> coverPath;
//   final Value<int?> trackCount;
//   final Value<String> source;
//   const AlbumsCompanion({
//     this.id = const Value.absent(),
//     this.externalId = const Value.absent(),
//     this.title = const Value.absent(),
//     this.type = const Value.absent(),
//     this.metaType = const Value.absent(),
//     this.year = const Value.absent(),
//     this.releaseDate = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.trackCount = const Value.absent(),
//     this.source = const Value.absent(),
//   });
//   AlbumsCompanion.insert({
//     this.id = const Value.absent(),
//     this.externalId = const Value.absent(),
//     this.title = const Value.absent(),
//     this.type = const Value.absent(),
//     this.metaType = const Value.absent(),
//     this.year = const Value.absent(),
//     this.releaseDate = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.trackCount = const Value.absent(),
//     this.source = const Value.absent(),
//   });
//   static Insertable<Album> custom({
//     Expression<int>? id,
//     Expression<String>? externalId,
//     Expression<String>? title,
//     Expression<String>? type,
//     Expression<String>? metaType,
//     Expression<int>? year,
//     Expression<String>? releaseDate,
//     Expression<String>? coverUrl,
//     Expression<String>? coverPath,
//     Expression<int>? trackCount,
//     Expression<String>? source,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (externalId != null) 'external_id': externalId,
//       if (title != null) 'title': title,
//       if (type != null) 'type': type,
//       if (metaType != null) 'meta_type': metaType,
//       if (year != null) 'year': year,
//       if (releaseDate != null) 'release_date': releaseDate,
//       if (coverUrl != null) 'cover_url': coverUrl,
//       if (coverPath != null) 'cover_path': coverPath,
//       if (trackCount != null) 'track_count': trackCount,
//       if (source != null) 'source': source,
//     });
//   }

//   AlbumsCompanion copyWith({
//     Value<int>? id,
//     Value<String?>? externalId,
//     Value<String>? title,
//     Value<String?>? type,
//     Value<String?>? metaType,
//     Value<int?>? year,
//     Value<String?>? releaseDate,
//     Value<String?>? coverUrl,
//     Value<String?>? coverPath,
//     Value<int?>? trackCount,
//     Value<String>? source,
//   }) {
//     return AlbumsCompanion(
//       id: id ?? this.id,
//       externalId: externalId ?? this.externalId,
//       title: title ?? this.title,
//       type: type ?? this.type,
//       metaType: metaType ?? this.metaType,
//       year: year ?? this.year,
//       releaseDate: releaseDate ?? this.releaseDate,
//       coverUrl: coverUrl ?? this.coverUrl,
//       coverPath: coverPath ?? this.coverPath,
//       trackCount: trackCount ?? this.trackCount,
//       source: source ?? this.source,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (externalId.present) {
//       map['external_id'] = Variable<String>(externalId.value);
//     }
//     if (title.present) {
//       map['title'] = Variable<String>(title.value);
//     }
//     if (type.present) {
//       map['type'] = Variable<String>(type.value);
//     }
//     if (metaType.present) {
//       map['meta_type'] = Variable<String>(metaType.value);
//     }
//     if (year.present) {
//       map['year'] = Variable<int>(year.value);
//     }
//     if (releaseDate.present) {
//       map['release_date'] = Variable<String>(releaseDate.value);
//     }
//     if (coverUrl.present) {
//       map['cover_url'] = Variable<String>(coverUrl.value);
//     }
//     if (coverPath.present) {
//       map['cover_path'] = Variable<String>(coverPath.value);
//     }
//     if (trackCount.present) {
//       map['track_count'] = Variable<int>(trackCount.value);
//     }
//     if (source.present) {
//       map['source'] = Variable<String>(source.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('AlbumsCompanion(')
//           ..write('id: $id, ')
//           ..write('externalId: $externalId, ')
//           ..write('title: $title, ')
//           ..write('type: $type, ')
//           ..write('metaType: $metaType, ')
//           ..write('year: $year, ')
//           ..write('releaseDate: $releaseDate, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('trackCount: $trackCount, ')
//           ..write('source: $source')
//           ..write(')'))
//         .toString();
//   }
// }

// class $GenresTable extends Genres with TableInfo<$GenresTable, Genre> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $GenresTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//     'id',
//     aliasedName,
//     false,
//     hasAutoIncrement: true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'PRIMARY KEY AUTOINCREMENT',
//     ),
//   );
//   static const VerificationMeta _nameMeta = const VerificationMeta('name');
//   @override
//   late final GeneratedColumn<String> name = GeneratedColumn<String>(
//     'name',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [id, name];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'genres';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<Genre> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('name')) {
//       context.handle(
//         _nameMeta,
//         name.isAcceptableOrUnknown(data['name']!, _nameMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_nameMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   Genre map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return Genre(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       name: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}name'],
//       )!,
//     );
//   }

//   @override
//   $GenresTable createAlias(String alias) {
//     return $GenresTable(attachedDatabase, alias);
//   }
// }

// class Genre extends DataClass implements Insertable<Genre> {
//   final int id;
//   final String name;
//   const Genre({required this.id, required this.name});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     map['name'] = Variable<String>(name);
//     return map;
//   }

//   GenresCompanion toCompanion(bool nullToAbsent) {
//     return GenresCompanion(id: Value(id), name: Value(name));
//   }

//   factory Genre.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return Genre(
//       id: serializer.fromJson<int>(json['id']),
//       name: serializer.fromJson<String>(json['name']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'name': serializer.toJson<String>(name),
//     };
//   }

//   Genre copyWith({int? id, String? name}) =>
//       Genre(id: id ?? this.id, name: name ?? this.name);
//   Genre copyWithCompanion(GenresCompanion data) {
//     return Genre(
//       id: data.id.present ? data.id.value : this.id,
//       name: data.name.present ? data.name.value : this.name,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('Genre(')
//           ..write('id: $id, ')
//           ..write('name: $name')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(id, name);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Genre && other.id == this.id && other.name == this.name);
// }

// class GenresCompanion extends UpdateCompanion<Genre> {
//   final Value<int> id;
//   final Value<String> name;
//   const GenresCompanion({
//     this.id = const Value.absent(),
//     this.name = const Value.absent(),
//   });
//   GenresCompanion.insert({this.id = const Value.absent(), required String name})
//     : name = Value(name);
//   static Insertable<Genre> custom({
//     Expression<int>? id,
//     Expression<String>? name,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (name != null) 'name': name,
//     });
//   }

//   GenresCompanion copyWith({Value<int>? id, Value<String>? name}) {
//     return GenresCompanion(id: id ?? this.id, name: name ?? this.name);
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (name.present) {
//       map['name'] = Variable<String>(name.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('GenresCompanion(')
//           ..write('id: $id, ')
//           ..write('name: $name')
//           ..write(')'))
//         .toString();
//   }
// }

// class $TrackGenreTable extends TrackGenre
//     with TableInfo<$TrackGenreTable, TrackGenreData> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $TrackGenreTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _trackIdMeta = const VerificationMeta(
//     'trackId',
//   );
//   @override
//   late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
//     'track_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES tracks (id)',
//     ),
//   );
//   static const VerificationMeta _genreIdMeta = const VerificationMeta(
//     'genreId',
//   );
//   @override
//   late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
//     'genre_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'UNIQUE REFERENCES genres (id)',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [trackId, genreId];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'track_genre';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<TrackGenreData> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('track_id')) {
//       context.handle(
//         _trackIdMeta,
//         trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_trackIdMeta);
//     }
//     if (data.containsKey('genre_id')) {
//       context.handle(
//         _genreIdMeta,
//         genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_genreIdMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {trackId, genreId};
//   @override
//   TrackGenreData map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return TrackGenreData(
//       trackId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track_id'],
//       )!,
//       genreId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}genre_id'],
//       )!,
//     );
//   }

//   @override
//   $TrackGenreTable createAlias(String alias) {
//     return $TrackGenreTable(attachedDatabase, alias);
//   }
// }

// class TrackGenreData extends DataClass implements Insertable<TrackGenreData> {
//   final int trackId;
//   final int genreId;
//   const TrackGenreData({required this.trackId, required this.genreId});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['track_id'] = Variable<int>(trackId);
//     map['genre_id'] = Variable<int>(genreId);
//     return map;
//   }

//   TrackGenreCompanion toCompanion(bool nullToAbsent) {
//     return TrackGenreCompanion(
//       trackId: Value(trackId),
//       genreId: Value(genreId),
//     );
//   }

//   factory TrackGenreData.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return TrackGenreData(
//       trackId: serializer.fromJson<int>(json['trackId']),
//       genreId: serializer.fromJson<int>(json['genreId']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'trackId': serializer.toJson<int>(trackId),
//       'genreId': serializer.toJson<int>(genreId),
//     };
//   }

//   TrackGenreData copyWith({int? trackId, int? genreId}) => TrackGenreData(
//     trackId: trackId ?? this.trackId,
//     genreId: genreId ?? this.genreId,
//   );
//   TrackGenreData copyWithCompanion(TrackGenreCompanion data) {
//     return TrackGenreData(
//       trackId: data.trackId.present ? data.trackId.value : this.trackId,
//       genreId: data.genreId.present ? data.genreId.value : this.genreId,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('TrackGenreData(')
//           ..write('trackId: $trackId, ')
//           ..write('genreId: $genreId')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(trackId, genreId);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is TrackGenreData &&
//           other.trackId == this.trackId &&
//           other.genreId == this.genreId);
// }

// class TrackGenreCompanion extends UpdateCompanion<TrackGenreData> {
//   final Value<int> trackId;
//   final Value<int> genreId;
//   final Value<int> rowid;
//   const TrackGenreCompanion({
//     this.trackId = const Value.absent(),
//     this.genreId = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   TrackGenreCompanion.insert({
//     required int trackId,
//     required int genreId,
//     this.rowid = const Value.absent(),
//   }) : trackId = Value(trackId),
//        genreId = Value(genreId);
//   static Insertable<TrackGenreData> custom({
//     Expression<int>? trackId,
//     Expression<int>? genreId,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (trackId != null) 'track_id': trackId,
//       if (genreId != null) 'genre_id': genreId,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   TrackGenreCompanion copyWith({
//     Value<int>? trackId,
//     Value<int>? genreId,
//     Value<int>? rowid,
//   }) {
//     return TrackGenreCompanion(
//       trackId: trackId ?? this.trackId,
//       genreId: genreId ?? this.genreId,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (trackId.present) {
//       map['track_id'] = Variable<int>(trackId.value);
//     }
//     if (genreId.present) {
//       map['genre_id'] = Variable<int>(genreId.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('TrackGenreCompanion(')
//           ..write('trackId: $trackId, ')
//           ..write('genreId: $genreId, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $AlbumGenreTable extends AlbumGenre
//     with TableInfo<$AlbumGenreTable, AlbumGenreData> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $AlbumGenreTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _albumIdMeta = const VerificationMeta(
//     'albumId',
//   );
//   @override
//   late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
//     'album_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES albums (id)',
//     ),
//   );
//   static const VerificationMeta _genreIdMeta = const VerificationMeta(
//     'genreId',
//   );
//   @override
//   late final GeneratedColumn<int> genreId = GeneratedColumn<int>(
//     'genre_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'UNIQUE REFERENCES genres (id)',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [albumId, genreId];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'album_genre';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<AlbumGenreData> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('album_id')) {
//       context.handle(
//         _albumIdMeta,
//         albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_albumIdMeta);
//     }
//     if (data.containsKey('genre_id')) {
//       context.handle(
//         _genreIdMeta,
//         genreId.isAcceptableOrUnknown(data['genre_id']!, _genreIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_genreIdMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {albumId, genreId};
//   @override
//   AlbumGenreData map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return AlbumGenreData(
//       albumId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}album_id'],
//       )!,
//       genreId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}genre_id'],
//       )!,
//     );
//   }

//   @override
//   $AlbumGenreTable createAlias(String alias) {
//     return $AlbumGenreTable(attachedDatabase, alias);
//   }
// }

// class AlbumGenreData extends DataClass implements Insertable<AlbumGenreData> {
//   final int albumId;
//   final int genreId;
//   const AlbumGenreData({required this.albumId, required this.genreId});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['album_id'] = Variable<int>(albumId);
//     map['genre_id'] = Variable<int>(genreId);
//     return map;
//   }

//   AlbumGenreCompanion toCompanion(bool nullToAbsent) {
//     return AlbumGenreCompanion(
//       albumId: Value(albumId),
//       genreId: Value(genreId),
//     );
//   }

//   factory AlbumGenreData.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return AlbumGenreData(
//       albumId: serializer.fromJson<int>(json['albumId']),
//       genreId: serializer.fromJson<int>(json['genreId']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'albumId': serializer.toJson<int>(albumId),
//       'genreId': serializer.toJson<int>(genreId),
//     };
//   }

//   AlbumGenreData copyWith({int? albumId, int? genreId}) => AlbumGenreData(
//     albumId: albumId ?? this.albumId,
//     genreId: genreId ?? this.genreId,
//   );
//   AlbumGenreData copyWithCompanion(AlbumGenreCompanion data) {
//     return AlbumGenreData(
//       albumId: data.albumId.present ? data.albumId.value : this.albumId,
//       genreId: data.genreId.present ? data.genreId.value : this.genreId,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('AlbumGenreData(')
//           ..write('albumId: $albumId, ')
//           ..write('genreId: $genreId')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(albumId, genreId);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is AlbumGenreData &&
//           other.albumId == this.albumId &&
//           other.genreId == this.genreId);
// }

// class AlbumGenreCompanion extends UpdateCompanion<AlbumGenreData> {
//   final Value<int> albumId;
//   final Value<int> genreId;
//   final Value<int> rowid;
//   const AlbumGenreCompanion({
//     this.albumId = const Value.absent(),
//     this.genreId = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   AlbumGenreCompanion.insert({
//     required int albumId,
//     required int genreId,
//     this.rowid = const Value.absent(),
//   }) : albumId = Value(albumId),
//        genreId = Value(genreId);
//   static Insertable<AlbumGenreData> custom({
//     Expression<int>? albumId,
//     Expression<int>? genreId,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (albumId != null) 'album_id': albumId,
//       if (genreId != null) 'genre_id': genreId,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   AlbumGenreCompanion copyWith({
//     Value<int>? albumId,
//     Value<int>? genreId,
//     Value<int>? rowid,
//   }) {
//     return AlbumGenreCompanion(
//       albumId: albumId ?? this.albumId,
//       genreId: genreId ?? this.genreId,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (albumId.present) {
//       map['album_id'] = Variable<int>(albumId.value);
//     }
//     if (genreId.present) {
//       map['genre_id'] = Variable<int>(genreId.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('AlbumGenreCompanion(')
//           ..write('albumId: $albumId, ')
//           ..write('genreId: $genreId, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $TrackArtistTable extends TrackArtist
//     with TableInfo<$TrackArtistTable, TrackArtistData> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $TrackArtistTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _trackIdMeta = const VerificationMeta(
//     'trackId',
//   );
//   @override
//   late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
//     'track_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES tracks (id)',
//     ),
//   );
//   static const VerificationMeta _artistIdMeta = const VerificationMeta(
//     'artistId',
//   );
//   @override
//   late final GeneratedColumn<int> artistId = GeneratedColumn<int>(
//     'artist_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'UNIQUE REFERENCES artists (id)',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [trackId, artistId];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'track_artist';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<TrackArtistData> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('track_id')) {
//       context.handle(
//         _trackIdMeta,
//         trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_trackIdMeta);
//     }
//     if (data.containsKey('artist_id')) {
//       context.handle(
//         _artistIdMeta,
//         artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_artistIdMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {trackId, artistId};
//   @override
//   TrackArtistData map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return TrackArtistData(
//       trackId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track_id'],
//       )!,
//       artistId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}artist_id'],
//       )!,
//     );
//   }

//   @override
//   $TrackArtistTable createAlias(String alias) {
//     return $TrackArtistTable(attachedDatabase, alias);
//   }
// }

// class TrackArtistData extends DataClass implements Insertable<TrackArtistData> {
//   final int trackId;
//   final int artistId;
//   const TrackArtistData({required this.trackId, required this.artistId});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['track_id'] = Variable<int>(trackId);
//     map['artist_id'] = Variable<int>(artistId);
//     return map;
//   }

//   TrackArtistCompanion toCompanion(bool nullToAbsent) {
//     return TrackArtistCompanion(
//       trackId: Value(trackId),
//       artistId: Value(artistId),
//     );
//   }

//   factory TrackArtistData.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return TrackArtistData(
//       trackId: serializer.fromJson<int>(json['trackId']),
//       artistId: serializer.fromJson<int>(json['artistId']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'trackId': serializer.toJson<int>(trackId),
//       'artistId': serializer.toJson<int>(artistId),
//     };
//   }

//   TrackArtistData copyWith({int? trackId, int? artistId}) => TrackArtistData(
//     trackId: trackId ?? this.trackId,
//     artistId: artistId ?? this.artistId,
//   );
//   TrackArtistData copyWithCompanion(TrackArtistCompanion data) {
//     return TrackArtistData(
//       trackId: data.trackId.present ? data.trackId.value : this.trackId,
//       artistId: data.artistId.present ? data.artistId.value : this.artistId,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('TrackArtistData(')
//           ..write('trackId: $trackId, ')
//           ..write('artistId: $artistId')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(trackId, artistId);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is TrackArtistData &&
//           other.trackId == this.trackId &&
//           other.artistId == this.artistId);
// }

// class TrackArtistCompanion extends UpdateCompanion<TrackArtistData> {
//   final Value<int> trackId;
//   final Value<int> artistId;
//   final Value<int> rowid;
//   const TrackArtistCompanion({
//     this.trackId = const Value.absent(),
//     this.artistId = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   TrackArtistCompanion.insert({
//     required int trackId,
//     required int artistId,
//     this.rowid = const Value.absent(),
//   }) : trackId = Value(trackId),
//        artistId = Value(artistId);
//   static Insertable<TrackArtistData> custom({
//     Expression<int>? trackId,
//     Expression<int>? artistId,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (trackId != null) 'track_id': trackId,
//       if (artistId != null) 'artist_id': artistId,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   TrackArtistCompanion copyWith({
//     Value<int>? trackId,
//     Value<int>? artistId,
//     Value<int>? rowid,
//   }) {
//     return TrackArtistCompanion(
//       trackId: trackId ?? this.trackId,
//       artistId: artistId ?? this.artistId,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (trackId.present) {
//       map['track_id'] = Variable<int>(trackId.value);
//     }
//     if (artistId.present) {
//       map['artist_id'] = Variable<int>(artistId.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('TrackArtistCompanion(')
//           ..write('trackId: $trackId, ')
//           ..write('artistId: $artistId, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $TrackAlbumTable extends TrackAlbum
//     with TableInfo<$TrackAlbumTable, TrackAlbumData> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $TrackAlbumTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _trackIdMeta = const VerificationMeta(
//     'trackId',
//   );
//   @override
//   late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
//     'track_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES tracks (id)',
//     ),
//   );
//   static const VerificationMeta _albumIdMeta = const VerificationMeta(
//     'albumId',
//   );
//   @override
//   late final GeneratedColumn<int> albumId = GeneratedColumn<int>(
//     'album_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'UNIQUE REFERENCES albums (id)',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [trackId, albumId];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'track_album';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<TrackAlbumData> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('track_id')) {
//       context.handle(
//         _trackIdMeta,
//         trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_trackIdMeta);
//     }
//     if (data.containsKey('album_id')) {
//       context.handle(
//         _albumIdMeta,
//         albumId.isAcceptableOrUnknown(data['album_id']!, _albumIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_albumIdMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {trackId, albumId};
//   @override
//   TrackAlbumData map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return TrackAlbumData(
//       trackId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track_id'],
//       )!,
//       albumId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}album_id'],
//       )!,
//     );
//   }

//   @override
//   $TrackAlbumTable createAlias(String alias) {
//     return $TrackAlbumTable(attachedDatabase, alias);
//   }
// }

// class TrackAlbumData extends DataClass implements Insertable<TrackAlbumData> {
//   final int trackId;
//   final int albumId;
//   const TrackAlbumData({required this.trackId, required this.albumId});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['track_id'] = Variable<int>(trackId);
//     map['album_id'] = Variable<int>(albumId);
//     return map;
//   }

//   TrackAlbumCompanion toCompanion(bool nullToAbsent) {
//     return TrackAlbumCompanion(
//       trackId: Value(trackId),
//       albumId: Value(albumId),
//     );
//   }

//   factory TrackAlbumData.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return TrackAlbumData(
//       trackId: serializer.fromJson<int>(json['trackId']),
//       albumId: serializer.fromJson<int>(json['albumId']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'trackId': serializer.toJson<int>(trackId),
//       'albumId': serializer.toJson<int>(albumId),
//     };
//   }

//   TrackAlbumData copyWith({int? trackId, int? albumId}) => TrackAlbumData(
//     trackId: trackId ?? this.trackId,
//     albumId: albumId ?? this.albumId,
//   );
//   TrackAlbumData copyWithCompanion(TrackAlbumCompanion data) {
//     return TrackAlbumData(
//       trackId: data.trackId.present ? data.trackId.value : this.trackId,
//       albumId: data.albumId.present ? data.albumId.value : this.albumId,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('TrackAlbumData(')
//           ..write('trackId: $trackId, ')
//           ..write('albumId: $albumId')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(trackId, albumId);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is TrackAlbumData &&
//           other.trackId == this.trackId &&
//           other.albumId == this.albumId);
// }

// class TrackAlbumCompanion extends UpdateCompanion<TrackAlbumData> {
//   final Value<int> trackId;
//   final Value<int> albumId;
//   final Value<int> rowid;
//   const TrackAlbumCompanion({
//     this.trackId = const Value.absent(),
//     this.albumId = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   TrackAlbumCompanion.insert({
//     required int trackId,
//     required int albumId,
//     this.rowid = const Value.absent(),
//   }) : trackId = Value(trackId),
//        albumId = Value(albumId);
//   static Insertable<TrackAlbumData> custom({
//     Expression<int>? trackId,
//     Expression<int>? albumId,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (trackId != null) 'track_id': trackId,
//       if (albumId != null) 'album_id': albumId,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   TrackAlbumCompanion copyWith({
//     Value<int>? trackId,
//     Value<int>? albumId,
//     Value<int>? rowid,
//   }) {
//     return TrackAlbumCompanion(
//       trackId: trackId ?? this.trackId,
//       albumId: albumId ?? this.albumId,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (trackId.present) {
//       map['track_id'] = Variable<int>(trackId.value);
//     }
//     if (albumId.present) {
//       map['album_id'] = Variable<int>(albumId.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('TrackAlbumCompanion(')
//           ..write('trackId: $trackId, ')
//           ..write('albumId: $albumId, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $DisclaimersTable extends Disclaimers
//     with TableInfo<$DisclaimersTable, Disclaimer> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $DisclaimersTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//     'id',
//     aliasedName,
//     false,
//     hasAutoIncrement: true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'PRIMARY KEY AUTOINCREMENT',
//     ),
//   );
//   static const VerificationMeta _nameMeta = const VerificationMeta('name');
//   @override
//   late final GeneratedColumn<String> name = GeneratedColumn<String>(
//     'name',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [id, name];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'disclaimers';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<Disclaimer> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('name')) {
//       context.handle(
//         _nameMeta,
//         name.isAcceptableOrUnknown(data['name']!, _nameMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_nameMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   Disclaimer map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return Disclaimer(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       name: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}name'],
//       )!,
//     );
//   }

//   @override
//   $DisclaimersTable createAlias(String alias) {
//     return $DisclaimersTable(attachedDatabase, alias);
//   }
// }

// class Disclaimer extends DataClass implements Insertable<Disclaimer> {
//   final int id;
//   final String name;
//   const Disclaimer({required this.id, required this.name});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     map['name'] = Variable<String>(name);
//     return map;
//   }

//   DisclaimersCompanion toCompanion(bool nullToAbsent) {
//     return DisclaimersCompanion(id: Value(id), name: Value(name));
//   }

//   factory Disclaimer.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return Disclaimer(
//       id: serializer.fromJson<int>(json['id']),
//       name: serializer.fromJson<String>(json['name']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'name': serializer.toJson<String>(name),
//     };
//   }

//   Disclaimer copyWith({int? id, String? name}) =>
//       Disclaimer(id: id ?? this.id, name: name ?? this.name);
//   Disclaimer copyWithCompanion(DisclaimersCompanion data) {
//     return Disclaimer(
//       id: data.id.present ? data.id.value : this.id,
//       name: data.name.present ? data.name.value : this.name,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('Disclaimer(')
//           ..write('id: $id, ')
//           ..write('name: $name')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(id, name);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Disclaimer && other.id == this.id && other.name == this.name);
// }

// class DisclaimersCompanion extends UpdateCompanion<Disclaimer> {
//   final Value<int> id;
//   final Value<String> name;
//   const DisclaimersCompanion({
//     this.id = const Value.absent(),
//     this.name = const Value.absent(),
//   });
//   DisclaimersCompanion.insert({
//     this.id = const Value.absent(),
//     required String name,
//   }) : name = Value(name);
//   static Insertable<Disclaimer> custom({
//     Expression<int>? id,
//     Expression<String>? name,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (name != null) 'name': name,
//     });
//   }

//   DisclaimersCompanion copyWith({Value<int>? id, Value<String>? name}) {
//     return DisclaimersCompanion(id: id ?? this.id, name: name ?? this.name);
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (name.present) {
//       map['name'] = Variable<String>(name.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('DisclaimersCompanion(')
//           ..write('id: $id, ')
//           ..write('name: $name')
//           ..write(')'))
//         .toString();
//   }
// }

// class $YandexMusicAditionalTrackInfoTable extends YandexMusicAditionalTrackInfo
//     with
//         TableInfo<
//           $YandexMusicAditionalTrackInfoTable,
//           YandexMusicAditionalTrackInfoData
//         > {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $YandexMusicAditionalTrackInfoTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _idMeta = const VerificationMeta('id');
//   @override
//   late final GeneratedColumn<int> id = GeneratedColumn<int>(
//     'id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES tracks (id)',
//     ),
//   );
//   static const VerificationMeta _realIdMeta = const VerificationMeta('realId');
//   @override
//   late final GeneratedColumn<int> realId = GeneratedColumn<int>(
//     'real_id',
//     aliasedName,
//     true,
//     type: DriftSqlType.int,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _trackSharingFlagMeta = const VerificationMeta(
//     'trackSharingFlag',
//   );
//   @override
//   late final GeneratedColumn<String> trackSharingFlag = GeneratedColumn<String>(
//     'track_sharing_flag',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _trackSourceMeta = const VerificationMeta(
//     'trackSource',
//   );
//   @override
//   late final GeneratedColumn<String> trackSource = GeneratedColumn<String>(
//     'track_source',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _r128iMeta = const VerificationMeta('r128i');
//   @override
//   late final GeneratedColumn<double> r128i = GeneratedColumn<double>(
//     'r128i',
//     aliasedName,
//     true,
//     type: DriftSqlType.double,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _r128tpMeta = const VerificationMeta('r128tp');
//   @override
//   late final GeneratedColumn<double> r128tp = GeneratedColumn<double>(
//     'r128tp',
//     aliasedName,
//     true,
//     type: DriftSqlType.double,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _fadeInStartMeta = const VerificationMeta(
//     'fadeInStart',
//   );
//   @override
//   late final GeneratedColumn<double> fadeInStart = GeneratedColumn<double>(
//     'fade_in_start',
//     aliasedName,
//     true,
//     type: DriftSqlType.double,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _fadeInStopMeta = const VerificationMeta(
//     'fadeInStop',
//   );
//   @override
//   late final GeneratedColumn<double> fadeInStop = GeneratedColumn<double>(
//     'fade_in_stop',
//     aliasedName,
//     true,
//     type: DriftSqlType.double,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _fadeOutStartMeta = const VerificationMeta(
//     'fadeOutStart',
//   );
//   @override
//   late final GeneratedColumn<double> fadeOutStart = GeneratedColumn<double>(
//     'fade_out_start',
//     aliasedName,
//     true,
//     type: DriftSqlType.double,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _fadeOutStopMeta = const VerificationMeta(
//     'fadeOutStop',
//   );
//   @override
//   late final GeneratedColumn<double> fadeOutStop = GeneratedColumn<double>(
//     'fade_out_stop',
//     aliasedName,
//     true,
//     type: DriftSqlType.double,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _averageColorMeta = const VerificationMeta(
//     'averageColor',
//   );
//   @override
//   late final GeneratedColumn<String> averageColor = GeneratedColumn<String>(
//     'average_color',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _waveTextColorMeta = const VerificationMeta(
//     'waveTextColor',
//   );
//   @override
//   late final GeneratedColumn<String> waveTextColor = GeneratedColumn<String>(
//     'wave_text_color',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _miniPlayerColorMeta = const VerificationMeta(
//     'miniPlayerColor',
//   );
//   @override
//   late final GeneratedColumn<String> miniPlayerColor = GeneratedColumn<String>(
//     'mini_player_color',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _accentColorMeta = const VerificationMeta(
//     'accentColor',
//   );
//   @override
//   late final GeneratedColumn<String> accentColor = GeneratedColumn<String>(
//     'accent_color',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     id,
//     realId,
//     trackSharingFlag,
//     trackSource,
//     r128i,
//     r128tp,
//     fadeInStart,
//     fadeInStop,
//     fadeOutStart,
//     fadeOutStop,
//     averageColor,
//     waveTextColor,
//     miniPlayerColor,
//     accentColor,
//   ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'yandex_music_aditional_track_info';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<YandexMusicAditionalTrackInfoData> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     } else if (isInserting) {
//       context.missing(_idMeta);
//     }
//     if (data.containsKey('real_id')) {
//       context.handle(
//         _realIdMeta,
//         realId.isAcceptableOrUnknown(data['real_id']!, _realIdMeta),
//       );
//     }
//     if (data.containsKey('track_sharing_flag')) {
//       context.handle(
//         _trackSharingFlagMeta,
//         trackSharingFlag.isAcceptableOrUnknown(
//           data['track_sharing_flag']!,
//           _trackSharingFlagMeta,
//         ),
//       );
//     }
//     if (data.containsKey('track_source')) {
//       context.handle(
//         _trackSourceMeta,
//         trackSource.isAcceptableOrUnknown(
//           data['track_source']!,
//           _trackSourceMeta,
//         ),
//       );
//     }
//     if (data.containsKey('r128i')) {
//       context.handle(
//         _r128iMeta,
//         r128i.isAcceptableOrUnknown(data['r128i']!, _r128iMeta),
//       );
//     }
//     if (data.containsKey('r128tp')) {
//       context.handle(
//         _r128tpMeta,
//         r128tp.isAcceptableOrUnknown(data['r128tp']!, _r128tpMeta),
//       );
//     }
//     if (data.containsKey('fade_in_start')) {
//       context.handle(
//         _fadeInStartMeta,
//         fadeInStart.isAcceptableOrUnknown(
//           data['fade_in_start']!,
//           _fadeInStartMeta,
//         ),
//       );
//     }
//     if (data.containsKey('fade_in_stop')) {
//       context.handle(
//         _fadeInStopMeta,
//         fadeInStop.isAcceptableOrUnknown(
//           data['fade_in_stop']!,
//           _fadeInStopMeta,
//         ),
//       );
//     }
//     if (data.containsKey('fade_out_start')) {
//       context.handle(
//         _fadeOutStartMeta,
//         fadeOutStart.isAcceptableOrUnknown(
//           data['fade_out_start']!,
//           _fadeOutStartMeta,
//         ),
//       );
//     }
//     if (data.containsKey('fade_out_stop')) {
//       context.handle(
//         _fadeOutStopMeta,
//         fadeOutStop.isAcceptableOrUnknown(
//           data['fade_out_stop']!,
//           _fadeOutStopMeta,
//         ),
//       );
//     }
//     if (data.containsKey('average_color')) {
//       context.handle(
//         _averageColorMeta,
//         averageColor.isAcceptableOrUnknown(
//           data['average_color']!,
//           _averageColorMeta,
//         ),
//       );
//     }
//     if (data.containsKey('wave_text_color')) {
//       context.handle(
//         _waveTextColorMeta,
//         waveTextColor.isAcceptableOrUnknown(
//           data['wave_text_color']!,
//           _waveTextColorMeta,
//         ),
//       );
//     }
//     if (data.containsKey('mini_player_color')) {
//       context.handle(
//         _miniPlayerColorMeta,
//         miniPlayerColor.isAcceptableOrUnknown(
//           data['mini_player_color']!,
//           _miniPlayerColorMeta,
//         ),
//       );
//     }
//     if (data.containsKey('accent_color')) {
//       context.handle(
//         _accentColorMeta,
//         accentColor.isAcceptableOrUnknown(
//           data['accent_color']!,
//           _accentColorMeta,
//         ),
//       );
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => const {};
//   @override
//   YandexMusicAditionalTrackInfoData map(
//     Map<String, dynamic> data, {
//     String? tablePrefix,
//   }) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return YandexMusicAditionalTrackInfoData(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       realId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}real_id'],
//       ),
//       trackSharingFlag: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}track_sharing_flag'],
//       ),
//       trackSource: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}track_source'],
//       ),
//       r128i: attachedDatabase.typeMapping.read(
//         DriftSqlType.double,
//         data['${effectivePrefix}r128i'],
//       ),
//       r128tp: attachedDatabase.typeMapping.read(
//         DriftSqlType.double,
//         data['${effectivePrefix}r128tp'],
//       ),
//       fadeInStart: attachedDatabase.typeMapping.read(
//         DriftSqlType.double,
//         data['${effectivePrefix}fade_in_start'],
//       ),
//       fadeInStop: attachedDatabase.typeMapping.read(
//         DriftSqlType.double,
//         data['${effectivePrefix}fade_in_stop'],
//       ),
//       fadeOutStart: attachedDatabase.typeMapping.read(
//         DriftSqlType.double,
//         data['${effectivePrefix}fade_out_start'],
//       ),
//       fadeOutStop: attachedDatabase.typeMapping.read(
//         DriftSqlType.double,
//         data['${effectivePrefix}fade_out_stop'],
//       ),
//       averageColor: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}average_color'],
//       ),
//       waveTextColor: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}wave_text_color'],
//       ),
//       miniPlayerColor: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}mini_player_color'],
//       ),
//       accentColor: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}accent_color'],
//       ),
//     );
//   }

//   @override
//   $YandexMusicAditionalTrackInfoTable createAlias(String alias) {
//     return $YandexMusicAditionalTrackInfoTable(attachedDatabase, alias);
//   }
// }

// class YandexMusicAditionalTrackInfoData extends DataClass
//     implements Insertable<YandexMusicAditionalTrackInfoData> {
//   final int id;
//   final int? realId;
//   final String? trackSharingFlag;
//   final String? trackSource;
//   final double? r128i;
//   final double? r128tp;
//   final double? fadeInStart;
//   final double? fadeInStop;
//   final double? fadeOutStart;
//   final double? fadeOutStop;
//   final String? averageColor;
//   final String? waveTextColor;
//   final String? miniPlayerColor;
//   final String? accentColor;
//   const YandexMusicAditionalTrackInfoData({
//     required this.id,
//     this.realId,
//     this.trackSharingFlag,
//     this.trackSource,
//     this.r128i,
//     this.r128tp,
//     this.fadeInStart,
//     this.fadeInStop,
//     this.fadeOutStart,
//     this.fadeOutStop,
//     this.averageColor,
//     this.waveTextColor,
//     this.miniPlayerColor,
//     this.accentColor,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     if (!nullToAbsent || realId != null) {
//       map['real_id'] = Variable<int>(realId);
//     }
//     if (!nullToAbsent || trackSharingFlag != null) {
//       map['track_sharing_flag'] = Variable<String>(trackSharingFlag);
//     }
//     if (!nullToAbsent || trackSource != null) {
//       map['track_source'] = Variable<String>(trackSource);
//     }
//     if (!nullToAbsent || r128i != null) {
//       map['r128i'] = Variable<double>(r128i);
//     }
//     if (!nullToAbsent || r128tp != null) {
//       map['r128tp'] = Variable<double>(r128tp);
//     }
//     if (!nullToAbsent || fadeInStart != null) {
//       map['fade_in_start'] = Variable<double>(fadeInStart);
//     }
//     if (!nullToAbsent || fadeInStop != null) {
//       map['fade_in_stop'] = Variable<double>(fadeInStop);
//     }
//     if (!nullToAbsent || fadeOutStart != null) {
//       map['fade_out_start'] = Variable<double>(fadeOutStart);
//     }
//     if (!nullToAbsent || fadeOutStop != null) {
//       map['fade_out_stop'] = Variable<double>(fadeOutStop);
//     }
//     if (!nullToAbsent || averageColor != null) {
//       map['average_color'] = Variable<String>(averageColor);
//     }
//     if (!nullToAbsent || waveTextColor != null) {
//       map['wave_text_color'] = Variable<String>(waveTextColor);
//     }
//     if (!nullToAbsent || miniPlayerColor != null) {
//       map['mini_player_color'] = Variable<String>(miniPlayerColor);
//     }
//     if (!nullToAbsent || accentColor != null) {
//       map['accent_color'] = Variable<String>(accentColor);
//     }
//     return map;
//   }

//   YandexMusicAditionalTrackInfoCompanion toCompanion(bool nullToAbsent) {
//     return YandexMusicAditionalTrackInfoCompanion(
//       id: Value(id),
//       realId: realId == null && nullToAbsent
//           ? const Value.absent()
//           : Value(realId),
//       trackSharingFlag: trackSharingFlag == null && nullToAbsent
//           ? const Value.absent()
//           : Value(trackSharingFlag),
//       trackSource: trackSource == null && nullToAbsent
//           ? const Value.absent()
//           : Value(trackSource),
//       r128i: r128i == null && nullToAbsent
//           ? const Value.absent()
//           : Value(r128i),
//       r128tp: r128tp == null && nullToAbsent
//           ? const Value.absent()
//           : Value(r128tp),
//       fadeInStart: fadeInStart == null && nullToAbsent
//           ? const Value.absent()
//           : Value(fadeInStart),
//       fadeInStop: fadeInStop == null && nullToAbsent
//           ? const Value.absent()
//           : Value(fadeInStop),
//       fadeOutStart: fadeOutStart == null && nullToAbsent
//           ? const Value.absent()
//           : Value(fadeOutStart),
//       fadeOutStop: fadeOutStop == null && nullToAbsent
//           ? const Value.absent()
//           : Value(fadeOutStop),
//       averageColor: averageColor == null && nullToAbsent
//           ? const Value.absent()
//           : Value(averageColor),
//       waveTextColor: waveTextColor == null && nullToAbsent
//           ? const Value.absent()
//           : Value(waveTextColor),
//       miniPlayerColor: miniPlayerColor == null && nullToAbsent
//           ? const Value.absent()
//           : Value(miniPlayerColor),
//       accentColor: accentColor == null && nullToAbsent
//           ? const Value.absent()
//           : Value(accentColor),
//     );
//   }

//   factory YandexMusicAditionalTrackInfoData.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return YandexMusicAditionalTrackInfoData(
//       id: serializer.fromJson<int>(json['id']),
//       realId: serializer.fromJson<int?>(json['realId']),
//       trackSharingFlag: serializer.fromJson<String?>(json['trackSharingFlag']),
//       trackSource: serializer.fromJson<String?>(json['trackSource']),
//       r128i: serializer.fromJson<double?>(json['r128i']),
//       r128tp: serializer.fromJson<double?>(json['r128tp']),
//       fadeInStart: serializer.fromJson<double?>(json['fadeInStart']),
//       fadeInStop: serializer.fromJson<double?>(json['fadeInStop']),
//       fadeOutStart: serializer.fromJson<double?>(json['fadeOutStart']),
//       fadeOutStop: serializer.fromJson<double?>(json['fadeOutStop']),
//       averageColor: serializer.fromJson<String?>(json['averageColor']),
//       waveTextColor: serializer.fromJson<String?>(json['waveTextColor']),
//       miniPlayerColor: serializer.fromJson<String?>(json['miniPlayerColor']),
//       accentColor: serializer.fromJson<String?>(json['accentColor']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'realId': serializer.toJson<int?>(realId),
//       'trackSharingFlag': serializer.toJson<String?>(trackSharingFlag),
//       'trackSource': serializer.toJson<String?>(trackSource),
//       'r128i': serializer.toJson<double?>(r128i),
//       'r128tp': serializer.toJson<double?>(r128tp),
//       'fadeInStart': serializer.toJson<double?>(fadeInStart),
//       'fadeInStop': serializer.toJson<double?>(fadeInStop),
//       'fadeOutStart': serializer.toJson<double?>(fadeOutStart),
//       'fadeOutStop': serializer.toJson<double?>(fadeOutStop),
//       'averageColor': serializer.toJson<String?>(averageColor),
//       'waveTextColor': serializer.toJson<String?>(waveTextColor),
//       'miniPlayerColor': serializer.toJson<String?>(miniPlayerColor),
//       'accentColor': serializer.toJson<String?>(accentColor),
//     };
//   }

//   YandexMusicAditionalTrackInfoData copyWith({
//     int? id,
//     Value<int?> realId = const Value.absent(),
//     Value<String?> trackSharingFlag = const Value.absent(),
//     Value<String?> trackSource = const Value.absent(),
//     Value<double?> r128i = const Value.absent(),
//     Value<double?> r128tp = const Value.absent(),
//     Value<double?> fadeInStart = const Value.absent(),
//     Value<double?> fadeInStop = const Value.absent(),
//     Value<double?> fadeOutStart = const Value.absent(),
//     Value<double?> fadeOutStop = const Value.absent(),
//     Value<String?> averageColor = const Value.absent(),
//     Value<String?> waveTextColor = const Value.absent(),
//     Value<String?> miniPlayerColor = const Value.absent(),
//     Value<String?> accentColor = const Value.absent(),
//   }) => YandexMusicAditionalTrackInfoData(
//     id: id ?? this.id,
//     realId: realId.present ? realId.value : this.realId,
//     trackSharingFlag: trackSharingFlag.present
//         ? trackSharingFlag.value
//         : this.trackSharingFlag,
//     trackSource: trackSource.present ? trackSource.value : this.trackSource,
//     r128i: r128i.present ? r128i.value : this.r128i,
//     r128tp: r128tp.present ? r128tp.value : this.r128tp,
//     fadeInStart: fadeInStart.present ? fadeInStart.value : this.fadeInStart,
//     fadeInStop: fadeInStop.present ? fadeInStop.value : this.fadeInStop,
//     fadeOutStart: fadeOutStart.present ? fadeOutStart.value : this.fadeOutStart,
//     fadeOutStop: fadeOutStop.present ? fadeOutStop.value : this.fadeOutStop,
//     averageColor: averageColor.present ? averageColor.value : this.averageColor,
//     waveTextColor: waveTextColor.present
//         ? waveTextColor.value
//         : this.waveTextColor,
//     miniPlayerColor: miniPlayerColor.present
//         ? miniPlayerColor.value
//         : this.miniPlayerColor,
//     accentColor: accentColor.present ? accentColor.value : this.accentColor,
//   );
//   YandexMusicAditionalTrackInfoData copyWithCompanion(
//     YandexMusicAditionalTrackInfoCompanion data,
//   ) {
//     return YandexMusicAditionalTrackInfoData(
//       id: data.id.present ? data.id.value : this.id,
//       realId: data.realId.present ? data.realId.value : this.realId,
//       trackSharingFlag: data.trackSharingFlag.present
//           ? data.trackSharingFlag.value
//           : this.trackSharingFlag,
//       trackSource: data.trackSource.present
//           ? data.trackSource.value
//           : this.trackSource,
//       r128i: data.r128i.present ? data.r128i.value : this.r128i,
//       r128tp: data.r128tp.present ? data.r128tp.value : this.r128tp,
//       fadeInStart: data.fadeInStart.present
//           ? data.fadeInStart.value
//           : this.fadeInStart,
//       fadeInStop: data.fadeInStop.present
//           ? data.fadeInStop.value
//           : this.fadeInStop,
//       fadeOutStart: data.fadeOutStart.present
//           ? data.fadeOutStart.value
//           : this.fadeOutStart,
//       fadeOutStop: data.fadeOutStop.present
//           ? data.fadeOutStop.value
//           : this.fadeOutStop,
//       averageColor: data.averageColor.present
//           ? data.averageColor.value
//           : this.averageColor,
//       waveTextColor: data.waveTextColor.present
//           ? data.waveTextColor.value
//           : this.waveTextColor,
//       miniPlayerColor: data.miniPlayerColor.present
//           ? data.miniPlayerColor.value
//           : this.miniPlayerColor,
//       accentColor: data.accentColor.present
//           ? data.accentColor.value
//           : this.accentColor,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('YandexMusicAditionalTrackInfoData(')
//           ..write('id: $id, ')
//           ..write('realId: $realId, ')
//           ..write('trackSharingFlag: $trackSharingFlag, ')
//           ..write('trackSource: $trackSource, ')
//           ..write('r128i: $r128i, ')
//           ..write('r128tp: $r128tp, ')
//           ..write('fadeInStart: $fadeInStart, ')
//           ..write('fadeInStop: $fadeInStop, ')
//           ..write('fadeOutStart: $fadeOutStart, ')
//           ..write('fadeOutStop: $fadeOutStop, ')
//           ..write('averageColor: $averageColor, ')
//           ..write('waveTextColor: $waveTextColor, ')
//           ..write('miniPlayerColor: $miniPlayerColor, ')
//           ..write('accentColor: $accentColor')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(
//     id,
//     realId,
//     trackSharingFlag,
//     trackSource,
//     r128i,
//     r128tp,
//     fadeInStart,
//     fadeInStop,
//     fadeOutStart,
//     fadeOutStop,
//     averageColor,
//     waveTextColor,
//     miniPlayerColor,
//     accentColor,
//   );
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is YandexMusicAditionalTrackInfoData &&
//           other.id == this.id &&
//           other.realId == this.realId &&
//           other.trackSharingFlag == this.trackSharingFlag &&
//           other.trackSource == this.trackSource &&
//           other.r128i == this.r128i &&
//           other.r128tp == this.r128tp &&
//           other.fadeInStart == this.fadeInStart &&
//           other.fadeInStop == this.fadeInStop &&
//           other.fadeOutStart == this.fadeOutStart &&
//           other.fadeOutStop == this.fadeOutStop &&
//           other.averageColor == this.averageColor &&
//           other.waveTextColor == this.waveTextColor &&
//           other.miniPlayerColor == this.miniPlayerColor &&
//           other.accentColor == this.accentColor);
// }

// class YandexMusicAditionalTrackInfoCompanion
//     extends UpdateCompanion<YandexMusicAditionalTrackInfoData> {
//   final Value<int> id;
//   final Value<int?> realId;
//   final Value<String?> trackSharingFlag;
//   final Value<String?> trackSource;
//   final Value<double?> r128i;
//   final Value<double?> r128tp;
//   final Value<double?> fadeInStart;
//   final Value<double?> fadeInStop;
//   final Value<double?> fadeOutStart;
//   final Value<double?> fadeOutStop;
//   final Value<String?> averageColor;
//   final Value<String?> waveTextColor;
//   final Value<String?> miniPlayerColor;
//   final Value<String?> accentColor;
//   final Value<int> rowid;
//   const YandexMusicAditionalTrackInfoCompanion({
//     this.id = const Value.absent(),
//     this.realId = const Value.absent(),
//     this.trackSharingFlag = const Value.absent(),
//     this.trackSource = const Value.absent(),
//     this.r128i = const Value.absent(),
//     this.r128tp = const Value.absent(),
//     this.fadeInStart = const Value.absent(),
//     this.fadeInStop = const Value.absent(),
//     this.fadeOutStart = const Value.absent(),
//     this.fadeOutStop = const Value.absent(),
//     this.averageColor = const Value.absent(),
//     this.waveTextColor = const Value.absent(),
//     this.miniPlayerColor = const Value.absent(),
//     this.accentColor = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   YandexMusicAditionalTrackInfoCompanion.insert({
//     required int id,
//     this.realId = const Value.absent(),
//     this.trackSharingFlag = const Value.absent(),
//     this.trackSource = const Value.absent(),
//     this.r128i = const Value.absent(),
//     this.r128tp = const Value.absent(),
//     this.fadeInStart = const Value.absent(),
//     this.fadeInStop = const Value.absent(),
//     this.fadeOutStart = const Value.absent(),
//     this.fadeOutStop = const Value.absent(),
//     this.averageColor = const Value.absent(),
//     this.waveTextColor = const Value.absent(),
//     this.miniPlayerColor = const Value.absent(),
//     this.accentColor = const Value.absent(),
//     this.rowid = const Value.absent(),
//   }) : id = Value(id);
//   static Insertable<YandexMusicAditionalTrackInfoData> custom({
//     Expression<int>? id,
//     Expression<int>? realId,
//     Expression<String>? trackSharingFlag,
//     Expression<String>? trackSource,
//     Expression<double>? r128i,
//     Expression<double>? r128tp,
//     Expression<double>? fadeInStart,
//     Expression<double>? fadeInStop,
//     Expression<double>? fadeOutStart,
//     Expression<double>? fadeOutStop,
//     Expression<String>? averageColor,
//     Expression<String>? waveTextColor,
//     Expression<String>? miniPlayerColor,
//     Expression<String>? accentColor,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (realId != null) 'real_id': realId,
//       if (trackSharingFlag != null) 'track_sharing_flag': trackSharingFlag,
//       if (trackSource != null) 'track_source': trackSource,
//       if (r128i != null) 'r128i': r128i,
//       if (r128tp != null) 'r128tp': r128tp,
//       if (fadeInStart != null) 'fade_in_start': fadeInStart,
//       if (fadeInStop != null) 'fade_in_stop': fadeInStop,
//       if (fadeOutStart != null) 'fade_out_start': fadeOutStart,
//       if (fadeOutStop != null) 'fade_out_stop': fadeOutStop,
//       if (averageColor != null) 'average_color': averageColor,
//       if (waveTextColor != null) 'wave_text_color': waveTextColor,
//       if (miniPlayerColor != null) 'mini_player_color': miniPlayerColor,
//       if (accentColor != null) 'accent_color': accentColor,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   YandexMusicAditionalTrackInfoCompanion copyWith({
//     Value<int>? id,
//     Value<int?>? realId,
//     Value<String?>? trackSharingFlag,
//     Value<String?>? trackSource,
//     Value<double?>? r128i,
//     Value<double?>? r128tp,
//     Value<double?>? fadeInStart,
//     Value<double?>? fadeInStop,
//     Value<double?>? fadeOutStart,
//     Value<double?>? fadeOutStop,
//     Value<String?>? averageColor,
//     Value<String?>? waveTextColor,
//     Value<String?>? miniPlayerColor,
//     Value<String?>? accentColor,
//     Value<int>? rowid,
//   }) {
//     return YandexMusicAditionalTrackInfoCompanion(
//       id: id ?? this.id,
//       realId: realId ?? this.realId,
//       trackSharingFlag: trackSharingFlag ?? this.trackSharingFlag,
//       trackSource: trackSource ?? this.trackSource,
//       r128i: r128i ?? this.r128i,
//       r128tp: r128tp ?? this.r128tp,
//       fadeInStart: fadeInStart ?? this.fadeInStart,
//       fadeInStop: fadeInStop ?? this.fadeInStop,
//       fadeOutStart: fadeOutStart ?? this.fadeOutStart,
//       fadeOutStop: fadeOutStop ?? this.fadeOutStop,
//       averageColor: averageColor ?? this.averageColor,
//       waveTextColor: waveTextColor ?? this.waveTextColor,
//       miniPlayerColor: miniPlayerColor ?? this.miniPlayerColor,
//       accentColor: accentColor ?? this.accentColor,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (realId.present) {
//       map['real_id'] = Variable<int>(realId.value);
//     }
//     if (trackSharingFlag.present) {
//       map['track_sharing_flag'] = Variable<String>(trackSharingFlag.value);
//     }
//     if (trackSource.present) {
//       map['track_source'] = Variable<String>(trackSource.value);
//     }
//     if (r128i.present) {
//       map['r128i'] = Variable<double>(r128i.value);
//     }
//     if (r128tp.present) {
//       map['r128tp'] = Variable<double>(r128tp.value);
//     }
//     if (fadeInStart.present) {
//       map['fade_in_start'] = Variable<double>(fadeInStart.value);
//     }
//     if (fadeInStop.present) {
//       map['fade_in_stop'] = Variable<double>(fadeInStop.value);
//     }
//     if (fadeOutStart.present) {
//       map['fade_out_start'] = Variable<double>(fadeOutStart.value);
//     }
//     if (fadeOutStop.present) {
//       map['fade_out_stop'] = Variable<double>(fadeOutStop.value);
//     }
//     if (averageColor.present) {
//       map['average_color'] = Variable<String>(averageColor.value);
//     }
//     if (waveTextColor.present) {
//       map['wave_text_color'] = Variable<String>(waveTextColor.value);
//     }
//     if (miniPlayerColor.present) {
//       map['mini_player_color'] = Variable<String>(miniPlayerColor.value);
//     }
//     if (accentColor.present) {
//       map['accent_color'] = Variable<String>(accentColor.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('YandexMusicAditionalTrackInfoCompanion(')
//           ..write('id: $id, ')
//           ..write('realId: $realId, ')
//           ..write('trackSharingFlag: $trackSharingFlag, ')
//           ..write('trackSource: $trackSource, ')
//           ..write('r128i: $r128i, ')
//           ..write('r128tp: $r128tp, ')
//           ..write('fadeInStart: $fadeInStart, ')
//           ..write('fadeInStop: $fadeInStop, ')
//           ..write('fadeOutStart: $fadeOutStart, ')
//           ..write('fadeOutStop: $fadeOutStop, ')
//           ..write('averageColor: $averageColor, ')
//           ..write('waveTextColor: $waveTextColor, ')
//           ..write('miniPlayerColor: $miniPlayerColor, ')
//           ..write('accentColor: $accentColor, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $YandexMusicTrackDisclaimerTable extends YandexMusicTrackDisclaimer
//     with
//         TableInfo<
//           $YandexMusicTrackDisclaimerTable,
//           YandexMusicTrackDisclaimerData
//         > {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $YandexMusicTrackDisclaimerTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _trackIdMeta = const VerificationMeta(
//     'trackId',
//   );
//   @override
//   late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
//     'track_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES tracks (id)',
//     ),
//   );
//   static const VerificationMeta _disclaimerIdMeta = const VerificationMeta(
//     'disclaimerId',
//   );
//   @override
//   late final GeneratedColumn<int> disclaimerId = GeneratedColumn<int>(
//     'disclaimer_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'UNIQUE REFERENCES disclaimers (id)',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [trackId, disclaimerId];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'yandex_music_track_disclaimer';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<YandexMusicTrackDisclaimerData> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('track_id')) {
//       context.handle(
//         _trackIdMeta,
//         trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_trackIdMeta);
//     }
//     if (data.containsKey('disclaimer_id')) {
//       context.handle(
//         _disclaimerIdMeta,
//         disclaimerId.isAcceptableOrUnknown(
//           data['disclaimer_id']!,
//           _disclaimerIdMeta,
//         ),
//       );
//     } else if (isInserting) {
//       context.missing(_disclaimerIdMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {trackId, disclaimerId};
//   @override
//   YandexMusicTrackDisclaimerData map(
//     Map<String, dynamic> data, {
//     String? tablePrefix,
//   }) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return YandexMusicTrackDisclaimerData(
//       trackId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track_id'],
//       )!,
//       disclaimerId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}disclaimer_id'],
//       )!,
//     );
//   }

//   @override
//   $YandexMusicTrackDisclaimerTable createAlias(String alias) {
//     return $YandexMusicTrackDisclaimerTable(attachedDatabase, alias);
//   }
// }

// class YandexMusicTrackDisclaimerData extends DataClass
//     implements Insertable<YandexMusicTrackDisclaimerData> {
//   final int trackId;
//   final int disclaimerId;
//   const YandexMusicTrackDisclaimerData({
//     required this.trackId,
//     required this.disclaimerId,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['track_id'] = Variable<int>(trackId);
//     map['disclaimer_id'] = Variable<int>(disclaimerId);
//     return map;
//   }

//   YandexMusicTrackDisclaimerCompanion toCompanion(bool nullToAbsent) {
//     return YandexMusicTrackDisclaimerCompanion(
//       trackId: Value(trackId),
//       disclaimerId: Value(disclaimerId),
//     );
//   }

//   factory YandexMusicTrackDisclaimerData.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return YandexMusicTrackDisclaimerData(
//       trackId: serializer.fromJson<int>(json['trackId']),
//       disclaimerId: serializer.fromJson<int>(json['disclaimerId']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'trackId': serializer.toJson<int>(trackId),
//       'disclaimerId': serializer.toJson<int>(disclaimerId),
//     };
//   }

//   YandexMusicTrackDisclaimerData copyWith({int? trackId, int? disclaimerId}) =>
//       YandexMusicTrackDisclaimerData(
//         trackId: trackId ?? this.trackId,
//         disclaimerId: disclaimerId ?? this.disclaimerId,
//       );
//   YandexMusicTrackDisclaimerData copyWithCompanion(
//     YandexMusicTrackDisclaimerCompanion data,
//   ) {
//     return YandexMusicTrackDisclaimerData(
//       trackId: data.trackId.present ? data.trackId.value : this.trackId,
//       disclaimerId: data.disclaimerId.present
//           ? data.disclaimerId.value
//           : this.disclaimerId,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('YandexMusicTrackDisclaimerData(')
//           ..write('trackId: $trackId, ')
//           ..write('disclaimerId: $disclaimerId')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(trackId, disclaimerId);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is YandexMusicTrackDisclaimerData &&
//           other.trackId == this.trackId &&
//           other.disclaimerId == this.disclaimerId);
// }

// class YandexMusicTrackDisclaimerCompanion
//     extends UpdateCompanion<YandexMusicTrackDisclaimerData> {
//   final Value<int> trackId;
//   final Value<int> disclaimerId;
//   final Value<int> rowid;
//   const YandexMusicTrackDisclaimerCompanion({
//     this.trackId = const Value.absent(),
//     this.disclaimerId = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   YandexMusicTrackDisclaimerCompanion.insert({
//     required int trackId,
//     required int disclaimerId,
//     this.rowid = const Value.absent(),
//   }) : trackId = Value(trackId),
//        disclaimerId = Value(disclaimerId);
//   static Insertable<YandexMusicTrackDisclaimerData> custom({
//     Expression<int>? trackId,
//     Expression<int>? disclaimerId,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (trackId != null) 'track_id': trackId,
//       if (disclaimerId != null) 'disclaimer_id': disclaimerId,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   YandexMusicTrackDisclaimerCompanion copyWith({
//     Value<int>? trackId,
//     Value<int>? disclaimerId,
//     Value<int>? rowid,
//   }) {
//     return YandexMusicTrackDisclaimerCompanion(
//       trackId: trackId ?? this.trackId,
//       disclaimerId: disclaimerId ?? this.disclaimerId,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (trackId.present) {
//       map['track_id'] = Variable<int>(trackId.value);
//     }
//     if (disclaimerId.present) {
//       map['disclaimer_id'] = Variable<int>(disclaimerId.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('YandexMusicTrackDisclaimerCompanion(')
//           ..write('trackId: $trackId, ')
//           ..write('disclaimerId: $disclaimerId, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $PlaylistTracksTable extends PlaylistTracks
//     with TableInfo<$PlaylistTracksTable, PlaylistTrack> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $PlaylistTracksTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _trackIdMeta = const VerificationMeta(
//     'trackId',
//   );
//   @override
//   late final GeneratedColumn<int> trackId = GeneratedColumn<int>(
//     'track_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES tracks (id)',
//     ),
//   );
//   static const VerificationMeta _playlistIdMeta = const VerificationMeta(
//     'playlistId',
//   );
//   @override
//   late final GeneratedColumn<int> playlistId = GeneratedColumn<int>(
//     'playlist_id',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES playlists (id)',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [trackId, playlistId];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'playlist_tracks';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<PlaylistTrack> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('track_id')) {
//       context.handle(
//         _trackIdMeta,
//         trackId.isAcceptableOrUnknown(data['track_id']!, _trackIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_trackIdMeta);
//     }
//     if (data.containsKey('playlist_id')) {
//       context.handle(
//         _playlistIdMeta,
//         playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_playlistIdMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {playlistId, trackId};
//   @override
//   PlaylistTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return PlaylistTrack(
//       trackId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track_id'],
//       )!,
//       playlistId: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}playlist_id'],
//       )!,
//     );
//   }

//   @override
//   $PlaylistTracksTable createAlias(String alias) {
//     return $PlaylistTracksTable(attachedDatabase, alias);
//   }
// }

// class PlaylistTrack extends DataClass implements Insertable<PlaylistTrack> {
//   final int trackId;
//   final int playlistId;
//   const PlaylistTrack({required this.trackId, required this.playlistId});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['track_id'] = Variable<int>(trackId);
//     map['playlist_id'] = Variable<int>(playlistId);
//     return map;
//   }

//   PlaylistTracksCompanion toCompanion(bool nullToAbsent) {
//     return PlaylistTracksCompanion(
//       trackId: Value(trackId),
//       playlistId: Value(playlistId),
//     );
//   }

//   factory PlaylistTrack.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return PlaylistTrack(
//       trackId: serializer.fromJson<int>(json['trackId']),
//       playlistId: serializer.fromJson<int>(json['playlistId']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'trackId': serializer.toJson<int>(trackId),
//       'playlistId': serializer.toJson<int>(playlistId),
//     };
//   }

//   PlaylistTrack copyWith({int? trackId, int? playlistId}) => PlaylistTrack(
//     trackId: trackId ?? this.trackId,
//     playlistId: playlistId ?? this.playlistId,
//   );
//   PlaylistTrack copyWithCompanion(PlaylistTracksCompanion data) {
//     return PlaylistTrack(
//       trackId: data.trackId.present ? data.trackId.value : this.trackId,
//       playlistId: data.playlistId.present
//           ? data.playlistId.value
//           : this.playlistId,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('PlaylistTrack(')
//           ..write('trackId: $trackId, ')
//           ..write('playlistId: $playlistId')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(trackId, playlistId);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is PlaylistTrack &&
//           other.trackId == this.trackId &&
//           other.playlistId == this.playlistId);
// }

// class PlaylistTracksCompanion extends UpdateCompanion<PlaylistTrack> {
//   final Value<int> trackId;
//   final Value<int> playlistId;
//   final Value<int> rowid;
//   const PlaylistTracksCompanion({
//     this.trackId = const Value.absent(),
//     this.playlistId = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   PlaylistTracksCompanion.insert({
//     required int trackId,
//     required int playlistId,
//     this.rowid = const Value.absent(),
//   }) : trackId = Value(trackId),
//        playlistId = Value(playlistId);
//   static Insertable<PlaylistTrack> custom({
//     Expression<int>? trackId,
//     Expression<int>? playlistId,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (trackId != null) 'track_id': trackId,
//       if (playlistId != null) 'playlist_id': playlistId,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   PlaylistTracksCompanion copyWith({
//     Value<int>? trackId,
//     Value<int>? playlistId,
//     Value<int>? rowid,
//   }) {
//     return PlaylistTracksCompanion(
//       trackId: trackId ?? this.trackId,
//       playlistId: playlistId ?? this.playlistId,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (trackId.present) {
//       map['track_id'] = Variable<int>(trackId.value);
//     }
//     if (playlistId.present) {
//       map['playlist_id'] = Variable<int>(playlistId.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('PlaylistTracksCompanion(')
//           ..write('trackId: $trackId, ')
//           ..write('playlistId: $playlistId, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// abstract class _$AppDatabase extends GeneratedDatabase {
//   _$AppDatabase(QueryExecutor e) : super(e);
//   $AppDatabaseManager get managers => $AppDatabaseManager(this);
//   late final $TracksTable tracks = $TracksTable(this);
//   late final $SettingsTable settings = $SettingsTable(this);
//   late final $PlaylistsTable playlists = $PlaylistsTable(this);
//   late final $ArtistsTable artists = $ArtistsTable(this);
//   late final $AlbumsTable albums = $AlbumsTable(this);
//   late final $GenresTable genres = $GenresTable(this);
//   late final $TrackGenreTable trackGenre = $TrackGenreTable(this);
//   late final $AlbumGenreTable albumGenre = $AlbumGenreTable(this);
//   late final $TrackArtistTable trackArtist = $TrackArtistTable(this);
//   late final $TrackAlbumTable trackAlbum = $TrackAlbumTable(this);
//   late final $DisclaimersTable disclaimers = $DisclaimersTable(this);
//   late final $YandexMusicAditionalTrackInfoTable yandexMusicAditionalTrackInfo =
//       $YandexMusicAditionalTrackInfoTable(this);
//   late final $YandexMusicTrackDisclaimerTable yandexMusicTrackDisclaimer =
//       $YandexMusicTrackDisclaimerTable(this);
//   late final $PlaylistTracksTable playlistTracks = $PlaylistTracksTable(this);
//   @override
//   Iterable<TableInfo<Table, Object?>> get allTables =>
//       allSchemaEntities.whereType<TableInfo<Table, Object?>>();
//   @override
//   List<DatabaseSchemaEntity> get allSchemaEntities => [
//     tracks,
//     settings,
//     playlists,
//     artists,
//     albums,
//     genres,
//     trackGenre,
//     albumGenre,
//     trackArtist,
//     trackAlbum,
//     disclaimers,
//     yandexMusicAditionalTrackInfo,
//     yandexMusicTrackDisclaimer,
//     playlistTracks,
//   ];
// }

// typedef $$TracksTableCreateCompanionBuilder =
//     TracksCompanion Function({
//       Value<int> id,
//       Value<String> title,
//       Value<String?> date,
//       Value<String?> composer,
//       Value<String?> performer,
//       Value<String?> albumArtistName,
//       Value<int?> trackNumberInAlbum,
//       Value<int?> totalTrackInAlbum,
//       Value<int?> discNumber,
//       Value<int?> totalDiscs,
//       Value<String?> comment,
//       Value<String?> externalId,
//       Value<int> durationMs,
//       Value<int> sampleRate,
//       Value<int> channels,
//       Value<int> bitsPerSample,
//       Value<int> bitrate,
//       Value<String?> codec,
//       Value<String?> encoding,
//       Value<String?> tool,
//       Value<int> listenCount,
//       Value<String?> audioMd5,
//       required String filePath,
//       Value<String> source,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//     });
// typedef $$TracksTableUpdateCompanionBuilder =
//     TracksCompanion Function({
//       Value<int> id,
//       Value<String> title,
//       Value<String?> date,
//       Value<String?> composer,
//       Value<String?> performer,
//       Value<String?> albumArtistName,
//       Value<int?> trackNumberInAlbum,
//       Value<int?> totalTrackInAlbum,
//       Value<int?> discNumber,
//       Value<int?> totalDiscs,
//       Value<String?> comment,
//       Value<String?> externalId,
//       Value<int> durationMs,
//       Value<int> sampleRate,
//       Value<int> channels,
//       Value<int> bitsPerSample,
//       Value<int> bitrate,
//       Value<String?> codec,
//       Value<String?> encoding,
//       Value<String?> tool,
//       Value<int> listenCount,
//       Value<String?> audioMd5,
//       Value<String> filePath,
//       Value<String> source,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//     });

// final class $$TracksTableReferences
//     extends BaseReferences<_$AppDatabase, $TracksTable, Track> {
//   $$TracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static MultiTypedResultKey<$SettingsTable, List<Setting>> _settingsRefsTable(
//     _$AppDatabase db,
//   ) => MultiTypedResultKey.fromTable(
//     db.settings,
//     aliasName: $_aliasNameGenerator(db.tracks.id, db.settings.lastTrack),
//   );

//   $$SettingsTableProcessedTableManager get settingsRefs {
//     final manager = $$SettingsTableTableManager(
//       $_db,
//       $_db.settings,
//     ).filter((f) => f.lastTrack.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_settingsRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<$PlaylistsTable, List<Playlist>>
//   _playlistsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.playlists,
//     aliasName: $_aliasNameGenerator(db.tracks.id, db.playlists.lastPlayedTrack),
//   );

//   $$PlaylistsTableProcessedTableManager get playlistsRefs {
//     final manager = $$PlaylistsTableTableManager(
//       $_db,
//       $_db.playlists,
//     ).filter((f) => f.lastPlayedTrack.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_playlistsRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<$TrackGenreTable, List<TrackGenreData>>
//   _trackGenreRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.trackGenre,
//     aliasName: $_aliasNameGenerator(db.tracks.id, db.trackGenre.trackId),
//   );

//   $$TrackGenreTableProcessedTableManager get trackGenreRefs {
//     final manager = $$TrackGenreTableTableManager(
//       $_db,
//       $_db.trackGenre,
//     ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_trackGenreRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<$TrackArtistTable, List<TrackArtistData>>
//   _trackArtistRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.trackArtist,
//     aliasName: $_aliasNameGenerator(db.tracks.id, db.trackArtist.trackId),
//   );

//   $$TrackArtistTableProcessedTableManager get trackArtistRefs {
//     final manager = $$TrackArtistTableTableManager(
//       $_db,
//       $_db.trackArtist,
//     ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_trackArtistRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<$TrackAlbumTable, List<TrackAlbumData>>
//   _trackAlbumRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.trackAlbum,
//     aliasName: $_aliasNameGenerator(db.tracks.id, db.trackAlbum.trackId),
//   );

//   $$TrackAlbumTableProcessedTableManager get trackAlbumRefs {
//     final manager = $$TrackAlbumTableTableManager(
//       $_db,
//       $_db.trackAlbum,
//     ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_trackAlbumRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<
//     $YandexMusicAditionalTrackInfoTable,
//     List<YandexMusicAditionalTrackInfoData>
//   >
//   _yandexMusicAditionalTrackInfoRefsTable(_$AppDatabase db) =>
//       MultiTypedResultKey.fromTable(
//         db.yandexMusicAditionalTrackInfo,
//         aliasName: $_aliasNameGenerator(
//           db.tracks.id,
//           db.yandexMusicAditionalTrackInfo.id,
//         ),
//       );

//   $$YandexMusicAditionalTrackInfoTableProcessedTableManager
//   get yandexMusicAditionalTrackInfoRefs {
//     final manager = $$YandexMusicAditionalTrackInfoTableTableManager(
//       $_db,
//       $_db.yandexMusicAditionalTrackInfo,
//     ).filter((f) => f.id.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(
//       _yandexMusicAditionalTrackInfoRefsTable($_db),
//     );
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<
//     $YandexMusicTrackDisclaimerTable,
//     List<YandexMusicTrackDisclaimerData>
//   >
//   _yandexMusicTrackDisclaimerRefsTable(_$AppDatabase db) =>
//       MultiTypedResultKey.fromTable(
//         db.yandexMusicTrackDisclaimer,
//         aliasName: $_aliasNameGenerator(
//           db.tracks.id,
//           db.yandexMusicTrackDisclaimer.trackId,
//         ),
//       );

//   $$YandexMusicTrackDisclaimerTableProcessedTableManager
//   get yandexMusicTrackDisclaimerRefs {
//     final manager = $$YandexMusicTrackDisclaimerTableTableManager(
//       $_db,
//       $_db.yandexMusicTrackDisclaimer,
//     ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(
//       _yandexMusicTrackDisclaimerRefsTable($_db),
//     );
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<$PlaylistTracksTable, List<PlaylistTrack>>
//   _playlistTracksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.playlistTracks,
//     aliasName: $_aliasNameGenerator(db.tracks.id, db.playlistTracks.trackId),
//   );

//   $$PlaylistTracksTableProcessedTableManager get playlistTracksRefs {
//     final manager = $$PlaylistTracksTableTableManager(
//       $_db,
//       $_db.playlistTracks,
//     ).filter((f) => f.trackId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_playlistTracksRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }
// }

// class $$TracksTableFilterComposer
//     extends Composer<_$AppDatabase, $TracksTable> {
//   $$TracksTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get title => $composableBuilder(
//     column: $table.title,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get date => $composableBuilder(
//     column: $table.date,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get composer => $composableBuilder(
//     column: $table.composer,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get performer => $composableBuilder(
//     column: $table.performer,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get albumArtistName => $composableBuilder(
//     column: $table.albumArtistName,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get trackNumberInAlbum => $composableBuilder(
//     column: $table.trackNumberInAlbum,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get totalTrackInAlbum => $composableBuilder(
//     column: $table.totalTrackInAlbum,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get discNumber => $composableBuilder(
//     column: $table.discNumber,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get totalDiscs => $composableBuilder(
//     column: $table.totalDiscs,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get comment => $composableBuilder(
//     column: $table.comment,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get durationMs => $composableBuilder(
//     column: $table.durationMs,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get sampleRate => $composableBuilder(
//     column: $table.sampleRate,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get channels => $composableBuilder(
//     column: $table.channels,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get bitsPerSample => $composableBuilder(
//     column: $table.bitsPerSample,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get bitrate => $composableBuilder(
//     column: $table.bitrate,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get codec => $composableBuilder(
//     column: $table.codec,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get encoding => $composableBuilder(
//     column: $table.encoding,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get tool => $composableBuilder(
//     column: $table.tool,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get listenCount => $composableBuilder(
//     column: $table.listenCount,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get audioMd5 => $composableBuilder(
//     column: $table.audioMd5,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get filePath => $composableBuilder(
//     column: $table.filePath,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get coverUrl => $composableBuilder(
//     column: $table.coverUrl,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get coverPath => $composableBuilder(
//     column: $table.coverPath,
//     builder: (column) => ColumnFilters(column),
//   );

//   Expression<bool> settingsRefs(
//     Expression<bool> Function($$SettingsTableFilterComposer f) f,
//   ) {
//     final $$SettingsTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.settings,
//       getReferencedColumn: (t) => t.lastTrack,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$SettingsTableFilterComposer(
//             $db: $db,
//             $table: $db.settings,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<bool> playlistsRefs(
//     Expression<bool> Function($$PlaylistsTableFilterComposer f) f,
//   ) {
//     final $$PlaylistsTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlists,
//       getReferencedColumn: (t) => t.lastPlayedTrack,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistsTableFilterComposer(
//             $db: $db,
//             $table: $db.playlists,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<bool> trackGenreRefs(
//     Expression<bool> Function($$TrackGenreTableFilterComposer f) f,
//   ) {
//     final $$TrackGenreTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackGenre,
//       getReferencedColumn: (t) => t.trackId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackGenreTableFilterComposer(
//             $db: $db,
//             $table: $db.trackGenre,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<bool> trackArtistRefs(
//     Expression<bool> Function($$TrackArtistTableFilterComposer f) f,
//   ) {
//     final $$TrackArtistTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackArtist,
//       getReferencedColumn: (t) => t.trackId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackArtistTableFilterComposer(
//             $db: $db,
//             $table: $db.trackArtist,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<bool> trackAlbumRefs(
//     Expression<bool> Function($$TrackAlbumTableFilterComposer f) f,
//   ) {
//     final $$TrackAlbumTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackAlbum,
//       getReferencedColumn: (t) => t.trackId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackAlbumTableFilterComposer(
//             $db: $db,
//             $table: $db.trackAlbum,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<bool> yandexMusicAditionalTrackInfoRefs(
//     Expression<bool> Function(
//       $$YandexMusicAditionalTrackInfoTableFilterComposer f,
//     )
//     f,
//   ) {
//     final $$YandexMusicAditionalTrackInfoTableFilterComposer composer =
//         $composerBuilder(
//           composer: this,
//           getCurrentColumn: (t) => t.id,
//           referencedTable: $db.yandexMusicAditionalTrackInfo,
//           getReferencedColumn: (t) => t.id,
//           builder:
//               (
//                 joinBuilder, {
//                 $addJoinBuilderToRootComposer,
//                 $removeJoinBuilderFromRootComposer,
//               }) => $$YandexMusicAditionalTrackInfoTableFilterComposer(
//                 $db: $db,
//                 $table: $db.yandexMusicAditionalTrackInfo,
//                 $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//                 joinBuilder: joinBuilder,
//                 $removeJoinBuilderFromRootComposer:
//                     $removeJoinBuilderFromRootComposer,
//               ),
//         );
//     return f(composer);
//   }

//   Expression<bool> yandexMusicTrackDisclaimerRefs(
//     Expression<bool> Function($$YandexMusicTrackDisclaimerTableFilterComposer f)
//     f,
//   ) {
//     final $$YandexMusicTrackDisclaimerTableFilterComposer composer =
//         $composerBuilder(
//           composer: this,
//           getCurrentColumn: (t) => t.id,
//           referencedTable: $db.yandexMusicTrackDisclaimer,
//           getReferencedColumn: (t) => t.trackId,
//           builder:
//               (
//                 joinBuilder, {
//                 $addJoinBuilderToRootComposer,
//                 $removeJoinBuilderFromRootComposer,
//               }) => $$YandexMusicTrackDisclaimerTableFilterComposer(
//                 $db: $db,
//                 $table: $db.yandexMusicTrackDisclaimer,
//                 $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//                 joinBuilder: joinBuilder,
//                 $removeJoinBuilderFromRootComposer:
//                     $removeJoinBuilderFromRootComposer,
//               ),
//         );
//     return f(composer);
//   }

//   Expression<bool> playlistTracksRefs(
//     Expression<bool> Function($$PlaylistTracksTableFilterComposer f) f,
//   ) {
//     final $$PlaylistTracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlistTracks,
//       getReferencedColumn: (t) => t.trackId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistTracksTableFilterComposer(
//             $db: $db,
//             $table: $db.playlistTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$TracksTableOrderingComposer
//     extends Composer<_$AppDatabase, $TracksTable> {
//   $$TracksTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get title => $composableBuilder(
//     column: $table.title,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get date => $composableBuilder(
//     column: $table.date,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get composer => $composableBuilder(
//     column: $table.composer,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get performer => $composableBuilder(
//     column: $table.performer,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get albumArtistName => $composableBuilder(
//     column: $table.albumArtistName,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get trackNumberInAlbum => $composableBuilder(
//     column: $table.trackNumberInAlbum,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get totalTrackInAlbum => $composableBuilder(
//     column: $table.totalTrackInAlbum,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get discNumber => $composableBuilder(
//     column: $table.discNumber,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get totalDiscs => $composableBuilder(
//     column: $table.totalDiscs,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get comment => $composableBuilder(
//     column: $table.comment,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get durationMs => $composableBuilder(
//     column: $table.durationMs,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get sampleRate => $composableBuilder(
//     column: $table.sampleRate,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get channels => $composableBuilder(
//     column: $table.channels,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get bitsPerSample => $composableBuilder(
//     column: $table.bitsPerSample,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get bitrate => $composableBuilder(
//     column: $table.bitrate,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get codec => $composableBuilder(
//     column: $table.codec,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get encoding => $composableBuilder(
//     column: $table.encoding,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get tool => $composableBuilder(
//     column: $table.tool,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get listenCount => $composableBuilder(
//     column: $table.listenCount,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get audioMd5 => $composableBuilder(
//     column: $table.audioMd5,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get filePath => $composableBuilder(
//     column: $table.filePath,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get coverUrl => $composableBuilder(
//     column: $table.coverUrl,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get coverPath => $composableBuilder(
//     column: $table.coverPath,
//     builder: (column) => ColumnOrderings(column),
//   );
// }

// class $$TracksTableAnnotationComposer
//     extends Composer<_$AppDatabase, $TracksTable> {
//   $$TracksTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get id =>
//       $composableBuilder(column: $table.id, builder: (column) => column);

//   GeneratedColumn<String> get title =>
//       $composableBuilder(column: $table.title, builder: (column) => column);

//   GeneratedColumn<String> get date =>
//       $composableBuilder(column: $table.date, builder: (column) => column);

//   GeneratedColumn<String> get composer =>
//       $composableBuilder(column: $table.composer, builder: (column) => column);

//   GeneratedColumn<String> get performer =>
//       $composableBuilder(column: $table.performer, builder: (column) => column);

//   GeneratedColumn<String> get albumArtistName => $composableBuilder(
//     column: $table.albumArtistName,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get trackNumberInAlbum => $composableBuilder(
//     column: $table.trackNumberInAlbum,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get totalTrackInAlbum => $composableBuilder(
//     column: $table.totalTrackInAlbum,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get discNumber => $composableBuilder(
//     column: $table.discNumber,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get totalDiscs => $composableBuilder(
//     column: $table.totalDiscs,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get comment =>
//       $composableBuilder(column: $table.comment, builder: (column) => column);

//   GeneratedColumn<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get durationMs => $composableBuilder(
//     column: $table.durationMs,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get sampleRate => $composableBuilder(
//     column: $table.sampleRate,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get channels =>
//       $composableBuilder(column: $table.channels, builder: (column) => column);

//   GeneratedColumn<int> get bitsPerSample => $composableBuilder(
//     column: $table.bitsPerSample,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get bitrate =>
//       $composableBuilder(column: $table.bitrate, builder: (column) => column);

//   GeneratedColumn<String> get codec =>
//       $composableBuilder(column: $table.codec, builder: (column) => column);

//   GeneratedColumn<String> get encoding =>
//       $composableBuilder(column: $table.encoding, builder: (column) => column);

//   GeneratedColumn<String> get tool =>
//       $composableBuilder(column: $table.tool, builder: (column) => column);

//   GeneratedColumn<int> get listenCount => $composableBuilder(
//     column: $table.listenCount,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get audioMd5 =>
//       $composableBuilder(column: $table.audioMd5, builder: (column) => column);

//   GeneratedColumn<String> get filePath =>
//       $composableBuilder(column: $table.filePath, builder: (column) => column);

//   GeneratedColumn<String> get source =>
//       $composableBuilder(column: $table.source, builder: (column) => column);

//   GeneratedColumn<String> get coverUrl =>
//       $composableBuilder(column: $table.coverUrl, builder: (column) => column);

//   GeneratedColumn<String> get coverPath =>
//       $composableBuilder(column: $table.coverPath, builder: (column) => column);

//   Expression<T> settingsRefs<T extends Object>(
//     Expression<T> Function($$SettingsTableAnnotationComposer a) f,
//   ) {
//     final $$SettingsTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.settings,
//       getReferencedColumn: (t) => t.lastTrack,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$SettingsTableAnnotationComposer(
//             $db: $db,
//             $table: $db.settings,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<T> playlistsRefs<T extends Object>(
//     Expression<T> Function($$PlaylistsTableAnnotationComposer a) f,
//   ) {
//     final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlists,
//       getReferencedColumn: (t) => t.lastPlayedTrack,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistsTableAnnotationComposer(
//             $db: $db,
//             $table: $db.playlists,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<T> trackGenreRefs<T extends Object>(
//     Expression<T> Function($$TrackGenreTableAnnotationComposer a) f,
//   ) {
//     final $$TrackGenreTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackGenre,
//       getReferencedColumn: (t) => t.trackId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackGenreTableAnnotationComposer(
//             $db: $db,
//             $table: $db.trackGenre,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<T> trackArtistRefs<T extends Object>(
//     Expression<T> Function($$TrackArtistTableAnnotationComposer a) f,
//   ) {
//     final $$TrackArtistTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackArtist,
//       getReferencedColumn: (t) => t.trackId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackArtistTableAnnotationComposer(
//             $db: $db,
//             $table: $db.trackArtist,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<T> trackAlbumRefs<T extends Object>(
//     Expression<T> Function($$TrackAlbumTableAnnotationComposer a) f,
//   ) {
//     final $$TrackAlbumTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackAlbum,
//       getReferencedColumn: (t) => t.trackId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackAlbumTableAnnotationComposer(
//             $db: $db,
//             $table: $db.trackAlbum,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<T> yandexMusicAditionalTrackInfoRefs<T extends Object>(
//     Expression<T> Function(
//       $$YandexMusicAditionalTrackInfoTableAnnotationComposer a,
//     )
//     f,
//   ) {
//     final $$YandexMusicAditionalTrackInfoTableAnnotationComposer composer =
//         $composerBuilder(
//           composer: this,
//           getCurrentColumn: (t) => t.id,
//           referencedTable: $db.yandexMusicAditionalTrackInfo,
//           getReferencedColumn: (t) => t.id,
//           builder:
//               (
//                 joinBuilder, {
//                 $addJoinBuilderToRootComposer,
//                 $removeJoinBuilderFromRootComposer,
//               }) => $$YandexMusicAditionalTrackInfoTableAnnotationComposer(
//                 $db: $db,
//                 $table: $db.yandexMusicAditionalTrackInfo,
//                 $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//                 joinBuilder: joinBuilder,
//                 $removeJoinBuilderFromRootComposer:
//                     $removeJoinBuilderFromRootComposer,
//               ),
//         );
//     return f(composer);
//   }

//   Expression<T> yandexMusicTrackDisclaimerRefs<T extends Object>(
//     Expression<T> Function(
//       $$YandexMusicTrackDisclaimerTableAnnotationComposer a,
//     )
//     f,
//   ) {
//     final $$YandexMusicTrackDisclaimerTableAnnotationComposer composer =
//         $composerBuilder(
//           composer: this,
//           getCurrentColumn: (t) => t.id,
//           referencedTable: $db.yandexMusicTrackDisclaimer,
//           getReferencedColumn: (t) => t.trackId,
//           builder:
//               (
//                 joinBuilder, {
//                 $addJoinBuilderToRootComposer,
//                 $removeJoinBuilderFromRootComposer,
//               }) => $$YandexMusicTrackDisclaimerTableAnnotationComposer(
//                 $db: $db,
//                 $table: $db.yandexMusicTrackDisclaimer,
//                 $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//                 joinBuilder: joinBuilder,
//                 $removeJoinBuilderFromRootComposer:
//                     $removeJoinBuilderFromRootComposer,
//               ),
//         );
//     return f(composer);
//   }

//   Expression<T> playlistTracksRefs<T extends Object>(
//     Expression<T> Function($$PlaylistTracksTableAnnotationComposer a) f,
//   ) {
//     final $$PlaylistTracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlistTracks,
//       getReferencedColumn: (t) => t.trackId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistTracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.playlistTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$TracksTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $TracksTable,
//           Track,
//           $$TracksTableFilterComposer,
//           $$TracksTableOrderingComposer,
//           $$TracksTableAnnotationComposer,
//           $$TracksTableCreateCompanionBuilder,
//           $$TracksTableUpdateCompanionBuilder,
//           (Track, $$TracksTableReferences),
//           Track,
//           PrefetchHooks Function({
//             bool settingsRefs,
//             bool playlistsRefs,
//             bool trackGenreRefs,
//             bool trackArtistRefs,
//             bool trackAlbumRefs,
//             bool yandexMusicAditionalTrackInfoRefs,
//             bool yandexMusicTrackDisclaimerRefs,
//             bool playlistTracksRefs,
//           })
//         > {
//   $$TracksTableTableManager(_$AppDatabase db, $TracksTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$TracksTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$TracksTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$TracksTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String> title = const Value.absent(),
//                 Value<String?> date = const Value.absent(),
//                 Value<String?> composer = const Value.absent(),
//                 Value<String?> performer = const Value.absent(),
//                 Value<String?> albumArtistName = const Value.absent(),
//                 Value<int?> trackNumberInAlbum = const Value.absent(),
//                 Value<int?> totalTrackInAlbum = const Value.absent(),
//                 Value<int?> discNumber = const Value.absent(),
//                 Value<int?> totalDiscs = const Value.absent(),
//                 Value<String?> comment = const Value.absent(),
//                 Value<String?> externalId = const Value.absent(),
//                 Value<int> durationMs = const Value.absent(),
//                 Value<int> sampleRate = const Value.absent(),
//                 Value<int> channels = const Value.absent(),
//                 Value<int> bitsPerSample = const Value.absent(),
//                 Value<int> bitrate = const Value.absent(),
//                 Value<String?> codec = const Value.absent(),
//                 Value<String?> encoding = const Value.absent(),
//                 Value<String?> tool = const Value.absent(),
//                 Value<int> listenCount = const Value.absent(),
//                 Value<String?> audioMd5 = const Value.absent(),
//                 Value<String> filePath = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//               }) => TracksCompanion(
//                 id: id,
//                 title: title,
//                 date: date,
//                 composer: composer,
//                 performer: performer,
//                 albumArtistName: albumArtistName,
//                 trackNumberInAlbum: trackNumberInAlbum,
//                 totalTrackInAlbum: totalTrackInAlbum,
//                 discNumber: discNumber,
//                 totalDiscs: totalDiscs,
//                 comment: comment,
//                 externalId: externalId,
//                 durationMs: durationMs,
//                 sampleRate: sampleRate,
//                 channels: channels,
//                 bitsPerSample: bitsPerSample,
//                 bitrate: bitrate,
//                 codec: codec,
//                 encoding: encoding,
//                 tool: tool,
//                 listenCount: listenCount,
//                 audioMd5: audioMd5,
//                 filePath: filePath,
//                 source: source,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//               ),
//           createCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String> title = const Value.absent(),
//                 Value<String?> date = const Value.absent(),
//                 Value<String?> composer = const Value.absent(),
//                 Value<String?> performer = const Value.absent(),
//                 Value<String?> albumArtistName = const Value.absent(),
//                 Value<int?> trackNumberInAlbum = const Value.absent(),
//                 Value<int?> totalTrackInAlbum = const Value.absent(),
//                 Value<int?> discNumber = const Value.absent(),
//                 Value<int?> totalDiscs = const Value.absent(),
//                 Value<String?> comment = const Value.absent(),
//                 Value<String?> externalId = const Value.absent(),
//                 Value<int> durationMs = const Value.absent(),
//                 Value<int> sampleRate = const Value.absent(),
//                 Value<int> channels = const Value.absent(),
//                 Value<int> bitsPerSample = const Value.absent(),
//                 Value<int> bitrate = const Value.absent(),
//                 Value<String?> codec = const Value.absent(),
//                 Value<String?> encoding = const Value.absent(),
//                 Value<String?> tool = const Value.absent(),
//                 Value<int> listenCount = const Value.absent(),
//                 Value<String?> audioMd5 = const Value.absent(),
//                 required String filePath,
//                 Value<String> source = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//               }) => TracksCompanion.insert(
//                 id: id,
//                 title: title,
//                 date: date,
//                 composer: composer,
//                 performer: performer,
//                 albumArtistName: albumArtistName,
//                 trackNumberInAlbum: trackNumberInAlbum,
//                 totalTrackInAlbum: totalTrackInAlbum,
//                 discNumber: discNumber,
//                 totalDiscs: totalDiscs,
//                 comment: comment,
//                 externalId: externalId,
//                 durationMs: durationMs,
//                 sampleRate: sampleRate,
//                 channels: channels,
//                 bitsPerSample: bitsPerSample,
//                 bitrate: bitrate,
//                 codec: codec,
//                 encoding: encoding,
//                 tool: tool,
//                 listenCount: listenCount,
//                 audioMd5: audioMd5,
//                 filePath: filePath,
//                 source: source,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) =>
//                     (e.readTable(table), $$TracksTableReferences(db, table, e)),
//               )
//               .toList(),
//           prefetchHooksCallback:
//               ({
//                 settingsRefs = false,
//                 playlistsRefs = false,
//                 trackGenreRefs = false,
//                 trackArtistRefs = false,
//                 trackAlbumRefs = false,
//                 yandexMusicAditionalTrackInfoRefs = false,
//                 yandexMusicTrackDisclaimerRefs = false,
//                 playlistTracksRefs = false,
//               }) {
//                 return PrefetchHooks(
//                   db: db,
//                   explicitlyWatchedTables: [
//                     if (settingsRefs) db.settings,
//                     if (playlistsRefs) db.playlists,
//                     if (trackGenreRefs) db.trackGenre,
//                     if (trackArtistRefs) db.trackArtist,
//                     if (trackAlbumRefs) db.trackAlbum,
//                     if (yandexMusicAditionalTrackInfoRefs)
//                       db.yandexMusicAditionalTrackInfo,
//                     if (yandexMusicTrackDisclaimerRefs)
//                       db.yandexMusicTrackDisclaimer,
//                     if (playlistTracksRefs) db.playlistTracks,
//                   ],
//                   addJoins: null,
//                   getPrefetchedDataCallback: (items) async {
//                     return [
//                       if (settingsRefs)
//                         await $_getPrefetchedData<Track, $TracksTable, Setting>(
//                           currentTable: table,
//                           referencedTable: $$TracksTableReferences
//                               ._settingsRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$TracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).settingsRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.lastTrack == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (playlistsRefs)
//                         await $_getPrefetchedData<
//                           Track,
//                           $TracksTable,
//                           Playlist
//                         >(
//                           currentTable: table,
//                           referencedTable: $$TracksTableReferences
//                               ._playlistsRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$TracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).playlistsRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.lastPlayedTrack == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (trackGenreRefs)
//                         await $_getPrefetchedData<
//                           Track,
//                           $TracksTable,
//                           TrackGenreData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$TracksTableReferences
//                               ._trackGenreRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$TracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).trackGenreRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.trackId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (trackArtistRefs)
//                         await $_getPrefetchedData<
//                           Track,
//                           $TracksTable,
//                           TrackArtistData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$TracksTableReferences
//                               ._trackArtistRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$TracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).trackArtistRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.trackId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (trackAlbumRefs)
//                         await $_getPrefetchedData<
//                           Track,
//                           $TracksTable,
//                           TrackAlbumData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$TracksTableReferences
//                               ._trackAlbumRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$TracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).trackAlbumRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.trackId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (yandexMusicAditionalTrackInfoRefs)
//                         await $_getPrefetchedData<
//                           Track,
//                           $TracksTable,
//                           YandexMusicAditionalTrackInfoData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$TracksTableReferences
//                               ._yandexMusicAditionalTrackInfoRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$TracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).yandexMusicAditionalTrackInfoRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) =>
//                                   referencedItems.where((e) => e.id == item.id),
//                           typedResults: items,
//                         ),
//                       if (yandexMusicTrackDisclaimerRefs)
//                         await $_getPrefetchedData<
//                           Track,
//                           $TracksTable,
//                           YandexMusicTrackDisclaimerData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$TracksTableReferences
//                               ._yandexMusicTrackDisclaimerRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$TracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).yandexMusicTrackDisclaimerRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.trackId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (playlistTracksRefs)
//                         await $_getPrefetchedData<
//                           Track,
//                           $TracksTable,
//                           PlaylistTrack
//                         >(
//                           currentTable: table,
//                           referencedTable: $$TracksTableReferences
//                               ._playlistTracksRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$TracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).playlistTracksRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.trackId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                     ];
//                   },
//                 );
//               },
//         ),
//       );
// }

// typedef $$TracksTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $TracksTable,
//       Track,
//       $$TracksTableFilterComposer,
//       $$TracksTableOrderingComposer,
//       $$TracksTableAnnotationComposer,
//       $$TracksTableCreateCompanionBuilder,
//       $$TracksTableUpdateCompanionBuilder,
//       (Track, $$TracksTableReferences),
//       Track,
//       PrefetchHooks Function({
//         bool settingsRefs,
//         bool playlistsRefs,
//         bool trackGenreRefs,
//         bool trackArtistRefs,
//         bool trackAlbumRefs,
//         bool yandexMusicAditionalTrackInfoRefs,
//         bool yandexMusicTrackDisclaimerRefs,
//         bool playlistTracksRefs,
//       })
//     >;
// typedef $$SettingsTableCreateCompanionBuilder =
//     SettingsCompanion Function({
//       required int id,
//       Value<double> volume,
//       Value<bool> indicatorState,
//       Value<bool> albumArtAsBackground,
//       Value<bool> smartShuffle,
//       Value<bool> adwaitaTheme,
//       Value<bool> transparentMode,
//       Value<bool> windowManager,
//       Value<bool> logListenedTracks,
//       Value<bool> openPlaylistAtStart,
//       Value<String?> yandexMusicAccountToken,
//       Value<String?> yandexMusicAccountEmail,
//       Value<String?> yandexMusicAccountLogin,
//       Value<String?> yandexMusicAccountName,
//       Value<String?> yandexMusicAccountUid,
//       Value<String?> yandexMusicAccountFullname,
//       Value<String?> yandexMusicDownloadQuality,
//       Value<bool> yandexMusicPreloadAtStart,
//       Value<int?> lastTrack,
//       Value<int> rowid,
//     });
// typedef $$SettingsTableUpdateCompanionBuilder =
//     SettingsCompanion Function({
//       Value<int> id,
//       Value<double> volume,
//       Value<bool> indicatorState,
//       Value<bool> albumArtAsBackground,
//       Value<bool> smartShuffle,
//       Value<bool> adwaitaTheme,
//       Value<bool> transparentMode,
//       Value<bool> windowManager,
//       Value<bool> logListenedTracks,
//       Value<bool> openPlaylistAtStart,
//       Value<String?> yandexMusicAccountToken,
//       Value<String?> yandexMusicAccountEmail,
//       Value<String?> yandexMusicAccountLogin,
//       Value<String?> yandexMusicAccountName,
//       Value<String?> yandexMusicAccountUid,
//       Value<String?> yandexMusicAccountFullname,
//       Value<String?> yandexMusicDownloadQuality,
//       Value<bool> yandexMusicPreloadAtStart,
//       Value<int?> lastTrack,
//       Value<int> rowid,
//     });

// final class $$SettingsTableReferences
//     extends BaseReferences<_$AppDatabase, $SettingsTable, Setting> {
//   $$SettingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static $TracksTable _lastTrackTable(_$AppDatabase db) => db.tracks
//       .createAlias($_aliasNameGenerator(db.settings.lastTrack, db.tracks.id));

//   $$TracksTableProcessedTableManager? get lastTrack {
//     final $_column = $_itemColumn<int>('last_track');
//     if ($_column == null) return null;
//     final manager = $$TracksTableTableManager(
//       $_db,
//       $_db.tracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_lastTrackTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$SettingsTableFilterComposer
//     extends Composer<_$AppDatabase, $SettingsTable> {
//   $$SettingsTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<double> get volume => $composableBuilder(
//     column: $table.volume,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get indicatorState => $composableBuilder(
//     column: $table.indicatorState,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get albumArtAsBackground => $composableBuilder(
//     column: $table.albumArtAsBackground,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get smartShuffle => $composableBuilder(
//     column: $table.smartShuffle,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get adwaitaTheme => $composableBuilder(
//     column: $table.adwaitaTheme,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get transparentMode => $composableBuilder(
//     column: $table.transparentMode,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get windowManager => $composableBuilder(
//     column: $table.windowManager,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get logListenedTracks => $composableBuilder(
//     column: $table.logListenedTracks,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get openPlaylistAtStart => $composableBuilder(
//     column: $table.openPlaylistAtStart,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get yandexMusicAccountToken => $composableBuilder(
//     column: $table.yandexMusicAccountToken,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get yandexMusicAccountEmail => $composableBuilder(
//     column: $table.yandexMusicAccountEmail,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get yandexMusicAccountLogin => $composableBuilder(
//     column: $table.yandexMusicAccountLogin,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get yandexMusicAccountName => $composableBuilder(
//     column: $table.yandexMusicAccountName,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get yandexMusicAccountUid => $composableBuilder(
//     column: $table.yandexMusicAccountUid,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get yandexMusicAccountFullname => $composableBuilder(
//     column: $table.yandexMusicAccountFullname,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get yandexMusicDownloadQuality => $composableBuilder(
//     column: $table.yandexMusicDownloadQuality,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get yandexMusicPreloadAtStart => $composableBuilder(
//     column: $table.yandexMusicPreloadAtStart,
//     builder: (column) => ColumnFilters(column),
//   );

//   $$TracksTableFilterComposer get lastTrack {
//     final $$TracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.lastTrack,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableFilterComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$SettingsTableOrderingComposer
//     extends Composer<_$AppDatabase, $SettingsTable> {
//   $$SettingsTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<double> get volume => $composableBuilder(
//     column: $table.volume,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get indicatorState => $composableBuilder(
//     column: $table.indicatorState,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get albumArtAsBackground => $composableBuilder(
//     column: $table.albumArtAsBackground,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get smartShuffle => $composableBuilder(
//     column: $table.smartShuffle,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get adwaitaTheme => $composableBuilder(
//     column: $table.adwaitaTheme,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get transparentMode => $composableBuilder(
//     column: $table.transparentMode,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get windowManager => $composableBuilder(
//     column: $table.windowManager,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get logListenedTracks => $composableBuilder(
//     column: $table.logListenedTracks,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get openPlaylistAtStart => $composableBuilder(
//     column: $table.openPlaylistAtStart,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get yandexMusicAccountToken => $composableBuilder(
//     column: $table.yandexMusicAccountToken,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get yandexMusicAccountEmail => $composableBuilder(
//     column: $table.yandexMusicAccountEmail,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get yandexMusicAccountLogin => $composableBuilder(
//     column: $table.yandexMusicAccountLogin,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get yandexMusicAccountName => $composableBuilder(
//     column: $table.yandexMusicAccountName,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get yandexMusicAccountUid => $composableBuilder(
//     column: $table.yandexMusicAccountUid,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get yandexMusicAccountFullname => $composableBuilder(
//     column: $table.yandexMusicAccountFullname,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get yandexMusicDownloadQuality => $composableBuilder(
//     column: $table.yandexMusicDownloadQuality,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get yandexMusicPreloadAtStart => $composableBuilder(
//     column: $table.yandexMusicPreloadAtStart,
//     builder: (column) => ColumnOrderings(column),
//   );

//   $$TracksTableOrderingComposer get lastTrack {
//     final $$TracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.lastTrack,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$SettingsTableAnnotationComposer
//     extends Composer<_$AppDatabase, $SettingsTable> {
//   $$SettingsTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get id =>
//       $composableBuilder(column: $table.id, builder: (column) => column);

//   GeneratedColumn<double> get volume =>
//       $composableBuilder(column: $table.volume, builder: (column) => column);

//   GeneratedColumn<bool> get indicatorState => $composableBuilder(
//     column: $table.indicatorState,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get albumArtAsBackground => $composableBuilder(
//     column: $table.albumArtAsBackground,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get smartShuffle => $composableBuilder(
//     column: $table.smartShuffle,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get adwaitaTheme => $composableBuilder(
//     column: $table.adwaitaTheme,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get transparentMode => $composableBuilder(
//     column: $table.transparentMode,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get windowManager => $composableBuilder(
//     column: $table.windowManager,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get logListenedTracks => $composableBuilder(
//     column: $table.logListenedTracks,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get openPlaylistAtStart => $composableBuilder(
//     column: $table.openPlaylistAtStart,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get yandexMusicAccountToken => $composableBuilder(
//     column: $table.yandexMusicAccountToken,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get yandexMusicAccountEmail => $composableBuilder(
//     column: $table.yandexMusicAccountEmail,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get yandexMusicAccountLogin => $composableBuilder(
//     column: $table.yandexMusicAccountLogin,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get yandexMusicAccountName => $composableBuilder(
//     column: $table.yandexMusicAccountName,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get yandexMusicAccountUid => $composableBuilder(
//     column: $table.yandexMusicAccountUid,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get yandexMusicAccountFullname => $composableBuilder(
//     column: $table.yandexMusicAccountFullname,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get yandexMusicDownloadQuality => $composableBuilder(
//     column: $table.yandexMusicDownloadQuality,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get yandexMusicPreloadAtStart => $composableBuilder(
//     column: $table.yandexMusicPreloadAtStart,
//     builder: (column) => column,
//   );

//   $$TracksTableAnnotationComposer get lastTrack {
//     final $$TracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.lastTrack,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$SettingsTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $SettingsTable,
//           Setting,
//           $$SettingsTableFilterComposer,
//           $$SettingsTableOrderingComposer,
//           $$SettingsTableAnnotationComposer,
//           $$SettingsTableCreateCompanionBuilder,
//           $$SettingsTableUpdateCompanionBuilder,
//           (Setting, $$SettingsTableReferences),
//           Setting,
//           PrefetchHooks Function({bool lastTrack})
//         > {
//   $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$SettingsTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$SettingsTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$SettingsTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<double> volume = const Value.absent(),
//                 Value<bool> indicatorState = const Value.absent(),
//                 Value<bool> albumArtAsBackground = const Value.absent(),
//                 Value<bool> smartShuffle = const Value.absent(),
//                 Value<bool> adwaitaTheme = const Value.absent(),
//                 Value<bool> transparentMode = const Value.absent(),
//                 Value<bool> windowManager = const Value.absent(),
//                 Value<bool> logListenedTracks = const Value.absent(),
//                 Value<bool> openPlaylistAtStart = const Value.absent(),
//                 Value<String?> yandexMusicAccountToken = const Value.absent(),
//                 Value<String?> yandexMusicAccountEmail = const Value.absent(),
//                 Value<String?> yandexMusicAccountLogin = const Value.absent(),
//                 Value<String?> yandexMusicAccountName = const Value.absent(),
//                 Value<String?> yandexMusicAccountUid = const Value.absent(),
//                 Value<String?> yandexMusicAccountFullname =
//                     const Value.absent(),
//                 Value<String?> yandexMusicDownloadQuality =
//                     const Value.absent(),
//                 Value<bool> yandexMusicPreloadAtStart = const Value.absent(),
//                 Value<int?> lastTrack = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => SettingsCompanion(
//                 id: id,
//                 volume: volume,
//                 indicatorState: indicatorState,
//                 albumArtAsBackground: albumArtAsBackground,
//                 smartShuffle: smartShuffle,
//                 adwaitaTheme: adwaitaTheme,
//                 transparentMode: transparentMode,
//                 windowManager: windowManager,
//                 logListenedTracks: logListenedTracks,
//                 openPlaylistAtStart: openPlaylistAtStart,
//                 yandexMusicAccountToken: yandexMusicAccountToken,
//                 yandexMusicAccountEmail: yandexMusicAccountEmail,
//                 yandexMusicAccountLogin: yandexMusicAccountLogin,
//                 yandexMusicAccountName: yandexMusicAccountName,
//                 yandexMusicAccountUid: yandexMusicAccountUid,
//                 yandexMusicAccountFullname: yandexMusicAccountFullname,
//                 yandexMusicDownloadQuality: yandexMusicDownloadQuality,
//                 yandexMusicPreloadAtStart: yandexMusicPreloadAtStart,
//                 lastTrack: lastTrack,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int id,
//                 Value<double> volume = const Value.absent(),
//                 Value<bool> indicatorState = const Value.absent(),
//                 Value<bool> albumArtAsBackground = const Value.absent(),
//                 Value<bool> smartShuffle = const Value.absent(),
//                 Value<bool> adwaitaTheme = const Value.absent(),
//                 Value<bool> transparentMode = const Value.absent(),
//                 Value<bool> windowManager = const Value.absent(),
//                 Value<bool> logListenedTracks = const Value.absent(),
//                 Value<bool> openPlaylistAtStart = const Value.absent(),
//                 Value<String?> yandexMusicAccountToken = const Value.absent(),
//                 Value<String?> yandexMusicAccountEmail = const Value.absent(),
//                 Value<String?> yandexMusicAccountLogin = const Value.absent(),
//                 Value<String?> yandexMusicAccountName = const Value.absent(),
//                 Value<String?> yandexMusicAccountUid = const Value.absent(),
//                 Value<String?> yandexMusicAccountFullname =
//                     const Value.absent(),
//                 Value<String?> yandexMusicDownloadQuality =
//                     const Value.absent(),
//                 Value<bool> yandexMusicPreloadAtStart = const Value.absent(),
//                 Value<int?> lastTrack = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => SettingsCompanion.insert(
//                 id: id,
//                 volume: volume,
//                 indicatorState: indicatorState,
//                 albumArtAsBackground: albumArtAsBackground,
//                 smartShuffle: smartShuffle,
//                 adwaitaTheme: adwaitaTheme,
//                 transparentMode: transparentMode,
//                 windowManager: windowManager,
//                 logListenedTracks: logListenedTracks,
//                 openPlaylistAtStart: openPlaylistAtStart,
//                 yandexMusicAccountToken: yandexMusicAccountToken,
//                 yandexMusicAccountEmail: yandexMusicAccountEmail,
//                 yandexMusicAccountLogin: yandexMusicAccountLogin,
//                 yandexMusicAccountName: yandexMusicAccountName,
//                 yandexMusicAccountUid: yandexMusicAccountUid,
//                 yandexMusicAccountFullname: yandexMusicAccountFullname,
//                 yandexMusicDownloadQuality: yandexMusicDownloadQuality,
//                 yandexMusicPreloadAtStart: yandexMusicPreloadAtStart,
//                 lastTrack: lastTrack,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$SettingsTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({lastTrack = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [],
//               addJoins:
//                   <
//                     T extends TableManagerState<
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic
//                     >
//                   >(state) {
//                     if (lastTrack) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.lastTrack,
//                                 referencedTable: $$SettingsTableReferences
//                                     ._lastTrackTable(db),
//                                 referencedColumn: $$SettingsTableReferences
//                                     ._lastTrackTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }

//                     return state;
//                   },
//               getPrefetchedDataCallback: (items) async {
//                 return [];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$SettingsTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $SettingsTable,
//       Setting,
//       $$SettingsTableFilterComposer,
//       $$SettingsTableOrderingComposer,
//       $$SettingsTableAnnotationComposer,
//       $$SettingsTableCreateCompanionBuilder,
//       $$SettingsTableUpdateCompanionBuilder,
//       (Setting, $$SettingsTableReferences),
//       Setting,
//       PrefetchHooks Function({bool lastTrack})
//     >;
// typedef $$PlaylistsTableCreateCompanionBuilder =
//     PlaylistsCompanion Function({
//       Value<int> id,
//       Value<String?> externalId,
//       Value<String?> externalId2,
//       Value<String> title,
//       Value<int> trackCount,
//       Value<String> source,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<String?> description,
//       Value<String?> owner,
//       Value<int> listenCount,
//       Value<int?> lastPlayedTrack,
//       Value<int> durationMs,
//     });
// typedef $$PlaylistsTableUpdateCompanionBuilder =
//     PlaylistsCompanion Function({
//       Value<int> id,
//       Value<String?> externalId,
//       Value<String?> externalId2,
//       Value<String> title,
//       Value<int> trackCount,
//       Value<String> source,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<String?> description,
//       Value<String?> owner,
//       Value<int> listenCount,
//       Value<int?> lastPlayedTrack,
//       Value<int> durationMs,
//     });

// final class $$PlaylistsTableReferences
//     extends BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist> {
//   $$PlaylistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static $TracksTable _lastPlayedTrackTable(_$AppDatabase db) =>
//       db.tracks.createAlias(
//         $_aliasNameGenerator(db.playlists.lastPlayedTrack, db.tracks.id),
//       );

//   $$TracksTableProcessedTableManager? get lastPlayedTrack {
//     final $_column = $_itemColumn<int>('last_played_track');
//     if ($_column == null) return null;
//     final manager = $$TracksTableTableManager(
//       $_db,
//       $_db.tracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_lastPlayedTrackTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }

//   static MultiTypedResultKey<$PlaylistTracksTable, List<PlaylistTrack>>
//   _playlistTracksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.playlistTracks,
//     aliasName: $_aliasNameGenerator(
//       db.playlists.id,
//       db.playlistTracks.playlistId,
//     ),
//   );

//   $$PlaylistTracksTableProcessedTableManager get playlistTracksRefs {
//     final manager = $$PlaylistTracksTableTableManager(
//       $_db,
//       $_db.playlistTracks,
//     ).filter((f) => f.playlistId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_playlistTracksRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }
// }

// class $$PlaylistsTableFilterComposer
//     extends Composer<_$AppDatabase, $PlaylistsTable> {
//   $$PlaylistsTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get externalId2 => $composableBuilder(
//     column: $table.externalId2,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get title => $composableBuilder(
//     column: $table.title,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get trackCount => $composableBuilder(
//     column: $table.trackCount,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get coverUrl => $composableBuilder(
//     column: $table.coverUrl,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get coverPath => $composableBuilder(
//     column: $table.coverPath,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get description => $composableBuilder(
//     column: $table.description,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get owner => $composableBuilder(
//     column: $table.owner,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get listenCount => $composableBuilder(
//     column: $table.listenCount,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get durationMs => $composableBuilder(
//     column: $table.durationMs,
//     builder: (column) => ColumnFilters(column),
//   );

//   $$TracksTableFilterComposer get lastPlayedTrack {
//     final $$TracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.lastPlayedTrack,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableFilterComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   Expression<bool> playlistTracksRefs(
//     Expression<bool> Function($$PlaylistTracksTableFilterComposer f) f,
//   ) {
//     final $$PlaylistTracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlistTracks,
//       getReferencedColumn: (t) => t.playlistId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistTracksTableFilterComposer(
//             $db: $db,
//             $table: $db.playlistTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$PlaylistsTableOrderingComposer
//     extends Composer<_$AppDatabase, $PlaylistsTable> {
//   $$PlaylistsTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get externalId2 => $composableBuilder(
//     column: $table.externalId2,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get title => $composableBuilder(
//     column: $table.title,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get trackCount => $composableBuilder(
//     column: $table.trackCount,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get coverUrl => $composableBuilder(
//     column: $table.coverUrl,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get coverPath => $composableBuilder(
//     column: $table.coverPath,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get description => $composableBuilder(
//     column: $table.description,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get owner => $composableBuilder(
//     column: $table.owner,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get listenCount => $composableBuilder(
//     column: $table.listenCount,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get durationMs => $composableBuilder(
//     column: $table.durationMs,
//     builder: (column) => ColumnOrderings(column),
//   );

//   $$TracksTableOrderingComposer get lastPlayedTrack {
//     final $$TracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.lastPlayedTrack,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$PlaylistsTableAnnotationComposer
//     extends Composer<_$AppDatabase, $PlaylistsTable> {
//   $$PlaylistsTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get id =>
//       $composableBuilder(column: $table.id, builder: (column) => column);

//   GeneratedColumn<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get externalId2 => $composableBuilder(
//     column: $table.externalId2,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get title =>
//       $composableBuilder(column: $table.title, builder: (column) => column);

//   GeneratedColumn<int> get trackCount => $composableBuilder(
//     column: $table.trackCount,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get source =>
//       $composableBuilder(column: $table.source, builder: (column) => column);

//   GeneratedColumn<String> get coverUrl =>
//       $composableBuilder(column: $table.coverUrl, builder: (column) => column);

//   GeneratedColumn<String> get coverPath =>
//       $composableBuilder(column: $table.coverPath, builder: (column) => column);

//   GeneratedColumn<String> get description => $composableBuilder(
//     column: $table.description,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get owner =>
//       $composableBuilder(column: $table.owner, builder: (column) => column);

//   GeneratedColumn<int> get listenCount => $composableBuilder(
//     column: $table.listenCount,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get durationMs => $composableBuilder(
//     column: $table.durationMs,
//     builder: (column) => column,
//   );

//   $$TracksTableAnnotationComposer get lastPlayedTrack {
//     final $$TracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.lastPlayedTrack,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   Expression<T> playlistTracksRefs<T extends Object>(
//     Expression<T> Function($$PlaylistTracksTableAnnotationComposer a) f,
//   ) {
//     final $$PlaylistTracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlistTracks,
//       getReferencedColumn: (t) => t.playlistId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistTracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.playlistTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$PlaylistsTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $PlaylistsTable,
//           Playlist,
//           $$PlaylistsTableFilterComposer,
//           $$PlaylistsTableOrderingComposer,
//           $$PlaylistsTableAnnotationComposer,
//           $$PlaylistsTableCreateCompanionBuilder,
//           $$PlaylistsTableUpdateCompanionBuilder,
//           (Playlist, $$PlaylistsTableReferences),
//           Playlist,
//           PrefetchHooks Function({
//             bool lastPlayedTrack,
//             bool playlistTracksRefs,
//           })
//         > {
//   $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$PlaylistsTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$PlaylistsTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$PlaylistsTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String?> externalId = const Value.absent(),
//                 Value<String?> externalId2 = const Value.absent(),
//                 Value<String> title = const Value.absent(),
//                 Value<int> trackCount = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<String?> description = const Value.absent(),
//                 Value<String?> owner = const Value.absent(),
//                 Value<int> listenCount = const Value.absent(),
//                 Value<int?> lastPlayedTrack = const Value.absent(),
//                 Value<int> durationMs = const Value.absent(),
//               }) => PlaylistsCompanion(
//                 id: id,
//                 externalId: externalId,
//                 externalId2: externalId2,
//                 title: title,
//                 trackCount: trackCount,
//                 source: source,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 description: description,
//                 owner: owner,
//                 listenCount: listenCount,
//                 lastPlayedTrack: lastPlayedTrack,
//                 durationMs: durationMs,
//               ),
//           createCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String?> externalId = const Value.absent(),
//                 Value<String?> externalId2 = const Value.absent(),
//                 Value<String> title = const Value.absent(),
//                 Value<int> trackCount = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<String?> description = const Value.absent(),
//                 Value<String?> owner = const Value.absent(),
//                 Value<int> listenCount = const Value.absent(),
//                 Value<int?> lastPlayedTrack = const Value.absent(),
//                 Value<int> durationMs = const Value.absent(),
//               }) => PlaylistsCompanion.insert(
//                 id: id,
//                 externalId: externalId,
//                 externalId2: externalId2,
//                 title: title,
//                 trackCount: trackCount,
//                 source: source,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 description: description,
//                 owner: owner,
//                 listenCount: listenCount,
//                 lastPlayedTrack: lastPlayedTrack,
//                 durationMs: durationMs,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$PlaylistsTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback:
//               ({lastPlayedTrack = false, playlistTracksRefs = false}) {
//                 return PrefetchHooks(
//                   db: db,
//                   explicitlyWatchedTables: [
//                     if (playlistTracksRefs) db.playlistTracks,
//                   ],
//                   addJoins:
//                       <
//                         T extends TableManagerState<
//                           dynamic,
//                           dynamic,
//                           dynamic,
//                           dynamic,
//                           dynamic,
//                           dynamic,
//                           dynamic,
//                           dynamic,
//                           dynamic,
//                           dynamic,
//                           dynamic
//                         >
//                       >(state) {
//                         if (lastPlayedTrack) {
//                           state =
//                               state.withJoin(
//                                     currentTable: table,
//                                     currentColumn: table.lastPlayedTrack,
//                                     referencedTable: $$PlaylistsTableReferences
//                                         ._lastPlayedTrackTable(db),
//                                     referencedColumn: $$PlaylistsTableReferences
//                                         ._lastPlayedTrackTable(db)
//                                         .id,
//                                   )
//                                   as T;
//                         }

//                         return state;
//                       },
//                   getPrefetchedDataCallback: (items) async {
//                     return [
//                       if (playlistTracksRefs)
//                         await $_getPrefetchedData<
//                           Playlist,
//                           $PlaylistsTable,
//                           PlaylistTrack
//                         >(
//                           currentTable: table,
//                           referencedTable: $$PlaylistsTableReferences
//                               ._playlistTracksRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$PlaylistsTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).playlistTracksRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.playlistId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                     ];
//                   },
//                 );
//               },
//         ),
//       );
// }

// typedef $$PlaylistsTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $PlaylistsTable,
//       Playlist,
//       $$PlaylistsTableFilterComposer,
//       $$PlaylistsTableOrderingComposer,
//       $$PlaylistsTableAnnotationComposer,
//       $$PlaylistsTableCreateCompanionBuilder,
//       $$PlaylistsTableUpdateCompanionBuilder,
//       (Playlist, $$PlaylistsTableReferences),
//       Playlist,
//       PrefetchHooks Function({bool lastPlayedTrack, bool playlistTracksRefs})
//     >;
// typedef $$ArtistsTableCreateCompanionBuilder =
//     ArtistsCompanion Function({
//       Value<int> id,
//       Value<String?> externalId,
//       Value<String> name,
//       Value<bool?> various,
//       Value<bool?> composer,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<String> source,
//     });
// typedef $$ArtistsTableUpdateCompanionBuilder =
//     ArtistsCompanion Function({
//       Value<int> id,
//       Value<String?> externalId,
//       Value<String> name,
//       Value<bool?> various,
//       Value<bool?> composer,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<String> source,
//     });

// final class $$ArtistsTableReferences
//     extends BaseReferences<_$AppDatabase, $ArtistsTable, Artist> {
//   $$ArtistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static MultiTypedResultKey<$TrackArtistTable, List<TrackArtistData>>
//   _trackArtistRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.trackArtist,
//     aliasName: $_aliasNameGenerator(db.artists.id, db.trackArtist.artistId),
//   );

//   $$TrackArtistTableProcessedTableManager get trackArtistRefs {
//     final manager = $$TrackArtistTableTableManager(
//       $_db,
//       $_db.trackArtist,
//     ).filter((f) => f.artistId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_trackArtistRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }
// }

// class $$ArtistsTableFilterComposer
//     extends Composer<_$AppDatabase, $ArtistsTable> {
//   $$ArtistsTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get name => $composableBuilder(
//     column: $table.name,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get various => $composableBuilder(
//     column: $table.various,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get composer => $composableBuilder(
//     column: $table.composer,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get coverUrl => $composableBuilder(
//     column: $table.coverUrl,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get coverPath => $composableBuilder(
//     column: $table.coverPath,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnFilters(column),
//   );

//   Expression<bool> trackArtistRefs(
//     Expression<bool> Function($$TrackArtistTableFilterComposer f) f,
//   ) {
//     final $$TrackArtistTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackArtist,
//       getReferencedColumn: (t) => t.artistId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackArtistTableFilterComposer(
//             $db: $db,
//             $table: $db.trackArtist,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$ArtistsTableOrderingComposer
//     extends Composer<_$AppDatabase, $ArtistsTable> {
//   $$ArtistsTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get name => $composableBuilder(
//     column: $table.name,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get various => $composableBuilder(
//     column: $table.various,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get composer => $composableBuilder(
//     column: $table.composer,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get coverUrl => $composableBuilder(
//     column: $table.coverUrl,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get coverPath => $composableBuilder(
//     column: $table.coverPath,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnOrderings(column),
//   );
// }

// class $$ArtistsTableAnnotationComposer
//     extends Composer<_$AppDatabase, $ArtistsTable> {
//   $$ArtistsTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get id =>
//       $composableBuilder(column: $table.id, builder: (column) => column);

//   GeneratedColumn<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get name =>
//       $composableBuilder(column: $table.name, builder: (column) => column);

//   GeneratedColumn<bool> get various =>
//       $composableBuilder(column: $table.various, builder: (column) => column);

//   GeneratedColumn<bool> get composer =>
//       $composableBuilder(column: $table.composer, builder: (column) => column);

//   GeneratedColumn<String> get coverUrl =>
//       $composableBuilder(column: $table.coverUrl, builder: (column) => column);

//   GeneratedColumn<String> get coverPath =>
//       $composableBuilder(column: $table.coverPath, builder: (column) => column);

//   GeneratedColumn<String> get source =>
//       $composableBuilder(column: $table.source, builder: (column) => column);

//   Expression<T> trackArtistRefs<T extends Object>(
//     Expression<T> Function($$TrackArtistTableAnnotationComposer a) f,
//   ) {
//     final $$TrackArtistTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackArtist,
//       getReferencedColumn: (t) => t.artistId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackArtistTableAnnotationComposer(
//             $db: $db,
//             $table: $db.trackArtist,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$ArtistsTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $ArtistsTable,
//           Artist,
//           $$ArtistsTableFilterComposer,
//           $$ArtistsTableOrderingComposer,
//           $$ArtistsTableAnnotationComposer,
//           $$ArtistsTableCreateCompanionBuilder,
//           $$ArtistsTableUpdateCompanionBuilder,
//           (Artist, $$ArtistsTableReferences),
//           Artist,
//           PrefetchHooks Function({bool trackArtistRefs})
//         > {
//   $$ArtistsTableTableManager(_$AppDatabase db, $ArtistsTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$ArtistsTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$ArtistsTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$ArtistsTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String?> externalId = const Value.absent(),
//                 Value<String> name = const Value.absent(),
//                 Value<bool?> various = const Value.absent(),
//                 Value<bool?> composer = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//               }) => ArtistsCompanion(
//                 id: id,
//                 externalId: externalId,
//                 name: name,
//                 various: various,
//                 composer: composer,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 source: source,
//               ),
//           createCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String?> externalId = const Value.absent(),
//                 Value<String> name = const Value.absent(),
//                 Value<bool?> various = const Value.absent(),
//                 Value<bool?> composer = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//               }) => ArtistsCompanion.insert(
//                 id: id,
//                 externalId: externalId,
//                 name: name,
//                 various: various,
//                 composer: composer,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 source: source,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$ArtistsTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({trackArtistRefs = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [if (trackArtistRefs) db.trackArtist],
//               addJoins: null,
//               getPrefetchedDataCallback: (items) async {
//                 return [
//                   if (trackArtistRefs)
//                     await $_getPrefetchedData<
//                       Artist,
//                       $ArtistsTable,
//                       TrackArtistData
//                     >(
//                       currentTable: table,
//                       referencedTable: $$ArtistsTableReferences
//                           ._trackArtistRefsTable(db),
//                       managerFromTypedResult: (p0) => $$ArtistsTableReferences(
//                         db,
//                         table,
//                         p0,
//                       ).trackArtistRefs,
//                       referencedItemsForCurrentItem: (item, referencedItems) =>
//                           referencedItems.where((e) => e.artistId == item.id),
//                       typedResults: items,
//                     ),
//                 ];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$ArtistsTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $ArtistsTable,
//       Artist,
//       $$ArtistsTableFilterComposer,
//       $$ArtistsTableOrderingComposer,
//       $$ArtistsTableAnnotationComposer,
//       $$ArtistsTableCreateCompanionBuilder,
//       $$ArtistsTableUpdateCompanionBuilder,
//       (Artist, $$ArtistsTableReferences),
//       Artist,
//       PrefetchHooks Function({bool trackArtistRefs})
//     >;
// typedef $$AlbumsTableCreateCompanionBuilder =
//     AlbumsCompanion Function({
//       Value<int> id,
//       Value<String?> externalId,
//       Value<String> title,
//       Value<String?> type,
//       Value<String?> metaType,
//       Value<int?> year,
//       Value<String?> releaseDate,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<int?> trackCount,
//       Value<String> source,
//     });
// typedef $$AlbumsTableUpdateCompanionBuilder =
//     AlbumsCompanion Function({
//       Value<int> id,
//       Value<String?> externalId,
//       Value<String> title,
//       Value<String?> type,
//       Value<String?> metaType,
//       Value<int?> year,
//       Value<String?> releaseDate,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<int?> trackCount,
//       Value<String> source,
//     });

// final class $$AlbumsTableReferences
//     extends BaseReferences<_$AppDatabase, $AlbumsTable, Album> {
//   $$AlbumsTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static MultiTypedResultKey<$AlbumGenreTable, List<AlbumGenreData>>
//   _albumGenreRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.albumGenre,
//     aliasName: $_aliasNameGenerator(db.albums.id, db.albumGenre.albumId),
//   );

//   $$AlbumGenreTableProcessedTableManager get albumGenreRefs {
//     final manager = $$AlbumGenreTableTableManager(
//       $_db,
//       $_db.albumGenre,
//     ).filter((f) => f.albumId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_albumGenreRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<$TrackAlbumTable, List<TrackAlbumData>>
//   _trackAlbumRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.trackAlbum,
//     aliasName: $_aliasNameGenerator(db.albums.id, db.trackAlbum.albumId),
//   );

//   $$TrackAlbumTableProcessedTableManager get trackAlbumRefs {
//     final manager = $$TrackAlbumTableTableManager(
//       $_db,
//       $_db.trackAlbum,
//     ).filter((f) => f.albumId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_trackAlbumRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }
// }

// class $$AlbumsTableFilterComposer
//     extends Composer<_$AppDatabase, $AlbumsTable> {
//   $$AlbumsTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get title => $composableBuilder(
//     column: $table.title,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get type => $composableBuilder(
//     column: $table.type,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get metaType => $composableBuilder(
//     column: $table.metaType,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get year => $composableBuilder(
//     column: $table.year,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get releaseDate => $composableBuilder(
//     column: $table.releaseDate,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get coverUrl => $composableBuilder(
//     column: $table.coverUrl,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get coverPath => $composableBuilder(
//     column: $table.coverPath,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get trackCount => $composableBuilder(
//     column: $table.trackCount,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnFilters(column),
//   );

//   Expression<bool> albumGenreRefs(
//     Expression<bool> Function($$AlbumGenreTableFilterComposer f) f,
//   ) {
//     final $$AlbumGenreTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.albumGenre,
//       getReferencedColumn: (t) => t.albumId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumGenreTableFilterComposer(
//             $db: $db,
//             $table: $db.albumGenre,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<bool> trackAlbumRefs(
//     Expression<bool> Function($$TrackAlbumTableFilterComposer f) f,
//   ) {
//     final $$TrackAlbumTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackAlbum,
//       getReferencedColumn: (t) => t.albumId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackAlbumTableFilterComposer(
//             $db: $db,
//             $table: $db.trackAlbum,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$AlbumsTableOrderingComposer
//     extends Composer<_$AppDatabase, $AlbumsTable> {
//   $$AlbumsTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get title => $composableBuilder(
//     column: $table.title,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get type => $composableBuilder(
//     column: $table.type,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get metaType => $composableBuilder(
//     column: $table.metaType,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get year => $composableBuilder(
//     column: $table.year,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get releaseDate => $composableBuilder(
//     column: $table.releaseDate,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get coverUrl => $composableBuilder(
//     column: $table.coverUrl,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get coverPath => $composableBuilder(
//     column: $table.coverPath,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get trackCount => $composableBuilder(
//     column: $table.trackCount,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnOrderings(column),
//   );
// }

// class $$AlbumsTableAnnotationComposer
//     extends Composer<_$AppDatabase, $AlbumsTable> {
//   $$AlbumsTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get id =>
//       $composableBuilder(column: $table.id, builder: (column) => column);

//   GeneratedColumn<String> get externalId => $composableBuilder(
//     column: $table.externalId,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get title =>
//       $composableBuilder(column: $table.title, builder: (column) => column);

//   GeneratedColumn<String> get type =>
//       $composableBuilder(column: $table.type, builder: (column) => column);

//   GeneratedColumn<String> get metaType =>
//       $composableBuilder(column: $table.metaType, builder: (column) => column);

//   GeneratedColumn<int> get year =>
//       $composableBuilder(column: $table.year, builder: (column) => column);

//   GeneratedColumn<String> get releaseDate => $composableBuilder(
//     column: $table.releaseDate,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get coverUrl =>
//       $composableBuilder(column: $table.coverUrl, builder: (column) => column);

//   GeneratedColumn<String> get coverPath =>
//       $composableBuilder(column: $table.coverPath, builder: (column) => column);

//   GeneratedColumn<int> get trackCount => $composableBuilder(
//     column: $table.trackCount,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get source =>
//       $composableBuilder(column: $table.source, builder: (column) => column);

//   Expression<T> albumGenreRefs<T extends Object>(
//     Expression<T> Function($$AlbumGenreTableAnnotationComposer a) f,
//   ) {
//     final $$AlbumGenreTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.albumGenre,
//       getReferencedColumn: (t) => t.albumId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumGenreTableAnnotationComposer(
//             $db: $db,
//             $table: $db.albumGenre,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<T> trackAlbumRefs<T extends Object>(
//     Expression<T> Function($$TrackAlbumTableAnnotationComposer a) f,
//   ) {
//     final $$TrackAlbumTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackAlbum,
//       getReferencedColumn: (t) => t.albumId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackAlbumTableAnnotationComposer(
//             $db: $db,
//             $table: $db.trackAlbum,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$AlbumsTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $AlbumsTable,
//           Album,
//           $$AlbumsTableFilterComposer,
//           $$AlbumsTableOrderingComposer,
//           $$AlbumsTableAnnotationComposer,
//           $$AlbumsTableCreateCompanionBuilder,
//           $$AlbumsTableUpdateCompanionBuilder,
//           (Album, $$AlbumsTableReferences),
//           Album,
//           PrefetchHooks Function({bool albumGenreRefs, bool trackAlbumRefs})
//         > {
//   $$AlbumsTableTableManager(_$AppDatabase db, $AlbumsTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$AlbumsTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$AlbumsTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$AlbumsTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String?> externalId = const Value.absent(),
//                 Value<String> title = const Value.absent(),
//                 Value<String?> type = const Value.absent(),
//                 Value<String?> metaType = const Value.absent(),
//                 Value<int?> year = const Value.absent(),
//                 Value<String?> releaseDate = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<int?> trackCount = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//               }) => AlbumsCompanion(
//                 id: id,
//                 externalId: externalId,
//                 title: title,
//                 type: type,
//                 metaType: metaType,
//                 year: year,
//                 releaseDate: releaseDate,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 trackCount: trackCount,
//                 source: source,
//               ),
//           createCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String?> externalId = const Value.absent(),
//                 Value<String> title = const Value.absent(),
//                 Value<String?> type = const Value.absent(),
//                 Value<String?> metaType = const Value.absent(),
//                 Value<int?> year = const Value.absent(),
//                 Value<String?> releaseDate = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<int?> trackCount = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//               }) => AlbumsCompanion.insert(
//                 id: id,
//                 externalId: externalId,
//                 title: title,
//                 type: type,
//                 metaType: metaType,
//                 year: year,
//                 releaseDate: releaseDate,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 trackCount: trackCount,
//                 source: source,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) =>
//                     (e.readTable(table), $$AlbumsTableReferences(db, table, e)),
//               )
//               .toList(),
//           prefetchHooksCallback:
//               ({albumGenreRefs = false, trackAlbumRefs = false}) {
//                 return PrefetchHooks(
//                   db: db,
//                   explicitlyWatchedTables: [
//                     if (albumGenreRefs) db.albumGenre,
//                     if (trackAlbumRefs) db.trackAlbum,
//                   ],
//                   addJoins: null,
//                   getPrefetchedDataCallback: (items) async {
//                     return [
//                       if (albumGenreRefs)
//                         await $_getPrefetchedData<
//                           Album,
//                           $AlbumsTable,
//                           AlbumGenreData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$AlbumsTableReferences
//                               ._albumGenreRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$AlbumsTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).albumGenreRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.albumId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (trackAlbumRefs)
//                         await $_getPrefetchedData<
//                           Album,
//                           $AlbumsTable,
//                           TrackAlbumData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$AlbumsTableReferences
//                               ._trackAlbumRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$AlbumsTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).trackAlbumRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.albumId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                     ];
//                   },
//                 );
//               },
//         ),
//       );
// }

// typedef $$AlbumsTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $AlbumsTable,
//       Album,
//       $$AlbumsTableFilterComposer,
//       $$AlbumsTableOrderingComposer,
//       $$AlbumsTableAnnotationComposer,
//       $$AlbumsTableCreateCompanionBuilder,
//       $$AlbumsTableUpdateCompanionBuilder,
//       (Album, $$AlbumsTableReferences),
//       Album,
//       PrefetchHooks Function({bool albumGenreRefs, bool trackAlbumRefs})
//     >;
// typedef $$GenresTableCreateCompanionBuilder =
//     GenresCompanion Function({Value<int> id, required String name});
// typedef $$GenresTableUpdateCompanionBuilder =
//     GenresCompanion Function({Value<int> id, Value<String> name});

// final class $$GenresTableReferences
//     extends BaseReferences<_$AppDatabase, $GenresTable, Genre> {
//   $$GenresTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static MultiTypedResultKey<$TrackGenreTable, List<TrackGenreData>>
//   _trackGenreRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.trackGenre,
//     aliasName: $_aliasNameGenerator(db.genres.id, db.trackGenre.genreId),
//   );

//   $$TrackGenreTableProcessedTableManager get trackGenreRefs {
//     final manager = $$TrackGenreTableTableManager(
//       $_db,
//       $_db.trackGenre,
//     ).filter((f) => f.genreId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_trackGenreRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<$AlbumGenreTable, List<AlbumGenreData>>
//   _albumGenreRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.albumGenre,
//     aliasName: $_aliasNameGenerator(db.genres.id, db.albumGenre.genreId),
//   );

//   $$AlbumGenreTableProcessedTableManager get albumGenreRefs {
//     final manager = $$AlbumGenreTableTableManager(
//       $_db,
//       $_db.albumGenre,
//     ).filter((f) => f.genreId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_albumGenreRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }
// }

// class $$GenresTableFilterComposer
//     extends Composer<_$AppDatabase, $GenresTable> {
//   $$GenresTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get name => $composableBuilder(
//     column: $table.name,
//     builder: (column) => ColumnFilters(column),
//   );

//   Expression<bool> trackGenreRefs(
//     Expression<bool> Function($$TrackGenreTableFilterComposer f) f,
//   ) {
//     final $$TrackGenreTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackGenre,
//       getReferencedColumn: (t) => t.genreId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackGenreTableFilterComposer(
//             $db: $db,
//             $table: $db.trackGenre,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<bool> albumGenreRefs(
//     Expression<bool> Function($$AlbumGenreTableFilterComposer f) f,
//   ) {
//     final $$AlbumGenreTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.albumGenre,
//       getReferencedColumn: (t) => t.genreId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumGenreTableFilterComposer(
//             $db: $db,
//             $table: $db.albumGenre,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$GenresTableOrderingComposer
//     extends Composer<_$AppDatabase, $GenresTable> {
//   $$GenresTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get name => $composableBuilder(
//     column: $table.name,
//     builder: (column) => ColumnOrderings(column),
//   );
// }

// class $$GenresTableAnnotationComposer
//     extends Composer<_$AppDatabase, $GenresTable> {
//   $$GenresTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get id =>
//       $composableBuilder(column: $table.id, builder: (column) => column);

//   GeneratedColumn<String> get name =>
//       $composableBuilder(column: $table.name, builder: (column) => column);

//   Expression<T> trackGenreRefs<T extends Object>(
//     Expression<T> Function($$TrackGenreTableAnnotationComposer a) f,
//   ) {
//     final $$TrackGenreTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.trackGenre,
//       getReferencedColumn: (t) => t.genreId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TrackGenreTableAnnotationComposer(
//             $db: $db,
//             $table: $db.trackGenre,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }

//   Expression<T> albumGenreRefs<T extends Object>(
//     Expression<T> Function($$AlbumGenreTableAnnotationComposer a) f,
//   ) {
//     final $$AlbumGenreTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.albumGenre,
//       getReferencedColumn: (t) => t.genreId,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumGenreTableAnnotationComposer(
//             $db: $db,
//             $table: $db.albumGenre,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$GenresTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $GenresTable,
//           Genre,
//           $$GenresTableFilterComposer,
//           $$GenresTableOrderingComposer,
//           $$GenresTableAnnotationComposer,
//           $$GenresTableCreateCompanionBuilder,
//           $$GenresTableUpdateCompanionBuilder,
//           (Genre, $$GenresTableReferences),
//           Genre,
//           PrefetchHooks Function({bool trackGenreRefs, bool albumGenreRefs})
//         > {
//   $$GenresTableTableManager(_$AppDatabase db, $GenresTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$GenresTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$GenresTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$GenresTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String> name = const Value.absent(),
//               }) => GenresCompanion(id: id, name: name),
//           createCompanionCallback:
//               ({Value<int> id = const Value.absent(), required String name}) =>
//                   GenresCompanion.insert(id: id, name: name),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) =>
//                     (e.readTable(table), $$GenresTableReferences(db, table, e)),
//               )
//               .toList(),
//           prefetchHooksCallback:
//               ({trackGenreRefs = false, albumGenreRefs = false}) {
//                 return PrefetchHooks(
//                   db: db,
//                   explicitlyWatchedTables: [
//                     if (trackGenreRefs) db.trackGenre,
//                     if (albumGenreRefs) db.albumGenre,
//                   ],
//                   addJoins: null,
//                   getPrefetchedDataCallback: (items) async {
//                     return [
//                       if (trackGenreRefs)
//                         await $_getPrefetchedData<
//                           Genre,
//                           $GenresTable,
//                           TrackGenreData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$GenresTableReferences
//                               ._trackGenreRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$GenresTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).trackGenreRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.genreId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (albumGenreRefs)
//                         await $_getPrefetchedData<
//                           Genre,
//                           $GenresTable,
//                           AlbumGenreData
//                         >(
//                           currentTable: table,
//                           referencedTable: $$GenresTableReferences
//                               ._albumGenreRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$GenresTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).albumGenreRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.genreId == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                     ];
//                   },
//                 );
//               },
//         ),
//       );
// }

// typedef $$GenresTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $GenresTable,
//       Genre,
//       $$GenresTableFilterComposer,
//       $$GenresTableOrderingComposer,
//       $$GenresTableAnnotationComposer,
//       $$GenresTableCreateCompanionBuilder,
//       $$GenresTableUpdateCompanionBuilder,
//       (Genre, $$GenresTableReferences),
//       Genre,
//       PrefetchHooks Function({bool trackGenreRefs, bool albumGenreRefs})
//     >;
// typedef $$TrackGenreTableCreateCompanionBuilder =
//     TrackGenreCompanion Function({
//       required int trackId,
//       required int genreId,
//       Value<int> rowid,
//     });
// typedef $$TrackGenreTableUpdateCompanionBuilder =
//     TrackGenreCompanion Function({
//       Value<int> trackId,
//       Value<int> genreId,
//       Value<int> rowid,
//     });

// final class $$TrackGenreTableReferences
//     extends BaseReferences<_$AppDatabase, $TrackGenreTable, TrackGenreData> {
//   $$TrackGenreTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias(
//     $_aliasNameGenerator(db.trackGenre.trackId, db.tracks.id),
//   );

//   $$TracksTableProcessedTableManager get trackId {
//     final $_column = $_itemColumn<int>('track_id')!;

//     final manager = $$TracksTableTableManager(
//       $_db,
//       $_db.tracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }

//   static $GenresTable _genreIdTable(_$AppDatabase db) => db.genres.createAlias(
//     $_aliasNameGenerator(db.trackGenre.genreId, db.genres.id),
//   );

//   $$GenresTableProcessedTableManager get genreId {
//     final $_column = $_itemColumn<int>('genre_id')!;

//     final manager = $$GenresTableTableManager(
//       $_db,
//       $_db.genres,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_genreIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$TrackGenreTableFilterComposer
//     extends Composer<_$AppDatabase, $TrackGenreTable> {
//   $$TrackGenreTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableFilterComposer get trackId {
//     final $$TracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableFilterComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$GenresTableFilterComposer get genreId {
//     final $$GenresTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.genreId,
//       referencedTable: $db.genres,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$GenresTableFilterComposer(
//             $db: $db,
//             $table: $db.genres,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackGenreTableOrderingComposer
//     extends Composer<_$AppDatabase, $TrackGenreTable> {
//   $$TrackGenreTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableOrderingComposer get trackId {
//     final $$TracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$GenresTableOrderingComposer get genreId {
//     final $$GenresTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.genreId,
//       referencedTable: $db.genres,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$GenresTableOrderingComposer(
//             $db: $db,
//             $table: $db.genres,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackGenreTableAnnotationComposer
//     extends Composer<_$AppDatabase, $TrackGenreTable> {
//   $$TrackGenreTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableAnnotationComposer get trackId {
//     final $$TracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$GenresTableAnnotationComposer get genreId {
//     final $$GenresTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.genreId,
//       referencedTable: $db.genres,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$GenresTableAnnotationComposer(
//             $db: $db,
//             $table: $db.genres,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackGenreTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $TrackGenreTable,
//           TrackGenreData,
//           $$TrackGenreTableFilterComposer,
//           $$TrackGenreTableOrderingComposer,
//           $$TrackGenreTableAnnotationComposer,
//           $$TrackGenreTableCreateCompanionBuilder,
//           $$TrackGenreTableUpdateCompanionBuilder,
//           (TrackGenreData, $$TrackGenreTableReferences),
//           TrackGenreData,
//           PrefetchHooks Function({bool trackId, bool genreId})
//         > {
//   $$TrackGenreTableTableManager(_$AppDatabase db, $TrackGenreTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$TrackGenreTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$TrackGenreTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$TrackGenreTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> trackId = const Value.absent(),
//                 Value<int> genreId = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => TrackGenreCompanion(
//                 trackId: trackId,
//                 genreId: genreId,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int trackId,
//                 required int genreId,
//                 Value<int> rowid = const Value.absent(),
//               }) => TrackGenreCompanion.insert(
//                 trackId: trackId,
//                 genreId: genreId,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$TrackGenreTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({trackId = false, genreId = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [],
//               addJoins:
//                   <
//                     T extends TableManagerState<
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic
//                     >
//                   >(state) {
//                     if (trackId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.trackId,
//                                 referencedTable: $$TrackGenreTableReferences
//                                     ._trackIdTable(db),
//                                 referencedColumn: $$TrackGenreTableReferences
//                                     ._trackIdTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }
//                     if (genreId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.genreId,
//                                 referencedTable: $$TrackGenreTableReferences
//                                     ._genreIdTable(db),
//                                 referencedColumn: $$TrackGenreTableReferences
//                                     ._genreIdTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }

//                     return state;
//                   },
//               getPrefetchedDataCallback: (items) async {
//                 return [];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$TrackGenreTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $TrackGenreTable,
//       TrackGenreData,
//       $$TrackGenreTableFilterComposer,
//       $$TrackGenreTableOrderingComposer,
//       $$TrackGenreTableAnnotationComposer,
//       $$TrackGenreTableCreateCompanionBuilder,
//       $$TrackGenreTableUpdateCompanionBuilder,
//       (TrackGenreData, $$TrackGenreTableReferences),
//       TrackGenreData,
//       PrefetchHooks Function({bool trackId, bool genreId})
//     >;
// typedef $$AlbumGenreTableCreateCompanionBuilder =
//     AlbumGenreCompanion Function({
//       required int albumId,
//       required int genreId,
//       Value<int> rowid,
//     });
// typedef $$AlbumGenreTableUpdateCompanionBuilder =
//     AlbumGenreCompanion Function({
//       Value<int> albumId,
//       Value<int> genreId,
//       Value<int> rowid,
//     });

// final class $$AlbumGenreTableReferences
//     extends BaseReferences<_$AppDatabase, $AlbumGenreTable, AlbumGenreData> {
//   $$AlbumGenreTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static $AlbumsTable _albumIdTable(_$AppDatabase db) => db.albums.createAlias(
//     $_aliasNameGenerator(db.albumGenre.albumId, db.albums.id),
//   );

//   $$AlbumsTableProcessedTableManager get albumId {
//     final $_column = $_itemColumn<int>('album_id')!;

//     final manager = $$AlbumsTableTableManager(
//       $_db,
//       $_db.albums,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_albumIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }

//   static $GenresTable _genreIdTable(_$AppDatabase db) => db.genres.createAlias(
//     $_aliasNameGenerator(db.albumGenre.genreId, db.genres.id),
//   );

//   $$GenresTableProcessedTableManager get genreId {
//     final $_column = $_itemColumn<int>('genre_id')!;

//     final manager = $$GenresTableTableManager(
//       $_db,
//       $_db.genres,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_genreIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$AlbumGenreTableFilterComposer
//     extends Composer<_$AppDatabase, $AlbumGenreTable> {
//   $$AlbumGenreTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$AlbumsTableFilterComposer get albumId {
//     final $$AlbumsTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.albumId,
//       referencedTable: $db.albums,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumsTableFilterComposer(
//             $db: $db,
//             $table: $db.albums,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$GenresTableFilterComposer get genreId {
//     final $$GenresTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.genreId,
//       referencedTable: $db.genres,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$GenresTableFilterComposer(
//             $db: $db,
//             $table: $db.genres,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$AlbumGenreTableOrderingComposer
//     extends Composer<_$AppDatabase, $AlbumGenreTable> {
//   $$AlbumGenreTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$AlbumsTableOrderingComposer get albumId {
//     final $$AlbumsTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.albumId,
//       referencedTable: $db.albums,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumsTableOrderingComposer(
//             $db: $db,
//             $table: $db.albums,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$GenresTableOrderingComposer get genreId {
//     final $$GenresTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.genreId,
//       referencedTable: $db.genres,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$GenresTableOrderingComposer(
//             $db: $db,
//             $table: $db.genres,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$AlbumGenreTableAnnotationComposer
//     extends Composer<_$AppDatabase, $AlbumGenreTable> {
//   $$AlbumGenreTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$AlbumsTableAnnotationComposer get albumId {
//     final $$AlbumsTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.albumId,
//       referencedTable: $db.albums,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumsTableAnnotationComposer(
//             $db: $db,
//             $table: $db.albums,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$GenresTableAnnotationComposer get genreId {
//     final $$GenresTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.genreId,
//       referencedTable: $db.genres,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$GenresTableAnnotationComposer(
//             $db: $db,
//             $table: $db.genres,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$AlbumGenreTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $AlbumGenreTable,
//           AlbumGenreData,
//           $$AlbumGenreTableFilterComposer,
//           $$AlbumGenreTableOrderingComposer,
//           $$AlbumGenreTableAnnotationComposer,
//           $$AlbumGenreTableCreateCompanionBuilder,
//           $$AlbumGenreTableUpdateCompanionBuilder,
//           (AlbumGenreData, $$AlbumGenreTableReferences),
//           AlbumGenreData,
//           PrefetchHooks Function({bool albumId, bool genreId})
//         > {
//   $$AlbumGenreTableTableManager(_$AppDatabase db, $AlbumGenreTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$AlbumGenreTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$AlbumGenreTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$AlbumGenreTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> albumId = const Value.absent(),
//                 Value<int> genreId = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => AlbumGenreCompanion(
//                 albumId: albumId,
//                 genreId: genreId,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int albumId,
//                 required int genreId,
//                 Value<int> rowid = const Value.absent(),
//               }) => AlbumGenreCompanion.insert(
//                 albumId: albumId,
//                 genreId: genreId,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$AlbumGenreTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({albumId = false, genreId = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [],
//               addJoins:
//                   <
//                     T extends TableManagerState<
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic
//                     >
//                   >(state) {
//                     if (albumId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.albumId,
//                                 referencedTable: $$AlbumGenreTableReferences
//                                     ._albumIdTable(db),
//                                 referencedColumn: $$AlbumGenreTableReferences
//                                     ._albumIdTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }
//                     if (genreId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.genreId,
//                                 referencedTable: $$AlbumGenreTableReferences
//                                     ._genreIdTable(db),
//                                 referencedColumn: $$AlbumGenreTableReferences
//                                     ._genreIdTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }

//                     return state;
//                   },
//               getPrefetchedDataCallback: (items) async {
//                 return [];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$AlbumGenreTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $AlbumGenreTable,
//       AlbumGenreData,
//       $$AlbumGenreTableFilterComposer,
//       $$AlbumGenreTableOrderingComposer,
//       $$AlbumGenreTableAnnotationComposer,
//       $$AlbumGenreTableCreateCompanionBuilder,
//       $$AlbumGenreTableUpdateCompanionBuilder,
//       (AlbumGenreData, $$AlbumGenreTableReferences),
//       AlbumGenreData,
//       PrefetchHooks Function({bool albumId, bool genreId})
//     >;
// typedef $$TrackArtistTableCreateCompanionBuilder =
//     TrackArtistCompanion Function({
//       required int trackId,
//       required int artistId,
//       Value<int> rowid,
//     });
// typedef $$TrackArtistTableUpdateCompanionBuilder =
//     TrackArtistCompanion Function({
//       Value<int> trackId,
//       Value<int> artistId,
//       Value<int> rowid,
//     });

// final class $$TrackArtistTableReferences
//     extends BaseReferences<_$AppDatabase, $TrackArtistTable, TrackArtistData> {
//   $$TrackArtistTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias(
//     $_aliasNameGenerator(db.trackArtist.trackId, db.tracks.id),
//   );

//   $$TracksTableProcessedTableManager get trackId {
//     final $_column = $_itemColumn<int>('track_id')!;

//     final manager = $$TracksTableTableManager(
//       $_db,
//       $_db.tracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }

//   static $ArtistsTable _artistIdTable(_$AppDatabase db) =>
//       db.artists.createAlias(
//         $_aliasNameGenerator(db.trackArtist.artistId, db.artists.id),
//       );

//   $$ArtistsTableProcessedTableManager get artistId {
//     final $_column = $_itemColumn<int>('artist_id')!;

//     final manager = $$ArtistsTableTableManager(
//       $_db,
//       $_db.artists,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_artistIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$TrackArtistTableFilterComposer
//     extends Composer<_$AppDatabase, $TrackArtistTable> {
//   $$TrackArtistTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableFilterComposer get trackId {
//     final $$TracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableFilterComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$ArtistsTableFilterComposer get artistId {
//     final $$ArtistsTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.artistId,
//       referencedTable: $db.artists,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$ArtistsTableFilterComposer(
//             $db: $db,
//             $table: $db.artists,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackArtistTableOrderingComposer
//     extends Composer<_$AppDatabase, $TrackArtistTable> {
//   $$TrackArtistTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableOrderingComposer get trackId {
//     final $$TracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$ArtistsTableOrderingComposer get artistId {
//     final $$ArtistsTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.artistId,
//       referencedTable: $db.artists,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$ArtistsTableOrderingComposer(
//             $db: $db,
//             $table: $db.artists,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackArtistTableAnnotationComposer
//     extends Composer<_$AppDatabase, $TrackArtistTable> {
//   $$TrackArtistTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableAnnotationComposer get trackId {
//     final $$TracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$ArtistsTableAnnotationComposer get artistId {
//     final $$ArtistsTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.artistId,
//       referencedTable: $db.artists,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$ArtistsTableAnnotationComposer(
//             $db: $db,
//             $table: $db.artists,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackArtistTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $TrackArtistTable,
//           TrackArtistData,
//           $$TrackArtistTableFilterComposer,
//           $$TrackArtistTableOrderingComposer,
//           $$TrackArtistTableAnnotationComposer,
//           $$TrackArtistTableCreateCompanionBuilder,
//           $$TrackArtistTableUpdateCompanionBuilder,
//           (TrackArtistData, $$TrackArtistTableReferences),
//           TrackArtistData,
//           PrefetchHooks Function({bool trackId, bool artistId})
//         > {
//   $$TrackArtistTableTableManager(_$AppDatabase db, $TrackArtistTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$TrackArtistTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$TrackArtistTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$TrackArtistTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> trackId = const Value.absent(),
//                 Value<int> artistId = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => TrackArtistCompanion(
//                 trackId: trackId,
//                 artistId: artistId,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int trackId,
//                 required int artistId,
//                 Value<int> rowid = const Value.absent(),
//               }) => TrackArtistCompanion.insert(
//                 trackId: trackId,
//                 artistId: artistId,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$TrackArtistTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({trackId = false, artistId = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [],
//               addJoins:
//                   <
//                     T extends TableManagerState<
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic
//                     >
//                   >(state) {
//                     if (trackId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.trackId,
//                                 referencedTable: $$TrackArtistTableReferences
//                                     ._trackIdTable(db),
//                                 referencedColumn: $$TrackArtistTableReferences
//                                     ._trackIdTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }
//                     if (artistId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.artistId,
//                                 referencedTable: $$TrackArtistTableReferences
//                                     ._artistIdTable(db),
//                                 referencedColumn: $$TrackArtistTableReferences
//                                     ._artistIdTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }

//                     return state;
//                   },
//               getPrefetchedDataCallback: (items) async {
//                 return [];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$TrackArtistTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $TrackArtistTable,
//       TrackArtistData,
//       $$TrackArtistTableFilterComposer,
//       $$TrackArtistTableOrderingComposer,
//       $$TrackArtistTableAnnotationComposer,
//       $$TrackArtistTableCreateCompanionBuilder,
//       $$TrackArtistTableUpdateCompanionBuilder,
//       (TrackArtistData, $$TrackArtistTableReferences),
//       TrackArtistData,
//       PrefetchHooks Function({bool trackId, bool artistId})
//     >;
// typedef $$TrackAlbumTableCreateCompanionBuilder =
//     TrackAlbumCompanion Function({
//       required int trackId,
//       required int albumId,
//       Value<int> rowid,
//     });
// typedef $$TrackAlbumTableUpdateCompanionBuilder =
//     TrackAlbumCompanion Function({
//       Value<int> trackId,
//       Value<int> albumId,
//       Value<int> rowid,
//     });

// final class $$TrackAlbumTableReferences
//     extends BaseReferences<_$AppDatabase, $TrackAlbumTable, TrackAlbumData> {
//   $$TrackAlbumTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias(
//     $_aliasNameGenerator(db.trackAlbum.trackId, db.tracks.id),
//   );

//   $$TracksTableProcessedTableManager get trackId {
//     final $_column = $_itemColumn<int>('track_id')!;

//     final manager = $$TracksTableTableManager(
//       $_db,
//       $_db.tracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }

//   static $AlbumsTable _albumIdTable(_$AppDatabase db) => db.albums.createAlias(
//     $_aliasNameGenerator(db.trackAlbum.albumId, db.albums.id),
//   );

//   $$AlbumsTableProcessedTableManager get albumId {
//     final $_column = $_itemColumn<int>('album_id')!;

//     final manager = $$AlbumsTableTableManager(
//       $_db,
//       $_db.albums,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_albumIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$TrackAlbumTableFilterComposer
//     extends Composer<_$AppDatabase, $TrackAlbumTable> {
//   $$TrackAlbumTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableFilterComposer get trackId {
//     final $$TracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableFilterComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$AlbumsTableFilterComposer get albumId {
//     final $$AlbumsTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.albumId,
//       referencedTable: $db.albums,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumsTableFilterComposer(
//             $db: $db,
//             $table: $db.albums,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackAlbumTableOrderingComposer
//     extends Composer<_$AppDatabase, $TrackAlbumTable> {
//   $$TrackAlbumTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableOrderingComposer get trackId {
//     final $$TracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$AlbumsTableOrderingComposer get albumId {
//     final $$AlbumsTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.albumId,
//       referencedTable: $db.albums,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumsTableOrderingComposer(
//             $db: $db,
//             $table: $db.albums,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackAlbumTableAnnotationComposer
//     extends Composer<_$AppDatabase, $TrackAlbumTable> {
//   $$TrackAlbumTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableAnnotationComposer get trackId {
//     final $$TracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$AlbumsTableAnnotationComposer get albumId {
//     final $$AlbumsTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.albumId,
//       referencedTable: $db.albums,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$AlbumsTableAnnotationComposer(
//             $db: $db,
//             $table: $db.albums,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$TrackAlbumTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $TrackAlbumTable,
//           TrackAlbumData,
//           $$TrackAlbumTableFilterComposer,
//           $$TrackAlbumTableOrderingComposer,
//           $$TrackAlbumTableAnnotationComposer,
//           $$TrackAlbumTableCreateCompanionBuilder,
//           $$TrackAlbumTableUpdateCompanionBuilder,
//           (TrackAlbumData, $$TrackAlbumTableReferences),
//           TrackAlbumData,
//           PrefetchHooks Function({bool trackId, bool albumId})
//         > {
//   $$TrackAlbumTableTableManager(_$AppDatabase db, $TrackAlbumTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$TrackAlbumTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$TrackAlbumTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$TrackAlbumTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> trackId = const Value.absent(),
//                 Value<int> albumId = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => TrackAlbumCompanion(
//                 trackId: trackId,
//                 albumId: albumId,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int trackId,
//                 required int albumId,
//                 Value<int> rowid = const Value.absent(),
//               }) => TrackAlbumCompanion.insert(
//                 trackId: trackId,
//                 albumId: albumId,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$TrackAlbumTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({trackId = false, albumId = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [],
//               addJoins:
//                   <
//                     T extends TableManagerState<
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic
//                     >
//                   >(state) {
//                     if (trackId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.trackId,
//                                 referencedTable: $$TrackAlbumTableReferences
//                                     ._trackIdTable(db),
//                                 referencedColumn: $$TrackAlbumTableReferences
//                                     ._trackIdTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }
//                     if (albumId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.albumId,
//                                 referencedTable: $$TrackAlbumTableReferences
//                                     ._albumIdTable(db),
//                                 referencedColumn: $$TrackAlbumTableReferences
//                                     ._albumIdTable(db)
//                                     .id,
//                               )
//                               as T;
//                     }

//                     return state;
//                   },
//               getPrefetchedDataCallback: (items) async {
//                 return [];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$TrackAlbumTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $TrackAlbumTable,
//       TrackAlbumData,
//       $$TrackAlbumTableFilterComposer,
//       $$TrackAlbumTableOrderingComposer,
//       $$TrackAlbumTableAnnotationComposer,
//       $$TrackAlbumTableCreateCompanionBuilder,
//       $$TrackAlbumTableUpdateCompanionBuilder,
//       (TrackAlbumData, $$TrackAlbumTableReferences),
//       TrackAlbumData,
//       PrefetchHooks Function({bool trackId, bool albumId})
//     >;
// typedef $$DisclaimersTableCreateCompanionBuilder =
//     DisclaimersCompanion Function({Value<int> id, required String name});
// typedef $$DisclaimersTableUpdateCompanionBuilder =
//     DisclaimersCompanion Function({Value<int> id, Value<String> name});

// final class $$DisclaimersTableReferences
//     extends BaseReferences<_$AppDatabase, $DisclaimersTable, Disclaimer> {
//   $$DisclaimersTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static MultiTypedResultKey<
//     $YandexMusicTrackDisclaimerTable,
//     List<YandexMusicTrackDisclaimerData>
//   >
//   _yandexMusicTrackDisclaimerRefsTable(_$AppDatabase db) =>
//       MultiTypedResultKey.fromTable(
//         db.yandexMusicTrackDisclaimer,
//         aliasName: $_aliasNameGenerator(
//           db.disclaimers.id,
//           db.yandexMusicTrackDisclaimer.disclaimerId,
//         ),
//       );

//   $$YandexMusicTrackDisclaimerTableProcessedTableManager
//   get yandexMusicTrackDisclaimerRefs {
//     final manager = $$YandexMusicTrackDisclaimerTableTableManager(
//       $_db,
//       $_db.yandexMusicTrackDisclaimer,
//     ).filter((f) => f.disclaimerId.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(
//       _yandexMusicTrackDisclaimerRefsTable($_db),
//     );
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }
// }

// class $$DisclaimersTableFilterComposer
//     extends Composer<_$AppDatabase, $DisclaimersTable> {
//   $$DisclaimersTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get name => $composableBuilder(
//     column: $table.name,
//     builder: (column) => ColumnFilters(column),
//   );

//   Expression<bool> yandexMusicTrackDisclaimerRefs(
//     Expression<bool> Function($$YandexMusicTrackDisclaimerTableFilterComposer f)
//     f,
//   ) {
//     final $$YandexMusicTrackDisclaimerTableFilterComposer composer =
//         $composerBuilder(
//           composer: this,
//           getCurrentColumn: (t) => t.id,
//           referencedTable: $db.yandexMusicTrackDisclaimer,
//           getReferencedColumn: (t) => t.disclaimerId,
//           builder:
//               (
//                 joinBuilder, {
//                 $addJoinBuilderToRootComposer,
//                 $removeJoinBuilderFromRootComposer,
//               }) => $$YandexMusicTrackDisclaimerTableFilterComposer(
//                 $db: $db,
//                 $table: $db.yandexMusicTrackDisclaimer,
//                 $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//                 joinBuilder: joinBuilder,
//                 $removeJoinBuilderFromRootComposer:
//                     $removeJoinBuilderFromRootComposer,
//               ),
//         );
//     return f(composer);
//   }
// }

// class $$DisclaimersTableOrderingComposer
//     extends Composer<_$AppDatabase, $DisclaimersTable> {
//   $$DisclaimersTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<int> get id => $composableBuilder(
//     column: $table.id,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get name => $composableBuilder(
//     column: $table.name,
//     builder: (column) => ColumnOrderings(column),
//   );
// }

// class $$DisclaimersTableAnnotationComposer
//     extends Composer<_$AppDatabase, $DisclaimersTable> {
//   $$DisclaimersTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get id =>
//       $composableBuilder(column: $table.id, builder: (column) => column);

//   GeneratedColumn<String> get name =>
//       $composableBuilder(column: $table.name, builder: (column) => column);

//   Expression<T> yandexMusicTrackDisclaimerRefs<T extends Object>(
//     Expression<T> Function(
//       $$YandexMusicTrackDisclaimerTableAnnotationComposer a,
//     )
//     f,
//   ) {
//     final $$YandexMusicTrackDisclaimerTableAnnotationComposer composer =
//         $composerBuilder(
//           composer: this,
//           getCurrentColumn: (t) => t.id,
//           referencedTable: $db.yandexMusicTrackDisclaimer,
//           getReferencedColumn: (t) => t.disclaimerId,
//           builder:
//               (
//                 joinBuilder, {
//                 $addJoinBuilderToRootComposer,
//                 $removeJoinBuilderFromRootComposer,
//               }) => $$YandexMusicTrackDisclaimerTableAnnotationComposer(
//                 $db: $db,
//                 $table: $db.yandexMusicTrackDisclaimer,
//                 $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//                 joinBuilder: joinBuilder,
//                 $removeJoinBuilderFromRootComposer:
//                     $removeJoinBuilderFromRootComposer,
//               ),
//         );
//     return f(composer);
//   }
// }

// class $$DisclaimersTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $DisclaimersTable,
//           Disclaimer,
//           $$DisclaimersTableFilterComposer,
//           $$DisclaimersTableOrderingComposer,
//           $$DisclaimersTableAnnotationComposer,
//           $$DisclaimersTableCreateCompanionBuilder,
//           $$DisclaimersTableUpdateCompanionBuilder,
//           (Disclaimer, $$DisclaimersTableReferences),
//           Disclaimer,
//           PrefetchHooks Function({bool yandexMusicTrackDisclaimerRefs})
//         > {
//   $$DisclaimersTableTableManager(_$AppDatabase db, $DisclaimersTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$DisclaimersTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$DisclaimersTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$DisclaimersTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String> name = const Value.absent(),
//               }) => DisclaimersCompanion(id: id, name: name),
//           createCompanionCallback:
//               ({Value<int> id = const Value.absent(), required String name}) =>
//                   DisclaimersCompanion.insert(id: id, name: name),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$DisclaimersTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({yandexMusicTrackDisclaimerRefs = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [
//                 if (yandexMusicTrackDisclaimerRefs)
//                   db.yandexMusicTrackDisclaimer,
//               ],
//               addJoins: null,
//               getPrefetchedDataCallback: (items) async {
//                 return [
//                   if (yandexMusicTrackDisclaimerRefs)
//                     await $_getPrefetchedData<
//                       Disclaimer,
//                       $DisclaimersTable,
//                       YandexMusicTrackDisclaimerData
//                     >(
//                       currentTable: table,
//                       referencedTable: $$DisclaimersTableReferences
//                           ._yandexMusicTrackDisclaimerRefsTable(db),
//                       managerFromTypedResult: (p0) =>
//                           $$DisclaimersTableReferences(
//                             db,
//                             table,
//                             p0,
//                           ).yandexMusicTrackDisclaimerRefs,
//                       referencedItemsForCurrentItem: (item, referencedItems) =>
//                           referencedItems.where(
//                             (e) => e.disclaimerId == item.id,
//                           ),
//                       typedResults: items,
//                     ),
//                 ];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$DisclaimersTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $DisclaimersTable,
//       Disclaimer,
//       $$DisclaimersTableFilterComposer,
//       $$DisclaimersTableOrderingComposer,
//       $$DisclaimersTableAnnotationComposer,
//       $$DisclaimersTableCreateCompanionBuilder,
//       $$DisclaimersTableUpdateCompanionBuilder,
//       (Disclaimer, $$DisclaimersTableReferences),
//       Disclaimer,
//       PrefetchHooks Function({bool yandexMusicTrackDisclaimerRefs})
//     >;
// typedef $$YandexMusicAditionalTrackInfoTableCreateCompanionBuilder =
//     YandexMusicAditionalTrackInfoCompanion Function({
//       required int id,
//       Value<int?> realId,
//       Value<String?> trackSharingFlag,
//       Value<String?> trackSource,
//       Value<double?> r128i,
//       Value<double?> r128tp,
//       Value<double?> fadeInStart,
//       Value<double?> fadeInStop,
//       Value<double?> fadeOutStart,
//       Value<double?> fadeOutStop,
//       Value<String?> averageColor,
//       Value<String?> waveTextColor,
//       Value<String?> miniPlayerColor,
//       Value<String?> accentColor,
//       Value<int> rowid,
//     });
// typedef $$YandexMusicAditionalTrackInfoTableUpdateCompanionBuilder =
//     YandexMusicAditionalTrackInfoCompanion Function({
//       Value<int> id,
//       Value<int?> realId,
//       Value<String?> trackSharingFlag,
//       Value<String?> trackSource,
//       Value<double?> r128i,
//       Value<double?> r128tp,
//       Value<double?> fadeInStart,
//       Value<double?> fadeInStop,
//       Value<double?> fadeOutStart,
//       Value<double?> fadeOutStop,
//       Value<String?> averageColor,
//       Value<String?> waveTextColor,
//       Value<String?> miniPlayerColor,
//       Value<String?> accentColor,
//       Value<int> rowid,
//     });

// final class $$YandexMusicAditionalTrackInfoTableReferences
//     extends
//         BaseReferences<
//           _$AppDatabase,
//           $YandexMusicAditionalTrackInfoTable,
//           YandexMusicAditionalTrackInfoData
//         > {
//   $$YandexMusicAditionalTrackInfoTableReferences(
//     super.$_db,
//     super.$_table,
//     super.$_typedResult,
//   );

//   static $TracksTable _idTable(_$AppDatabase db) => db.tracks.createAlias(
//     $_aliasNameGenerator(db.yandexMusicAditionalTrackInfo.id, db.tracks.id),
//   );

//   $$TracksTableProcessedTableManager get id {
//     final $_column = $_itemColumn<int>('id')!;

//     final manager = $$TracksTableTableManager(
//       $_db,
//       $_db.tracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_idTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$YandexMusicAditionalTrackInfoTableFilterComposer
//     extends Composer<_$AppDatabase, $YandexMusicAditionalTrackInfoTable> {
//   $$YandexMusicAditionalTrackInfoTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<int> get realId => $composableBuilder(
//     column: $table.realId,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get trackSharingFlag => $composableBuilder(
//     column: $table.trackSharingFlag,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get trackSource => $composableBuilder(
//     column: $table.trackSource,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<double> get r128i => $composableBuilder(
//     column: $table.r128i,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<double> get r128tp => $composableBuilder(
//     column: $table.r128tp,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<double> get fadeInStart => $composableBuilder(
//     column: $table.fadeInStart,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<double> get fadeInStop => $composableBuilder(
//     column: $table.fadeInStop,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<double> get fadeOutStart => $composableBuilder(
//     column: $table.fadeOutStart,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<double> get fadeOutStop => $composableBuilder(
//     column: $table.fadeOutStop,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get averageColor => $composableBuilder(
//     column: $table.averageColor,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get waveTextColor => $composableBuilder(
//     column: $table.waveTextColor,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get miniPlayerColor => $composableBuilder(
//     column: $table.miniPlayerColor,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get accentColor => $composableBuilder(
//     column: $table.accentColor,
//     builder: (column) => ColumnFilters(column),
//   );

//   $$TracksTableFilterComposer get id {
//     final $$TracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableFilterComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$YandexMusicAditionalTrackInfoTableOrderingComposer
//     extends Composer<_$AppDatabase, $YandexMusicAditionalTrackInfoTable> {
//   $$YandexMusicAditionalTrackInfoTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<int> get realId => $composableBuilder(
//     column: $table.realId,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get trackSharingFlag => $composableBuilder(
//     column: $table.trackSharingFlag,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get trackSource => $composableBuilder(
//     column: $table.trackSource,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<double> get r128i => $composableBuilder(
//     column: $table.r128i,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<double> get r128tp => $composableBuilder(
//     column: $table.r128tp,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<double> get fadeInStart => $composableBuilder(
//     column: $table.fadeInStart,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<double> get fadeInStop => $composableBuilder(
//     column: $table.fadeInStop,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<double> get fadeOutStart => $composableBuilder(
//     column: $table.fadeOutStart,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<double> get fadeOutStop => $composableBuilder(
//     column: $table.fadeOutStop,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get averageColor => $composableBuilder(
//     column: $table.averageColor,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get waveTextColor => $composableBuilder(
//     column: $table.waveTextColor,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get miniPlayerColor => $composableBuilder(
//     column: $table.miniPlayerColor,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get accentColor => $composableBuilder(
//     column: $table.accentColor,
//     builder: (column) => ColumnOrderings(column),
//   );

//   $$TracksTableOrderingComposer get id {
//     final $$TracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$YandexMusicAditionalTrackInfoTableAnnotationComposer
//     extends Composer<_$AppDatabase, $YandexMusicAditionalTrackInfoTable> {
//   $$YandexMusicAditionalTrackInfoTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get realId =>
//       $composableBuilder(column: $table.realId, builder: (column) => column);

//   GeneratedColumn<String> get trackSharingFlag => $composableBuilder(
//     column: $table.trackSharingFlag,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get trackSource => $composableBuilder(
//     column: $table.trackSource,
//     builder: (column) => column,
//   );

//   GeneratedColumn<double> get r128i =>
//       $composableBuilder(column: $table.r128i, builder: (column) => column);

//   GeneratedColumn<double> get r128tp =>
//       $composableBuilder(column: $table.r128tp, builder: (column) => column);

//   GeneratedColumn<double> get fadeInStart => $composableBuilder(
//     column: $table.fadeInStart,
//     builder: (column) => column,
//   );

//   GeneratedColumn<double> get fadeInStop => $composableBuilder(
//     column: $table.fadeInStop,
//     builder: (column) => column,
//   );

//   GeneratedColumn<double> get fadeOutStart => $composableBuilder(
//     column: $table.fadeOutStart,
//     builder: (column) => column,
//   );

//   GeneratedColumn<double> get fadeOutStop => $composableBuilder(
//     column: $table.fadeOutStop,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get averageColor => $composableBuilder(
//     column: $table.averageColor,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get waveTextColor => $composableBuilder(
//     column: $table.waveTextColor,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get miniPlayerColor => $composableBuilder(
//     column: $table.miniPlayerColor,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get accentColor => $composableBuilder(
//     column: $table.accentColor,
//     builder: (column) => column,
//   );

//   $$TracksTableAnnotationComposer get id {
//     final $$TracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$YandexMusicAditionalTrackInfoTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $YandexMusicAditionalTrackInfoTable,
//           YandexMusicAditionalTrackInfoData,
//           $$YandexMusicAditionalTrackInfoTableFilterComposer,
//           $$YandexMusicAditionalTrackInfoTableOrderingComposer,
//           $$YandexMusicAditionalTrackInfoTableAnnotationComposer,
//           $$YandexMusicAditionalTrackInfoTableCreateCompanionBuilder,
//           $$YandexMusicAditionalTrackInfoTableUpdateCompanionBuilder,
//           (
//             YandexMusicAditionalTrackInfoData,
//             $$YandexMusicAditionalTrackInfoTableReferences,
//           ),
//           YandexMusicAditionalTrackInfoData,
//           PrefetchHooks Function({bool id})
//         > {
//   $$YandexMusicAditionalTrackInfoTableTableManager(
//     _$AppDatabase db,
//     $YandexMusicAditionalTrackInfoTable table,
//   ) : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$YandexMusicAditionalTrackInfoTableFilterComposer(
//                 $db: db,
//                 $table: table,
//               ),
//           createOrderingComposer: () =>
//               $$YandexMusicAditionalTrackInfoTableOrderingComposer(
//                 $db: db,
//                 $table: table,
//               ),
//           createComputedFieldComposer: () =>
//               $$YandexMusicAditionalTrackInfoTableAnnotationComposer(
//                 $db: db,
//                 $table: table,
//               ),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<int?> realId = const Value.absent(),
//                 Value<String?> trackSharingFlag = const Value.absent(),
//                 Value<String?> trackSource = const Value.absent(),
//                 Value<double?> r128i = const Value.absent(),
//                 Value<double?> r128tp = const Value.absent(),
//                 Value<double?> fadeInStart = const Value.absent(),
//                 Value<double?> fadeInStop = const Value.absent(),
//                 Value<double?> fadeOutStart = const Value.absent(),
//                 Value<double?> fadeOutStop = const Value.absent(),
//                 Value<String?> averageColor = const Value.absent(),
//                 Value<String?> waveTextColor = const Value.absent(),
//                 Value<String?> miniPlayerColor = const Value.absent(),
//                 Value<String?> accentColor = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => YandexMusicAditionalTrackInfoCompanion(
//                 id: id,
//                 realId: realId,
//                 trackSharingFlag: trackSharingFlag,
//                 trackSource: trackSource,
//                 r128i: r128i,
//                 r128tp: r128tp,
//                 fadeInStart: fadeInStart,
//                 fadeInStop: fadeInStop,
//                 fadeOutStart: fadeOutStart,
//                 fadeOutStop: fadeOutStop,
//                 averageColor: averageColor,
//                 waveTextColor: waveTextColor,
//                 miniPlayerColor: miniPlayerColor,
//                 accentColor: accentColor,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int id,
//                 Value<int?> realId = const Value.absent(),
//                 Value<String?> trackSharingFlag = const Value.absent(),
//                 Value<String?> trackSource = const Value.absent(),
//                 Value<double?> r128i = const Value.absent(),
//                 Value<double?> r128tp = const Value.absent(),
//                 Value<double?> fadeInStart = const Value.absent(),
//                 Value<double?> fadeInStop = const Value.absent(),
//                 Value<double?> fadeOutStart = const Value.absent(),
//                 Value<double?> fadeOutStop = const Value.absent(),
//                 Value<String?> averageColor = const Value.absent(),
//                 Value<String?> waveTextColor = const Value.absent(),
//                 Value<String?> miniPlayerColor = const Value.absent(),
//                 Value<String?> accentColor = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => YandexMusicAditionalTrackInfoCompanion.insert(
//                 id: id,
//                 realId: realId,
//                 trackSharingFlag: trackSharingFlag,
//                 trackSource: trackSource,
//                 r128i: r128i,
//                 r128tp: r128tp,
//                 fadeInStart: fadeInStart,
//                 fadeInStop: fadeInStop,
//                 fadeOutStart: fadeOutStart,
//                 fadeOutStop: fadeOutStop,
//                 averageColor: averageColor,
//                 waveTextColor: waveTextColor,
//                 miniPlayerColor: miniPlayerColor,
//                 accentColor: accentColor,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$YandexMusicAditionalTrackInfoTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({id = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [],
//               addJoins:
//                   <
//                     T extends TableManagerState<
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic
//                     >
//                   >(state) {
//                     if (id) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.id,
//                                 referencedTable:
//                                     $$YandexMusicAditionalTrackInfoTableReferences
//                                         ._idTable(db),
//                                 referencedColumn:
//                                     $$YandexMusicAditionalTrackInfoTableReferences
//                                         ._idTable(db)
//                                         .id,
//                               )
//                               as T;
//                     }

//                     return state;
//                   },
//               getPrefetchedDataCallback: (items) async {
//                 return [];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$YandexMusicAditionalTrackInfoTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $YandexMusicAditionalTrackInfoTable,
//       YandexMusicAditionalTrackInfoData,
//       $$YandexMusicAditionalTrackInfoTableFilterComposer,
//       $$YandexMusicAditionalTrackInfoTableOrderingComposer,
//       $$YandexMusicAditionalTrackInfoTableAnnotationComposer,
//       $$YandexMusicAditionalTrackInfoTableCreateCompanionBuilder,
//       $$YandexMusicAditionalTrackInfoTableUpdateCompanionBuilder,
//       (
//         YandexMusicAditionalTrackInfoData,
//         $$YandexMusicAditionalTrackInfoTableReferences,
//       ),
//       YandexMusicAditionalTrackInfoData,
//       PrefetchHooks Function({bool id})
//     >;
// typedef $$YandexMusicTrackDisclaimerTableCreateCompanionBuilder =
//     YandexMusicTrackDisclaimerCompanion Function({
//       required int trackId,
//       required int disclaimerId,
//       Value<int> rowid,
//     });
// typedef $$YandexMusicTrackDisclaimerTableUpdateCompanionBuilder =
//     YandexMusicTrackDisclaimerCompanion Function({
//       Value<int> trackId,
//       Value<int> disclaimerId,
//       Value<int> rowid,
//     });

// final class $$YandexMusicTrackDisclaimerTableReferences
//     extends
//         BaseReferences<
//           _$AppDatabase,
//           $YandexMusicTrackDisclaimerTable,
//           YandexMusicTrackDisclaimerData
//         > {
//   $$YandexMusicTrackDisclaimerTableReferences(
//     super.$_db,
//     super.$_table,
//     super.$_typedResult,
//   );

//   static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias(
//     $_aliasNameGenerator(db.yandexMusicTrackDisclaimer.trackId, db.tracks.id),
//   );

//   $$TracksTableProcessedTableManager get trackId {
//     final $_column = $_itemColumn<int>('track_id')!;

//     final manager = $$TracksTableTableManager(
//       $_db,
//       $_db.tracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }

//   static $DisclaimersTable _disclaimerIdTable(_$AppDatabase db) =>
//       db.disclaimers.createAlias(
//         $_aliasNameGenerator(
//           db.yandexMusicTrackDisclaimer.disclaimerId,
//           db.disclaimers.id,
//         ),
//       );

//   $$DisclaimersTableProcessedTableManager get disclaimerId {
//     final $_column = $_itemColumn<int>('disclaimer_id')!;

//     final manager = $$DisclaimersTableTableManager(
//       $_db,
//       $_db.disclaimers,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_disclaimerIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$YandexMusicTrackDisclaimerTableFilterComposer
//     extends Composer<_$AppDatabase, $YandexMusicTrackDisclaimerTable> {
//   $$YandexMusicTrackDisclaimerTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableFilterComposer get trackId {
//     final $$TracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableFilterComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$DisclaimersTableFilterComposer get disclaimerId {
//     final $$DisclaimersTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.disclaimerId,
//       referencedTable: $db.disclaimers,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$DisclaimersTableFilterComposer(
//             $db: $db,
//             $table: $db.disclaimers,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$YandexMusicTrackDisclaimerTableOrderingComposer
//     extends Composer<_$AppDatabase, $YandexMusicTrackDisclaimerTable> {
//   $$YandexMusicTrackDisclaimerTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableOrderingComposer get trackId {
//     final $$TracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$DisclaimersTableOrderingComposer get disclaimerId {
//     final $$DisclaimersTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.disclaimerId,
//       referencedTable: $db.disclaimers,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$DisclaimersTableOrderingComposer(
//             $db: $db,
//             $table: $db.disclaimers,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$YandexMusicTrackDisclaimerTableAnnotationComposer
//     extends Composer<_$AppDatabase, $YandexMusicTrackDisclaimerTable> {
//   $$YandexMusicTrackDisclaimerTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableAnnotationComposer get trackId {
//     final $$TracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$DisclaimersTableAnnotationComposer get disclaimerId {
//     final $$DisclaimersTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.disclaimerId,
//       referencedTable: $db.disclaimers,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$DisclaimersTableAnnotationComposer(
//             $db: $db,
//             $table: $db.disclaimers,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$YandexMusicTrackDisclaimerTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $YandexMusicTrackDisclaimerTable,
//           YandexMusicTrackDisclaimerData,
//           $$YandexMusicTrackDisclaimerTableFilterComposer,
//           $$YandexMusicTrackDisclaimerTableOrderingComposer,
//           $$YandexMusicTrackDisclaimerTableAnnotationComposer,
//           $$YandexMusicTrackDisclaimerTableCreateCompanionBuilder,
//           $$YandexMusicTrackDisclaimerTableUpdateCompanionBuilder,
//           (
//             YandexMusicTrackDisclaimerData,
//             $$YandexMusicTrackDisclaimerTableReferences,
//           ),
//           YandexMusicTrackDisclaimerData,
//           PrefetchHooks Function({bool trackId, bool disclaimerId})
//         > {
//   $$YandexMusicTrackDisclaimerTableTableManager(
//     _$AppDatabase db,
//     $YandexMusicTrackDisclaimerTable table,
//   ) : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$YandexMusicTrackDisclaimerTableFilterComposer(
//                 $db: db,
//                 $table: table,
//               ),
//           createOrderingComposer: () =>
//               $$YandexMusicTrackDisclaimerTableOrderingComposer(
//                 $db: db,
//                 $table: table,
//               ),
//           createComputedFieldComposer: () =>
//               $$YandexMusicTrackDisclaimerTableAnnotationComposer(
//                 $db: db,
//                 $table: table,
//               ),
//           updateCompanionCallback:
//               ({
//                 Value<int> trackId = const Value.absent(),
//                 Value<int> disclaimerId = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => YandexMusicTrackDisclaimerCompanion(
//                 trackId: trackId,
//                 disclaimerId: disclaimerId,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int trackId,
//                 required int disclaimerId,
//                 Value<int> rowid = const Value.absent(),
//               }) => YandexMusicTrackDisclaimerCompanion.insert(
//                 trackId: trackId,
//                 disclaimerId: disclaimerId,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$YandexMusicTrackDisclaimerTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({trackId = false, disclaimerId = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [],
//               addJoins:
//                   <
//                     T extends TableManagerState<
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic
//                     >
//                   >(state) {
//                     if (trackId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.trackId,
//                                 referencedTable:
//                                     $$YandexMusicTrackDisclaimerTableReferences
//                                         ._trackIdTable(db),
//                                 referencedColumn:
//                                     $$YandexMusicTrackDisclaimerTableReferences
//                                         ._trackIdTable(db)
//                                         .id,
//                               )
//                               as T;
//                     }
//                     if (disclaimerId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.disclaimerId,
//                                 referencedTable:
//                                     $$YandexMusicTrackDisclaimerTableReferences
//                                         ._disclaimerIdTable(db),
//                                 referencedColumn:
//                                     $$YandexMusicTrackDisclaimerTableReferences
//                                         ._disclaimerIdTable(db)
//                                         .id,
//                               )
//                               as T;
//                     }

//                     return state;
//                   },
//               getPrefetchedDataCallback: (items) async {
//                 return [];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$YandexMusicTrackDisclaimerTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $YandexMusicTrackDisclaimerTable,
//       YandexMusicTrackDisclaimerData,
//       $$YandexMusicTrackDisclaimerTableFilterComposer,
//       $$YandexMusicTrackDisclaimerTableOrderingComposer,
//       $$YandexMusicTrackDisclaimerTableAnnotationComposer,
//       $$YandexMusicTrackDisclaimerTableCreateCompanionBuilder,
//       $$YandexMusicTrackDisclaimerTableUpdateCompanionBuilder,
//       (
//         YandexMusicTrackDisclaimerData,
//         $$YandexMusicTrackDisclaimerTableReferences,
//       ),
//       YandexMusicTrackDisclaimerData,
//       PrefetchHooks Function({bool trackId, bool disclaimerId})
//     >;
// typedef $$PlaylistTracksTableCreateCompanionBuilder =
//     PlaylistTracksCompanion Function({
//       required int trackId,
//       required int playlistId,
//       Value<int> rowid,
//     });
// typedef $$PlaylistTracksTableUpdateCompanionBuilder =
//     PlaylistTracksCompanion Function({
//       Value<int> trackId,
//       Value<int> playlistId,
//       Value<int> rowid,
//     });

// final class $$PlaylistTracksTableReferences
//     extends BaseReferences<_$AppDatabase, $PlaylistTracksTable, PlaylistTrack> {
//   $$PlaylistTracksTableReferences(
//     super.$_db,
//     super.$_table,
//     super.$_typedResult,
//   );

//   static $TracksTable _trackIdTable(_$AppDatabase db) => db.tracks.createAlias(
//     $_aliasNameGenerator(db.playlistTracks.trackId, db.tracks.id),
//   );

//   $$TracksTableProcessedTableManager get trackId {
//     final $_column = $_itemColumn<int>('track_id')!;

//     final manager = $$TracksTableTableManager(
//       $_db,
//       $_db.tracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_trackIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }

//   static $PlaylistsTable _playlistIdTable(_$AppDatabase db) =>
//       db.playlists.createAlias(
//         $_aliasNameGenerator(db.playlistTracks.playlistId, db.playlists.id),
//       );

//   $$PlaylistsTableProcessedTableManager get playlistId {
//     final $_column = $_itemColumn<int>('playlist_id')!;

//     final manager = $$PlaylistsTableTableManager(
//       $_db,
//       $_db.playlists,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_playlistIdTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$PlaylistTracksTableFilterComposer
//     extends Composer<_$AppDatabase, $PlaylistTracksTable> {
//   $$PlaylistTracksTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableFilterComposer get trackId {
//     final $$TracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableFilterComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$PlaylistsTableFilterComposer get playlistId {
//     final $$PlaylistsTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.playlistId,
//       referencedTable: $db.playlists,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistsTableFilterComposer(
//             $db: $db,
//             $table: $db.playlists,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$PlaylistTracksTableOrderingComposer
//     extends Composer<_$AppDatabase, $PlaylistTracksTable> {
//   $$PlaylistTracksTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableOrderingComposer get trackId {
//     final $$TracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$PlaylistsTableOrderingComposer get playlistId {
//     final $$PlaylistsTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.playlistId,
//       referencedTable: $db.playlists,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistsTableOrderingComposer(
//             $db: $db,
//             $table: $db.playlists,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$PlaylistTracksTableAnnotationComposer
//     extends Composer<_$AppDatabase, $PlaylistTracksTable> {
//   $$PlaylistTracksTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   $$TracksTableAnnotationComposer get trackId {
//     final $$TracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.trackId,
//       referencedTable: $db.tracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$TracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.tracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$PlaylistsTableAnnotationComposer get playlistId {
//     final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.playlistId,
//       referencedTable: $db.playlists,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$PlaylistsTableAnnotationComposer(
//             $db: $db,
//             $table: $db.playlists,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$PlaylistTracksTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $PlaylistTracksTable,
//           PlaylistTrack,
//           $$PlaylistTracksTableFilterComposer,
//           $$PlaylistTracksTableOrderingComposer,
//           $$PlaylistTracksTableAnnotationComposer,
//           $$PlaylistTracksTableCreateCompanionBuilder,
//           $$PlaylistTracksTableUpdateCompanionBuilder,
//           (PlaylistTrack, $$PlaylistTracksTableReferences),
//           PlaylistTrack,
//           PrefetchHooks Function({bool trackId, bool playlistId})
//         > {
//   $$PlaylistTracksTableTableManager(
//     _$AppDatabase db,
//     $PlaylistTracksTable table,
//   ) : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$PlaylistTracksTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$PlaylistTracksTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$PlaylistTracksTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> trackId = const Value.absent(),
//                 Value<int> playlistId = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => PlaylistTracksCompanion(
//                 trackId: trackId,
//                 playlistId: playlistId,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int trackId,
//                 required int playlistId,
//                 Value<int> rowid = const Value.absent(),
//               }) => PlaylistTracksCompanion.insert(
//                 trackId: trackId,
//                 playlistId: playlistId,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$PlaylistTracksTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({trackId = false, playlistId = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [],
//               addJoins:
//                   <
//                     T extends TableManagerState<
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic,
//                       dynamic
//                     >
//                   >(state) {
//                     if (trackId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.trackId,
//                                 referencedTable: $$PlaylistTracksTableReferences
//                                     ._trackIdTable(db),
//                                 referencedColumn:
//                                     $$PlaylistTracksTableReferences
//                                         ._trackIdTable(db)
//                                         .id,
//                               )
//                               as T;
//                     }
//                     if (playlistId) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.playlistId,
//                                 referencedTable: $$PlaylistTracksTableReferences
//                                     ._playlistIdTable(db),
//                                 referencedColumn:
//                                     $$PlaylistTracksTableReferences
//                                         ._playlistIdTable(db)
//                                         .id,
//                               )
//                               as T;
//                     }

//                     return state;
//                   },
//               getPrefetchedDataCallback: (items) async {
//                 return [];
//               },
//             );
//           },
//         ),
//       );
// }

// typedef $$PlaylistTracksTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $PlaylistTracksTable,
//       PlaylistTrack,
//       $$PlaylistTracksTableFilterComposer,
//       $$PlaylistTracksTableOrderingComposer,
//       $$PlaylistTracksTableAnnotationComposer,
//       $$PlaylistTracksTableCreateCompanionBuilder,
//       $$PlaylistTracksTableUpdateCompanionBuilder,
//       (PlaylistTrack, $$PlaylistTracksTableReferences),
//       PlaylistTrack,
//       PrefetchHooks Function({bool trackId, bool playlistId})
//     >;

// class $AppDatabaseManager {
//   final _$AppDatabase _db;
//   $AppDatabaseManager(this._db);
//   $$TracksTableTableManager get tracks =>
//       $$TracksTableTableManager(_db, _db.tracks);
//   $$SettingsTableTableManager get settings =>
//       $$SettingsTableTableManager(_db, _db.settings);
//   $$PlaylistsTableTableManager get playlists =>
//       $$PlaylistsTableTableManager(_db, _db.playlists);
//   $$ArtistsTableTableManager get artists =>
//       $$ArtistsTableTableManager(_db, _db.artists);
//   $$AlbumsTableTableManager get albums =>
//       $$AlbumsTableTableManager(_db, _db.albums);
//   $$GenresTableTableManager get genres =>
//       $$GenresTableTableManager(_db, _db.genres);
//   $$TrackGenreTableTableManager get trackGenre =>
//       $$TrackGenreTableTableManager(_db, _db.trackGenre);
//   $$AlbumGenreTableTableManager get albumGenre =>
//       $$AlbumGenreTableTableManager(_db, _db.albumGenre);
//   $$TrackArtistTableTableManager get trackArtist =>
//       $$TrackArtistTableTableManager(_db, _db.trackArtist);
//   $$TrackAlbumTableTableManager get trackAlbum =>
//       $$TrackAlbumTableTableManager(_db, _db.trackAlbum);
//   $$DisclaimersTableTableManager get disclaimers =>
//       $$DisclaimersTableTableManager(_db, _db.disclaimers);
//   $$YandexMusicAditionalTrackInfoTableTableManager
//   get yandexMusicAditionalTrackInfo =>
//       $$YandexMusicAditionalTrackInfoTableTableManager(
//         _db,
//         _db.yandexMusicAditionalTrackInfo,
//       );
//   $$YandexMusicTrackDisclaimerTableTableManager
//   get yandexMusicTrackDisclaimer =>
//       $$YandexMusicTrackDisclaimerTableTableManager(
//         _db,
//         _db.yandexMusicTrackDisclaimer,
//       );
//   $$PlaylistTracksTableTableManager get playlistTracks =>
//       $$PlaylistTracksTableTableManager(_db, _db.playlistTracks);
// }
