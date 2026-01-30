import 'database_engine.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class DatabaseStreamerService {
  static final DatabaseStreamerService _instance = DatabaseStreamerService._internal();

  factory DatabaseStreamerService() => _instance;

  DatabaseStreamerService._internal();

  late final Database dbInstanse;

  Future<void> init(Database instance) async {
    dbInstanse = instance;
  }

  final volume = ValueNotifier<double>(0.7);
  final stateIndicator = ValueNotifier<bool>(true);
  final recursiveFilesAdding = ValueNotifier<bool>(true);
  final playlistOpeningArea = ValueNotifier<bool>(false);
  final yandexMusicToken = ValueNotifier<String>('');
  final transitionSpeed = ValueNotifier<double>(1.0);
  final yandexMusicSearch = ValueNotifier<bool>(true);
  final yandexMusicPreload = ValueNotifier<bool>(true);
  final yandexMusicQuality = ValueNotifier<String>('mp3');
}
