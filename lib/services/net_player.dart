import 'player.dart';
import 'package:quark/objects/track.dart';
import 'package:yandex_music/yandex_music.dart';

// A complementary class to the main player, created for network playback of tracks. (SPOTIFY may be added)
class NetPlayer {
  final Player player;
  final YandexMusic yandexMusic;

  NetPlayer({required this.player, required this.yandexMusic});

  Future<void> playYandex(PlayerTrack track) async {
    try {
      String link = await yandexMusic.tracks.getDownloadLink(
        (track as YandexMusicTrack).track.id,
      );
      await player.playNetTrack(link, track);
    } catch (e) {}
  }
}