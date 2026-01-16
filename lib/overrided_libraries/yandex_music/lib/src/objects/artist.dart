abstract class Artist {
  final String title;
  Artist(this.title);
}

/// UGC artist obtained from tracks uploaded by the user
class UGCArtist extends Artist {
  UGCArtist(Map<String, dynamic> json) : super(json['name'] as String);
}

/// Official artist class obtained from official tracks.
class OfficialArtist extends Artist {
  final String id;
  final bool various;
  final bool composer;
  final bool available;
  final String? coverUri;

  OfficialArtist(Map<String, dynamic> json)
      : id = (json['id'] is int) ? json['id'].toString() : json['id'] as String,
        various = json['various'] as bool? ?? false,
        composer = json['composer'] as bool? ?? false,
        available = json['available'] as bool? ?? true,
        coverUri = json['cover']?['uri'] as String?,
        super(json['name'] as String);
}