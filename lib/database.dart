import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

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

  static Future<dynamic> getValue(String key) async {
    final box = await _ensureInitialized();

    if (!box.containsKey(key)) {
      return null;
    }

    return box.get(key);
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
    print(path);
    return path;
  }
}
