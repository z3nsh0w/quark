class vibeSetting {
  String name;
  String? value;
  String seedName;
  String? imageUrl;
  String group;
  Map<String, dynamic> raw;

  vibeSetting(Map<String, dynamic> jsonRaw) :
    raw = jsonRaw,
    name = jsonRaw['name'],
    seedName = jsonRaw['serializedSeed'] != null ? jsonRaw['serializedSeed'] : '${jsonRaw['id']['type']}:${jsonRaw['id']['tag']}',
    value = jsonRaw['value'],
    group = '', // later
    imageUrl = jsonRaw['imageUrl']
    ;
}
