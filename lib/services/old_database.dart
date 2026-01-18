import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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

  /// ```Boolean```
  /// Is the cover set as the background
  albumArtAsBackground('background_art'),

  /// ```Boolean```
  /// Is smart shuffle enabled
  smartShuffle('smart_shuffle_state'),

  /// ```Boolean```
  /// Is adwaita theme enabled
  adwaitaTheme('adwaita_theme_state'),

  /// ```Boolean```
  /// Is transparent mode enabled
  transparentMode('transparent_mode'),

  /// ```Color```
  /// Player accent color
  accentColor('accent_color'),

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

  /// ```String```
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

  static Future<Box> _ensureInitialized() async {
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
      return _box!;
    } finally {
      _isInitializing = false;
    }
  }

  static Future<void> init() async {
    final directory = await getApplicationCacheDirectory();
    Hive.init(directory.path);
    await _ensureInitialized();
  }

  static Future<bool> setValue<T>(String key, T value) async {
    final box = await _ensureInitialized();
    try {
      await box.put(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<dynamic> getValue(String key, {dynamic defaultValue}) async {
    final box = await _ensureInitialized();

    if (!box.containsKey(key)) {
      return defaultValue;
    }

    return await box.get(key);
  }

  static Future<bool> containsKey(String key) async {
    final box = await _ensureInitialized();
    return box.containsKey(key);
  }

  static Future<Set<String>> getKeys() async {
    final box = await _ensureInitialized();
    return box.keys.cast<String>().toSet();
  }

  static Future<bool> remove(String key) async {
    final box = await _ensureInitialized();
    try {
      await box.delete(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> clear() async {
    final box = await _ensureInitialized();
    try {
      await box.clear();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getDirectory() async {
    final box = await _ensureInitialized();
    var path = box.path.toString();
    return path;
  }
}
