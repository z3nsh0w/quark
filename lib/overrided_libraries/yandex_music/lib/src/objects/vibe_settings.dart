enum VibeGroup {
  character('character'),
  mood('mood'),
  language('language'),
  activity('activity');

  final String value;
  const VibeGroup(this.value);
}


class VibeSetting {
  final String name;
  final String? value;
  final String seedName;
  final String? imageUrl;
  final VibeGroup group;
  final bool unspecified;

  const VibeSetting({
    required this.name,
    required this.seedName,
    required this.group,
    this.value,
    this.imageUrl,
    this.unspecified = false,
  });

  factory VibeSetting.fromRestriction(
    Map<String, dynamic> json,
    VibeGroup group,
  ) {
    return VibeSetting(
      name: json['name'],
      value: json['value'],
      seedName: json['serializedSeed'],
      imageUrl: json['imageUrl'],
      group: group,
      unspecified: json['unspecified'] == true,
    );
  }

  factory VibeSetting.fromContext(Map<String, dynamic> json) {
    final id = json['id'] as Map<String, dynamic>;
    final icon = json['icon'] as Map<String, dynamic>?;
    return VibeSetting(
      name: json['name'],
      seedName: '${id['type']}:${id['tag']}',
      imageUrl: icon?['imageUrl'],
      group: VibeGroup.activity,
      unspecified: false,
    );
  }
}

class VibeSettings {
  final List<VibeSetting> character;
  final List<VibeSetting> mood;
  final List<VibeSetting> language;
  final List<VibeSetting> activities;

  const VibeSettings({
    required this.character,
    required this.mood,
    required this.language,
    required this.activities,
  });

  List<VibeSetting> get all => [...character, ...mood, ...language, ...activities];

  factory VibeSettings.fromJson(Map<String, dynamic> json) {
    final restrictions = json['settingRestrictions'] as Map<String, dynamic>;
    final contexts = (json['blocks'] as List).isNotEmpty
        ? ((json['blocks'][0]['items']) as List)
        : <dynamic>[];

    List<VibeSetting> _parseRestriction(String key, VibeGroup group) {
      final values = restrictions[key]?['possibleValues'] as List? ?? [];
      return values
          .map((e) => VibeSetting.fromRestriction(e as Map<String, dynamic>, group))
          .toList();
    }

    return VibeSettings(
      character: _parseRestriction('diversity', VibeGroup.character),
      mood: _parseRestriction('moodEnergy', VibeGroup.mood),
      language: _parseRestriction('language', VibeGroup.language),
      activities: contexts
          .map((e) => VibeSetting.fromContext(e as Map<String, dynamic>))
          .toList(),
    );
  }
}