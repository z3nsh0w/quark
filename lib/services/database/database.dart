import 'package:quark/objects/playlist.dart';
import 'package:quark/services/player/player.dart';

import 'database_engine.dart';
import 'package:flutter/foundation.dart';

class DatabaseStreamerService {
  static final DatabaseStreamerService _instance =
      DatabaseStreamerService._internal();

  factory DatabaseStreamerService() => _instance;

  DatabaseStreamerService._internal();

  Future<void> init() async {
    final v = await Database.get(DatabaseKeys.volume.value);
    final s = await Database.get(DatabaseKeys.stateIndicatorState.value);
    final poa = await Database.get(DatabaseKeys.playlistOpeningArea.value);
    final ymt = await Database.get(DatabaseKeys.yandexMusicToken.value);
    final ts = await Database.get(DatabaseKeys.transitionSpeed.value);
    final yms = await Database.get(DatabaseKeys.yandexMusicSearch.value);
    final ymq = await Database.get(DatabaseKeys.yandexMusicTrackQuality.value);
    final rfs = await Database.get(DatabaseKeys.recursiveFilesAdding.value);
    final ymp = await Database.get(DatabaseKeys.yandexMusicPreload.value);

    volume.value = v ?? 0.7;
    stateIndicator.value = s ?? true;
    recursiveFilesAdding.value = rfs ?? true;
    playlistOpeningArea.value = poa ?? false;
    yandexMusicToken.value = ymt ?? '';
    transitionSpeed.value = ts ?? 1.0;
    yandexMusicSearch.value = yms ?? true;
    yandexMusicPreload.value = ymp ?? true;
    yandexMusicQuality.value = ymq ?? 'nq';
  }

  final volume = ValueNotifier<double>(0.7);
  final stateIndicator = ValueNotifier<bool>(true);
  final recursiveFilesAdding = ValueNotifier<bool>(true);
  final playlistOpeningArea = ValueNotifier<bool>(false);
  final yandexMusicToken = ValueNotifier<String>('');
  final transitionSpeed = ValueNotifier<double>(1.0);
  final yandexMusicSearch = ValueNotifier<bool>(true);
  final yandexMusicPreload = ValueNotifier<bool>(true);
  final yandexMusicQuality = ValueNotifier<String>('nq');

  final dbChangeNotifier = ChangeNotifier();
}

class DatabaseSaver {
  static final DatabaseSaver _instance = DatabaseSaver._internal();

  factory DatabaseSaver() => _instance;

  DatabaseSaver._internal();

  late final VoidCallback _trackListener;
  late final VoidCallback _playlistListener;

  void init() async {
    _trackListener = () async {
      saveLastTrack();
    };
    _playlistListener = () async {
      updateDatabasePlaylist();
    };

    Player.player.playlistNotifier.addListener(_playlistListener);
    Player.player.trackChangeNotifier.addListener(_trackListener);
  }

  void saveLastTrack() async {
    await Database.put(
      DatabaseKeys.lastTrack.value,
      Player.player.nowPlayingTrack.filepath,
    );
  }

  void updateDatabasePlaylist() async {
    PlayerPlaylist pl = PlayerPlaylist(
      ownerUid: Player.player.playlistInfo.ownerUid,
      kind: Player.player.playlistInfo.kind,
      name: Player.player.playlistInfo.name,
      tracks: Player.player.unShuffledPlaylist,
      source: Player.player.playlistInfo.source,
    );
    Map play = await serializePlaylist(pl);
    await Database.put(DatabaseKeys.lastPlaylist.value, play);
  }
}
