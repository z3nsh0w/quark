class Lyrics {
  final String downloadUrl;
  final String lyricId;
  final String? externalLyricId;
  final List<String>? writers;
  final Major? major;

  final Map<String, dynamic> raw;

  // Lyrics(this.downloadUrl, this.lyricId, this.externalLyricId, this.writers, this.major);
  Lyrics(Map<String, dynamic> json)
    : downloadUrl = json['downloadUrl'],
      lyricId = json['lyricId'].toString(),
      externalLyricId = json['externalLyricId']?.toString(),
      writers = (json['writers'] as List<dynamic>?)?.cast<String>(),
      major = json['major'] != null ? Major.fromJson(json['major']) : null,
      raw = json;
}

class Major {
  final String id;
  final String name;
  final String prettyName;

  Major(this.id, this.name, this.prettyName);

  Major.fromJson(Map<String, dynamic> json)
    : id = json['id'].toString(),
      name = json['name'],
      prettyName = json['prettyName'];
}
