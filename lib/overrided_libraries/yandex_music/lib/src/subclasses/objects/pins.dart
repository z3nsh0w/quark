import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

// TODO: MOVE FUNCTIONS INTO LOWER_LEVEL
class YandexMusicPin {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicPin(this._parentClass, this.api);

  String unPin = 'delete';
  String pin = 'put';

  Future<dynamic> album(
    String albumId,
    String operation, {
    CancelToken? cancelToken,
  }) async {
    Map<String, dynamic> body = {'id': albumId};
    if (operation == pin) {
      final result = await api.put(
        '/pin/album',
        body,
        cancelToken: cancelToken,
      );
      return result;
    } else if (operation == unPin) {
      final result = await api.delete(
        '/pin/album',
        body,
        cancelToken: cancelToken,
      );
      return result;
    } else {
      throw YandexMusicException.badRequest('Incorrect action specified');
    }
  }

  Future<dynamic> playlist(
    int ownerUid,
    int kind,
    String operation, {
    CancelToken? cancelToken,
  }) async {
    Map<String, dynamic> body = {'uid': ownerUid, 'kind': kind};
    if (operation == pin) {
      final result = await api.put(
        '/pin/playlist',
        body,
        cancelToken: cancelToken,
      );
      return result;
    } else if (operation == unPin) {
      final result = await api.delete(
        '/pin/playlist',
        body,
        cancelToken: cancelToken,
      );
      return result;
    } else {
      throw YandexMusicException.badRequest('Incorrect action specified');
    }
  }

  Future<dynamic> wave(
    List<String> seeds,
    String operation, {
    CancelToken? cancelToken,
  }) async {
    Map<String, dynamic> body = {'seeds': seeds};
    if (operation == pin) {
      final result = await api.put(
        '/pin/wave',
        body,
        cancelToken: cancelToken,
      );
      return result;
    } else if (operation == unPin) {
      final result = await api.delete(
        '/pin/wave',
        body,
        cancelToken: cancelToken,
      );
      return result;
    } else {
      throw YandexMusicException.badRequest('Incorrect action specified');
    }
  }
}
