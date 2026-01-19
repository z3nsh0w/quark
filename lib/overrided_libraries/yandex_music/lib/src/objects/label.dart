class Label {
  final int id;
  final String name;

  Label(this.id, this.name);

  factory Label.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Label(0, '');
    
    return Label(
      json['id'] as int? ?? 0,
      json['name'] as String? ?? '',
    );
  }
}