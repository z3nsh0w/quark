enum YandexMusicExceptionType {
  network,
  request,
  initialization,
  unauthorized,
  parse,
  badRequest,
  notFound,
  wrongRevision
}


/// Главный класс исключений библиотеки.
/// 
/// Включает в себя 3 поля:
/// ```
/// message - основное сообщение ошибки
/// code - http код ошибки (может быть null!)
/// type - тип ошибки (являющийся частью группы ошибок YandexMusicExceptionType)
/// ```
/// 
/// Использование: 
/// ```dart
/// var ym = YandexMusic(
///      token: 'y0_4fjegHFFWgn552fnHfjsveegjknavd89UIGFEs',
///    );
/// await ym.init();
/// 
/// try {
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
///   // ETC. все типы можно увидеть внутри YandexMusicExceptionType
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

  /// Сообщает об ошибке сети. 
  /// Ошибка может быть вызвана только сетевой проблемой, которую определит библиотека dio
  YandexMusicException.network(String message, {int? code}) 
      : this(message, YandexMusicExceptionType.network, code: code);
  
  /// Сообщает о проблеме запроса к серверу. 
  /// 
  /// Является сообщением об ошибки сервера\клиента 
  /// 
  /// Все http коды кроме 200, 201, 202, 203, 204, 400, 401, 403, 404, 405, 412 вызывают этот тип ошибки.
  YandexMusicException.request(String message, {int? code}) 
      : this(message, YandexMusicExceptionType.request, code: code);
  
  /// Сообщает об ошибке инициализации библиотеки
  /// 
  /// Скорее всего токен неактивен
  /// 
  /// Вызывается если библиотека не смогла спарсить ym.getAllAccountInformation
  /// 
  /// (Токен становится неактивным только если пользователь меняет\восстанавливает пароль с выходом из аккаунта на всех устройствах)
  YandexMusicException.initialization(String message) 
      : this(message, YandexMusicExceptionType.initialization);
  
  /// Сообщает об ошибки авторизации
  /// 
  /// Скорее всего токен перестал быть активен и нужно заново инициализировать библиотеку с уже новым токеном
  /// 
  /// (Либо разработчик где то не прописал токен :)
  YandexMusicException.unauthorized(String message, {int? code}) 
      : this(message, YandexMusicExceptionType.unauthorized, code: code);
  
  /// Не используется.
  /// Заменена на request
  YandexMusicException.parse(String message) 
      : this(message, YandexMusicExceptionType.parse);

  /// Запрос был выполнен успешно, но сервер не нашел информацию по запросу
  YandexMusicException.notFound(String message, {int? code})
      : this(message, YandexMusicExceptionType.notFound, code: code);

  /// Сообщает об ошибке передаваемых данных в запросе. 
  YandexMusicException.badRequest(String message, {int? code})
      : this(message, YandexMusicExceptionType.badRequest, code: code);

  /// Для изменения плейлиста необходимо указать правильную ревизию плейлиста.
  /// 
  ///  ̶T̶O̶D̶O̶ ̶а̶в̶т̶о̶м̶а̶т̶и̶ч̶е̶с̶к̶о̶е̶ ̶о̶п̶р̶е̶д̶е̶л̶е̶н̶и̶е̶ ̶р̶е̶в̶и̶з̶и̶и̶ Сделано.

  YandexMusicException.wrongRevision(String message, {int? code})
      : this(message, YandexMusicExceptionType.wrongRevision, code: code);

  @override
  String toString() {
    final typeStr = type.name.substring(0, 1).toUpperCase() + type.name.substring(1);
    return 'YandexMusic${typeStr}Exception: $message${code != null ? ' (Code: $code)' : ''}';
  }
}