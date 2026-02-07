enum YandexMusicExceptionType {
  network,
  request,
  initialization,
  unauthorized,
  parse,
  badRequest,
  notFound,
  wrongRevision, 
  argumentError
}


/// The main exception class of the library.
/// 
/// Includes 3 fields:
/// ```
/// message - main error message
/// code - http error code (May be null!)
/// type - error type (part of an error groupYandexMusicExceptionType)
/// ```
/// 
/// Usage: 
/// ```dart
/// var ym = YandexMusic(
///      token: 'y0_4fjegHFFWgn552fnHfjsveegjknavd89UIGFEs',
///    );
/// 
/// try {
///   await ym.init();
///   final result = await ym.playlists.getUsersPlaylists();
///   print(result);
///   
/// } on YandexMusicException catch (e) {
/// switch (e.type) {
///   case YandexMusicExceptionType.network:
///     print('Network exception: ${e.message}');
///     break;
///   case YandexMusicExceptionType.unauthorized:
///     print('Authorization exception: ${e.message}');
///     break;
///   case YandexMusicExceptionType.badRequest:
///     print('Bad request: ${e.message}');
///     break;
///   case YandexMusicExceptionType.wrongRevision:
///     print('Wrong revision: ${e.message}');
///     break;
///   case YandexMusicExceptionType.notFound:
///     print('Not found: ${e.message}');
///     break;
///   // ETC. all types can be seen inside YandexMusicExceptionType
///   default:
///     print('Another error: ${e.message}');
/// }
/// }
/// ```
class YandexMusicException implements Exception {
  final String message;
  final int? code;
  final YandexMusicExceptionType type;

  YandexMusicException(this.message, this.type, {this.code});

  /// Reports a network error.
  /// The error can only be caused by a network problem, which the dio library will detect
  YandexMusicException.network(String message, {int? code}) 
      : this(message, YandexMusicExceptionType.network, code: code);
  
  /// Reports a problem with a request to the server.
  /// 
  /// Is a server\client error message
  /// 
  /// All other errors, not considering the others, will cause this type of error.
  YandexMusicException.request(String message, {int? code}) 
      : this(message, YandexMusicExceptionType.request, code: code);
  
  /// Reports a library initialization error
  /// 
  /// Most likely the token is inactive
  /// 
  /// Called if the library could not parse ym.getAllAccountInformation
  /// 
///(The token becomes inactive only if the user logs out of the account on all devices or changes the password through the recovery)  
  YandexMusicException.initialization(String message) 
      : this(message, YandexMusicExceptionType.initialization);
  
  /// Reports authorization errors
  /// 
  /// Most likely the token has ceased to be active and you need to reinitialize the library with a new token
  YandexMusicException.unauthorized(String message, {int? code}) 
      : this(message, YandexMusicExceptionType.unauthorized, code: code);

  /// The request was completed successfully, but the server did not find information on the request
  YandexMusicException.notFound(String message, {int? code})
      : this(message, YandexMusicExceptionType.notFound, code: code);

  /// Reports an error in the transmitted data in the request.
  YandexMusicException.badRequest(String message, {int? code})
      : this(message, YandexMusicExceptionType.badRequest, code: code);

  /// To change a playlist, you must specify the correct revision of the playlist.
  YandexMusicException.wrongRevision(String message, {int? code})
      : this(message, YandexMusicExceptionType.wrongRevision, code: code);

  /// The argument passed is invalid.
  YandexMusicException.argumentError(String message, {int? code})
      : this(message, YandexMusicExceptionType.argumentError, code: code);

  @override
  String toString() {
    final typeStr = type.name.substring(0, 1).toUpperCase() + type.name.substring(1);
    return 'YandexMusic${typeStr}Exception: $message${code != null ? ' (Code: $code)' : ''}';
  }
}