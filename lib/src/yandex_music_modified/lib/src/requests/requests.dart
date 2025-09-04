import 'package:dio/dio.dart';
import '../exceptions/exceptions.dart';
class Requests {
  final String token;
  
  Requests({required this.token});

  static const baseUrl = 'https://api.music.yandex.net';

  final dio = Dio(BaseOptions(validateStatus: (status) => true));

  Future<Map<String, dynamic>> basicRequest(String route, [String? fullRoute, ResponseType? responceType]) async {
    String finalRoute;
    
    if (fullRoute != null) {
      finalRoute = fullRoute;
    } else {
      finalRoute = '$baseUrl${route.replaceFirst(baseUrl, '')}';
    }
    try {
      final response = await dio.get(
        finalRoute,
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
          responseType: responceType
        ),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          if (responceType != null) {
            return {'result': response.data};
          } else {return response.data;}

        case 404:
          throw YandexMusicException.notFound(response.statusMessage ?? 'Not Found');
        case 400:
          throw YandexMusicException.badRequest(
            response.statusMessage ?? 'Bad Request',
            code: response.statusCode,
          );
        case 401:
          throw YandexMusicException.unauthorized(
            response.statusMessage ?? 'Unauthorized',
            code: response.statusCode,
          );
        default:
          throw YandexMusicException.request(
            response.statusMessage ?? 'Request Failed',
            code: response.statusCode,
          );
      }
    } on DioException catch (e) {
      throw YandexMusicException.network(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }
  
  Future<dynamic> customUrlRequest(String link) async {
    try {
      final response = await dio.get(
        link,
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          return response.data;
        case 404:
          throw YandexMusicException.notFound(response.statusMessage ?? 'Not Found');
        case 400:
          throw YandexMusicException.badRequest(
            response.statusMessage ?? 'Bad Request',
            code: response.statusCode,
          );
        case 401:
          throw YandexMusicException.unauthorized(
            response.statusMessage ?? 'Unauthorized',
            code: response.statusCode,
          );
        default:
          throw YandexMusicException.request(
            response.statusMessage ?? 'Request Failed',
            code: response.statusCode,
          );
      }
    } on DioException catch (e) {
      throw YandexMusicException.network(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }


  Future<Map<String, dynamic>> requestWithParameters(String route, Map<String, dynamic> queryParameters, [CancelToken? cancelToken]) async {
    try {
      route.replaceFirst(baseUrl, '');
      final response = await dio.get(
        '$baseUrl$route',
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/json',
          },
        ),
        cancelToken: cancelToken,
      );

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          return response.data;
        case 404:
          throw YandexMusicException.notFound(response.statusMessage ?? 'Not Found');
        case 400:
          throw YandexMusicException.badRequest(
            response.statusMessage ?? 'Bad Request',
            code: response.statusCode,
          );
        case 401:
          throw YandexMusicException.unauthorized(
            response.statusMessage ?? 'Unauthorized',
            code: response.statusCode,
          );
        default:
          throw YandexMusicException.request(
            response.statusMessage ?? 'Request Failed',
            code: response.statusCode,
          );
      }
    } on DioException catch (e) {
      throw YandexMusicException.network(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

  Future<dynamic> postRequest(String route, [Map<String, dynamic>? queryParameters, dynamic data]) async {
        try {
      route.replaceFirst(baseUrl, '');
      final response = await dio.post(
        '$baseUrl$route',
        queryParameters: queryParameters,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 203:
        case 204:
          return response.data;
        case 404:
          throw YandexMusicException.notFound(response.statusMessage ?? 'Not Found');
        case 400:
          throw YandexMusicException.badRequest(
            response.statusMessage ?? 'Bad Request',
            code: response.statusCode,
          );
        case 401:
          throw YandexMusicException.unauthorized(
            response.statusMessage ?? 'Unauthorized',
            code: response.statusCode,
          );
        case 412:
          throw YandexMusicException.wrongRevision(response.statusMessage ?? 'Wrong revision', code: response.statusCode);

        default:
          throw YandexMusicException.request(
            response.statusMessage ?? 'Request Failed',
            code: response.statusCode,
          );
      }
    } on DioException catch (e) {
      throw YandexMusicException.network(
        'Request Failed. Network Error: ${e.message}',
        code: e.response?.statusCode,
      );
    }
  }

}

