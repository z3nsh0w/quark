import 'track.dart';

class Quality {
  /// Высокое качество звучания. 
  /// 
  /// Пропускная способность: Lossless или ниже (в зависимости от трека) 
  /// 
  /// Средний вес lossless файла > 20 мбайт
  String lossless = 'lossless';
  /// Среднее качество звучания. 
  /// 
  /// Пропускная способность: 192 кбит/с
  /// 
  /// Средний вес файла > 5 мбайт
  String balanced = 'nq';
  /// Низкое качество звучания. 
  /// 
  /// Пропускная способность: 64 кбит/c
  /// 
  /// Средний вес файла около 2 мбайт
  String efficient = 'lq';
}


class LyricsFormat {
  /// Простые субтитры в текстовом формате
  String text = 'TEXT';
  /// Субтитры с временной меткой трека
  /// 
  /// [00:00.05] Ich will
  String withTime = 'LRC';
}

class Operations {
  String insertTrack = 'insert';
  String deleteTracks = 'delete';
}


class PlayerPlaylist {
  final int ownerUid;
  final int kind;
  final String name;
  final List<Track> tracks;
  PlayerPlaylist(this.ownerUid, this.kind, this.name, this.tracks);
}