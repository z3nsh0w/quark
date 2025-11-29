class Artist {
  final String? id;
  final String? title;
  final bool? various;
  final bool? composer;
  final bool? available;
  final String? coverUri;
  
  Artist(Map<String, dynamic> json)
  : id = json['id'] is int ? json['id'].toString() : json['id'],
    title = json['name'],
    various = json['various'],
    composer = json['composer'],
    coverUri = json['cover']?['uri'],
    available = json['available'];
}