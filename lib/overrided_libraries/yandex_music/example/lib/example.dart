import 'package:yandex_music/yandex_music.dart';


// void main() async {
//   try {
//     await yandexMusic.init();
//     var a = await yandexMusic.tracks.download('99363737', quality: AudioQuality.mp3);
//     await File('14.flac').writeAsBytes(a);
//   } on YandexMusicException catch (e) {
//     switch (e.type) {
//       case YandexMusicExceptionType.network:
//         print('Network error: ${e.message}');
//         break;
//       case YandexMusicExceptionType.unauthorized:
//         print('Token invalid: ${e.code} ${e.message}');
//         break;
//       case YandexMusicExceptionType.wrongRevision:
//         print('Playlist revision mismatch');
//         break;
//       default:
//         print('Other error: ${e.message}');
//     }
//   }
// }

// void accountInfo(YandexMusic yandexMusic) async {
//   int accountID = await yandexMusic.account.getAccountID();
//   // OR
//   accountID = yandexMusic.accountID;
//   // Email
//   String email = await yandexMusic.account.getEmail();
//   // Логин аккаунта
//   String login = await yandexMusic.account.getLogin();
//   // Полное имя пользователя
//   String fullName = await yandexMusic.account.getFullName();
//   // Псевдоним аккаунта
//   String displayName = await yandexMusic.account.getDisplayName();
//   // Проверяет наличие подписки PLUS. False || Null если ее нет.
//   bool? plusSubscription = await yandexMusic.account.hasPlusSubscription();

//   print('Email: $email');
//   print('Login: $login');
//   print('Full name: $fullName');
//   print('Account ID: $accountID');
//   print('Display name: $displayName');
//   print('Plus subscription state: $plusSubscription');
// }

// void trackExamples(YandexMusic yandexMusic) async {
//   // Получение информации о треке
//   Track track = (await yandexMusic.tracks.getTracks(['330765']))[0];
//   print('Track: ${track.title} by ${track.artists.map((a) => a.title).join(', ')}');

//   // Скачивание трека (MP3 320)
//   var bytes = await yandexMusic.tracks.download('330765');
//   print('Downloaded ${bytes.length} bytes');

//   // Скачивание в lossless
//   var losslessBytes = await yandexMusic.tracks.download('330765', quality: AudioQuality.lossless);
//   print('Lossless size: ${losslessBytes.length} bytes');

//   // Получение текста песни
//   Lyrics lyrics = await yandexMusic.tracks.getLyrics('330765');
//   print('Lyrics: ${lyrics.downloadUrl}');

//   // Похожие треки
//   List<Track> similar = await yandexMusic.tracks.getSimilar('330765');
//   print('Similar tracks: ${similar.length}');
// }


// void albumExamples(YandexMusic yandexMusic) async {
//   // Получение альбома
//   Album album = await yandexMusic.albums.getInformation(3389005);
//   print('Album: ${album.title} by ${album.artists.map((a) => a.title).join(', ')}');

//   // Несколько альбомов
//   List<Album> albums = await yandexMusic.albums.getAlbums([3389005]);
//   print('Fetched ${albums.length} albums');
// }


// void playlistExamples(YandexMusic yandexMusic) async {
//   // Получение всех пользовательских плейлистов
//   List<Playlist> playlists = await yandexMusic.playlists.getUsersPlaylists();
//   print('User has ${playlists.length} playlists');

//   // Создание нового плейлиста
//   Playlist newPlaylist = await yandexMusic.playlists.createPlaylist('My Cool Playlist', yandexMusic.playlists.publicPlaylist);
//   print('Created playlist: ${newPlaylist.title} (kind: ${newPlaylist.kind})');

//   // Добавление трека
//   await yandexMusic.playlists.insertTrack(newPlaylist.kind, '1234567', '7654321');
//   print('Track added');

//   // Переименование
//   await yandexMusic.playlists.renamePlaylist(newPlaylist.kind, 'Even Cooler Playlist');

//   // Удаление
//   await yandexMusic.playlists.deletePlaylist(newPlaylist.kind);
//   print('Playlist deleted');
// }


// void likeExamples(YandexMusic yandexMusic) async {
//   // Лайк трека
//   await yandexMusic.usertracks.like(['330765']);
//   print('Track liked');

//   // Получение лайкнутых треков
//   List<Track2> liked = await yandexMusic.usertracks.getLiked();
//   print('Liked tracks: ${liked.length}');

//   // Дизлайк
//   await yandexMusic.usertracks.unlike(['330765']);
//   print('Track unliked');

//   // Дизлайкнутые треки (редко используется)
//   List<dynamic> disliked = await yandexMusic.usertracks.getDisliked();
//   print('Disliked tracks: ${disliked.length}');
// }

// void searchExamples(YandexMusic yandexMusic) async {
//   // Поиск треков
//   List<Track> tracks = await yandexMusic.search.tracks('Pink Floyd');
//   print('Found ${tracks.length} tracks');

//   // Поиск альбомов
//   List<Album> albums = await yandexMusic.search.albums('Pink Floyd');
//   print('Found ${albums.length} albums');

//   // Поиск исполнителей
//   List<Artist> artists = await yandexMusic.search.artists('Pink Floyd');
//   print('Found ${artists.length} artists');

//   // Универсальный поиск
//   var all = await yandexMusic.search.all('Pink Floyd');
//   print('Best result type: ${all['best']['type']}');
// }

// void vibeExamples(YandexMusic yandexMusic) async {
//   // Доступные настройки
//   List<vibeSetting> settings = await yandexMusic.myVibe.getWaves();
//   print('Available vibe settings: ${settings.length}');

//   // Создание волны
//   Wave wave = await yandexMusic.myVibe.createWave(settings.take(2).toList());
//   print('Wave created: ${wave.batchId}');

//   // Отправка feedback
//   List<Track> queue = wave.tracks;
//   await yandexMusic.myVibe.sendFeedback(
//     wave,
//     SkipFeedback(
//       queue: queue,
//       track: wave.tracks[0],
//       totalPlayedSeconds: 10.5,
//     ),
//   );
//   print('Skip feedback sent');
// }

// void pinExamples(YandexMusic yandexMusic) async {
//   // Закреп альбома
//   await yandexMusic.pin.album('100500', yandexMusic.pin.pin);
//   print('Album pinned');

//   // Открепление
//   await yandexMusic.pin.album('100500', yandexMusic.pin.unPin);
//   print('Album unpinned');

//   // Закреп плейлиста
//   await yandexMusic.pin.playlist(123456789, 100500, yandexMusic.pin.pin);
//   print('Playlist pinned');

//   // Закреп волны
//   await yandexMusic.pin.wave(['artist:12345'], yandexMusic.pin.pin);
//   print('Wave pinned');
// }

// void uploadExamples(YandexMusic yandexMusic) async {
//   // Загрузка файла
//   File file = File('my_track.mp3');
//   String trackId = await yandexMusic.usertracks.uploadUGCTrack(3, file); // 3 = kind плейлиста "Мне нравится"
//   print('Uploaded track ID: $trackId');

//   // Переименование
//   bool renamed = await yandexMusic.usertracks.renameUGCTrack(trackId, 'My Track', 'Me');
//   print('Renamed: $renamed');
// }

// void landingExamples(YandexMusic yandexMusic) async {
//   // Все блоки
//   var allBlocks = await yandexMusic.landing.getAllLangingBlocks();
//   print('Landing blocks count: ${allBlocks['blocks'].length}');

//   // Новые релизы
//   var newReleases = await yandexMusic.landing.getBlock(yandexMusic.landing.newReleases);
//   print('New releases count: ${newReleases['tracks'].length}');
// }
