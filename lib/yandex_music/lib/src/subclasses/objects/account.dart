import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicAccount {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicAccount(this._parentClass, this.api);

  /// Выдает уникальный идентификатор аккаунта
  Future<int> getAccountID() async {
    return _parentClass.accountID;
  }

  /// Выдает логин аккаунта.
  Future<String> getLogin() async {
    return _parentClass.rawUserInfo['result']['account']['login'];
  }

  /// Выдает полное имя пользователя (Имя + Фамилия)
  Future<String> getFullName() async {
    return _parentClass.rawUserInfo['result']['account']['fullName'];
  }

  /// Выдает никнейм пользователя
  Future<String> getDisplayName() async {
    return _parentClass.rawUserInfo['result']['account']['displayName'];
  }

  /// Выдает всю доступную информацию об аккаунте в сыром виде
  Future<Map<String, dynamic>> getAccountInformation() async {
    var _userInfo = await api.getAccountInformation();

    return _userInfo['result'];
  }

  /// Выдает состояние подписки плюс
  Future<bool?> hasPlusSubscription() async {
    return _parentClass.rawUserInfo['result']['plus']['hasPlus'];
  }

  /// Выдает полный дефолтный email пользователя
  Future<String> getEmail() async {
    return _parentClass.rawUserInfo['result']['defaultEmail'];
  }

  /// Выдает настройки пользователя в сыром виде
  Future<Map<String, dynamic>> getAccountSettings() async {
    var a = await api.getAccountSettings();
    return a['result'];
  }
}
