import 'dart:io';
import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import '/objects/track.dart';
import 'package:path/path.dart' as path;
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class ApplicationCacheDirectory {
  ApplicationCacheDirectory._();

  static final ApplicationCacheDirectory _instance =
      ApplicationCacheDirectory._();

  static ApplicationCacheDirectory get instance => _instance;

  Directory? _directory;

  Future<void> init() async {
    if (_directory != null) return;
    _directory = await getApplicationCacheDirectory();
  }

  Directory get directory {
    return _directory!;
  }
}

class Files {
  Future<LocalTrack> _getTrackInfo(FileSystemEntity entity) async {
    try {
      final tagsFromFile = readMetadata(File(entity.path), getImage: true);

      String trackName = tagsFromFile.title ??= 'Unknown';
      Uint8List? cover = tagsFromFile.pictures.isNotEmpty
          ? tagsFromFile.pictures.first.bytes
          : null;

      LocalTrack track = LocalTrack(
        title: trackName,
        artists: [tagsFromFile.artist ??= 'Unknown'],
        filepath: entity.path,
        albums: ['Unknown'],
      );

      track.coverByted = cover!;

      return track;
    } catch (e) {
      String trackName = path.basename(path.normalize(entity.path));
      LocalTrack track = LocalTrack(
        title: trackName,
        artists: ['Unknown'],
        filepath: entity.path,
        albums: ['Unknown'],
      );
      return track;
    }
  }

  static AudioMetadata? getFileTags(String path, {bool getImage = false}) {
    try {
      return readMetadata(File(path), getImage: getImage);
    } catch (e) {
      return null;
    }
  }

  Future<void> _scanDirectory({
    required String path,
    required List<PlayerTrack> fileNames,
    required bool recursiveEnable,
  }) async {
    final dir = Directory(path);

    await for (final entity in dir.list()) {
      if (entity is File) {
        if (entity.path.toLowerCase().endsWith('.mp3') ||
            entity.path.toLowerCase().endsWith('.wav') ||
            entity.path.toLowerCase().endsWith('.flac') ||
            entity.path.toLowerCase().endsWith('.dsf') ||
            entity.path.toLowerCase().endsWith('.aac') ||
            // entity.path.toLowerCase().endsWith('.ogg') || // NO LONGER SUPPORTED
            entity.path.toLowerCase().endsWith('.alac') ||
            entity.path.toLowerCase().endsWith('.pcm') ||
            entity.path.toLowerCase().endsWith('.m4a')) {
          final LocalTrack track = await _getTrackInfo(entity);
          fileNames.add(track);
        }
      }
      if (entity is Directory) {
        if (recursiveEnable) {
          await _scanDirectory(
            path: entity.path,
            fileNames: fileNames,
            recursiveEnable: recursiveEnable,
          );
        }
      }
    }
  }

  Future<List<PlayerTrack>> getFilesFromDirectory({
    required String directoryPath,
    bool? recursiveEnable,
  }) async {
    try {
      final List<PlayerTrack> fileNames = [];
      await _scanDirectory(
        path: directoryPath,
        fileNames: fileNames,
        recursiveEnable: recursiveEnable ?? true,
      );

      return fileNames;
    } catch (e) {
      Logger('Files').severe('Failed to get files from directory.', e);
    }
    return [];
  }
}
