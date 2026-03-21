// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'listen_logger.dart';

// // **************************************************************************
// // IsarCollectionGenerator
// // **************************************************************************

// // coverage:ignore-file
// // ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

// extension GetPlayerTrack1Collection on Isar {
//   IsarCollection<PlayerTrack1> get playerTrack1s => this.collection();
// }

// const PlayerTrack1Schema = CollectionSchema(
//   name: r'PlayerTrack1',
//   id: -8735287268116828532,
//   properties: {
//     r'albums': PropertySchema(
//       id: 0,
//       name: r'albums',
//       type: IsarType.stringList,
//     ),
//     r'artists': PropertySchema(
//       id: 1,
//       name: r'artists',
//       type: IsarType.stringList,
//     ),
//     r'cover': PropertySchema(
//       id: 2,
//       name: r'cover',
//       type: IsarType.string,
//     ),
//     r'filepath': PropertySchema(
//       id: 3,
//       name: r'filepath',
//       type: IsarType.string,
//     ),
//     r'md5Hash': PropertySchema(
//       id: 4,
//       name: r'md5Hash',
//       type: IsarType.string,
//     ),
//     r'source': PropertySchema(
//       id: 5,
//       name: r'source',
//       type: IsarType.byte,
//       enumMap: _PlayerTrack1sourceEnumValueMap,
//     ),
//     r'title': PropertySchema(
//       id: 6,
//       name: r'title',
//       type: IsarType.string,
//     )
//   },
//   estimateSize: _playerTrack1EstimateSize,
//   serialize: _playerTrack1Serialize,
//   deserialize: _playerTrack1Deserialize,
//   deserializeProp: _playerTrack1DeserializeProp,
//   idName: r'id',
//   indexes: {
//     r'md5Hash': IndexSchema(
//       id: -2016395055340351828,
//       name: r'md5Hash',
//       unique: true,
//       replace: true,
//       properties: [
//         IndexPropertySchema(
//           name: r'md5Hash',
//           type: IndexType.hash,
//           caseSensitive: true,
//         )
//       ],
//     )
//   },
//   links: {},
//   embeddedSchemas: {},
//   getId: _playerTrack1GetId,
//   getLinks: _playerTrack1GetLinks,
//   attach: _playerTrack1Attach,
//   version: '3.1.0+1',
// );

// int _playerTrack1EstimateSize(
//   PlayerTrack1 object,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   var bytesCount = offsets.last;
//   bytesCount += 3 + object.albums.length * 3;
//   {
//     for (var i = 0; i < object.albums.length; i++) {
//       final value = object.albums[i];
//       bytesCount += value.length * 3;
//     }
//   }
//   bytesCount += 3 + object.artists.length * 3;
//   {
//     for (var i = 0; i < object.artists.length; i++) {
//       final value = object.artists[i];
//       bytesCount += value.length * 3;
//     }
//   }
//   bytesCount += 3 + object.cover.length * 3;
//   bytesCount += 3 + object.filepath.length * 3;
//   bytesCount += 3 + object.md5Hash.length * 3;
//   bytesCount += 3 + object.title.length * 3;
//   return bytesCount;
// }

// void _playerTrack1Serialize(
//   PlayerTrack1 object,
//   IsarWriter writer,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   writer.writeStringList(offsets[0], object.albums);
//   writer.writeStringList(offsets[1], object.artists);
//   writer.writeString(offsets[2], object.cover);
//   writer.writeString(offsets[3], object.filepath);
//   writer.writeString(offsets[4], object.md5Hash);
//   writer.writeByte(offsets[5], object.source.index);
//   writer.writeString(offsets[6], object.title);
// }

// PlayerTrack1 _playerTrack1Deserialize(
//   Id id,
//   IsarReader reader,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   final object = PlayerTrack1(
//     albums: reader.readStringList(offsets[0]) ?? [],
//     artists: reader.readStringList(offsets[1]) ?? [],
//     cover: reader.readString(offsets[2]),
//     filepath: reader.readString(offsets[3]),
//     md5Hash: reader.readString(offsets[4]),
//     source:
//         _PlayerTrack1sourceValueEnumMap[reader.readByteOrNull(offsets[5])] ??
//             Source.yandexMusic,
//     title: reader.readString(offsets[6]),
//   );
//   object.id = id;
//   return object;
// }

// P _playerTrack1DeserializeProp<P>(
//   IsarReader reader,
//   int propertyId,
//   int offset,
//   Map<Type, List<int>> allOffsets,
// ) {
//   switch (propertyId) {
//     case 0:
//       return (reader.readStringList(offset) ?? []) as P;
//     case 1:
//       return (reader.readStringList(offset) ?? []) as P;
//     case 2:
//       return (reader.readString(offset)) as P;
//     case 3:
//       return (reader.readString(offset)) as P;
//     case 4:
//       return (reader.readString(offset)) as P;
//     case 5:
//       return (_PlayerTrack1sourceValueEnumMap[reader.readByteOrNull(offset)] ??
//           Source.yandexMusic) as P;
//     case 6:
//       return (reader.readString(offset)) as P;
//     default:
//       throw IsarError('Unknown property with id $propertyId');
//   }
// }

// const _PlayerTrack1sourceEnumValueMap = {
//   'yandexMusic': 0,
//   'local': 1,
// };
// const _PlayerTrack1sourceValueEnumMap = {
//   0: Source.yandexMusic,
//   1: Source.local,
// };

// Id _playerTrack1GetId(PlayerTrack1 object) {
//   return object.id;
// }

// List<IsarLinkBase<dynamic>> _playerTrack1GetLinks(PlayerTrack1 object) {
//   return [];
// }

// void _playerTrack1Attach(
//     IsarCollection<dynamic> col, Id id, PlayerTrack1 object) {
//   object.id = id;
// }

// extension PlayerTrack1ByIndex on IsarCollection<PlayerTrack1> {
//   Future<PlayerTrack1?> getByMd5Hash(String md5Hash) {
//     return getByIndex(r'md5Hash', [md5Hash]);
//   }

//   PlayerTrack1? getByMd5HashSync(String md5Hash) {
//     return getByIndexSync(r'md5Hash', [md5Hash]);
//   }

//   Future<bool> deleteByMd5Hash(String md5Hash) {
//     return deleteByIndex(r'md5Hash', [md5Hash]);
//   }

//   bool deleteByMd5HashSync(String md5Hash) {
//     return deleteByIndexSync(r'md5Hash', [md5Hash]);
//   }

//   Future<List<PlayerTrack1?>> getAllByMd5Hash(List<String> md5HashValues) {
//     final values = md5HashValues.map((e) => [e]).toList();
//     return getAllByIndex(r'md5Hash', values);
//   }

//   List<PlayerTrack1?> getAllByMd5HashSync(List<String> md5HashValues) {
//     final values = md5HashValues.map((e) => [e]).toList();
//     return getAllByIndexSync(r'md5Hash', values);
//   }

//   Future<int> deleteAllByMd5Hash(List<String> md5HashValues) {
//     final values = md5HashValues.map((e) => [e]).toList();
//     return deleteAllByIndex(r'md5Hash', values);
//   }

//   int deleteAllByMd5HashSync(List<String> md5HashValues) {
//     final values = md5HashValues.map((e) => [e]).toList();
//     return deleteAllByIndexSync(r'md5Hash', values);
//   }

//   Future<Id> putByMd5Hash(PlayerTrack1 object) {
//     return putByIndex(r'md5Hash', object);
//   }

//   Id putByMd5HashSync(PlayerTrack1 object, {bool saveLinks = true}) {
//     return putByIndexSync(r'md5Hash', object, saveLinks: saveLinks);
//   }

//   Future<List<Id>> putAllByMd5Hash(List<PlayerTrack1> objects) {
//     return putAllByIndex(r'md5Hash', objects);
//   }

//   List<Id> putAllByMd5HashSync(List<PlayerTrack1> objects,
//       {bool saveLinks = true}) {
//     return putAllByIndexSync(r'md5Hash', objects, saveLinks: saveLinks);
//   }
// }

// extension PlayerTrack1QueryWhereSort
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QWhere> {
//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterWhere> anyId() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(const IdWhereClause.any());
//     });
//   }
// }

// extension PlayerTrack1QueryWhere
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QWhereClause> {
//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterWhereClause> idEqualTo(Id id) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: id,
//         upper: id,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterWhereClause> idNotEqualTo(
//       Id id) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             )
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             );
//       } else {
//         return query
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             )
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             );
//       }
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterWhereClause> idGreaterThan(
//       Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.greaterThan(lower: id, includeLower: include),
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterWhereClause> idLessThan(Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.lessThan(upper: id, includeUpper: include),
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterWhereClause> idBetween(
//     Id lowerId,
//     Id upperId, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: lowerId,
//         includeLower: includeLower,
//         upper: upperId,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterWhereClause> md5HashEqualTo(
//       String md5Hash) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.equalTo(
//         indexName: r'md5Hash',
//         value: [md5Hash],
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterWhereClause> md5HashNotEqualTo(
//       String md5Hash) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'md5Hash',
//               lower: [],
//               upper: [md5Hash],
//               includeUpper: false,
//             ))
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'md5Hash',
//               lower: [md5Hash],
//               includeLower: false,
//               upper: [],
//             ));
//       } else {
//         return query
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'md5Hash',
//               lower: [md5Hash],
//               includeLower: false,
//               upper: [],
//             ))
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'md5Hash',
//               lower: [],
//               upper: [md5Hash],
//               includeUpper: false,
//             ));
//       }
//     });
//   }
// }

// extension PlayerTrack1QueryFilter
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QFilterCondition> {
//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'albums',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'albums',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'albums',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'albums',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'albums',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'albums',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementContains(String value, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'albums',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementMatches(String pattern, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'albums',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'albums',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsElementIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'albums',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsLengthEqualTo(int length) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'albums',
//         length,
//         true,
//         length,
//         true,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'albums',
//         0,
//         true,
//         0,
//         true,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'albums',
//         0,
//         false,
//         999999,
//         true,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsLengthLessThan(
//     int length, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'albums',
//         0,
//         true,
//         length,
//         include,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsLengthGreaterThan(
//     int length, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'albums',
//         length,
//         include,
//         999999,
//         true,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       albumsLengthBetween(
//     int lower,
//     int upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'albums',
//         lower,
//         includeLower,
//         upper,
//         includeUpper,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'artists',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'artists',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'artists',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'artists',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'artists',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'artists',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementContains(String value, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'artists',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementMatches(String pattern, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'artists',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'artists',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsElementIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'artists',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsLengthEqualTo(int length) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'artists',
//         length,
//         true,
//         length,
//         true,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'artists',
//         0,
//         true,
//         0,
//         true,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'artists',
//         0,
//         false,
//         999999,
//         true,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsLengthLessThan(
//     int length, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'artists',
//         0,
//         true,
//         length,
//         include,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsLengthGreaterThan(
//     int length, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'artists',
//         length,
//         include,
//         999999,
//         true,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       artistsLengthBetween(
//     int lower,
//     int upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.listLength(
//         r'artists',
//         lower,
//         includeLower,
//         upper,
//         includeUpper,
//       );
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> coverEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'cover',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       coverGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'cover',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> coverLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'cover',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> coverBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'cover',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       coverStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'cover',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> coverEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'cover',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> coverContains(
//       String value,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'cover',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> coverMatches(
//       String pattern,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'cover',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       coverIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'cover',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       coverIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'cover',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'filepath',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'filepath',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'filepath',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'filepath',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'filepath',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'filepath',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathContains(String value, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'filepath',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathMatches(String pattern, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'filepath',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'filepath',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       filepathIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'filepath',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> idEqualTo(
//       Id value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> idGreaterThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> idLessThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> idBetween(
//     Id lower,
//     Id upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'id',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'md5Hash',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'md5Hash',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'md5Hash',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'md5Hash',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'md5Hash',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'md5Hash',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashContains(String value, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'md5Hash',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashMatches(String pattern, {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'md5Hash',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'md5Hash',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       md5HashIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'md5Hash',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> sourceEqualTo(
//       Source value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'source',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       sourceGreaterThan(
//     Source value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'source',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       sourceLessThan(
//     Source value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'source',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> sourceBetween(
//     Source lower,
//     Source upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'source',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> titleEqualTo(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       titleGreaterThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> titleLessThan(
//     String value, {
//     bool include = false,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> titleBetween(
//     String lower,
//     String upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'title',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       titleStartsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.startsWith(
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> titleEndsWith(
//     String value, {
//     bool caseSensitive = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.endsWith(
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> titleContains(
//       String value,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.contains(
//         property: r'title',
//         value: value,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition> titleMatches(
//       String pattern,
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.matches(
//         property: r'title',
//         wildcard: pattern,
//         caseSensitive: caseSensitive,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       titleIsEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'title',
//         value: '',
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterFilterCondition>
//       titleIsNotEmpty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         property: r'title',
//         value: '',
//       ));
//     });
//   }
// }

// extension PlayerTrack1QueryObject
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QFilterCondition> {}

// extension PlayerTrack1QueryLinks
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QFilterCondition> {}

// extension PlayerTrack1QuerySortBy
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QSortBy> {
//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortByCover() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'cover', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortByCoverDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'cover', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortByFilepath() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'filepath', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortByFilepathDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'filepath', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortByMd5Hash() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'md5Hash', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortByMd5HashDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'md5Hash', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortBySource() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'source', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortBySourceDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'source', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortByTitle() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'title', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> sortByTitleDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'title', Sort.desc);
//     });
//   }
// }

// extension PlayerTrack1QuerySortThenBy
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QSortThenBy> {
//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByCover() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'cover', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByCoverDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'cover', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByFilepath() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'filepath', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByFilepathDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'filepath', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenById() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByIdDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByMd5Hash() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'md5Hash', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByMd5HashDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'md5Hash', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenBySource() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'source', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenBySourceDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'source', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByTitle() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'title', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QAfterSortBy> thenByTitleDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'title', Sort.desc);
//     });
//   }
// }

// extension PlayerTrack1QueryWhereDistinct
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QDistinct> {
//   QueryBuilder<PlayerTrack1, PlayerTrack1, QDistinct> distinctByAlbums() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'albums');
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QDistinct> distinctByArtists() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'artists');
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QDistinct> distinctByCover(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'cover', caseSensitive: caseSensitive);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QDistinct> distinctByFilepath(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'filepath', caseSensitive: caseSensitive);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QDistinct> distinctByMd5Hash(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'md5Hash', caseSensitive: caseSensitive);
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QDistinct> distinctBySource() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'source');
//     });
//   }

//   QueryBuilder<PlayerTrack1, PlayerTrack1, QDistinct> distinctByTitle(
//       {bool caseSensitive = true}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
//     });
//   }
// }

// extension PlayerTrack1QueryProperty
//     on QueryBuilder<PlayerTrack1, PlayerTrack1, QQueryProperty> {
//   QueryBuilder<PlayerTrack1, int, QQueryOperations> idProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'id');
//     });
//   }

//   QueryBuilder<PlayerTrack1, List<String>, QQueryOperations> albumsProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'albums');
//     });
//   }

//   QueryBuilder<PlayerTrack1, List<String>, QQueryOperations> artistsProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'artists');
//     });
//   }

//   QueryBuilder<PlayerTrack1, String, QQueryOperations> coverProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'cover');
//     });
//   }

//   QueryBuilder<PlayerTrack1, String, QQueryOperations> filepathProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'filepath');
//     });
//   }

//   QueryBuilder<PlayerTrack1, String, QQueryOperations> md5HashProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'md5Hash');
//     });
//   }

//   QueryBuilder<PlayerTrack1, Source, QQueryOperations> sourceProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'source');
//     });
//   }

//   QueryBuilder<PlayerTrack1, String, QQueryOperations> titleProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'title');
//     });
//   }
// }

// // coverage:ignore-file
// // ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

// extension GetPlayerTrackStatCollection on Isar {
//   IsarCollection<PlayerTrackStat> get playerTrackStats => this.collection();
// }

// const PlayerTrackStatSchema = CollectionSchema(
//   name: r'PlayerTrackStat',
//   id: 6705731610674877699,
//   properties: {
//     r'changeType': PropertySchema(
//       id: 0,
//       name: r'changeType',
//       type: IsarType.byte,
//       enumMap: _PlayerTrackStatchangeTypeEnumValueMap,
//     ),
//     r'playedSeconds': PropertySchema(
//       id: 1,
//       name: r'playedSeconds',
//       type: IsarType.long,
//     ),
//     r'progressPercent': PropertySchema(
//       id: 2,
//       name: r'progressPercent',
//       type: IsarType.long,
//     ),
//     r'time': PropertySchema(
//       id: 3,
//       name: r'time',
//       type: IsarType.dateTime,
//     ),
//     r'totalTrackDuration': PropertySchema(
//       id: 4,
//       name: r'totalTrackDuration',
//       type: IsarType.long,
//     )
//   },
//   estimateSize: _playerTrackStatEstimateSize,
//   serialize: _playerTrackStatSerialize,
//   deserialize: _playerTrackStatDeserialize,
//   deserializeProp: _playerTrackStatDeserializeProp,
//   idName: r'id',
//   indexes: {
//     r'time': IndexSchema(
//       id: -2250472054110640942,
//       name: r'time',
//       unique: false,
//       replace: false,
//       properties: [
//         IndexPropertySchema(
//           name: r'time',
//           type: IndexType.value,
//           caseSensitive: false,
//         )
//       ],
//     ),
//     r'progressPercent': IndexSchema(
//       id: -747329510781924327,
//       name: r'progressPercent',
//       unique: false,
//       replace: false,
//       properties: [
//         IndexPropertySchema(
//           name: r'progressPercent',
//           type: IndexType.value,
//           caseSensitive: false,
//         )
//       ],
//     )
//   },
//   links: {
//     r'track': LinkSchema(
//       id: -2468075212062679561,
//       name: r'track',
//       target: r'PlayerTrack1',
//       single: true,
//     )
//   },
//   embeddedSchemas: {},
//   getId: _playerTrackStatGetId,
//   getLinks: _playerTrackStatGetLinks,
//   attach: _playerTrackStatAttach,
//   version: '3.1.0+1',
// );

// int _playerTrackStatEstimateSize(
//   PlayerTrackStat object,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   var bytesCount = offsets.last;
//   return bytesCount;
// }

// void _playerTrackStatSerialize(
//   PlayerTrackStat object,
//   IsarWriter writer,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   writer.writeByte(offsets[0], object.changeType.index);
//   writer.writeLong(offsets[1], object.playedSeconds);
//   writer.writeLong(offsets[2], object.progressPercent);
//   writer.writeDateTime(offsets[3], object.time);
//   writer.writeLong(offsets[4], object.totalTrackDuration);
// }

// PlayerTrackStat _playerTrackStatDeserialize(
//   Id id,
//   IsarReader reader,
//   List<int> offsets,
//   Map<Type, List<int>> allOffsets,
// ) {
//   final object = PlayerTrackStat(
//     changeType: _PlayerTrackStatchangeTypeValueEnumMap[
//             reader.readByteOrNull(offsets[0])] ??
//         PlayedType.completed,
//     playedSeconds: reader.readLong(offsets[1]),
//     progressPercent: reader.readLong(offsets[2]),
//     time: reader.readDateTime(offsets[3]),
//     totalTrackDuration: reader.readLong(offsets[4]),
//   );
//   object.id = id;
//   return object;
// }

// P _playerTrackStatDeserializeProp<P>(
//   IsarReader reader,
//   int propertyId,
//   int offset,
//   Map<Type, List<int>> allOffsets,
// ) {
//   switch (propertyId) {
//     case 0:
//       return (_PlayerTrackStatchangeTypeValueEnumMap[
//               reader.readByteOrNull(offset)] ??
//           PlayedType.completed) as P;
//     case 1:
//       return (reader.readLong(offset)) as P;
//     case 2:
//       return (reader.readLong(offset)) as P;
//     case 3:
//       return (reader.readDateTime(offset)) as P;
//     case 4:
//       return (reader.readLong(offset)) as P;
//     default:
//       throw IsarError('Unknown property with id $propertyId');
//   }
// }

// const _PlayerTrackStatchangeTypeEnumValueMap = {
//   'completed': 0,
//   'skipped': 1,
// };
// const _PlayerTrackStatchangeTypeValueEnumMap = {
//   0: PlayedType.completed,
//   1: PlayedType.skipped,
// };

// Id _playerTrackStatGetId(PlayerTrackStat object) {
//   return object.id;
// }

// List<IsarLinkBase<dynamic>> _playerTrackStatGetLinks(PlayerTrackStat object) {
//   return [object.track];
// }

// void _playerTrackStatAttach(
//     IsarCollection<dynamic> col, Id id, PlayerTrackStat object) {
//   object.id = id;
//   object.track.attach(col, col.isar.collection<PlayerTrack1>(), r'track', id);
// }

// extension PlayerTrackStatQueryWhereSort
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QWhere> {
//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhere> anyId() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(const IdWhereClause.any());
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhere> anyTime() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         const IndexWhereClause.any(indexName: r'time'),
//       );
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhere>
//       anyProgressPercent() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         const IndexWhereClause.any(indexName: r'progressPercent'),
//       );
//     });
//   }
// }

// extension PlayerTrackStatQueryWhere
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QWhereClause> {
//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause> idEqualTo(
//       Id id) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: id,
//         upper: id,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       idNotEqualTo(Id id) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             )
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             );
//       } else {
//         return query
//             .addWhereClause(
//               IdWhereClause.greaterThan(lower: id, includeLower: false),
//             )
//             .addWhereClause(
//               IdWhereClause.lessThan(upper: id, includeUpper: false),
//             );
//       }
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       idGreaterThan(Id id, {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.greaterThan(lower: id, includeLower: include),
//       );
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause> idLessThan(
//       Id id,
//       {bool include = false}) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(
//         IdWhereClause.lessThan(upper: id, includeUpper: include),
//       );
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause> idBetween(
//     Id lowerId,
//     Id upperId, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IdWhereClause.between(
//         lower: lowerId,
//         includeLower: includeLower,
//         upper: upperId,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause> timeEqualTo(
//       DateTime time) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.equalTo(
//         indexName: r'time',
//         value: [time],
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       timeNotEqualTo(DateTime time) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'time',
//               lower: [],
//               upper: [time],
//               includeUpper: false,
//             ))
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'time',
//               lower: [time],
//               includeLower: false,
//               upper: [],
//             ));
//       } else {
//         return query
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'time',
//               lower: [time],
//               includeLower: false,
//               upper: [],
//             ))
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'time',
//               lower: [],
//               upper: [time],
//               includeUpper: false,
//             ));
//       }
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       timeGreaterThan(
//     DateTime time, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'time',
//         lower: [time],
//         includeLower: include,
//         upper: [],
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       timeLessThan(
//     DateTime time, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'time',
//         lower: [],
//         upper: [time],
//         includeUpper: include,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause> timeBetween(
//     DateTime lowerTime,
//     DateTime upperTime, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'time',
//         lower: [lowerTime],
//         includeLower: includeLower,
//         upper: [upperTime],
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       progressPercentEqualTo(int progressPercent) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.equalTo(
//         indexName: r'progressPercent',
//         value: [progressPercent],
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       progressPercentNotEqualTo(int progressPercent) {
//     return QueryBuilder.apply(this, (query) {
//       if (query.whereSort == Sort.asc) {
//         return query
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'progressPercent',
//               lower: [],
//               upper: [progressPercent],
//               includeUpper: false,
//             ))
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'progressPercent',
//               lower: [progressPercent],
//               includeLower: false,
//               upper: [],
//             ));
//       } else {
//         return query
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'progressPercent',
//               lower: [progressPercent],
//               includeLower: false,
//               upper: [],
//             ))
//             .addWhereClause(IndexWhereClause.between(
//               indexName: r'progressPercent',
//               lower: [],
//               upper: [progressPercent],
//               includeUpper: false,
//             ));
//       }
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       progressPercentGreaterThan(
//     int progressPercent, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'progressPercent',
//         lower: [progressPercent],
//         includeLower: include,
//         upper: [],
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       progressPercentLessThan(
//     int progressPercent, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'progressPercent',
//         lower: [],
//         upper: [progressPercent],
//         includeUpper: include,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterWhereClause>
//       progressPercentBetween(
//     int lowerProgressPercent,
//     int upperProgressPercent, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addWhereClause(IndexWhereClause.between(
//         indexName: r'progressPercent',
//         lower: [lowerProgressPercent],
//         includeLower: includeLower,
//         upper: [upperProgressPercent],
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension PlayerTrackStatQueryFilter
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QFilterCondition> {
//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       changeTypeEqualTo(PlayedType value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'changeType',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       changeTypeGreaterThan(
//     PlayedType value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'changeType',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       changeTypeLessThan(
//     PlayedType value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'changeType',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       changeTypeBetween(
//     PlayedType lower,
//     PlayedType upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'changeType',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       idEqualTo(Id value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       idGreaterThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       idLessThan(
//     Id value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'id',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       idBetween(
//     Id lower,
//     Id upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'id',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       playedSecondsEqualTo(int value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'playedSeconds',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       playedSecondsGreaterThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'playedSeconds',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       playedSecondsLessThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'playedSeconds',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       playedSecondsBetween(
//     int lower,
//     int upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'playedSeconds',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       progressPercentEqualTo(int value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'progressPercent',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       progressPercentGreaterThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'progressPercent',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       progressPercentLessThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'progressPercent',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       progressPercentBetween(
//     int lower,
//     int upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'progressPercent',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       timeEqualTo(DateTime value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'time',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       timeGreaterThan(
//     DateTime value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'time',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       timeLessThan(
//     DateTime value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'time',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       timeBetween(
//     DateTime lower,
//     DateTime upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'time',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       totalTrackDurationEqualTo(int value) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.equalTo(
//         property: r'totalTrackDuration',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       totalTrackDurationGreaterThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.greaterThan(
//         include: include,
//         property: r'totalTrackDuration',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       totalTrackDurationLessThan(
//     int value, {
//     bool include = false,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.lessThan(
//         include: include,
//         property: r'totalTrackDuration',
//         value: value,
//       ));
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       totalTrackDurationBetween(
//     int lower,
//     int upper, {
//     bool includeLower = true,
//     bool includeUpper = true,
//   }) {
//     return QueryBuilder.apply(this, (query) {
//       return query.addFilterCondition(FilterCondition.between(
//         property: r'totalTrackDuration',
//         lower: lower,
//         includeLower: includeLower,
//         upper: upper,
//         includeUpper: includeUpper,
//       ));
//     });
//   }
// }

// extension PlayerTrackStatQueryObject
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QFilterCondition> {}

// extension PlayerTrackStatQueryLinks
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QFilterCondition> {
//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition> track(
//       FilterQuery<PlayerTrack1> q) {
//     return QueryBuilder.apply(this, (query) {
//       return query.link(q, r'track');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterFilterCondition>
//       trackIsNull() {
//     return QueryBuilder.apply(this, (query) {
//       return query.linkLength(r'track', 0, true, 0, true);
//     });
//   }
// }

// extension PlayerTrackStatQuerySortBy
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QSortBy> {
//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByChangeType() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'changeType', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByChangeTypeDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'changeType', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByPlayedSeconds() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'playedSeconds', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByPlayedSecondsDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'playedSeconds', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByProgressPercent() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'progressPercent', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByProgressPercentDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'progressPercent', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy> sortByTime() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'time', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByTimeDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'time', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByTotalTrackDuration() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'totalTrackDuration', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       sortByTotalTrackDurationDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'totalTrackDuration', Sort.desc);
//     });
//   }
// }

// extension PlayerTrackStatQuerySortThenBy
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QSortThenBy> {
//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByChangeType() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'changeType', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByChangeTypeDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'changeType', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy> thenById() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy> thenByIdDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'id', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByPlayedSeconds() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'playedSeconds', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByPlayedSecondsDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'playedSeconds', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByProgressPercent() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'progressPercent', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByProgressPercentDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'progressPercent', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy> thenByTime() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'time', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByTimeDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'time', Sort.desc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByTotalTrackDuration() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'totalTrackDuration', Sort.asc);
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QAfterSortBy>
//       thenByTotalTrackDurationDesc() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addSortBy(r'totalTrackDuration', Sort.desc);
//     });
//   }
// }

// extension PlayerTrackStatQueryWhereDistinct
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QDistinct> {
//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QDistinct>
//       distinctByChangeType() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'changeType');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QDistinct>
//       distinctByPlayedSeconds() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'playedSeconds');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QDistinct>
//       distinctByProgressPercent() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'progressPercent');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QDistinct> distinctByTime() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'time');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayerTrackStat, QDistinct>
//       distinctByTotalTrackDuration() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addDistinctBy(r'totalTrackDuration');
//     });
//   }
// }

// extension PlayerTrackStatQueryProperty
//     on QueryBuilder<PlayerTrackStat, PlayerTrackStat, QQueryProperty> {
//   QueryBuilder<PlayerTrackStat, int, QQueryOperations> idProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'id');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, PlayedType, QQueryOperations>
//       changeTypeProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'changeType');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, int, QQueryOperations> playedSecondsProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'playedSeconds');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, int, QQueryOperations>
//       progressPercentProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'progressPercent');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, DateTime, QQueryOperations> timeProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'time');
//     });
//   }

//   QueryBuilder<PlayerTrackStat, int, QQueryOperations>
//       totalTrackDurationProperty() {
//     return QueryBuilder.apply(this, (query) {
//       return query.addPropertyName(r'totalTrackDuration');
//     });
//   }
// }
