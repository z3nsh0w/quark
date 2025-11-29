// import '../requests/requests.dart';
// import '../../yandex_music.dart';

// class _YandexMusicAccount {
//   final YandexMusic _parentClass;
//   late final Requests requests;
//   _YandexMusicAccount(this._parentClass);

//   /// Выдает уникальный итендификатор аккаунта
//   Future<int> getAccountID() async {
//     return _parentClass.accountID;
//   }

//   /// Выдает логин аккаунта.
//   Future<String> getLogin() async {
//     final response = await requests.basicRequest('/account/status');
//     return response['result']['account']['login']; 
//   }

//   /// Выдает полное имя пользователя (Имя + Фамилия)
//   Future<String> getFullName() async {
//     final response = await requests.basicRequest('/account/status');

//     return response['result']['account']['fullName'];
//   }

//   /// Выдает никнейм пользователя
//   Future<String> getDisplayName() async {
//     final response = await requests.basicRequest('/account/status');

//     return response['result']['account']['displayName'];
//   }

//   /// Выдает всю доступную информацию об аккаунте в сыром виде
//   Future<Map<String, dynamic>> getAllAccountInformation() async {
//     final response = await requests.basicRequest('/account/status');

//     return response['result'];
//   }

//   /// Выдает состояние подписки плюс
//   Future<bool?> hasPlusSubscription() async {
//     final response = await requests.basicRequest('/account/status');

//     return response['result']['plus']['hasPlus'];
//   }

//   /// Выдает полный дефолтный email пользователя
//   Future<String> getUserEmail() async {
//     final response = await requests.basicRequest('/account/status');

//     return response['result']['defaultEmail'];
//   }

//   /// Выдает настройки пользователя в сыром виде
//   Future<Map<String, dynamic>> getUserAccountSettings() async {
//     final response = await requests.basicRequest('/account/settings');
//     return response['result'];
//   }
// }