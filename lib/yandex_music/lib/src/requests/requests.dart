import 'package:dio/dio.dart';
import '../exceptions/exceptions.dart';

class Requests {
  final String token;

  Requests({required this.token});

  static const baseUrl = 'https://api.music.yandex.net';

  final dio = Dio(BaseOptions(validateStatus: (status) => true));

  Future<dynamic> basicGet(
    String route, [
    String? fullRoute,
    ResponseType? responceType,
  ]) async {
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
          responseType: responceType,
        ),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          if (responceType != null) {
            return {'result': response.data};
          } else {
            return response.data;
          }

        case 404:
          throw YandexMusicException.notFound(
            response.statusMessage ?? 'Not Found',
          );
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

  Future<Map<String, dynamic>> customGet(
    String route,
    Map<String, dynamic> queryParameters, [
    String? fullRoute,
    Map<String, dynamic>? headers,
  ]) async {
    String finalRoute;

    if (fullRoute != null) {
      finalRoute = fullRoute;
    } else {
      finalRoute = '$baseUrl${route.replaceFirst(baseUrl, '')}';
    }

    Map<String, dynamic> fullheaders;

    if (headers != null) {
      fullheaders = headers;
    } else {
      fullheaders = {
        'Authorization': 'OAuth $token',
        'Content-Type': 'application/json',
      };
    }

    try {
      route.replaceFirst(baseUrl, '');
      final response = await dio.get(
        finalRoute,
        queryParameters: queryParameters,
        options: Options(headers: fullheaders),
      );

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          return response.data;
        case 404:
          throw YandexMusicException.notFound(
            response.statusMessage ?? 'Not Found',
          );
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

  Future<dynamic> post(
    String route, [
    Map<String, dynamic>? queryParameters,
    dynamic data,
    dynamic contentType,
  ]) async {
    try {
      contentType ??= 'application/x-www-form-urlencoded';
      route.replaceFirst(baseUrl, '');
      final response = await dio.post(
        '$baseUrl$route',
        queryParameters: queryParameters,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'OAuth $token',
            'Content-Type': contentType,
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
          throw YandexMusicException.notFound(
            response.statusMessage ?? 'Not Found',
          );
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
          throw YandexMusicException.wrongRevision(
            response.statusMessage ?? 'Wrong revision',
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

  Future<dynamic> put(
    String route,
    Map<String, dynamic> data, [
    String? customRoute,
  ]) async {
    try {
      route = customRoute != null ? customRoute : route;
      route.replaceFirst(baseUrl, '');
      final response = await dio.put(
        '$baseUrl$route',
        data: data,
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
        case 203:
        case 204:
          return response.data;
        case 404:
          throw YandexMusicException.notFound(
            response.statusMessage ?? 'Not Found',
          );
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
          throw YandexMusicException.wrongRevision(
            response.statusMessage ?? 'Wrong revision',
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

  Future<dynamic> delete(
    String route,
    Map<String, dynamic> data, [
    String? customRoute,
  ]) async {
    try {
      route = customRoute != null ? customRoute : route;
      route.replaceFirst(baseUrl, '');
      final response = await dio.delete(
        '$baseUrl$route',
        data: data,
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
        case 203:
        case 204:
          return response.data;
        case 404:
          throw YandexMusicException.notFound(
            response.statusMessage ?? 'Not Found',
          );
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
          throw YandexMusicException.wrongRevision(
            response.statusMessage ?? 'Wrong revision',
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
}
