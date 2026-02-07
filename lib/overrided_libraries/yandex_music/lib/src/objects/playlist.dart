import 'track.dart';
import 'owner.dart';

class Playlist {
  /// Playlist identifier
  final int kind;

  /// Playlist owner ID
  final int ownerUid;

  final Owner owner;

  /// Unique playlist identifier
  final String playlistUuid;

  /// Playlist name
  final String title;

  /// Revising the playlist
  final int revision;

  /// Playlist privacy
  ///
  /// Either public or private
  final String visibility;

  /// A sheet with playlist tracks that are objects of the Track class
  final List<Track> tracks;

  /// Map with covers
  final Map<String, dynamic>? cover;

  /// Clean response from the server
  final Map<String, dynamic> raw;

  Playlist(Map<String, dynamic> json)
    : kind = json['kind'],
      ownerUid = json['owner']?['uid'] ?? json['uid'],
      owner = json['owner'] != null ? Owner(json['owner']) : Owner({}),
      playlistUuid = json['playlistUuid'],
      title = json['title'],
      revision = json['revision'],
      visibility = json['visibility'],
      cover = json['cover'],
      tracks = json['tracks'] != null
          ? (json['tracks'] as List).map((t) => Track(t['track'] ?? t)).toList()
          : [],
      raw = json;
}

class PlaylistWShortTracks {
  /// Playlist identifier
  final int kind;

  /// Playlist owner ID
  final int ownerUid;

  final Owner owner;

  /// Unique playlist identifier
  final String playlistUuid;

  /// Playlist name
  String title;

  /// Revising the playlist
  final int revision;

  /// Playlist privacy
  ///
  /// Either public or private
  final String visibility;

  /// A sheet with playlist tracks that are objects of the Track class
  final List<ShortTrack> tracks;

  /// Map with covers
  Map<String, dynamic>? cover;

  /// Clean response from the server
  final Map<String, dynamic> raw;

  PlaylistWShortTracks(Map<String, dynamic> json)
    : kind = json['kind'],
      ownerUid = json['owner']?['uid'] ?? json['uid'],
      owner = json['owner'] != null ? Owner(json['owner']) : Owner({}),
      playlistUuid = json['playlistUuid'],
      title = json['title'],
      revision = json['revision'],
      visibility = json['visibility'],
      cover = json['cover'],
      tracks = json['tracks'] != null
          ? (json['tracks'] as List)
                .map((t) => ShortTrack(t['track'] ?? t))
                .toList()
          : [],
      raw = json;
}

class ShortPlaylistInfo {
  final int likesCount;
  final int trackCount;
  final int ownerUid;
  final String playlistUuid;
  final int kind;
  final String title;
  final String coverUri;

  ShortPlaylistInfo(Map<String, dynamic> fromJson)
    : likesCount = fromJson['likesCount'],
      trackCount = fromJson['trackCount'],
      playlistUuid = fromJson['playlist']['playlistUuid'],
      kind = fromJson['playlist']['kind'],
      title = fromJson['playlist']['title'],
      ownerUid = fromJson['playlist']['uid'],
      coverUri = fromJson['playlist']['cover']['uri'];
}
