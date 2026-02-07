import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quark/services/database/database.dart';

/// Wrapper over the database so you don't have to enter keys manually
///
/// Usage:
/// ```
/// Database.getValue(DatabaseKeys.volume.value);
/// ```
enum DatabaseKeys {
  /// ```Double``` Player volume
  volume('volume'),

  /// ```Boolean```
  /// Is the indicator enabled
  stateIndicatorState('indicator_state'),

  /// ```Boolean```
  /// recursiveFilesAdding
  recursiveFilesAdding('recursive_files_adding'),

  /// ```Boolean```
  /// Is the playlist opening area enabled?
  playlistOpeningArea('playlist_opening_area'),

  /// ```List<Map<String, dynamic>>```
  /// Cached info about user's playlists
  yandexMusicPlaylists('yandex_music_playlists'),

  /// ```Boolean```
  /// Is the windowManager plugin enabled
  windowManager('window_manager_state'),

  /// ```Boolean```
  /// Is listening to tracks logged
  logListenedTracks('log_listener_state'),

  /// ```String```
  /// Yandex account access token
  yandexMusicToken('yandex_music_token'),

  /// ```String```
  /// Yandex account email
  yandexMusicEmail('yandex_music_email'),

  /// ```String```
  /// Yandex account login
  yandexMusicLogin('yandex_music_login'),

  /// ```String```
  /// Yandex account display name
  yandexMusicDisplayName('yandex_music_displayname'),

  /// ```String```
  /// Yandex account full name
  yandexMusicFullName('yandex_music_fullname'),

  /// ```String```
  /// Yandex account unique id
  yandexMusicUid('yandex_music_uid'),

  /// ```String``` - enum value of AudioQuality from YandexMusic lib
  /// Quality of track
  yandexMusicTrackQuality('yandex_music_track_quality'),

  /// ```Map<String, dynamic>>
  /// Serialized last playlist
  lastPlaylist('last_playlist'),

  // #TODO```Map<String, dynamic>>
  /// ```String```
  /// Last track's path
  lastTrack('last_track'),

  /// ```Bool```
  /// Gradient mode setting.
  gradientMode('gradient_mode'),

  /// ```Bool```
  /// Last playlist widget state
  lastPlaylistState('last_playlist_state'),

  /// ```double```
  /// Animations speed
  transitionSpeed('transition_speed'),

  /// ```bool```
  /// Enables yandex music search in playlistview
  yandexMusicSearch('yandex_music_search'),

  /// ```bool```
  /// Preload yandexMusic when player starts
  yandexMusicPreload('yandex_music_preload');

  final String value;
  const DatabaseKeys(this.value);
}

class Database {
  static Box? _box;
  static bool _isInitializing = false;

  static bool isInited = false;
  static Object? lastError;

  static Future<Box?> _ensureInitialized() async {
    if (_box != null) return _box!;

    if (_isInitializing) {
      while (_isInitializing) {
        await Future.delayed(const Duration(milliseconds: 10));
      }
      return _box!;
    }

    _isInitializing = true;
    try {
      _box = await Hive.openBox('database');
      isInited = true;
      return _box!;
    } catch (e) {
      Logger('Database').shout('Failed to initialize database.', e);
      lastError = e;
    } finally {
      _isInitializing = false;
    }
  }

  static Future<void> init() async {
    try {
      final directory = await getApplicationCacheDirectory();
      Hive.init(directory.path);
      await _ensureInitialized();
      DatabaseSaver().init();
    } catch (e) {
      Logger('Database').shout('Failed to initialize database.', e);
    }
  }

  static Future<bool> put<T>(String key, T value) async {
    final box = await _ensureInitialized();
    if (box == null) return false;
    try {
      await box.put(key, value);
      return true;
    } catch (e) {
      Logger('Database').shout('Failed to get database value.', e);
      lastError = e;
      return false;
    }
  }

  static Future<bool> putAll(Map<String, dynamic> values) async {
    final box = await _ensureInitialized();
    if (box == null) return false;
    try {
      await box.putAll(values);
      return true;
    } catch (e) {
      Logger('Database').shout('Failed to put database value.', e);
      lastError = e;
      return false;
    }
  }

  static Future<dynamic> get(String key, {dynamic defaultValue}) async {
    try {
      final box = await _ensureInitialized();
      if (box == null) return defaultValue;
      if (!box.containsKey(key)) {
        return defaultValue;
      }

      return await box.get(key);
    } catch (e) {
      Logger('Database').shout('Failed to get database value.', e);
      lastError = e;
      return defaultValue;
    }
  }

  static Future<bool> containsKey(String key) async {
    final box = await _ensureInitialized();
    if (box == null) return false;
    return box.containsKey(key);
  }

  static Future<Set<String>> getKeys() async {
    final box = await _ensureInitialized();
    if (box == null) return {};
    return box.keys.cast<String>().toSet();
  }

  static Future<bool> remove(String key) async {
    final box = await _ensureInitialized();
    if (box == null) return false;
    try {
      await box.delete(key);
      return true;
    } catch (e) {
      Logger('Database').shout('Failed to remove database value.', e);
      lastError = e;
      return false;
    }
  }

  static Future<bool> clear() async {
    final box = await _ensureInitialized();
    if (box == null) return false;
    try {
      await box.clear();
      return true;
    } catch (e) {
      Logger('Database').shout('Failed to clear database value.', e);
      lastError = e;
      return false;
    }
  }

  static Future<String> getDirectory() async {
    final box = await _ensureInitialized();
    if (box == null) return 'false';
    var path = box.path.toString();
    return path;
  }
}
