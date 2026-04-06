// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'library_engine.dart';

// // ignore_for_file: type=lint
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
//   static const VerificationMeta _titleMeta = const VerificationMeta('title');
//   @override
//   late final GeneratedColumn<String> title = GeneratedColumn<String>(
//     'title',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
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
//   static const VerificationMeta _blurCoverPathMeta = const VerificationMeta(
//     'blurCoverPath',
//   );
//   @override
//   late final GeneratedColumn<String> blurCoverPath = GeneratedColumn<String>(
//     'blur_cover_path',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _typeMeta = const VerificationMeta('type');
//   @override
//   late final GeneratedColumn<String> type = GeneratedColumn<String>(
//     'type',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//     defaultValue: const Constant("Playlist"),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     id,
//     title,
//     coverUrl,
//     coverPath,
//     description,
//     blurCoverPath,
//     type,
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
//     if (data.containsKey('title')) {
//       context.handle(
//         _titleMeta,
//         title.isAcceptableOrUnknown(data['title']!, _titleMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_titleMeta);
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
//     if (data.containsKey('blur_cover_path')) {
//       context.handle(
//         _blurCoverPathMeta,
//         blurCoverPath.isAcceptableOrUnknown(
//           data['blur_cover_path']!,
//           _blurCoverPathMeta,
//         ),
//       );
//     }
//     if (data.containsKey('type')) {
//       context.handle(
//         _typeMeta,
//         type.isAcceptableOrUnknown(data['type']!, _typeMeta),
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
//       title: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}title'],
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
//       blurCoverPath: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}blur_cover_path'],
//       ),
//       type: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}type'],
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
//   final String title;
//   final String? coverUrl;
//   final String? coverPath;
//   final String? description;
//   final String? blurCoverPath;
//   final String type;
//   const Playlist({
//     required this.id,
//     required this.title,
//     this.coverUrl,
//     this.coverPath,
//     this.description,
//     this.blurCoverPath,
//     required this.type,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     map['title'] = Variable<String>(title);
//     if (!nullToAbsent || coverUrl != null) {
//       map['cover_url'] = Variable<String>(coverUrl);
//     }
//     if (!nullToAbsent || coverPath != null) {
//       map['cover_path'] = Variable<String>(coverPath);
//     }
//     if (!nullToAbsent || description != null) {
//       map['description'] = Variable<String>(description);
//     }
//     if (!nullToAbsent || blurCoverPath != null) {
//       map['blur_cover_path'] = Variable<String>(blurCoverPath);
//     }
//     map['type'] = Variable<String>(type);
//     return map;
//   }

//   PlaylistsCompanion toCompanion(bool nullToAbsent) {
//     return PlaylistsCompanion(
//       id: Value(id),
//       title: Value(title),
//       coverUrl: coverUrl == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverUrl),
//       coverPath: coverPath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverPath),
//       description: description == null && nullToAbsent
//           ? const Value.absent()
//           : Value(description),
//       blurCoverPath: blurCoverPath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(blurCoverPath),
//       type: Value(type),
//     );
//   }

//   factory Playlist.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return Playlist(
//       id: serializer.fromJson<int>(json['id']),
//       title: serializer.fromJson<String>(json['title']),
//       coverUrl: serializer.fromJson<String?>(json['coverUrl']),
//       coverPath: serializer.fromJson<String?>(json['coverPath']),
//       description: serializer.fromJson<String?>(json['description']),
//       blurCoverPath: serializer.fromJson<String?>(json['blurCoverPath']),
//       type: serializer.fromJson<String>(json['type']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'title': serializer.toJson<String>(title),
//       'coverUrl': serializer.toJson<String?>(coverUrl),
//       'coverPath': serializer.toJson<String?>(coverPath),
//       'description': serializer.toJson<String?>(description),
//       'blurCoverPath': serializer.toJson<String?>(blurCoverPath),
//       'type': serializer.toJson<String>(type),
//     };
//   }

//   Playlist copyWith({
//     int? id,
//     String? title,
//     Value<String?> coverUrl = const Value.absent(),
//     Value<String?> coverPath = const Value.absent(),
//     Value<String?> description = const Value.absent(),
//     Value<String?> blurCoverPath = const Value.absent(),
//     String? type,
//   }) => Playlist(
//     id: id ?? this.id,
//     title: title ?? this.title,
//     coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
//     coverPath: coverPath.present ? coverPath.value : this.coverPath,
//     description: description.present ? description.value : this.description,
//     blurCoverPath: blurCoverPath.present
//         ? blurCoverPath.value
//         : this.blurCoverPath,
//     type: type ?? this.type,
//   );
//   Playlist copyWithCompanion(PlaylistsCompanion data) {
//     return Playlist(
//       id: data.id.present ? data.id.value : this.id,
//       title: data.title.present ? data.title.value : this.title,
//       coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
//       coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
//       description: data.description.present
//           ? data.description.value
//           : this.description,
//       blurCoverPath: data.blurCoverPath.present
//           ? data.blurCoverPath.value
//           : this.blurCoverPath,
//       type: data.type.present ? data.type.value : this.type,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('Playlist(')
//           ..write('id: $id, ')
//           ..write('title: $title, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('description: $description, ')
//           ..write('blurCoverPath: $blurCoverPath, ')
//           ..write('type: $type')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(
//     id,
//     title,
//     coverUrl,
//     coverPath,
//     description,
//     blurCoverPath,
//     type,
//   );
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is Playlist &&
//           other.id == this.id &&
//           other.title == this.title &&
//           other.coverUrl == this.coverUrl &&
//           other.coverPath == this.coverPath &&
//           other.description == this.description &&
//           other.blurCoverPath == this.blurCoverPath &&
//           other.type == this.type);
// }

// class PlaylistsCompanion extends UpdateCompanion<Playlist> {
//   final Value<int> id;
//   final Value<String> title;
//   final Value<String?> coverUrl;
//   final Value<String?> coverPath;
//   final Value<String?> description;
//   final Value<String?> blurCoverPath;
//   final Value<String> type;
//   const PlaylistsCompanion({
//     this.id = const Value.absent(),
//     this.title = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.description = const Value.absent(),
//     this.blurCoverPath = const Value.absent(),
//     this.type = const Value.absent(),
//   });
//   PlaylistsCompanion.insert({
//     this.id = const Value.absent(),
//     required String title,
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.description = const Value.absent(),
//     this.blurCoverPath = const Value.absent(),
//     this.type = const Value.absent(),
//   }) : title = Value(title);
//   static Insertable<Playlist> custom({
//     Expression<int>? id,
//     Expression<String>? title,
//     Expression<String>? coverUrl,
//     Expression<String>? coverPath,
//     Expression<String>? description,
//     Expression<String>? blurCoverPath,
//     Expression<String>? type,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (title != null) 'title': title,
//       if (coverUrl != null) 'cover_url': coverUrl,
//       if (coverPath != null) 'cover_path': coverPath,
//       if (description != null) 'description': description,
//       if (blurCoverPath != null) 'blur_cover_path': blurCoverPath,
//       if (type != null) 'type': type,
//     });
//   }

//   PlaylistsCompanion copyWith({
//     Value<int>? id,
//     Value<String>? title,
//     Value<String?>? coverUrl,
//     Value<String?>? coverPath,
//     Value<String?>? description,
//     Value<String?>? blurCoverPath,
//     Value<String>? type,
//   }) {
//     return PlaylistsCompanion(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       coverUrl: coverUrl ?? this.coverUrl,
//       coverPath: coverPath ?? this.coverPath,
//       description: description ?? this.description,
//       blurCoverPath: blurCoverPath ?? this.blurCoverPath,
//       type: type ?? this.type,
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
//     if (coverUrl.present) {
//       map['cover_url'] = Variable<String>(coverUrl.value);
//     }
//     if (coverPath.present) {
//       map['cover_path'] = Variable<String>(coverPath.value);
//     }
//     if (description.present) {
//       map['description'] = Variable<String>(description.value);
//     }
//     if (blurCoverPath.present) {
//       map['blur_cover_path'] = Variable<String>(blurCoverPath.value);
//     }
//     if (type.present) {
//       map['type'] = Variable<String>(type.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('PlaylistsCompanion(')
//           ..write('id: $id, ')
//           ..write('title: $title, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('description: $description, ')
//           ..write('blurCoverPath: $blurCoverPath, ')
//           ..write('type: $type')
//           ..write(')'))
//         .toString();
//   }
// }

// class $KnownTracksTable extends KnownTracks
//     with TableInfo<$KnownTracksTable, KnownTrack> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $KnownTracksTable(this.attachedDatabase, [this._alias]);
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
//   static const VerificationMeta _pathMeta = const VerificationMeta('path');
//   @override
//   late final GeneratedColumn<String> path = GeneratedColumn<String>(
//     'path',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
//   );
//   static const VerificationMeta _titleMeta = const VerificationMeta('title');
//   @override
//   late final GeneratedColumn<String> title = GeneratedColumn<String>(
//     'title',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _artistsMeta = const VerificationMeta(
//     'artists',
//   );
//   @override
//   late final GeneratedColumn<String> artists = GeneratedColumn<String>(
//     'artists',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _albumMeta = const VerificationMeta('album');
//   @override
//   late final GeneratedColumn<String> album = GeneratedColumn<String>(
//     'album',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
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
//   static const VerificationMeta _blurCoverPathMeta = const VerificationMeta(
//     'blurCoverPath',
//   );
//   @override
//   late final GeneratedColumn<String> blurCoverPath = GeneratedColumn<String>(
//     'blur_cover_path',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _md5Meta = const VerificationMeta('md5');
//   @override
//   late final GeneratedColumn<String> md5 = GeneratedColumn<String>(
//     'md5',
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
//     defaultValue: const Constant("local"),
//   );
//   static const VerificationMeta _sourceidMeta = const VerificationMeta(
//     'sourceid',
//   );
//   @override
//   late final GeneratedColumn<String> sourceid = GeneratedColumn<String>(
//     'sourceid',
//     aliasedName,
//     true,
//     type: DriftSqlType.string,
//     requiredDuringInsert: false,
//   );
//   static const VerificationMeta _downloadedMeta = const VerificationMeta(
//     'downloaded',
//   );
//   @override
//   late final GeneratedColumn<bool> downloaded = GeneratedColumn<bool>(
//     'downloaded',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("downloaded" IN (0, 1))',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     id,
//     path,
//     title,
//     artists,
//     album,
//     coverUrl,
//     coverPath,
//     blurCoverPath,
//     md5,
//     source,
//     sourceid,
//     downloaded,
//   ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'known_tracks';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<KnownTrack> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('id')) {
//       context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
//     }
//     if (data.containsKey('path')) {
//       context.handle(
//         _pathMeta,
//         path.isAcceptableOrUnknown(data['path']!, _pathMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_pathMeta);
//     }
//     if (data.containsKey('title')) {
//       context.handle(
//         _titleMeta,
//         title.isAcceptableOrUnknown(data['title']!, _titleMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_titleMeta);
//     }
//     if (data.containsKey('artists')) {
//       context.handle(
//         _artistsMeta,
//         artists.isAcceptableOrUnknown(data['artists']!, _artistsMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_artistsMeta);
//     }
//     if (data.containsKey('album')) {
//       context.handle(
//         _albumMeta,
//         album.isAcceptableOrUnknown(data['album']!, _albumMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_albumMeta);
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
//     if (data.containsKey('blur_cover_path')) {
//       context.handle(
//         _blurCoverPathMeta,
//         blurCoverPath.isAcceptableOrUnknown(
//           data['blur_cover_path']!,
//           _blurCoverPathMeta,
//         ),
//       );
//     }
//     if (data.containsKey('md5')) {
//       context.handle(
//         _md5Meta,
//         md5.isAcceptableOrUnknown(data['md5']!, _md5Meta),
//       );
//     }
//     if (data.containsKey('source')) {
//       context.handle(
//         _sourceMeta,
//         source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
//       );
//     }
//     if (data.containsKey('sourceid')) {
//       context.handle(
//         _sourceidMeta,
//         sourceid.isAcceptableOrUnknown(data['sourceid']!, _sourceidMeta),
//       );
//     }
//     if (data.containsKey('downloaded')) {
//       context.handle(
//         _downloadedMeta,
//         downloaded.isAcceptableOrUnknown(data['downloaded']!, _downloadedMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_downloadedMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {id};
//   @override
//   KnownTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return KnownTrack(
//       id: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}id'],
//       )!,
//       path: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}path'],
//       )!,
//       title: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}title'],
//       )!,
//       artists: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}artists'],
//       )!,
//       album: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}album'],
//       )!,
//       coverUrl: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_url'],
//       ),
//       coverPath: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}cover_path'],
//       ),
//       blurCoverPath: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}blur_cover_path'],
//       ),
//       md5: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}md5'],
//       ),
//       source: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}source'],
//       )!,
//       sourceid: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}sourceid'],
//       ),
//       downloaded: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}downloaded'],
//       )!,
//     );
//   }

//   @override
//   $KnownTracksTable createAlias(String alias) {
//     return $KnownTracksTable(attachedDatabase, alias);
//   }
// }

// class KnownTrack extends DataClass implements Insertable<KnownTrack> {
//   final int id;
//   final String path;
//   final String title;
//   final String artists;
//   final String album;
//   final String? coverUrl;
//   final String? coverPath;
//   final String? blurCoverPath;
//   final String? md5;
//   final String source;
//   final String? sourceid;
//   final bool downloaded;
//   const KnownTrack({
//     required this.id,
//     required this.path,
//     required this.title,
//     required this.artists,
//     required this.album,
//     this.coverUrl,
//     this.coverPath,
//     this.blurCoverPath,
//     this.md5,
//     required this.source,
//     this.sourceid,
//     required this.downloaded,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['id'] = Variable<int>(id);
//     map['path'] = Variable<String>(path);
//     map['title'] = Variable<String>(title);
//     map['artists'] = Variable<String>(artists);
//     map['album'] = Variable<String>(album);
//     if (!nullToAbsent || coverUrl != null) {
//       map['cover_url'] = Variable<String>(coverUrl);
//     }
//     if (!nullToAbsent || coverPath != null) {
//       map['cover_path'] = Variable<String>(coverPath);
//     }
//     if (!nullToAbsent || blurCoverPath != null) {
//       map['blur_cover_path'] = Variable<String>(blurCoverPath);
//     }
//     if (!nullToAbsent || md5 != null) {
//       map['md5'] = Variable<String>(md5);
//     }
//     map['source'] = Variable<String>(source);
//     if (!nullToAbsent || sourceid != null) {
//       map['sourceid'] = Variable<String>(sourceid);
//     }
//     map['downloaded'] = Variable<bool>(downloaded);
//     return map;
//   }

//   KnownTracksCompanion toCompanion(bool nullToAbsent) {
//     return KnownTracksCompanion(
//       id: Value(id),
//       path: Value(path),
//       title: Value(title),
//       artists: Value(artists),
//       album: Value(album),
//       coverUrl: coverUrl == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverUrl),
//       coverPath: coverPath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(coverPath),
//       blurCoverPath: blurCoverPath == null && nullToAbsent
//           ? const Value.absent()
//           : Value(blurCoverPath),
//       md5: md5 == null && nullToAbsent ? const Value.absent() : Value(md5),
//       source: Value(source),
//       sourceid: sourceid == null && nullToAbsent
//           ? const Value.absent()
//           : Value(sourceid),
//       downloaded: Value(downloaded),
//     );
//   }

//   factory KnownTrack.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return KnownTrack(
//       id: serializer.fromJson<int>(json['id']),
//       path: serializer.fromJson<String>(json['path']),
//       title: serializer.fromJson<String>(json['title']),
//       artists: serializer.fromJson<String>(json['artists']),
//       album: serializer.fromJson<String>(json['album']),
//       coverUrl: serializer.fromJson<String?>(json['coverUrl']),
//       coverPath: serializer.fromJson<String?>(json['coverPath']),
//       blurCoverPath: serializer.fromJson<String?>(json['blurCoverPath']),
//       md5: serializer.fromJson<String?>(json['md5']),
//       source: serializer.fromJson<String>(json['source']),
//       sourceid: serializer.fromJson<String?>(json['sourceid']),
//       downloaded: serializer.fromJson<bool>(json['downloaded']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'id': serializer.toJson<int>(id),
//       'path': serializer.toJson<String>(path),
//       'title': serializer.toJson<String>(title),
//       'artists': serializer.toJson<String>(artists),
//       'album': serializer.toJson<String>(album),
//       'coverUrl': serializer.toJson<String?>(coverUrl),
//       'coverPath': serializer.toJson<String?>(coverPath),
//       'blurCoverPath': serializer.toJson<String?>(blurCoverPath),
//       'md5': serializer.toJson<String?>(md5),
//       'source': serializer.toJson<String>(source),
//       'sourceid': serializer.toJson<String?>(sourceid),
//       'downloaded': serializer.toJson<bool>(downloaded),
//     };
//   }

//   KnownTrack copyWith({
//     int? id,
//     String? path,
//     String? title,
//     String? artists,
//     String? album,
//     Value<String?> coverUrl = const Value.absent(),
//     Value<String?> coverPath = const Value.absent(),
//     Value<String?> blurCoverPath = const Value.absent(),
//     Value<String?> md5 = const Value.absent(),
//     String? source,
//     Value<String?> sourceid = const Value.absent(),
//     bool? downloaded,
//   }) => KnownTrack(
//     id: id ?? this.id,
//     path: path ?? this.path,
//     title: title ?? this.title,
//     artists: artists ?? this.artists,
//     album: album ?? this.album,
//     coverUrl: coverUrl.present ? coverUrl.value : this.coverUrl,
//     coverPath: coverPath.present ? coverPath.value : this.coverPath,
//     blurCoverPath: blurCoverPath.present
//         ? blurCoverPath.value
//         : this.blurCoverPath,
//     md5: md5.present ? md5.value : this.md5,
//     source: source ?? this.source,
//     sourceid: sourceid.present ? sourceid.value : this.sourceid,
//     downloaded: downloaded ?? this.downloaded,
//   );
//   KnownTrack copyWithCompanion(KnownTracksCompanion data) {
//     return KnownTrack(
//       id: data.id.present ? data.id.value : this.id,
//       path: data.path.present ? data.path.value : this.path,
//       title: data.title.present ? data.title.value : this.title,
//       artists: data.artists.present ? data.artists.value : this.artists,
//       album: data.album.present ? data.album.value : this.album,
//       coverUrl: data.coverUrl.present ? data.coverUrl.value : this.coverUrl,
//       coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
//       blurCoverPath: data.blurCoverPath.present
//           ? data.blurCoverPath.value
//           : this.blurCoverPath,
//       md5: data.md5.present ? data.md5.value : this.md5,
//       source: data.source.present ? data.source.value : this.source,
//       sourceid: data.sourceid.present ? data.sourceid.value : this.sourceid,
//       downloaded: data.downloaded.present
//           ? data.downloaded.value
//           : this.downloaded,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('KnownTrack(')
//           ..write('id: $id, ')
//           ..write('path: $path, ')
//           ..write('title: $title, ')
//           ..write('artists: $artists, ')
//           ..write('album: $album, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('blurCoverPath: $blurCoverPath, ')
//           ..write('md5: $md5, ')
//           ..write('source: $source, ')
//           ..write('sourceid: $sourceid, ')
//           ..write('downloaded: $downloaded')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(
//     id,
//     path,
//     title,
//     artists,
//     album,
//     coverUrl,
//     coverPath,
//     blurCoverPath,
//     md5,
//     source,
//     sourceid,
//     downloaded,
//   );
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is KnownTrack &&
//           other.id == this.id &&
//           other.path == this.path &&
//           other.title == this.title &&
//           other.artists == this.artists &&
//           other.album == this.album &&
//           other.coverUrl == this.coverUrl &&
//           other.coverPath == this.coverPath &&
//           other.blurCoverPath == this.blurCoverPath &&
//           other.md5 == this.md5 &&
//           other.source == this.source &&
//           other.sourceid == this.sourceid &&
//           other.downloaded == this.downloaded);
// }

// class KnownTracksCompanion extends UpdateCompanion<KnownTrack> {
//   final Value<int> id;
//   final Value<String> path;
//   final Value<String> title;
//   final Value<String> artists;
//   final Value<String> album;
//   final Value<String?> coverUrl;
//   final Value<String?> coverPath;
//   final Value<String?> blurCoverPath;
//   final Value<String?> md5;
//   final Value<String> source;
//   final Value<String?> sourceid;
//   final Value<bool> downloaded;
//   const KnownTracksCompanion({
//     this.id = const Value.absent(),
//     this.path = const Value.absent(),
//     this.title = const Value.absent(),
//     this.artists = const Value.absent(),
//     this.album = const Value.absent(),
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.blurCoverPath = const Value.absent(),
//     this.md5 = const Value.absent(),
//     this.source = const Value.absent(),
//     this.sourceid = const Value.absent(),
//     this.downloaded = const Value.absent(),
//   });
//   KnownTracksCompanion.insert({
//     this.id = const Value.absent(),
//     required String path,
//     required String title,
//     required String artists,
//     required String album,
//     this.coverUrl = const Value.absent(),
//     this.coverPath = const Value.absent(),
//     this.blurCoverPath = const Value.absent(),
//     this.md5 = const Value.absent(),
//     this.source = const Value.absent(),
//     this.sourceid = const Value.absent(),
//     required bool downloaded,
//   }) : path = Value(path),
//        title = Value(title),
//        artists = Value(artists),
//        album = Value(album),
//        downloaded = Value(downloaded);
//   static Insertable<KnownTrack> custom({
//     Expression<int>? id,
//     Expression<String>? path,
//     Expression<String>? title,
//     Expression<String>? artists,
//     Expression<String>? album,
//     Expression<String>? coverUrl,
//     Expression<String>? coverPath,
//     Expression<String>? blurCoverPath,
//     Expression<String>? md5,
//     Expression<String>? source,
//     Expression<String>? sourceid,
//     Expression<bool>? downloaded,
//   }) {
//     return RawValuesInsertable({
//       if (id != null) 'id': id,
//       if (path != null) 'path': path,
//       if (title != null) 'title': title,
//       if (artists != null) 'artists': artists,
//       if (album != null) 'album': album,
//       if (coverUrl != null) 'cover_url': coverUrl,
//       if (coverPath != null) 'cover_path': coverPath,
//       if (blurCoverPath != null) 'blur_cover_path': blurCoverPath,
//       if (md5 != null) 'md5': md5,
//       if (source != null) 'source': source,
//       if (sourceid != null) 'sourceid': sourceid,
//       if (downloaded != null) 'downloaded': downloaded,
//     });
//   }

//   KnownTracksCompanion copyWith({
//     Value<int>? id,
//     Value<String>? path,
//     Value<String>? title,
//     Value<String>? artists,
//     Value<String>? album,
//     Value<String?>? coverUrl,
//     Value<String?>? coverPath,
//     Value<String?>? blurCoverPath,
//     Value<String?>? md5,
//     Value<String>? source,
//     Value<String?>? sourceid,
//     Value<bool>? downloaded,
//   }) {
//     return KnownTracksCompanion(
//       id: id ?? this.id,
//       path: path ?? this.path,
//       title: title ?? this.title,
//       artists: artists ?? this.artists,
//       album: album ?? this.album,
//       coverUrl: coverUrl ?? this.coverUrl,
//       coverPath: coverPath ?? this.coverPath,
//       blurCoverPath: blurCoverPath ?? this.blurCoverPath,
//       md5: md5 ?? this.md5,
//       source: source ?? this.source,
//       sourceid: sourceid ?? this.sourceid,
//       downloaded: downloaded ?? this.downloaded,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (id.present) {
//       map['id'] = Variable<int>(id.value);
//     }
//     if (path.present) {
//       map['path'] = Variable<String>(path.value);
//     }
//     if (title.present) {
//       map['title'] = Variable<String>(title.value);
//     }
//     if (artists.present) {
//       map['artists'] = Variable<String>(artists.value);
//     }
//     if (album.present) {
//       map['album'] = Variable<String>(album.value);
//     }
//     if (coverUrl.present) {
//       map['cover_url'] = Variable<String>(coverUrl.value);
//     }
//     if (coverPath.present) {
//       map['cover_path'] = Variable<String>(coverPath.value);
//     }
//     if (blurCoverPath.present) {
//       map['blur_cover_path'] = Variable<String>(blurCoverPath.value);
//     }
//     if (md5.present) {
//       map['md5'] = Variable<String>(md5.value);
//     }
//     if (source.present) {
//       map['source'] = Variable<String>(source.value);
//     }
//     if (sourceid.present) {
//       map['sourceid'] = Variable<String>(sourceid.value);
//     }
//     if (downloaded.present) {
//       map['downloaded'] = Variable<bool>(downloaded.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('KnownTracksCompanion(')
//           ..write('id: $id, ')
//           ..write('path: $path, ')
//           ..write('title: $title, ')
//           ..write('artists: $artists, ')
//           ..write('album: $album, ')
//           ..write('coverUrl: $coverUrl, ')
//           ..write('coverPath: $coverPath, ')
//           ..write('blurCoverPath: $blurCoverPath, ')
//           ..write('md5: $md5, ')
//           ..write('source: $source, ')
//           ..write('sourceid: $sourceid, ')
//           ..write('downloaded: $downloaded')
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
//   static const VerificationMeta _trackMeta = const VerificationMeta('track');
//   @override
//   late final GeneratedColumn<int> track = GeneratedColumn<int>(
//     'track',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES known_tracks (id)',
//     ),
//   );
//   static const VerificationMeta _playlistMeta = const VerificationMeta(
//     'playlist',
//   );
//   @override
//   late final GeneratedColumn<int> playlist = GeneratedColumn<int>(
//     'playlist',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES playlists (id)',
//     ),
//   );
//   static const VerificationMeta _positionMeta = const VerificationMeta(
//     'position',
//   );
//   @override
//   late final GeneratedColumn<int> position = GeneratedColumn<int>(
//     'position',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//   );
//   @override
//   List<GeneratedColumn> get $columns => [track, playlist, position];
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
//     if (data.containsKey('track')) {
//       context.handle(
//         _trackMeta,
//         track.isAcceptableOrUnknown(data['track']!, _trackMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_trackMeta);
//     }
//     if (data.containsKey('playlist')) {
//       context.handle(
//         _playlistMeta,
//         playlist.isAcceptableOrUnknown(data['playlist']!, _playlistMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_playlistMeta);
//     }
//     if (data.containsKey('position')) {
//       context.handle(
//         _positionMeta,
//         position.isAcceptableOrUnknown(data['position']!, _positionMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_positionMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {playlist, track};
//   @override
//   PlaylistTrack map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return PlaylistTrack(
//       track: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track'],
//       )!,
//       playlist: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}playlist'],
//       )!,
//       position: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}position'],
//       )!,
//     );
//   }

//   @override
//   $PlaylistTracksTable createAlias(String alias) {
//     return $PlaylistTracksTable(attachedDatabase, alias);
//   }
// }

// class PlaylistTrack extends DataClass implements Insertable<PlaylistTrack> {
//   final int track;
//   final int playlist;
//   final int position;
//   const PlaylistTrack({
//     required this.track,
//     required this.playlist,
//     required this.position,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['track'] = Variable<int>(track);
//     map['playlist'] = Variable<int>(playlist);
//     map['position'] = Variable<int>(position);
//     return map;
//   }

//   PlaylistTracksCompanion toCompanion(bool nullToAbsent) {
//     return PlaylistTracksCompanion(
//       track: Value(track),
//       playlist: Value(playlist),
//       position: Value(position),
//     );
//   }

//   factory PlaylistTrack.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return PlaylistTrack(
//       track: serializer.fromJson<int>(json['track']),
//       playlist: serializer.fromJson<int>(json['playlist']),
//       position: serializer.fromJson<int>(json['position']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'track': serializer.toJson<int>(track),
//       'playlist': serializer.toJson<int>(playlist),
//       'position': serializer.toJson<int>(position),
//     };
//   }

//   PlaylistTrack copyWith({int? track, int? playlist, int? position}) =>
//       PlaylistTrack(
//         track: track ?? this.track,
//         playlist: playlist ?? this.playlist,
//         position: position ?? this.position,
//       );
//   PlaylistTrack copyWithCompanion(PlaylistTracksCompanion data) {
//     return PlaylistTrack(
//       track: data.track.present ? data.track.value : this.track,
//       playlist: data.playlist.present ? data.playlist.value : this.playlist,
//       position: data.position.present ? data.position.value : this.position,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('PlaylistTrack(')
//           ..write('track: $track, ')
//           ..write('playlist: $playlist, ')
//           ..write('position: $position')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(track, playlist, position);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is PlaylistTrack &&
//           other.track == this.track &&
//           other.playlist == this.playlist &&
//           other.position == this.position);
// }

// class PlaylistTracksCompanion extends UpdateCompanion<PlaylistTrack> {
//   final Value<int> track;
//   final Value<int> playlist;
//   final Value<int> position;
//   final Value<int> rowid;
//   const PlaylistTracksCompanion({
//     this.track = const Value.absent(),
//     this.playlist = const Value.absent(),
//     this.position = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   PlaylistTracksCompanion.insert({
//     required int track,
//     required int playlist,
//     required int position,
//     this.rowid = const Value.absent(),
//   }) : track = Value(track),
//        playlist = Value(playlist),
//        position = Value(position);
//   static Insertable<PlaylistTrack> custom({
//     Expression<int>? track,
//     Expression<int>? playlist,
//     Expression<int>? position,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (track != null) 'track': track,
//       if (playlist != null) 'playlist': playlist,
//       if (position != null) 'position': position,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   PlaylistTracksCompanion copyWith({
//     Value<int>? track,
//     Value<int>? playlist,
//     Value<int>? position,
//     Value<int>? rowid,
//   }) {
//     return PlaylistTracksCompanion(
//       track: track ?? this.track,
//       playlist: playlist ?? this.playlist,
//       position: position ?? this.position,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (track.present) {
//       map['track'] = Variable<int>(track.value);
//     }
//     if (playlist.present) {
//       map['playlist'] = Variable<int>(playlist.value);
//     }
//     if (position.present) {
//       map['position'] = Variable<int>(position.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('PlaylistTracksCompanion(')
//           ..write('track: $track, ')
//           ..write('playlist: $playlist, ')
//           ..write('position: $position, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $CoverColorsTable extends CoverColors
//     with TableInfo<$CoverColorsTable, CoverColor> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $CoverColorsTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _md5Meta = const VerificationMeta('md5');
//   @override
//   late final GeneratedColumn<String> md5 = GeneratedColumn<String>(
//     'md5',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _colorsMeta = const VerificationMeta('colors');
//   @override
//   late final GeneratedColumn<String> colors = GeneratedColumn<String>(
//     'colors',
//     aliasedName,
//     false,
//     type: DriftSqlType.string,
//     requiredDuringInsert: true,
//   );
//   @override
//   List<GeneratedColumn> get $columns => [md5, colors];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'cover_colors';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<CoverColor> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('md5')) {
//       context.handle(
//         _md5Meta,
//         md5.isAcceptableOrUnknown(data['md5']!, _md5Meta),
//       );
//     } else if (isInserting) {
//       context.missing(_md5Meta);
//     }
//     if (data.containsKey('colors')) {
//       context.handle(
//         _colorsMeta,
//         colors.isAcceptableOrUnknown(data['colors']!, _colorsMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_colorsMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => {md5};
//   @override
//   CoverColor map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return CoverColor(
//       md5: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}md5'],
//       )!,
//       colors: attachedDatabase.typeMapping.read(
//         DriftSqlType.string,
//         data['${effectivePrefix}colors'],
//       )!,
//     );
//   }

//   @override
//   $CoverColorsTable createAlias(String alias) {
//     return $CoverColorsTable(attachedDatabase, alias);
//   }
// }

// class CoverColor extends DataClass implements Insertable<CoverColor> {
//   final String md5;

//   /// JSON FORMAT => ```List<int>```
//   final String colors;
//   const CoverColor({required this.md5, required this.colors});
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['md5'] = Variable<String>(md5);
//     map['colors'] = Variable<String>(colors);
//     return map;
//   }

//   CoverColorsCompanion toCompanion(bool nullToAbsent) {
//     return CoverColorsCompanion(md5: Value(md5), colors: Value(colors));
//   }

//   factory CoverColor.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return CoverColor(
//       md5: serializer.fromJson<String>(json['md5']),
//       colors: serializer.fromJson<String>(json['colors']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'md5': serializer.toJson<String>(md5),
//       'colors': serializer.toJson<String>(colors),
//     };
//   }

//   CoverColor copyWith({String? md5, String? colors}) =>
//       CoverColor(md5: md5 ?? this.md5, colors: colors ?? this.colors);
//   CoverColor copyWithCompanion(CoverColorsCompanion data) {
//     return CoverColor(
//       md5: data.md5.present ? data.md5.value : this.md5,
//       colors: data.colors.present ? data.colors.value : this.colors,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('CoverColor(')
//           ..write('md5: $md5, ')
//           ..write('colors: $colors')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(md5, colors);
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is CoverColor &&
//           other.md5 == this.md5 &&
//           other.colors == this.colors);
// }

// class CoverColorsCompanion extends UpdateCompanion<CoverColor> {
//   final Value<String> md5;
//   final Value<String> colors;
//   final Value<int> rowid;
//   const CoverColorsCompanion({
//     this.md5 = const Value.absent(),
//     this.colors = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   CoverColorsCompanion.insert({
//     required String md5,
//     required String colors,
//     this.rowid = const Value.absent(),
//   }) : md5 = Value(md5),
//        colors = Value(colors);
//   static Insertable<CoverColor> custom({
//     Expression<String>? md5,
//     Expression<String>? colors,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (md5 != null) 'md5': md5,
//       if (colors != null) 'colors': colors,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   CoverColorsCompanion copyWith({
//     Value<String>? md5,
//     Value<String>? colors,
//     Value<int>? rowid,
//   }) {
//     return CoverColorsCompanion(
//       md5: md5 ?? this.md5,
//       colors: colors ?? this.colors,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (md5.present) {
//       map['md5'] = Variable<String>(md5.value);
//     }
//     if (colors.present) {
//       map['colors'] = Variable<String>(colors.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('CoverColorsCompanion(')
//           ..write('md5: $md5, ')
//           ..write('colors: $colors, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// class $ListenStatsTable extends ListenStats
//     with TableInfo<$ListenStatsTable, ListenStat> {
//   @override
//   final GeneratedDatabase attachedDatabase;
//   final String? _alias;
//   $ListenStatsTable(this.attachedDatabase, [this._alias]);
//   static const VerificationMeta _trackMeta = const VerificationMeta('track');
//   @override
//   late final GeneratedColumn<int> track = GeneratedColumn<int>(
//     'track',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'REFERENCES known_tracks (id)',
//     ),
//   );
//   static const VerificationMeta _timeMeta = const VerificationMeta('time');
//   @override
//   late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
//     'time',
//     aliasedName,
//     false,
//     type: DriftSqlType.dateTime,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _playedSecondsMeta = const VerificationMeta(
//     'playedSeconds',
//   );
//   @override
//   late final GeneratedColumn<int> playedSeconds = GeneratedColumn<int>(
//     'played_seconds',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _totalTrackDurationMeta =
//       const VerificationMeta('totalTrackDuration');
//   @override
//   late final GeneratedColumn<int> totalTrackDuration = GeneratedColumn<int>(
//     'total_track_duration',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _progressPercentMeta = const VerificationMeta(
//     'progressPercent',
//   );
//   @override
//   late final GeneratedColumn<int> progressPercent = GeneratedColumn<int>(
//     'progress_percent',
//     aliasedName,
//     false,
//     type: DriftSqlType.int,
//     requiredDuringInsert: true,
//   );
//   static const VerificationMeta _isSkippedMeta = const VerificationMeta(
//     'isSkipped',
//   );
//   @override
//   late final GeneratedColumn<bool> isSkipped = GeneratedColumn<bool>(
//     'is_skipped',
//     aliasedName,
//     false,
//     type: DriftSqlType.bool,
//     requiredDuringInsert: true,
//     defaultConstraints: GeneratedColumn.constraintIsAlways(
//       'CHECK ("is_skipped" IN (0, 1))',
//     ),
//   );
//   @override
//   List<GeneratedColumn> get $columns => [
//     track,
//     time,
//     playedSeconds,
//     totalTrackDuration,
//     progressPercent,
//     isSkipped,
//   ];
//   @override
//   String get aliasedName => _alias ?? actualTableName;
//   @override
//   String get actualTableName => $name;
//   static const String $name = 'listen_stats';
//   @override
//   VerificationContext validateIntegrity(
//     Insertable<ListenStat> instance, {
//     bool isInserting = false,
//   }) {
//     final context = VerificationContext();
//     final data = instance.toColumns(true);
//     if (data.containsKey('track')) {
//       context.handle(
//         _trackMeta,
//         track.isAcceptableOrUnknown(data['track']!, _trackMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_trackMeta);
//     }
//     if (data.containsKey('time')) {
//       context.handle(
//         _timeMeta,
//         time.isAcceptableOrUnknown(data['time']!, _timeMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_timeMeta);
//     }
//     if (data.containsKey('played_seconds')) {
//       context.handle(
//         _playedSecondsMeta,
//         playedSeconds.isAcceptableOrUnknown(
//           data['played_seconds']!,
//           _playedSecondsMeta,
//         ),
//       );
//     } else if (isInserting) {
//       context.missing(_playedSecondsMeta);
//     }
//     if (data.containsKey('total_track_duration')) {
//       context.handle(
//         _totalTrackDurationMeta,
//         totalTrackDuration.isAcceptableOrUnknown(
//           data['total_track_duration']!,
//           _totalTrackDurationMeta,
//         ),
//       );
//     } else if (isInserting) {
//       context.missing(_totalTrackDurationMeta);
//     }
//     if (data.containsKey('progress_percent')) {
//       context.handle(
//         _progressPercentMeta,
//         progressPercent.isAcceptableOrUnknown(
//           data['progress_percent']!,
//           _progressPercentMeta,
//         ),
//       );
//     } else if (isInserting) {
//       context.missing(_progressPercentMeta);
//     }
//     if (data.containsKey('is_skipped')) {
//       context.handle(
//         _isSkippedMeta,
//         isSkipped.isAcceptableOrUnknown(data['is_skipped']!, _isSkippedMeta),
//       );
//     } else if (isInserting) {
//       context.missing(_isSkippedMeta);
//     }
//     return context;
//   }

//   @override
//   Set<GeneratedColumn> get $primaryKey => const {};
//   @override
//   ListenStat map(Map<String, dynamic> data, {String? tablePrefix}) {
//     final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
//     return ListenStat(
//       track: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}track'],
//       )!,
//       time: attachedDatabase.typeMapping.read(
//         DriftSqlType.dateTime,
//         data['${effectivePrefix}time'],
//       )!,
//       playedSeconds: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}played_seconds'],
//       )!,
//       totalTrackDuration: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}total_track_duration'],
//       )!,
//       progressPercent: attachedDatabase.typeMapping.read(
//         DriftSqlType.int,
//         data['${effectivePrefix}progress_percent'],
//       )!,
//       isSkipped: attachedDatabase.typeMapping.read(
//         DriftSqlType.bool,
//         data['${effectivePrefix}is_skipped'],
//       )!,
//     );
//   }

//   @override
//   $ListenStatsTable createAlias(String alias) {
//     return $ListenStatsTable(attachedDatabase, alias);
//   }
// }

// class ListenStat extends DataClass implements Insertable<ListenStat> {
//   final int track;

//   /// ISO8601
//   final DateTime time;
//   final int playedSeconds;
//   final int totalTrackDuration;
//   final int progressPercent;
//   final bool isSkipped;
//   const ListenStat({
//     required this.track,
//     required this.time,
//     required this.playedSeconds,
//     required this.totalTrackDuration,
//     required this.progressPercent,
//     required this.isSkipped,
//   });
//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     map['track'] = Variable<int>(track);
//     map['time'] = Variable<DateTime>(time);
//     map['played_seconds'] = Variable<int>(playedSeconds);
//     map['total_track_duration'] = Variable<int>(totalTrackDuration);
//     map['progress_percent'] = Variable<int>(progressPercent);
//     map['is_skipped'] = Variable<bool>(isSkipped);
//     return map;
//   }

//   ListenStatsCompanion toCompanion(bool nullToAbsent) {
//     return ListenStatsCompanion(
//       track: Value(track),
//       time: Value(time),
//       playedSeconds: Value(playedSeconds),
//       totalTrackDuration: Value(totalTrackDuration),
//       progressPercent: Value(progressPercent),
//       isSkipped: Value(isSkipped),
//     );
//   }

//   factory ListenStat.fromJson(
//     Map<String, dynamic> json, {
//     ValueSerializer? serializer,
//   }) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return ListenStat(
//       track: serializer.fromJson<int>(json['track']),
//       time: serializer.fromJson<DateTime>(json['time']),
//       playedSeconds: serializer.fromJson<int>(json['playedSeconds']),
//       totalTrackDuration: serializer.fromJson<int>(json['totalTrackDuration']),
//       progressPercent: serializer.fromJson<int>(json['progressPercent']),
//       isSkipped: serializer.fromJson<bool>(json['isSkipped']),
//     );
//   }
//   @override
//   Map<String, dynamic> toJson({ValueSerializer? serializer}) {
//     serializer ??= driftRuntimeOptions.defaultSerializer;
//     return <String, dynamic>{
//       'track': serializer.toJson<int>(track),
//       'time': serializer.toJson<DateTime>(time),
//       'playedSeconds': serializer.toJson<int>(playedSeconds),
//       'totalTrackDuration': serializer.toJson<int>(totalTrackDuration),
//       'progressPercent': serializer.toJson<int>(progressPercent),
//       'isSkipped': serializer.toJson<bool>(isSkipped),
//     };
//   }

//   ListenStat copyWith({
//     int? track,
//     DateTime? time,
//     int? playedSeconds,
//     int? totalTrackDuration,
//     int? progressPercent,
//     bool? isSkipped,
//   }) => ListenStat(
//     track: track ?? this.track,
//     time: time ?? this.time,
//     playedSeconds: playedSeconds ?? this.playedSeconds,
//     totalTrackDuration: totalTrackDuration ?? this.totalTrackDuration,
//     progressPercent: progressPercent ?? this.progressPercent,
//     isSkipped: isSkipped ?? this.isSkipped,
//   );
//   ListenStat copyWithCompanion(ListenStatsCompanion data) {
//     return ListenStat(
//       track: data.track.present ? data.track.value : this.track,
//       time: data.time.present ? data.time.value : this.time,
//       playedSeconds: data.playedSeconds.present
//           ? data.playedSeconds.value
//           : this.playedSeconds,
//       totalTrackDuration: data.totalTrackDuration.present
//           ? data.totalTrackDuration.value
//           : this.totalTrackDuration,
//       progressPercent: data.progressPercent.present
//           ? data.progressPercent.value
//           : this.progressPercent,
//       isSkipped: data.isSkipped.present ? data.isSkipped.value : this.isSkipped,
//     );
//   }

//   @override
//   String toString() {
//     return (StringBuffer('ListenStat(')
//           ..write('track: $track, ')
//           ..write('time: $time, ')
//           ..write('playedSeconds: $playedSeconds, ')
//           ..write('totalTrackDuration: $totalTrackDuration, ')
//           ..write('progressPercent: $progressPercent, ')
//           ..write('isSkipped: $isSkipped')
//           ..write(')'))
//         .toString();
//   }

//   @override
//   int get hashCode => Object.hash(
//     track,
//     time,
//     playedSeconds,
//     totalTrackDuration,
//     progressPercent,
//     isSkipped,
//   );
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       (other is ListenStat &&
//           other.track == this.track &&
//           other.time == this.time &&
//           other.playedSeconds == this.playedSeconds &&
//           other.totalTrackDuration == this.totalTrackDuration &&
//           other.progressPercent == this.progressPercent &&
//           other.isSkipped == this.isSkipped);
// }

// class ListenStatsCompanion extends UpdateCompanion<ListenStat> {
//   final Value<int> track;
//   final Value<DateTime> time;
//   final Value<int> playedSeconds;
//   final Value<int> totalTrackDuration;
//   final Value<int> progressPercent;
//   final Value<bool> isSkipped;
//   final Value<int> rowid;
//   const ListenStatsCompanion({
//     this.track = const Value.absent(),
//     this.time = const Value.absent(),
//     this.playedSeconds = const Value.absent(),
//     this.totalTrackDuration = const Value.absent(),
//     this.progressPercent = const Value.absent(),
//     this.isSkipped = const Value.absent(),
//     this.rowid = const Value.absent(),
//   });
//   ListenStatsCompanion.insert({
//     required int track,
//     required DateTime time,
//     required int playedSeconds,
//     required int totalTrackDuration,
//     required int progressPercent,
//     required bool isSkipped,
//     this.rowid = const Value.absent(),
//   }) : track = Value(track),
//        time = Value(time),
//        playedSeconds = Value(playedSeconds),
//        totalTrackDuration = Value(totalTrackDuration),
//        progressPercent = Value(progressPercent),
//        isSkipped = Value(isSkipped);
//   static Insertable<ListenStat> custom({
//     Expression<int>? track,
//     Expression<DateTime>? time,
//     Expression<int>? playedSeconds,
//     Expression<int>? totalTrackDuration,
//     Expression<int>? progressPercent,
//     Expression<bool>? isSkipped,
//     Expression<int>? rowid,
//   }) {
//     return RawValuesInsertable({
//       if (track != null) 'track': track,
//       if (time != null) 'time': time,
//       if (playedSeconds != null) 'played_seconds': playedSeconds,
//       if (totalTrackDuration != null)
//         'total_track_duration': totalTrackDuration,
//       if (progressPercent != null) 'progress_percent': progressPercent,
//       if (isSkipped != null) 'is_skipped': isSkipped,
//       if (rowid != null) 'rowid': rowid,
//     });
//   }

//   ListenStatsCompanion copyWith({
//     Value<int>? track,
//     Value<DateTime>? time,
//     Value<int>? playedSeconds,
//     Value<int>? totalTrackDuration,
//     Value<int>? progressPercent,
//     Value<bool>? isSkipped,
//     Value<int>? rowid,
//   }) {
//     return ListenStatsCompanion(
//       track: track ?? this.track,
//       time: time ?? this.time,
//       playedSeconds: playedSeconds ?? this.playedSeconds,
//       totalTrackDuration: totalTrackDuration ?? this.totalTrackDuration,
//       progressPercent: progressPercent ?? this.progressPercent,
//       isSkipped: isSkipped ?? this.isSkipped,
//       rowid: rowid ?? this.rowid,
//     );
//   }

//   @override
//   Map<String, Expression> toColumns(bool nullToAbsent) {
//     final map = <String, Expression>{};
//     if (track.present) {
//       map['track'] = Variable<int>(track.value);
//     }
//     if (time.present) {
//       map['time'] = Variable<DateTime>(time.value);
//     }
//     if (playedSeconds.present) {
//       map['played_seconds'] = Variable<int>(playedSeconds.value);
//     }
//     if (totalTrackDuration.present) {
//       map['total_track_duration'] = Variable<int>(totalTrackDuration.value);
//     }
//     if (progressPercent.present) {
//       map['progress_percent'] = Variable<int>(progressPercent.value);
//     }
//     if (isSkipped.present) {
//       map['is_skipped'] = Variable<bool>(isSkipped.value);
//     }
//     if (rowid.present) {
//       map['rowid'] = Variable<int>(rowid.value);
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return (StringBuffer('ListenStatsCompanion(')
//           ..write('track: $track, ')
//           ..write('time: $time, ')
//           ..write('playedSeconds: $playedSeconds, ')
//           ..write('totalTrackDuration: $totalTrackDuration, ')
//           ..write('progressPercent: $progressPercent, ')
//           ..write('isSkipped: $isSkipped, ')
//           ..write('rowid: $rowid')
//           ..write(')'))
//         .toString();
//   }
// }

// abstract class _$AppDatabase extends GeneratedDatabase {
//   _$AppDatabase(QueryExecutor e) : super(e);
//   $AppDatabaseManager get managers => $AppDatabaseManager(this);
//   late final $PlaylistsTable playlists = $PlaylistsTable(this);
//   late final $KnownTracksTable knownTracks = $KnownTracksTable(this);
//   late final $PlaylistTracksTable playlistTracks = $PlaylistTracksTable(this);
//   late final $CoverColorsTable coverColors = $CoverColorsTable(this);
//   late final $ListenStatsTable listenStats = $ListenStatsTable(this);
//   late final Index idxPlaylistTracksPlaylistPos = Index(
//     'idx_playlist_tracks_playlist_pos',
//     'CREATE INDEX idx_playlist_tracks_playlist_pos ON playlist_tracks (playlist, position)',
//   );
//   late final Index idxKnownTracksTitle = Index(
//     'idx_known_tracks_title',
//     'CREATE INDEX idx_known_tracks_title ON known_tracks (title)',
//   );
//   late final Index idxKnownTracksArtists = Index(
//     'idx_known_tracks_artists',
//     'CREATE INDEX idx_known_tracks_artists ON known_tracks (artists)',
//   );
//   late final Index idxCoverColorsMd5 = Index(
//     'idx_cover_colors_md5',
//     'CREATE INDEX idx_cover_colors_md5 ON cover_colors (md5)',
//   );
//   late final Index idxListenStatsTrack = Index(
//     'idx_listen_stats_track',
//     'CREATE INDEX idx_listen_stats_track ON listen_stats (track)',
//   );
//   late final Index idxListenStatsTime = Index(
//     'idx_listen_stats_time',
//     'CREATE INDEX idx_listen_stats_time ON listen_stats (time)',
//   );
//   @override
//   Iterable<TableInfo<Table, Object?>> get allTables =>
//       allSchemaEntities.whereType<TableInfo<Table, Object?>>();
//   @override
//   List<DatabaseSchemaEntity> get allSchemaEntities => [
//     playlists,
//     knownTracks,
//     playlistTracks,
//     coverColors,
//     listenStats,
//     idxPlaylistTracksPlaylistPos,
//     idxKnownTracksTitle,
//     idxKnownTracksArtists,
//     idxCoverColorsMd5,
//     idxListenStatsTrack,
//     idxListenStatsTime,
//   ];
// }

// typedef $$PlaylistsTableCreateCompanionBuilder =
//     PlaylistsCompanion Function({
//       Value<int> id,
//       required String title,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<String?> description,
//       Value<String?> blurCoverPath,
//       Value<String> type,
//     });
// typedef $$PlaylistsTableUpdateCompanionBuilder =
//     PlaylistsCompanion Function({
//       Value<int> id,
//       Value<String> title,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<String?> description,
//       Value<String?> blurCoverPath,
//       Value<String> type,
//     });

// final class $$PlaylistsTableReferences
//     extends BaseReferences<_$AppDatabase, $PlaylistsTable, Playlist> {
//   $$PlaylistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static MultiTypedResultKey<$PlaylistTracksTable, List<PlaylistTrack>>
//   _playlistTracksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.playlistTracks,
//     aliasName: $_aliasNameGenerator(
//       db.playlists.id,
//       db.playlistTracks.playlist,
//     ),
//   );

//   $$PlaylistTracksTableProcessedTableManager get playlistTracksRefs {
//     final manager = $$PlaylistTracksTableTableManager(
//       $_db,
//       $_db.playlistTracks,
//     ).filter((f) => f.playlist.id.sqlEquals($_itemColumn<int>('id')!));

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

//   ColumnFilters<String> get title => $composableBuilder(
//     column: $table.title,
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

//   ColumnFilters<String> get blurCoverPath => $composableBuilder(
//     column: $table.blurCoverPath,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get type => $composableBuilder(
//     column: $table.type,
//     builder: (column) => ColumnFilters(column),
//   );

//   Expression<bool> playlistTracksRefs(
//     Expression<bool> Function($$PlaylistTracksTableFilterComposer f) f,
//   ) {
//     final $$PlaylistTracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlistTracks,
//       getReferencedColumn: (t) => t.playlist,
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

//   ColumnOrderings<String> get title => $composableBuilder(
//     column: $table.title,
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

//   ColumnOrderings<String> get blurCoverPath => $composableBuilder(
//     column: $table.blurCoverPath,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get type => $composableBuilder(
//     column: $table.type,
//     builder: (column) => ColumnOrderings(column),
//   );
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

//   GeneratedColumn<String> get title =>
//       $composableBuilder(column: $table.title, builder: (column) => column);

//   GeneratedColumn<String> get coverUrl =>
//       $composableBuilder(column: $table.coverUrl, builder: (column) => column);

//   GeneratedColumn<String> get coverPath =>
//       $composableBuilder(column: $table.coverPath, builder: (column) => column);

//   GeneratedColumn<String> get description => $composableBuilder(
//     column: $table.description,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get blurCoverPath => $composableBuilder(
//     column: $table.blurCoverPath,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get type =>
//       $composableBuilder(column: $table.type, builder: (column) => column);

//   Expression<T> playlistTracksRefs<T extends Object>(
//     Expression<T> Function($$PlaylistTracksTableAnnotationComposer a) f,
//   ) {
//     final $$PlaylistTracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlistTracks,
//       getReferencedColumn: (t) => t.playlist,
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
//           PrefetchHooks Function({bool playlistTracksRefs})
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
//                 Value<String> title = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<String?> description = const Value.absent(),
//                 Value<String?> blurCoverPath = const Value.absent(),
//                 Value<String> type = const Value.absent(),
//               }) => PlaylistsCompanion(
//                 id: id,
//                 title: title,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 description: description,
//                 blurCoverPath: blurCoverPath,
//                 type: type,
//               ),
//           createCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 required String title,
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<String?> description = const Value.absent(),
//                 Value<String?> blurCoverPath = const Value.absent(),
//                 Value<String> type = const Value.absent(),
//               }) => PlaylistsCompanion.insert(
//                 id: id,
//                 title: title,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 description: description,
//                 blurCoverPath: blurCoverPath,
//                 type: type,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$PlaylistsTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({playlistTracksRefs = false}) {
//             return PrefetchHooks(
//               db: db,
//               explicitlyWatchedTables: [
//                 if (playlistTracksRefs) db.playlistTracks,
//               ],
//               addJoins: null,
//               getPrefetchedDataCallback: (items) async {
//                 return [
//                   if (playlistTracksRefs)
//                     await $_getPrefetchedData<
//                       Playlist,
//                       $PlaylistsTable,
//                       PlaylistTrack
//                     >(
//                       currentTable: table,
//                       referencedTable: $$PlaylistsTableReferences
//                           ._playlistTracksRefsTable(db),
//                       managerFromTypedResult: (p0) =>
//                           $$PlaylistsTableReferences(
//                             db,
//                             table,
//                             p0,
//                           ).playlistTracksRefs,
//                       referencedItemsForCurrentItem: (item, referencedItems) =>
//                           referencedItems.where((e) => e.playlist == item.id),
//                       typedResults: items,
//                     ),
//                 ];
//               },
//             );
//           },
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
//       PrefetchHooks Function({bool playlistTracksRefs})
//     >;
// typedef $$KnownTracksTableCreateCompanionBuilder =
//     KnownTracksCompanion Function({
//       Value<int> id,
//       required String path,
//       required String title,
//       required String artists,
//       required String album,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<String?> blurCoverPath,
//       Value<String?> md5,
//       Value<String> source,
//       Value<String?> sourceid,
//       required bool downloaded,
//     });
// typedef $$KnownTracksTableUpdateCompanionBuilder =
//     KnownTracksCompanion Function({
//       Value<int> id,
//       Value<String> path,
//       Value<String> title,
//       Value<String> artists,
//       Value<String> album,
//       Value<String?> coverUrl,
//       Value<String?> coverPath,
//       Value<String?> blurCoverPath,
//       Value<String?> md5,
//       Value<String> source,
//       Value<String?> sourceid,
//       Value<bool> downloaded,
//     });

// final class $$KnownTracksTableReferences
//     extends BaseReferences<_$AppDatabase, $KnownTracksTable, KnownTrack> {
//   $$KnownTracksTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static MultiTypedResultKey<$PlaylistTracksTable, List<PlaylistTrack>>
//   _playlistTracksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.playlistTracks,
//     aliasName: $_aliasNameGenerator(db.knownTracks.id, db.playlistTracks.track),
//   );

//   $$PlaylistTracksTableProcessedTableManager get playlistTracksRefs {
//     final manager = $$PlaylistTracksTableTableManager(
//       $_db,
//       $_db.playlistTracks,
//     ).filter((f) => f.track.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_playlistTracksRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }

//   static MultiTypedResultKey<$ListenStatsTable, List<ListenStat>>
//   _listenStatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
//     db.listenStats,
//     aliasName: $_aliasNameGenerator(db.knownTracks.id, db.listenStats.track),
//   );

//   $$ListenStatsTableProcessedTableManager get listenStatsRefs {
//     final manager = $$ListenStatsTableTableManager(
//       $_db,
//       $_db.listenStats,
//     ).filter((f) => f.track.id.sqlEquals($_itemColumn<int>('id')!));

//     final cache = $_typedResult.readTableOrNull(_listenStatsRefsTable($_db));
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: cache),
//     );
//   }
// }

// class $$KnownTracksTableFilterComposer
//     extends Composer<_$AppDatabase, $KnownTracksTable> {
//   $$KnownTracksTableFilterComposer({
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

//   ColumnFilters<String> get path => $composableBuilder(
//     column: $table.path,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get title => $composableBuilder(
//     column: $table.title,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get artists => $composableBuilder(
//     column: $table.artists,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get album => $composableBuilder(
//     column: $table.album,
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

//   ColumnFilters<String> get blurCoverPath => $composableBuilder(
//     column: $table.blurCoverPath,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get md5 => $composableBuilder(
//     column: $table.md5,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get sourceid => $composableBuilder(
//     column: $table.sourceid,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get downloaded => $composableBuilder(
//     column: $table.downloaded,
//     builder: (column) => ColumnFilters(column),
//   );

//   Expression<bool> playlistTracksRefs(
//     Expression<bool> Function($$PlaylistTracksTableFilterComposer f) f,
//   ) {
//     final $$PlaylistTracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlistTracks,
//       getReferencedColumn: (t) => t.track,
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

//   Expression<bool> listenStatsRefs(
//     Expression<bool> Function($$ListenStatsTableFilterComposer f) f,
//   ) {
//     final $$ListenStatsTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.listenStats,
//       getReferencedColumn: (t) => t.track,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$ListenStatsTableFilterComposer(
//             $db: $db,
//             $table: $db.listenStats,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$KnownTracksTableOrderingComposer
//     extends Composer<_$AppDatabase, $KnownTracksTable> {
//   $$KnownTracksTableOrderingComposer({
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

//   ColumnOrderings<String> get path => $composableBuilder(
//     column: $table.path,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get title => $composableBuilder(
//     column: $table.title,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get artists => $composableBuilder(
//     column: $table.artists,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get album => $composableBuilder(
//     column: $table.album,
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

//   ColumnOrderings<String> get blurCoverPath => $composableBuilder(
//     column: $table.blurCoverPath,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get md5 => $composableBuilder(
//     column: $table.md5,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get source => $composableBuilder(
//     column: $table.source,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get sourceid => $composableBuilder(
//     column: $table.sourceid,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get downloaded => $composableBuilder(
//     column: $table.downloaded,
//     builder: (column) => ColumnOrderings(column),
//   );
// }

// class $$KnownTracksTableAnnotationComposer
//     extends Composer<_$AppDatabase, $KnownTracksTable> {
//   $$KnownTracksTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<int> get id =>
//       $composableBuilder(column: $table.id, builder: (column) => column);

//   GeneratedColumn<String> get path =>
//       $composableBuilder(column: $table.path, builder: (column) => column);

//   GeneratedColumn<String> get title =>
//       $composableBuilder(column: $table.title, builder: (column) => column);

//   GeneratedColumn<String> get artists =>
//       $composableBuilder(column: $table.artists, builder: (column) => column);

//   GeneratedColumn<String> get album =>
//       $composableBuilder(column: $table.album, builder: (column) => column);

//   GeneratedColumn<String> get coverUrl =>
//       $composableBuilder(column: $table.coverUrl, builder: (column) => column);

//   GeneratedColumn<String> get coverPath =>
//       $composableBuilder(column: $table.coverPath, builder: (column) => column);

//   GeneratedColumn<String> get blurCoverPath => $composableBuilder(
//     column: $table.blurCoverPath,
//     builder: (column) => column,
//   );

//   GeneratedColumn<String> get md5 =>
//       $composableBuilder(column: $table.md5, builder: (column) => column);

//   GeneratedColumn<String> get source =>
//       $composableBuilder(column: $table.source, builder: (column) => column);

//   GeneratedColumn<String> get sourceid =>
//       $composableBuilder(column: $table.sourceid, builder: (column) => column);

//   GeneratedColumn<bool> get downloaded => $composableBuilder(
//     column: $table.downloaded,
//     builder: (column) => column,
//   );

//   Expression<T> playlistTracksRefs<T extends Object>(
//     Expression<T> Function($$PlaylistTracksTableAnnotationComposer a) f,
//   ) {
//     final $$PlaylistTracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.playlistTracks,
//       getReferencedColumn: (t) => t.track,
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

//   Expression<T> listenStatsRefs<T extends Object>(
//     Expression<T> Function($$ListenStatsTableAnnotationComposer a) f,
//   ) {
//     final $$ListenStatsTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.id,
//       referencedTable: $db.listenStats,
//       getReferencedColumn: (t) => t.track,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$ListenStatsTableAnnotationComposer(
//             $db: $db,
//             $table: $db.listenStats,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return f(composer);
//   }
// }

// class $$KnownTracksTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $KnownTracksTable,
//           KnownTrack,
//           $$KnownTracksTableFilterComposer,
//           $$KnownTracksTableOrderingComposer,
//           $$KnownTracksTableAnnotationComposer,
//           $$KnownTracksTableCreateCompanionBuilder,
//           $$KnownTracksTableUpdateCompanionBuilder,
//           (KnownTrack, $$KnownTracksTableReferences),
//           KnownTrack,
//           PrefetchHooks Function({
//             bool playlistTracksRefs,
//             bool listenStatsRefs,
//           })
//         > {
//   $$KnownTracksTableTableManager(_$AppDatabase db, $KnownTracksTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$KnownTracksTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$KnownTracksTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$KnownTracksTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 Value<String> path = const Value.absent(),
//                 Value<String> title = const Value.absent(),
//                 Value<String> artists = const Value.absent(),
//                 Value<String> album = const Value.absent(),
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<String?> blurCoverPath = const Value.absent(),
//                 Value<String?> md5 = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//                 Value<String?> sourceid = const Value.absent(),
//                 Value<bool> downloaded = const Value.absent(),
//               }) => KnownTracksCompanion(
//                 id: id,
//                 path: path,
//                 title: title,
//                 artists: artists,
//                 album: album,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 blurCoverPath: blurCoverPath,
//                 md5: md5,
//                 source: source,
//                 sourceid: sourceid,
//                 downloaded: downloaded,
//               ),
//           createCompanionCallback:
//               ({
//                 Value<int> id = const Value.absent(),
//                 required String path,
//                 required String title,
//                 required String artists,
//                 required String album,
//                 Value<String?> coverUrl = const Value.absent(),
//                 Value<String?> coverPath = const Value.absent(),
//                 Value<String?> blurCoverPath = const Value.absent(),
//                 Value<String?> md5 = const Value.absent(),
//                 Value<String> source = const Value.absent(),
//                 Value<String?> sourceid = const Value.absent(),
//                 required bool downloaded,
//               }) => KnownTracksCompanion.insert(
//                 id: id,
//                 path: path,
//                 title: title,
//                 artists: artists,
//                 album: album,
//                 coverUrl: coverUrl,
//                 coverPath: coverPath,
//                 blurCoverPath: blurCoverPath,
//                 md5: md5,
//                 source: source,
//                 sourceid: sourceid,
//                 downloaded: downloaded,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$KnownTracksTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback:
//               ({playlistTracksRefs = false, listenStatsRefs = false}) {
//                 return PrefetchHooks(
//                   db: db,
//                   explicitlyWatchedTables: [
//                     if (playlistTracksRefs) db.playlistTracks,
//                     if (listenStatsRefs) db.listenStats,
//                   ],
//                   addJoins: null,
//                   getPrefetchedDataCallback: (items) async {
//                     return [
//                       if (playlistTracksRefs)
//                         await $_getPrefetchedData<
//                           KnownTrack,
//                           $KnownTracksTable,
//                           PlaylistTrack
//                         >(
//                           currentTable: table,
//                           referencedTable: $$KnownTracksTableReferences
//                               ._playlistTracksRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$KnownTracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).playlistTracksRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.track == item.id,
//                               ),
//                           typedResults: items,
//                         ),
//                       if (listenStatsRefs)
//                         await $_getPrefetchedData<
//                           KnownTrack,
//                           $KnownTracksTable,
//                           ListenStat
//                         >(
//                           currentTable: table,
//                           referencedTable: $$KnownTracksTableReferences
//                               ._listenStatsRefsTable(db),
//                           managerFromTypedResult: (p0) =>
//                               $$KnownTracksTableReferences(
//                                 db,
//                                 table,
//                                 p0,
//                               ).listenStatsRefs,
//                           referencedItemsForCurrentItem:
//                               (item, referencedItems) => referencedItems.where(
//                                 (e) => e.track == item.id,
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

// typedef $$KnownTracksTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $KnownTracksTable,
//       KnownTrack,
//       $$KnownTracksTableFilterComposer,
//       $$KnownTracksTableOrderingComposer,
//       $$KnownTracksTableAnnotationComposer,
//       $$KnownTracksTableCreateCompanionBuilder,
//       $$KnownTracksTableUpdateCompanionBuilder,
//       (KnownTrack, $$KnownTracksTableReferences),
//       KnownTrack,
//       PrefetchHooks Function({bool playlistTracksRefs, bool listenStatsRefs})
//     >;
// typedef $$PlaylistTracksTableCreateCompanionBuilder =
//     PlaylistTracksCompanion Function({
//       required int track,
//       required int playlist,
//       required int position,
//       Value<int> rowid,
//     });
// typedef $$PlaylistTracksTableUpdateCompanionBuilder =
//     PlaylistTracksCompanion Function({
//       Value<int> track,
//       Value<int> playlist,
//       Value<int> position,
//       Value<int> rowid,
//     });

// final class $$PlaylistTracksTableReferences
//     extends BaseReferences<_$AppDatabase, $PlaylistTracksTable, PlaylistTrack> {
//   $$PlaylistTracksTableReferences(
//     super.$_db,
//     super.$_table,
//     super.$_typedResult,
//   );

//   static $KnownTracksTable _trackTable(_$AppDatabase db) =>
//       db.knownTracks.createAlias(
//         $_aliasNameGenerator(db.playlistTracks.track, db.knownTracks.id),
//       );

//   $$KnownTracksTableProcessedTableManager get track {
//     final $_column = $_itemColumn<int>('track')!;

//     final manager = $$KnownTracksTableTableManager(
//       $_db,
//       $_db.knownTracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_trackTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }

//   static $PlaylistsTable _playlistTable(_$AppDatabase db) =>
//       db.playlists.createAlias(
//         $_aliasNameGenerator(db.playlistTracks.playlist, db.playlists.id),
//       );

//   $$PlaylistsTableProcessedTableManager get playlist {
//     final $_column = $_itemColumn<int>('playlist')!;

//     final manager = $$PlaylistsTableTableManager(
//       $_db,
//       $_db.playlists,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_playlistTable($_db));
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
//   ColumnFilters<int> get position => $composableBuilder(
//     column: $table.position,
//     builder: (column) => ColumnFilters(column),
//   );

//   $$KnownTracksTableFilterComposer get track {
//     final $$KnownTracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.track,
//       referencedTable: $db.knownTracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$KnownTracksTableFilterComposer(
//             $db: $db,
//             $table: $db.knownTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$PlaylistsTableFilterComposer get playlist {
//     final $$PlaylistsTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.playlist,
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
//   ColumnOrderings<int> get position => $composableBuilder(
//     column: $table.position,
//     builder: (column) => ColumnOrderings(column),
//   );

//   $$KnownTracksTableOrderingComposer get track {
//     final $$KnownTracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.track,
//       referencedTable: $db.knownTracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$KnownTracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.knownTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$PlaylistsTableOrderingComposer get playlist {
//     final $$PlaylistsTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.playlist,
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
//   GeneratedColumn<int> get position =>
//       $composableBuilder(column: $table.position, builder: (column) => column);

//   $$KnownTracksTableAnnotationComposer get track {
//     final $$KnownTracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.track,
//       referencedTable: $db.knownTracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$KnownTracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.knownTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }

//   $$PlaylistsTableAnnotationComposer get playlist {
//     final $$PlaylistsTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.playlist,
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
//           PrefetchHooks Function({bool track, bool playlist})
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
//                 Value<int> track = const Value.absent(),
//                 Value<int> playlist = const Value.absent(),
//                 Value<int> position = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => PlaylistTracksCompanion(
//                 track: track,
//                 playlist: playlist,
//                 position: position,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int track,
//                 required int playlist,
//                 required int position,
//                 Value<int> rowid = const Value.absent(),
//               }) => PlaylistTracksCompanion.insert(
//                 track: track,
//                 playlist: playlist,
//                 position: position,
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
//           prefetchHooksCallback: ({track = false, playlist = false}) {
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
//                     if (track) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.track,
//                                 referencedTable: $$PlaylistTracksTableReferences
//                                     ._trackTable(db),
//                                 referencedColumn:
//                                     $$PlaylistTracksTableReferences
//                                         ._trackTable(db)
//                                         .id,
//                               )
//                               as T;
//                     }
//                     if (playlist) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.playlist,
//                                 referencedTable: $$PlaylistTracksTableReferences
//                                     ._playlistTable(db),
//                                 referencedColumn:
//                                     $$PlaylistTracksTableReferences
//                                         ._playlistTable(db)
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
//       PrefetchHooks Function({bool track, bool playlist})
//     >;
// typedef $$CoverColorsTableCreateCompanionBuilder =
//     CoverColorsCompanion Function({
//       required String md5,
//       required String colors,
//       Value<int> rowid,
//     });
// typedef $$CoverColorsTableUpdateCompanionBuilder =
//     CoverColorsCompanion Function({
//       Value<String> md5,
//       Value<String> colors,
//       Value<int> rowid,
//     });

// class $$CoverColorsTableFilterComposer
//     extends Composer<_$AppDatabase, $CoverColorsTable> {
//   $$CoverColorsTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<String> get md5 => $composableBuilder(
//     column: $table.md5,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<String> get colors => $composableBuilder(
//     column: $table.colors,
//     builder: (column) => ColumnFilters(column),
//   );
// }

// class $$CoverColorsTableOrderingComposer
//     extends Composer<_$AppDatabase, $CoverColorsTable> {
//   $$CoverColorsTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<String> get md5 => $composableBuilder(
//     column: $table.md5,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<String> get colors => $composableBuilder(
//     column: $table.colors,
//     builder: (column) => ColumnOrderings(column),
//   );
// }

// class $$CoverColorsTableAnnotationComposer
//     extends Composer<_$AppDatabase, $CoverColorsTable> {
//   $$CoverColorsTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<String> get md5 =>
//       $composableBuilder(column: $table.md5, builder: (column) => column);

//   GeneratedColumn<String> get colors =>
//       $composableBuilder(column: $table.colors, builder: (column) => column);
// }

// class $$CoverColorsTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $CoverColorsTable,
//           CoverColor,
//           $$CoverColorsTableFilterComposer,
//           $$CoverColorsTableOrderingComposer,
//           $$CoverColorsTableAnnotationComposer,
//           $$CoverColorsTableCreateCompanionBuilder,
//           $$CoverColorsTableUpdateCompanionBuilder,
//           (
//             CoverColor,
//             BaseReferences<_$AppDatabase, $CoverColorsTable, CoverColor>,
//           ),
//           CoverColor,
//           PrefetchHooks Function()
//         > {
//   $$CoverColorsTableTableManager(_$AppDatabase db, $CoverColorsTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$CoverColorsTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$CoverColorsTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$CoverColorsTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<String> md5 = const Value.absent(),
//                 Value<String> colors = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) =>
//                   CoverColorsCompanion(md5: md5, colors: colors, rowid: rowid),
//           createCompanionCallback:
//               ({
//                 required String md5,
//                 required String colors,
//                 Value<int> rowid = const Value.absent(),
//               }) => CoverColorsCompanion.insert(
//                 md5: md5,
//                 colors: colors,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
//               .toList(),
//           prefetchHooksCallback: null,
//         ),
//       );
// }

// typedef $$CoverColorsTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $CoverColorsTable,
//       CoverColor,
//       $$CoverColorsTableFilterComposer,
//       $$CoverColorsTableOrderingComposer,
//       $$CoverColorsTableAnnotationComposer,
//       $$CoverColorsTableCreateCompanionBuilder,
//       $$CoverColorsTableUpdateCompanionBuilder,
//       (
//         CoverColor,
//         BaseReferences<_$AppDatabase, $CoverColorsTable, CoverColor>,
//       ),
//       CoverColor,
//       PrefetchHooks Function()
//     >;
// typedef $$ListenStatsTableCreateCompanionBuilder =
//     ListenStatsCompanion Function({
//       required int track,
//       required DateTime time,
//       required int playedSeconds,
//       required int totalTrackDuration,
//       required int progressPercent,
//       required bool isSkipped,
//       Value<int> rowid,
//     });
// typedef $$ListenStatsTableUpdateCompanionBuilder =
//     ListenStatsCompanion Function({
//       Value<int> track,
//       Value<DateTime> time,
//       Value<int> playedSeconds,
//       Value<int> totalTrackDuration,
//       Value<int> progressPercent,
//       Value<bool> isSkipped,
//       Value<int> rowid,
//     });

// final class $$ListenStatsTableReferences
//     extends BaseReferences<_$AppDatabase, $ListenStatsTable, ListenStat> {
//   $$ListenStatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

//   static $KnownTracksTable _trackTable(_$AppDatabase db) =>
//       db.knownTracks.createAlias(
//         $_aliasNameGenerator(db.listenStats.track, db.knownTracks.id),
//       );

//   $$KnownTracksTableProcessedTableManager get track {
//     final $_column = $_itemColumn<int>('track')!;

//     final manager = $$KnownTracksTableTableManager(
//       $_db,
//       $_db.knownTracks,
//     ).filter((f) => f.id.sqlEquals($_column));
//     final item = $_typedResult.readTableOrNull(_trackTable($_db));
//     if (item == null) return manager;
//     return ProcessedTableManager(
//       manager.$state.copyWith(prefetchedData: [item]),
//     );
//   }
// }

// class $$ListenStatsTableFilterComposer
//     extends Composer<_$AppDatabase, $ListenStatsTable> {
//   $$ListenStatsTableFilterComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnFilters<DateTime> get time => $composableBuilder(
//     column: $table.time,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get playedSeconds => $composableBuilder(
//     column: $table.playedSeconds,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get totalTrackDuration => $composableBuilder(
//     column: $table.totalTrackDuration,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<int> get progressPercent => $composableBuilder(
//     column: $table.progressPercent,
//     builder: (column) => ColumnFilters(column),
//   );

//   ColumnFilters<bool> get isSkipped => $composableBuilder(
//     column: $table.isSkipped,
//     builder: (column) => ColumnFilters(column),
//   );

//   $$KnownTracksTableFilterComposer get track {
//     final $$KnownTracksTableFilterComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.track,
//       referencedTable: $db.knownTracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$KnownTracksTableFilterComposer(
//             $db: $db,
//             $table: $db.knownTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$ListenStatsTableOrderingComposer
//     extends Composer<_$AppDatabase, $ListenStatsTable> {
//   $$ListenStatsTableOrderingComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   ColumnOrderings<DateTime> get time => $composableBuilder(
//     column: $table.time,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get playedSeconds => $composableBuilder(
//     column: $table.playedSeconds,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get totalTrackDuration => $composableBuilder(
//     column: $table.totalTrackDuration,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<int> get progressPercent => $composableBuilder(
//     column: $table.progressPercent,
//     builder: (column) => ColumnOrderings(column),
//   );

//   ColumnOrderings<bool> get isSkipped => $composableBuilder(
//     column: $table.isSkipped,
//     builder: (column) => ColumnOrderings(column),
//   );

//   $$KnownTracksTableOrderingComposer get track {
//     final $$KnownTracksTableOrderingComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.track,
//       referencedTable: $db.knownTracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$KnownTracksTableOrderingComposer(
//             $db: $db,
//             $table: $db.knownTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$ListenStatsTableAnnotationComposer
//     extends Composer<_$AppDatabase, $ListenStatsTable> {
//   $$ListenStatsTableAnnotationComposer({
//     required super.$db,
//     required super.$table,
//     super.joinBuilder,
//     super.$addJoinBuilderToRootComposer,
//     super.$removeJoinBuilderFromRootComposer,
//   });
//   GeneratedColumn<DateTime> get time =>
//       $composableBuilder(column: $table.time, builder: (column) => column);

//   GeneratedColumn<int> get playedSeconds => $composableBuilder(
//     column: $table.playedSeconds,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get totalTrackDuration => $composableBuilder(
//     column: $table.totalTrackDuration,
//     builder: (column) => column,
//   );

//   GeneratedColumn<int> get progressPercent => $composableBuilder(
//     column: $table.progressPercent,
//     builder: (column) => column,
//   );

//   GeneratedColumn<bool> get isSkipped =>
//       $composableBuilder(column: $table.isSkipped, builder: (column) => column);

//   $$KnownTracksTableAnnotationComposer get track {
//     final $$KnownTracksTableAnnotationComposer composer = $composerBuilder(
//       composer: this,
//       getCurrentColumn: (t) => t.track,
//       referencedTable: $db.knownTracks,
//       getReferencedColumn: (t) => t.id,
//       builder:
//           (
//             joinBuilder, {
//             $addJoinBuilderToRootComposer,
//             $removeJoinBuilderFromRootComposer,
//           }) => $$KnownTracksTableAnnotationComposer(
//             $db: $db,
//             $table: $db.knownTracks,
//             $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
//             joinBuilder: joinBuilder,
//             $removeJoinBuilderFromRootComposer:
//                 $removeJoinBuilderFromRootComposer,
//           ),
//     );
//     return composer;
//   }
// }

// class $$ListenStatsTableTableManager
//     extends
//         RootTableManager<
//           _$AppDatabase,
//           $ListenStatsTable,
//           ListenStat,
//           $$ListenStatsTableFilterComposer,
//           $$ListenStatsTableOrderingComposer,
//           $$ListenStatsTableAnnotationComposer,
//           $$ListenStatsTableCreateCompanionBuilder,
//           $$ListenStatsTableUpdateCompanionBuilder,
//           (ListenStat, $$ListenStatsTableReferences),
//           ListenStat,
//           PrefetchHooks Function({bool track})
//         > {
//   $$ListenStatsTableTableManager(_$AppDatabase db, $ListenStatsTable table)
//     : super(
//         TableManagerState(
//           db: db,
//           table: table,
//           createFilteringComposer: () =>
//               $$ListenStatsTableFilterComposer($db: db, $table: table),
//           createOrderingComposer: () =>
//               $$ListenStatsTableOrderingComposer($db: db, $table: table),
//           createComputedFieldComposer: () =>
//               $$ListenStatsTableAnnotationComposer($db: db, $table: table),
//           updateCompanionCallback:
//               ({
//                 Value<int> track = const Value.absent(),
//                 Value<DateTime> time = const Value.absent(),
//                 Value<int> playedSeconds = const Value.absent(),
//                 Value<int> totalTrackDuration = const Value.absent(),
//                 Value<int> progressPercent = const Value.absent(),
//                 Value<bool> isSkipped = const Value.absent(),
//                 Value<int> rowid = const Value.absent(),
//               }) => ListenStatsCompanion(
//                 track: track,
//                 time: time,
//                 playedSeconds: playedSeconds,
//                 totalTrackDuration: totalTrackDuration,
//                 progressPercent: progressPercent,
//                 isSkipped: isSkipped,
//                 rowid: rowid,
//               ),
//           createCompanionCallback:
//               ({
//                 required int track,
//                 required DateTime time,
//                 required int playedSeconds,
//                 required int totalTrackDuration,
//                 required int progressPercent,
//                 required bool isSkipped,
//                 Value<int> rowid = const Value.absent(),
//               }) => ListenStatsCompanion.insert(
//                 track: track,
//                 time: time,
//                 playedSeconds: playedSeconds,
//                 totalTrackDuration: totalTrackDuration,
//                 progressPercent: progressPercent,
//                 isSkipped: isSkipped,
//                 rowid: rowid,
//               ),
//           withReferenceMapper: (p0) => p0
//               .map(
//                 (e) => (
//                   e.readTable(table),
//                   $$ListenStatsTableReferences(db, table, e),
//                 ),
//               )
//               .toList(),
//           prefetchHooksCallback: ({track = false}) {
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
//                     if (track) {
//                       state =
//                           state.withJoin(
//                                 currentTable: table,
//                                 currentColumn: table.track,
//                                 referencedTable: $$ListenStatsTableReferences
//                                     ._trackTable(db),
//                                 referencedColumn: $$ListenStatsTableReferences
//                                     ._trackTable(db)
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

// typedef $$ListenStatsTableProcessedTableManager =
//     ProcessedTableManager<
//       _$AppDatabase,
//       $ListenStatsTable,
//       ListenStat,
//       $$ListenStatsTableFilterComposer,
//       $$ListenStatsTableOrderingComposer,
//       $$ListenStatsTableAnnotationComposer,
//       $$ListenStatsTableCreateCompanionBuilder,
//       $$ListenStatsTableUpdateCompanionBuilder,
//       (ListenStat, $$ListenStatsTableReferences),
//       ListenStat,
//       PrefetchHooks Function({bool track})
//     >;

// class $AppDatabaseManager {
//   final _$AppDatabase _db;
//   $AppDatabaseManager(this._db);
//   $$PlaylistsTableTableManager get playlists =>
//       $$PlaylistsTableTableManager(_db, _db.playlists);
//   $$KnownTracksTableTableManager get knownTracks =>
//       $$KnownTracksTableTableManager(_db, _db.knownTracks);
//   $$PlaylistTracksTableTableManager get playlistTracks =>
//       $$PlaylistTracksTableTableManager(_db, _db.playlistTracks);
//   $$CoverColorsTableTableManager get coverColors =>
//       $$CoverColorsTableTableManager(_db, _db.coverColors);
//   $$ListenStatsTableTableManager get listenStats =>
//       $$ListenStatsTableTableManager(_db, _db.listenStats);
// }
