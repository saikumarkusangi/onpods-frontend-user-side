class Data {
  final String id;
  final String icon;
  final String name;
  final String sound;

  Data({
    required this.id,
    required this.icon,
    required this.name,
    required this.sound,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      icon: json['icon'],
      name: json['name'],
      sound: json['sound'],
    );
  }
}

class SoundEffectCategory {
  final String soundEffectCategory;
  final List<Data> data;

  SoundEffectCategory({
    required this.soundEffectCategory,
    required this.data,
  });

  factory SoundEffectCategory.fromJson(Map<String, dynamic> json) {
    return SoundEffectCategory(
      soundEffectCategory: json['category'],
      data: (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
