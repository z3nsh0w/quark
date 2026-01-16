import 'dart:io';
import 'dart:typed_data';
import '/objects/track.dart';
import 'package:path/path.dart' as path;
import 'package:audio_metadata_reader/audio_metadata_reader.dart';

class Files {
  Future<List<PlayerTrack>> getFilesFromDirectory(String directoryPath) async {
    try {
      final dir = Directory(directoryPath);
      final List<PlayerTrack> fileNames = [];

      await for (final entity in dir.list()) {
        if (entity is File) {
          if (entity.path.toLowerCase().endsWith('.mp3') ||
              entity.path.toLowerCase().endsWith('.wav') ||
              entity.path.toLowerCase().endsWith('.flac') ||
              entity.path.toLowerCase().endsWith('.dsf') ||
              entity.path.toLowerCase().endsWith('.aac') ||
              entity.path.toLowerCase().endsWith('.ogg') ||
              entity.path.toLowerCase().endsWith('.alac') ||
              entity.path.toLowerCase().endsWith('.pcm') ||
              entity.path.toLowerCase().endsWith('.m4a')) {
            try {
              final tagsFromFile = readMetadata(
                File(entity.path),
                getImage: true,
              );

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

              fileNames.add(track);
            } catch (e) {
              String trackName = path.basename(path.normalize(entity.path));
              LocalTrack track = LocalTrack(
                title: trackName,
                artists: ['Unknown'],
                filepath: entity.path,
                albums: ['Unknown'],
              );
              fileNames.add(track);
            }
          }
        }
      }

      return fileNames;
    } catch (e) {}
    return [];
  }
}