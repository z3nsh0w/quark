import 'package:yandex_music/src/lower_level.dart';
import 'package:yandex_music/yandex_music.dart';

class YandexMusicAccount {
  final YandexMusic _parentClass;
  final YandexMusicApiAsync api;

  YandexMusicAccount(this._parentClass, this.api);

  /// Issues a unique account identifier
  Future<int> getAccountID() async {
    return _parentClass.accountID;
  }

  /// Displays the account login.
  Future<String> getLogin() async {
    return _parentClass.rawUserInfo['result']['account']['login'];
  }

  /// Returns the user's full name (First Name + Last Name)
  Future<String> getFullName() async {
    return _parentClass.rawUserInfo['result']['account']['fullName'];
  }

  /// Gives the user's nickname
  Future<String> getDisplayName() async {
    return _parentClass.rawUserInfo['result']['account']['displayName'];
  }

  /// Displays all available account information in raw form
  Future<Map<String, dynamic>> getAccountInformation() async {
    var _userInfo = await api.getAccountInformation();

    return _userInfo['result'];
  }

  /// Shows subscription status plus
  Future<bool?> hasPlusSubscription() async {
    return _parentClass.rawUserInfo['result']['plus']['hasPlus'];
  }

  /// Displays the user's full default email
  Future<String> getEmail() async {
    return _parentClass.rawUserInfo['result']['defaultEmail'];
  }

  /// Shows user settings in raw form
  Future<Map<String, dynamic>> getAccountSettings() async {
    var a = await api.getAccountSettings();
    return a['result'];
  }
}
