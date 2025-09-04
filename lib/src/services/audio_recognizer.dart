import 'package:quark/src/services/database.dart';
import 'package:quark/src/services/path_manager.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecognizerService {
  static void saveRecognizedData(
    filename,
    coverArtUint8,
    artistName,
    trackName,
  ) {
    Database.getValue('recognizedTracks').then((recognizedTracksList) {
      List<Map<String, dynamic>> tracksList = [];

      if (recognizedTracksList != null) {
        for (var track in recognizedTracksList) {
          final convertedTrack = track.cast<String, dynamic>();
          tracksList.add(convertedTrack);
        }
      }

      Map<String, dynamic> addToList = {
        'filename': filename,
        'coverArt': coverArtUint8,
        'artistName': artistName,
        'trackName': trackName,
      };

      tracksList.add(addToList);

      Database.setValue('recognizedTracks', tracksList);
    });
  }

  static Future<Map<String, dynamic>> recognizeMetadata(
    String track,
    String apiURL,
  ) async {
    var filename = PathManager.getFileName(track);
    var query = 'FILENAME:$filename'; // Make a request in free format
    try {
      final response = await http.get(
        Uri.parse(
          'http://$apiURL/get_metadata?data=$query',
        ), // Make a request in free format
      );

      var jsonResponseFromAPI =
          jsonDecode(response.body) as Map<String, dynamic>;

      var trackname = jsonResponseFromAPI['title'];
      var artist = jsonResponseFromAPI['artists'][0]['name'];
      var coverarturl = jsonResponseFromAPI['cover_art_url'];

      Map<String, dynamic> trackData = {
        'trackname': '$trackname',
        'artist': '$artist',
        'coverarturl': '$coverarturl',
      };
      return Future.value(trackData);
    } catch (e) {
      return Future.value({}); // If we don't find anything, we rest.
    }
  }

  static Future<Uint8List> urlImageToUint8List(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      return Uint8List(0);
    }
  }
}

