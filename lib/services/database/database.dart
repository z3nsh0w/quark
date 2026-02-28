import 'dart:isolate';

import 'database_engine.dart';
import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';
import 'package:quark/objects/playlist.dart';
import 'package:quark/services/player/player.dart';

class DatabaseStreamerService {
  static final DatabaseStreamerService _instance =
      DatabaseStreamerService._internal();

  factory DatabaseStreamerService() => _instance;

  DatabaseStreamerService._internal();

  Future<void> init() async {
    await reload();
    _attachSavers();
    _attachListeners();
    Logger('DatabaseStreamerService').fine('Inited');
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
  final lastTrack = ValueNotifier<String?>(null);
  final lastPlaylist = ValueNotifier<Map<dynamic, dynamic>?>(null);
  final yandexMusicLogin = ValueNotifier<String>('');
  final yandexMusicFullName = ValueNotifier<String>('');
  final yandexMusicDisplayName = ValueNotifier<String>('');
  final yandexMusicUid = ValueNotifier<int?>(null);
  final yandexMusicEmail = ValueNotifier<String>('');
  final yandexMusicTokenExpires = ValueNotifier<int>(0);
  final dbChangeNotifier = ChangeNotifier();
  final gradientMode = ValueNotifier<bool>(false);
  final lastPlaylistState = ValueNotifier<bool>(false);
  final yandexMusicPlaylists = ValueNotifier<List?>(null);
  final windowManager = ValueNotifier<bool>(false);
  final logListenedTracks = ValueNotifier<bool>(false);
  late final Listenable all = Listenable.merge([
    volume,
    stateIndicator,
    recursiveFilesAdding,
    playlistOpeningArea,
    yandexMusicToken,
    gradientMode,
    lastPlaylistState,
    yandexMusicPlaylists,
    windowManager,
    logListenedTracks,
    transitionSpeed,
    yandexMusicSearch,
    yandexMusicPreload,
    yandexMusicQuality,
    yandexMusicLogin,
    yandexMusicFullName,
    yandexMusicDisplayName,
    yandexMusicUid,
    yandexMusicEmail,
  ]);

  Future<void> reload() async {
    final lp = await Database.get(DatabaseKeys.lastPlaylist.value);
    lastPlaylist.value = lp;
    final v = await Database.get(DatabaseKeys.volume.value);
    final s = await Database.get(DatabaseKeys.stateIndicatorState.value);
    final poa = await Database.get(DatabaseKeys.playlistOpeningArea.value);
    final ymt = await Database.get(DatabaseKeys.yandexMusicToken.value);
    final ts = await Database.get(DatabaseKeys.transitionSpeed.value);
    final yms = await Database.get(DatabaseKeys.yandexMusicSearch.value);
    final ymq = await Database.get(DatabaseKeys.yandexMusicTrackQuality.value);
    final rfs = await Database.get(DatabaseKeys.recursiveFilesAdding.value);
    final ymp = await Database.get(DatabaseKeys.yandexMusicPreload.value);
    final lt = await Database.get(DatabaseKeys.lastTrack.value);
    final yml = await Database.get(DatabaseKeys.yandexMusicLogin.value);
    final ymfn = await Database.get(DatabaseKeys.yandexMusicFullName.value);
    final ymdn = await Database.get(DatabaseKeys.yandexMusicDisplayName.value);
    final ymuid = await Database.get(DatabaseKeys.yandexMusicUid.value);
    final yme = await Database.get(DatabaseKeys.yandexMusicEmail.value);
    final tE = await Database.get(DatabaseKeys.yandexMusicTokenExpires.value);
    final gm = await Database.get(DatabaseKeys.gradientMode.value);
    final lps = await Database.get(DatabaseKeys.lastPlaylistState.value);
    final ymp2 = await Database.get(DatabaseKeys.yandexMusicPlaylists.value);
    final wm = await Database.get(DatabaseKeys.windowManager.value);
    final llt = await Database.get(DatabaseKeys.logListenedTracks.value);

    gradientMode.value = gm ?? false;
    lastPlaylistState.value = lps ?? false;
    yandexMusicPlaylists.value = ymp2;
    windowManager.value = wm ?? false;
    logListenedTracks.value = llt ?? false;
    yandexMusicLogin.value = yml ?? '';
    yandexMusicFullName.value = ymfn ?? '';
    yandexMusicDisplayName.value = ymdn ?? '';
    yandexMusicUid.value = ymuid;
    yandexMusicEmail.value = yme ?? '';
    volume.value = v ?? 0.7;
    stateIndicator.value = s ?? true;
    recursiveFilesAdding.value = rfs ?? true;
    playlistOpeningArea.value = poa ?? false;
    yandexMusicToken.value = ymt ?? '';
    transitionSpeed.value = ts ?? 1.0;
    yandexMusicSearch.value = yms ?? true;
    yandexMusicPreload.value = ymp ?? true;
    yandexMusicQuality.value = ymq ?? 'nq';
    lastTrack.value = lt;
    yandexMusicTokenExpires.value = tE ?? 0;
    await Player.player.setVolume(volume.value);
  }

  void _attachSavers() {
    if (!Database.isInited) {
      Logger(
        'DatabaseStreamerService',
      ).warning('DB not available, changes will not be persisted.');
      return;
    }
    void bind<T>(ValueNotifier<T> notifier, DatabaseKeys key) async {
      notifier.addListener(() async {
        await Database.put(key.value, notifier.value);
      });
    }

    bind(gradientMode, DatabaseKeys.gradientMode);
    bind(lastPlaylistState, DatabaseKeys.lastPlaylistState);
    bind(yandexMusicPlaylists, DatabaseKeys.yandexMusicPlaylists);
    bind(windowManager, DatabaseKeys.windowManager);
    bind(logListenedTracks, DatabaseKeys.logListenedTracks);
    bind(volume, DatabaseKeys.volume);
    bind(stateIndicator, DatabaseKeys.stateIndicatorState);
    bind(recursiveFilesAdding, DatabaseKeys.recursiveFilesAdding);
    bind(playlistOpeningArea, DatabaseKeys.playlistOpeningArea);
    bind(yandexMusicToken, DatabaseKeys.yandexMusicToken);
    bind(transitionSpeed, DatabaseKeys.transitionSpeed);
    bind(yandexMusicSearch, DatabaseKeys.yandexMusicSearch);
    bind(yandexMusicPreload, DatabaseKeys.yandexMusicPreload);
    bind(yandexMusicQuality, DatabaseKeys.yandexMusicTrackQuality);
    bind(yandexMusicLogin, DatabaseKeys.yandexMusicLogin);
    bind(yandexMusicFullName, DatabaseKeys.yandexMusicFullName);
    bind(lastTrack, DatabaseKeys.lastTrack);
    bind(lastPlaylist, DatabaseKeys.lastPlaylist);
    bind(yandexMusicTokenExpires, DatabaseKeys.yandexMusicTokenExpires);
    bind(yandexMusicDisplayName, DatabaseKeys.yandexMusicDisplayName);
    bind(yandexMusicUid, DatabaseKeys.yandexMusicUid);
    bind(yandexMusicEmail, DatabaseKeys.yandexMusicEmail);
  }

  void _attachListeners() {
    Player.player.volumeNotifier.addListener(
      () => volume.value = Player.player.volumeNotifier.value,
    );
  }
}

class DatabaseSaver {
  static final DatabaseSaver _instance = DatabaseSaver._internal();

  factory DatabaseSaver() => _instance;

  DatabaseSaver._internal();

  late final VoidCallback _trackListener;
  late final VoidCallback _playlistListener;

  void init() async {
    _trackListener = () async {
      await saveLastTrack();
    };
    _playlistListener = () async {
      if (Player.player.shuffleModeNotifier.value == true) {
        return;
      }
      await updateDatabasePlaylist();
    };

    Player.player.playlistNotifier.addListener(_playlistListener);
    Player.player.trackChangeNotifier.addListener(_trackListener);
    Logger('DatabaseSaverService').fine('Inited');
  }

  Future<void> saveLastTrack() async {
    DatabaseStreamerService().lastTrack.value =
        Player.player.nowPlayingTrack.filepath;
  }

  Future<void> updateDatabasePlaylist() async {
    PlayerPlaylist pl = PlayerPlaylist(
      ownerUid: Player.player.playlistInfo.ownerUid,
      kind: Player.player.playlistInfo.kind,
      name: Player.player.playlistInfo.name,
      tracks: Player.player.unShuffledPlaylist,
      source: Player.player.playlistInfo.source,
    );
    Map play = await Isolate.run(() => serializePlaylist(pl));
    DatabaseStreamerService().lastPlaylist.value = play;
  }
}
