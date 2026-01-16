class Owner {
  final int? uid;
  final String? login;
  final String? name;
  final String? sex;
  final bool? verified;

  final Map<String, dynamic>? raw;

  Owner(Map<String, dynamic> json)
    : uid = json['uid'],
    login = json['login'],
    name = json['name'],
    sex = json['sex'],
    verified = json['verified'],
      raw = json;
}