import 'package:yandex_music/src/objects/devired_colors.dart';

class Cover {
  final String? type;
  final List<String>? itemsUri;
  final bool? custom;
  final String? uri;
  final String? prefix;

  Cover({this.type, this.itemsUri, this.custom, this.uri, this.prefix});

  factory Cover.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Cover();

    return Cover(
      type: json['type'] as String?,
      itemsUri: json['itemsUri'] != null
          ? List<String>.from(json['itemsUri'] as List)
          : null,
      custom: json['custom'] as bool?,
      uri: json['uri'] as String?,
      prefix: json['prefix'] as String?,
    );
  }
}

class Cover2 {
  final String uri;
  final String color;
  final DerivedColors? derivedColors;

  Cover2(Map<String, dynamic> fromJson)
    : uri = fromJson['uri'],
      color = fromJson['color'],
      derivedColors = fromJson['derivedColors'] != null ? DerivedColors(fromJson['derivedColors']) : null;
}
