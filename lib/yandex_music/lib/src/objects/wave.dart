import 'package:yandex_music/src/objects/track.dart';
import 'dart:core';

class Wave {
  String name;
  String batchId;
  String sessionId;
  bool? pumpkin;
  bool terminated;
  bool interactive;
  List seeds;
  List<Track> tracks;

  Wave(Map<String, dynamic> raw) : 
  tracks = (raw['sequence'] as List).map((t) => Track(t['track'])).toList(),
  seeds = raw['wave']['seeds'],
  sessionId = raw['radioSessionId'],
  batchId = raw['batchId'],
  pumpkin = raw['pumpkin'],
  terminated = raw['terminated'],
  interactive = raw['interactive'],
  name = raw['wave']['name'];
}