import 'player.dart';
import 'database_engine.dart';
import 'package:quark/objects/track.dart';
import 'package:yandex_music/yandex_music.dart';

/// A complementary class to the main player, created for network playback of tracks. (SPOTIFY may be added)
class NetPlayer {
  final Player player;

  YandexMusic yandexMusic;

  NetPlayer({required this.player, required this.yandexMusic});

  Future<void> init(YandexMusic instance) async {
    yandexMusic = instance;
  }

  Future<void> playYandex(PlayerTrack track) async {
    try {
      String link = await yandexMusic.tracks.getDownloadLink(
        (track as YandexMusicTrack).track.id,
      );
      await player.playNetTrack(link, track);
    } catch (e) {}
  }
}

/// Controls playback and caching of non-local and non-cached tracks

class NetConductor {
  late final Player _player;
  late final YandexMusic _yandex;

  static final NetConductor _singleton = NetConductor._internal();

  factory NetConductor() {
    return _singleton;
  }

  bool _isInitialized = false;

  NetConductor._internal();

  void init(Player player, YandexMusic yandex) async {
    if (_isInitialized) {
      return;
    }
    _player = player;
    _yandex = yandex;
    _player.trackNotifier.addListener(_onTrackChanged);
    _isInitialized = true;
  }

  void _onTrackChanged() async {
    final track = _player.trackNotifier.value;

    if (track is LocalTrack) {
      if (await File(track.filepath).exists()) {
      } else {}
    } else if (track is YandexMusicTrack) {
      if (await File(track.filepath).exists()) {
      } else {
        try {
          final link = await _yandex.tracks.getDownloadLink(track.track.id);
          print(link);
          await _player.playNetTrack(link, track);
        } catch (e) {}
      }
    }

    await cacheFiles();
  }

  /// Top function for caching tracks in storage
  Future<void> cacheFiles([List<PlayerTrack>? tracks]) async {
    if (tracks == null) {
      tracks = [];
      for (int i = -1; i < 2; i++) {
        tracks.add(
          Player.player.playlist[(Player.player.playlist.indexOf(
                    Player.player.nowPlayingTrack,
                  ) +
                  i) %
              Player.player.playlist.length],
        );
      }
    }
    for (PlayerTrack track in tracks) {
      if (track is! LocalTrack) {
        _cacheFileInBackground(track);
      }
    }
  }

  Future<void> _cacheFileInBackground(PlayerTrack track) async {
    String? quality = await Database.get(
      DatabaseKeys.yandexMusicTrackQuality.value,
    );
    quality ??= 'mp3';
    AudioQuality downloadQuality = switch (quality) {
      'lossless' => AudioQuality.lossless,
      'nq' => AudioQuality.normal,
      'lq' => AudioQuality.low,
      'mp3' => AudioQuality.mp3,
      _ => AudioQuality.mp3,
    };

    final exists = await File(track.filepath).exists();
    if (!exists) {
      try {
        final download = await _yandex.tracks.download(
          (track as YandexMusicTrack).track.id,
          quality: downloadQuality,
        );
        await File(track.filepath).parent.create(recursive: true);
        await File(track.filepath).writeAsBytes(download);
      } catch (error) {
      }
    }
  }
}
