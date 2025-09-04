import 'package:path/path.dart' as path;
import 'dart:io';

class PathManager {
  static String getFileName(String filePath) {
    return path.basename(path.normalize(filePath));
  }

  static Future<bool> checkfileExists(String filePath) async {
    try {
      return await File(filePath).exists();
    } catch (e) {
      return false;
    }
  }

  static String getnormalizePath(String filePath) {
    return path.normalize(filePath);
  }
}