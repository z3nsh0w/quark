import 'dart:io';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
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
  static Future<LocalTrack> _getTrackInfo(
    String paths, {
    Uint8List? customCover,
  }) async {
    try {
      final tagsFromFile = readMetadata(File(paths), getImage: true);

      String trackName = tagsFromFile.title ??= 'Unknown';
      Uint8List? cover = tagsFromFile.pictures.isNotEmpty
          ? tagsFromFile.pictures.first.bytes
          : null;
      cover ??= customCover;

      final CoverType coverType = cover == null
          ? customCover == null
                ? CoverType.noCover
                : CoverType.externalFile
          : CoverType.builtIn;

      LocalTrack track = LocalTrack(
        title: trackName,
        artists: [tagsFromFile.artist ??= 'Unknown'],
        filepath: paths,
        albums: ['Unknown'],
        coverType: coverType,
      );
      if (cover != null) {
        track.coverByted = cover;
      }

      return track;
    } catch (e) {
      String trackName = path.basename(path.normalize(paths));
      LocalTrack track = LocalTrack(
        title: trackName,
        artists: ['Unknown'],
        filepath: paths,
        albums: ['Unknown'],
        coverType: CoverType.noCover,
      );
      return track;
    }
  }

  static Future<LocalTrack> getTrackInfo(
    (String, Uint8List?) args,
  ) async {
    return _getTrackInfo(args.$1, customCover: args.$2);
  }

  static Future<AudioMetadata?> getFileTags(
    String path, {
    bool getImage = false,
  }) async {
    try {
      return await Isolate.run(() {
        return readMetadata(File(path), getImage: getImage);
      });
    } catch (e) {
      return null;
    }
  }

  static Future<void> _scanDirectory({
    required String path,
    required List<PlayerTrack> fileNames,
    required bool recursiveEnable,
  }) async {
    final dir = Directory(path);
    Uint8List? customCover;

    await for (final entity in dir.list()) {
      if (entity is File) {
        if (entity.path.toLowerCase().endsWith("folder.jpg") ||
            entity.path.toLowerCase().endsWith("cover.jpg")) {
          customCover = await entity.readAsBytes();
        }
      }
    }

    await for (final entity in dir.list()) {
      if (entity is File) {
        if (entity.path.toLowerCase().endsWith('.mp3') ||
            entity.path.toLowerCase().endsWith('.wav') ||
            entity.path.toLowerCase().endsWith('.flac') ||
            entity.path.toLowerCase().endsWith('.dsf') ||
            entity.path.toLowerCase().endsWith('.aac') ||
            entity.path.toLowerCase().endsWith('.alac') ||
            entity.path.toLowerCase().endsWith('.pcm') ||
            entity.path.toLowerCase().endsWith('.m4a')) {
          final LocalTrack track = await compute(getTrackInfo, (
            entity.path,
            customCover,
          ));
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

  static Future<List<PlayerTrack>> _scanDirectoryCompute(
    (String, bool?) args,
  ) async {
    final List<PlayerTrack> result = [];
    await _scanDirectory(
      path: args.$1,
      fileNames: result,
      recursiveEnable: args.$2 ?? true,
    );
    return result;
  }

  Future<List<PlayerTrack>> getFilesFromDirectory({
    required String directoryPath,
    bool? recursiveEnable,
  }) async {
    try {
      final fileNames = await compute(_scanDirectoryCompute, (
        directoryPath,
        recursiveEnable,
      ));

      return fileNames;
    } catch (e) {
      Logger('Files').severe('Failed to get files from directory.', e);
    }
    return [];
  }
}
