import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicMyVibe {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicMyVibe(this._parentClass, this.api);

  Future<List<vibeSetting>> getWaves() async {
    Map<String, dynamic> rst = await api.getAvailableSettings();
    List<vibeSetting> result = [];
    List contexts = rst['result']['blocks'][0]['items'];
    List diversity =
        rst['result']['settingRestrictions']['diversity']['possibleValues'];
    List moodEnegry =
        rst['result']['settingRestrictions']['moodEnergy']['possibleValues'];
    List language =
        rst['result']['settingRestrictions']['language']['possibleValues'];
    diversity.forEach((action) {
      vibeSetting vibe = vibeSetting(action);
      vibe.group = 'character';
      result.add(vibe);
    });
    moodEnegry.forEach((action) {
      vibeSetting vibe = vibeSetting(action);
      vibe.group = 'mood';
      result.add(vibe);
    });
    language.forEach((action) {
      vibeSetting vibe = vibeSetting(action);
      vibe.group = 'language';
      result.add(vibe);
    });
    contexts.forEach((action) {
      vibeSetting vibe = vibeSetting(action);
      vibe.group = 'activity';
      result.add(vibe);
    });

    return result;
  }

  Future<Wave> createWave(List<vibeSetting> vibeSettings) async {
    Map<String, dynamic> rst = await api.createWave(
      vibeSettings.map((vibe) => vibe.seedName).toList(),
    );
    return Wave(rst['result']);
  }

  Future<dynamic> sendFeedback(Wave wave, Feedback feedback) async {
    if (feedback is SkipFeedback) {
      if (feedback.queue.any((track) => track.albums.isEmpty)) {
        throw YandexMusicException.argumentError(
          '''One of the tracks is missing the necessary information for the request.\n 
            Please do not specify tracks downloaded by users or make sure that you are submitting the correct queue.''',
          code: 400,
        );
      }
      var result = await api.skipFeedback(
        wave,
        feedback.queue,
        feedback.totalPlayedSeconds,
        feedback.track,
      );
      print(result);
    } else if (feedback is TrackFinishedFeedback) {
      if (feedback.queue.any((track) => track.albums.isEmpty)) {
        throw YandexMusicException.argumentError(
          '''One of the tracks is missing the necessary information for the request.\n 
            Please do not specify tracks downloaded by users or make sure that you are submitting the correct queue.''',
          code: 400,
        );
      }
      var result = await api.trackFinishedFeedback(
        wave,
        feedback.queue,
        feedback.totalPlayedSeconds,
        feedback.track,
      );
      print(result);
    } else if (feedback is TrackStartedFeedback) {
      var result = await api.trackStartedFeedBack(
        wave,
        feedback.track,
      );
      print(result);
    }
  }
}
