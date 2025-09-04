import 'package:quark/src/services/path_manager.dart';
import 'dart:io';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'dart:typed_data';

class FileTags {
  static Future<Map<String, dynamic>> getTagsFromFile(String filePath) async {
    try {
      final track = File(filePath);

      final tagsFromFile = readMetadata(track, getImage: true);

      if (tagsFromFile == null) {
        return {
          'trackName': PathManager.getFileName(filePath),
          'trackArtistNames': ['Unknown'],
          'albumArt': Uint8List(0),
        };
      }

      return {
        'trackName':
            tagsFromFile?.title?.trim() ?? PathManager.getFileName(filePath),
        'trackArtistNames':
            tagsFromFile?.artist?.trim().isNotEmpty == true
                ? tagsFromFile!.artist!
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList()
                : ['Unknown'],
        'albumName': tagsFromFile.album?.trim() ?? 'Unknown',
        'albumArtistName': tagsFromFile.album?.trim() ?? 'Unknown',
        'trackNumber': tagsFromFile.trackNumber ?? 0,
        'albumLength': tagsFromFile.trackTotal ?? 0,
        'year': tagsFromFile.year ?? 0,
        'genre': tagsFromFile.genres ?? 'Unknown',
        'discNumber': tagsFromFile.discNumber,
        'authorName': 'metadata.authorName',
        'writerName': 'metadata.writerName',
        'mimeType': 'metadata.mimeType',
        'trackDuration': 0,
        'bitrate': 0,
        'albumArt':
            tagsFromFile.pictures.isNotEmpty
                ? tagsFromFile.pictures.first.bytes ?? Uint8List(0)
                : Uint8List(0),
        'albumArtPNG': tagsFromFile.pictures.first.pictureType,
      };
    } catch (e) {
      return {
        'trackName': PathManager.getFileName(filePath),
        'trackArtistNames': ['Unknown'],
        'albumArt': Uint8List(0),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getAllTracksMetadata(
    List<String> filePaths,
  ) async {
    final List<Map<String, dynamic>> results = [];
    for (final file in filePaths) {
      final tags = await getTagsFromFile(PathManager.getnormalizePath(file));
      results.add(tags);
    }
    return results;
  }
}