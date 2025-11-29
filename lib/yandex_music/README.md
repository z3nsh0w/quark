# yandex_music - неофициальная библиотека yandex music под flutter

Изначально было сделано для аудиоплеера quark

made by z3nsh0w

# Миграция

~~Я календарь~~ 

Спустя много часов просмотра скриптов яндекс музыки мы доделали основные функции и улучшили нашу библиотеку

Отныне плейлисты, альбомы, треки, тексты к трекам и тд будут представлять собой объекты класса

```dart
var playlist = await ymInstance.getPlaylist(1000);

// Возвращает kind плейлиста
print(playlist.kind)
// Возвращает uid владельца плейлиста
print(playlist.ownerUid)
// Название плейлиста
print(playlist.title)
// Ревизия плейлиста
print(playlist.revision)
// Статус приватности плейлиста
print(playlist.visibility)
// Uri обложки
print(playlist.cover)

for (var track in playlist.tracks) {
  print(track.title)
  print(track.id)
  print(track.realId)
  print(track.artists)
  print(track.albums)
  print(track.coverUri)
  print(track.durationMs)
  print(track.raw)
}

// Если вы хотите получить чистый ответ от сервера то можно использовать raw
print(playlist.raw) 

```



# Токен

Для использования библиотеки необходим OAuth-токен
### Рекомендуемый метод (если вы разрабатываете приложение с интерфейсом)

Метод заключается в том, чтобы использовать WebView, перебрасывать пользователя на [официальную страницу авторизации яндекса](https://oauth.yandex.ru/authorize?response_type=token&client_id=23cabbbdc6cd418abb4b39c32c41195d) и отслеживать его перемещение.
Когда пользователь авторизуется, в ссылке обязательно будет храниться токен, который можно использовать в библиотеке. 
Пример в самом конце.

### Альтернативные способы

Альтернативные методы получения токена описаны в [инструкции для самостоятельного получения токена](https://yandex-music.readthedocs.io/en/main/token.html) 

Важно! Нет гарантий что токен не попадет в 3-и руки при таких способах. Все на ваш страх и риск!
## Установка

```yaml
dependencies:
  yandex_music: ^latest
```

```bash
flutter pub get
```

или

```bash
flutter pub add yandex_music
```

### Использование

**Инициализация**

```dart
import 'package:yandex_music/yandex_music.dart';

void main() async {
  late final YandexMusic ymInstance;
  
  // ... some code
  
  ymInstance = YandexMusic(token: 'your_api_token_here');
  
  await ymInstance.init();
}
```

**Исключения**  
Во время работы с библиотекой желательно каждый запрос оборачивать в try catch.
Даже правильно составленый запрос может вернуть ошибку, например если запрашиваемая информация не найдена

```dart
try {
	final playlist = await ymInstance.playlists.getPlaylist(999); // Данный запрос вернет notFound
	
	final result = await ymInstance.search.all(''); // Этот запрос вернет badRequest тк поле поиска пустое
	
} on YandexMusicException catch (e) {

switch (e.type) {

	case YandexMusicExceptionType.network:
		print('Network exception: ${e.message}');
		break;
	
	case YandexMusicExceptionType.unauthorized:
		print('Authorization exception: ${e.message}');
		break;
	
	case YandexMusicExceptionType.badRequest:
		print('Bad request: ${e.message}');
		break;
	
	case YandexMusicExceptionType.wrongRevision:
		print('Wrong revision: ${e.message}');
		break;
	
	case YandexMusicExceptionType.notFound:
		print('Not found: ${e.message}');
		break;
	
	// ETC. все типы можно увидеть внутри YandexMusicExceptionType
	
	default:
		print('Another error: ${e.message}');

}

} catch (e) {
	logger.e('Error not related to yandex music: $e');
	
	rethrow;
}
```

**Информация об аккаунте**

```dart
// Информация об аккаунте кэшируется в момент инициализации класса.
// Если нужно получить актуальную информацию, используем метод updateCache();
await ymInstance.updateCache();

// Уникальный идентификатор пользователя
int accountId = await ymInstance.account.getAccountID();

// Логин пользователя
String login = await ymInstance.account.getLogin();

// Никнейм пользователя
String displayName = await ymInstance.account.getDisplayName();

// Почта
String email = await ymInstance.account.getEmail();

// Имеет ли пользователь активную подписку PLUS
bool hasPlus = await ymInstance.account.hasPlusSubscription();

// Настройки аккаунта музыки (тема, громкость, видимость аккаунта, настройки радио итд)
// Выдается не из кэша
Map<String, dynamic> settings = await ymInstance.account.getAccountSettings();

// Полная (необработанная) информация об аккаунте
// Выдается не из кэша

Map<String, dynamic> accountInfo = await ymInstance.account.getAllAccountInformation();
```

**Плейлисты**

```dart
// Для получение разного рода информации о плейлисте необходим KIND - (неуникальный для всего яндекса, но уникальный для пользователя) идентификатор плейлиста. Для примера взят 1000

// При каждом изменении плейлиста ревизия меняется на +1!

// Получение информации о плейлисте вместе с треками
Map<String, dynamic> playlistInfo = await ymInstance.playlists.getPlaylist(1000);

// Если плейлист создан кем-то другим, нужно передать accountId создателя
Map<String, dynamic> playlistInfo = await ymInstance.playlists.getPlaylist(1000, 19578195222);


// Получение всех плейлистов пользователя
List<dynamic> usersPlaylists = await ymInstance.playlists.getUsersPlaylists();

// Получение нескольких плейлистов
List<dynamic> multiplePlaylists = await ymInstance.playlists.getMultiplePlaylists([1000, 1001]);

// Получение нескольких плейлистов от других владельцев
// Плейлист указывается в формате accountId:kind
List<dynamic> playlists = await ymInstance.playlists.getPlaylists(['19578195222:1000']);


// Получение моей волны (рекомендаций) для определенного плейлиста
List<dynamic> recomendations = await ymInstance.playlists.getRecomendationsForPlaylist(1000);


// Создание нового плейлиста
// Создаст публичный плейлист с названием title 
Map<String, dynamic> newPlaylist = await ymInstance.playlists.createPlaylist('title', ymInstance.playlists.publicPlaylist);

// Создаст приватный плейлист с названием title56
Map<String, dynamic> newPlaylist = await ymInstance.playlists.createPlaylist('title56', ymInstance.playlists.privatePlaylist);


// Переименование плейлиста (например переименовываем плейлист 1000 на title78)
await ymInstance.playlists.renamePlaylist(1000, 'title78');

// Удаление плейлиста
await ymInstance.playlists.deletePlaylist(1000);


// Добавление треков в плейлист

// ! Если добавить трек дважды, то он добавиться дважды.
// Тоесть если вы захотели переместить трек, то его нужно сначала убрать, потом добавить

// Для изменения плейлиста обычно требуется его ревизия. Однако библиотека расчитана на автоматическое получение ревизии

// Более удобный метод:

// 1000 - KIND
// 35724293 - trackId | пример трека Radiohead - No Surprises
// 4468564 - albumId  | Альбом OK Computer OKNOTOK 1997 2017
// 0 - Индекс вставки трека. Трек можно вставить на любой индекс. По умолчанию значение 0. Можно не указывать

// Такой метод можно вызвать несколько раз
await ymInstance.playlists.insertTrackIntoPlaylist(1000, 35724293.toString(), 4468564.toString(), 0);



// Для добавления несколько треков за 1 запрос можно использовать другой метод.
// В этом методе треки передаются списком со словарями
// Все остальное также

// Интересный факт: используя такой метод подразумевается изменение плейлиста столько раз, сколько вы добавите треков. Тоесть на серверах яндекса это по сути вызов insertTrackIntoPlaylist несколько раз.
await ymInstance.playlists.addTracksToPlaylist(1000, [{'trackId': '35724293', 'albumId': '4468564'}], 0);


// Удаление треков из плейлиста
// В этом методе нельзя удалить треки указывая их ID
// Треки удаляются по индексам
// Например, выше мы вставили трек на индекс 0
// Вызываем метод с указанием индекса 0
// 
// Первый 0 - индекс с которого начнется удаление
// Второй 0 - индекс которым закончится удаление
// Таким образом можно снести весь плейлист указывая конечный индекс
await ymInstance.playlists.deleteTracksFromPlaylist(1000, 0, 0);


// Изменение доступности плейлиста (публичный, приватный)

await ymInstance.playlists.changeVisibility(1000, ymInstance.playlists.publicPlaylist);

// или

await ymInstance.playlists.changeVisibility(1000, ymInstance.playlists.privatePlaylist);
```

**Треки**

```dart
// Получение полной информации о треках
List tracks = await ymInstance.tracks.getTracks(['35724293']);

// Получение похожих треков
List similar = await ymInstance.tracks.getSimilarTracks('35724293');

// Получение дополнительной информации о треке
// Может вернуть микроклип, текст песни итд 
Map<String, dynamic> trackInfo = await ymInstance.tracks.getAdditionalTrackInfo('35724293');


// Скачивание трека

// Для скачивания трека много функций и букв, самому страшно
// Важно! Трек не скачивается в файл! Трек возвращается в байтовом формате, с которым вы работаете самостоятельно


// 1. Автоматическое скачивание
// Возвращает трек в MP3 320kbps
final track = await ymInstance.tracks.autoDownloadTrack('35724293');

// Также можно получить чисто ссылку для скаичвания
String link = await ymInstance.tracks.autoGetTrackLink('35724293');


// 2. Мануальное скачивание (если хотите заморочиться или скачать в другом качестве)
// 2.1 Вызываем функцию которая вернет информацию о скачивании трека
List downloadInfo = await ymInstance.tracks.getTrackDownloadInfo('35724293');
// Вывод будет таким [{codec: mp3, gain: false, preview: false, downloadInfoUrl: 'link', direct: false, bitrateInKbps: 192}, {codec: mp3, gain: false, preview: false, downloadInfoUrl: 'link', direct: false, bitrateInKbps: 320}]

// Отсюда нам нужна downloadInfoUrl. Для примера возьмем 192 kbps, т.е индекс 0

// Важно! Ссылку для скачивания можно посмотреть только 1 раз и определенное кол-во времени. 
// После этого ссылка перестанет быть действительной и будет выдавать 401

// 2.2
String downloadLink = await ymInstance.tracks.getTrackDownloadLink(downloadInfo[0]['downloadInfoUrl']);

// 2.3 Наконец получаем трек
final track = await ymInstance.tracks.getTrackAsBytes(downloadLink);

// 2.4 Для примера запишем в файл
File file = File('$path/track3.mp3');
file.writeAsBytes(track);
```

**Пользовательские треки**
В будущем здесь также будет возможность загрузить свои треки

```dart
// Получение всех понравившихся треков пользователя
List likedTracks = await ymInstance.usertracks.getDislikedTracks();

// Получение всех треков, которые пользователь дизлайкнул. 
List dislikedTracks = await ymInstance.usertracks.getLikedTracks();

// Методы ниже не являются void. 
// Они возвращают актуальную ревизию плейлиста Понравившиеся (внутри словаря). С точки зрения яндекса понравившиеся треки - это плейлист, но здесь мы не работаем с точки зрения плейлиста.

// Добавление треков в понравившиеся
await ymInstance.usertracks.likeTracks(['35724293']);

// Удаление треков из понравившихся. Не убирает трек из рекомендаций!
await ymInstance.usertracks.unlikeTracks(['35724293']);
```

**Поиск**

```dart
// При вызове каждого метода можно передать страницу поиска (по умолчанию 0).
// Можно передать bool значение noCorrect. Незнаю что оно делает 

// Поиск треков
final tracks = ymInstance.search.tracks('Execution is fun!', 1);

// Поиск артистов
final artists = ymInstance.search.artists('Rammstein');

// Поиск альбомов
final albums = ymInstance.search.albums('Ok computer');

// Поиск подскастов
final podcasts = ymInstance.search.podcasts('кто вообще слушает подкасты?');

// Поиск везде
final result = ymInstance.search.all('mr kitty');
```

**Альбомы**

```dart
// Получение информации об альбоме
final albumInfo = await ymInstance.albums.getAlbumInformation(3645134);

// Получение альбома с треками
final album = await ymInstance.albums.getAlbum(3456134);

// Получение нескольких альбомов
final albums = await ymInstance.albums.getAlbums([3456134]);
```

**Лендинг**
Лендинг - то что вы видите заходя на сайт яндекс музыки: подборки, новые релизы итд. Лендинг делится на блоки исходя из контента, который в нем содержится.


```dart
// Получение всех блоков

// Возвращает все блоки лендинга, а именно:
// Персональные плейлисты
// Акции
// Новые релизы
// Новые плейлисты
// Миксы
// Чарты
// Артисты
// Альбомы
// Плейлисты
// Контексты проигрывания трека
// Подкасты
final blocks = await ymInstance.landing.getAllLandingBlocks();

// Получение отдельного блока
// Поддерживает:
// landing.newReleases
// landing.newPlaylists
// landing.chart
// landing.podcasts

final block = await ymInstance.landing.getBlock(ymInstance.landing.newReleases);
```

# Получение токена через webview

Для примера используем Flutter inappwebview (не работает под линукс :(

```dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Добавить MaterialApp
      home: Scaffold(
        // Добавить Scaffold
        body: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
            child: Container(
              width: 400,
              height: 650,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(
                      'https://oauth.yandex.ru/authorize?response_type=token&client_id=23cabbbdc6cd418abb4b39c32c41195d',
                    ),
                  ),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStop: (controller, url) async {
                    if (url.toString().contains('access_token')) {
                      String token = url
                          .toString()
                          .split('#')[1]
                          .split('&')[0]
                          .replaceAll('access_token=', '');
                      if (token.length > 3) {
                        print('Got token: $token');
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```
