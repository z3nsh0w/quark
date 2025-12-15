import 'package:quark/objects/track.dart';

class PlayerPlaylist {
  final int kind;
  final String name;
  final int ownerUid;
  final List<PlayerTrack> tracks;
  PlayerPlaylist(this.ownerUid, this.kind, this.name, this.tracks);
}