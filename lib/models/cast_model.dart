import 'dart:convert';

class CastModel {
  final String name;
  final String image;
  final String character;
  CastModel({
    required this.name,
    required this.image,
    required this.character,
  });

  Map<String, dynamic> toMap() {
    return {
      'original_name': name,
      'profile_path': image,
      'character': character,
    };
  }

  factory CastModel.fromMap(Map<String, dynamic> map) {
    final pathModel = map['profile_path'];
    final urlImage = pathModel != null ? 'https://image.tmdb.org/t/p/w500$pathModel' : '';

    return CastModel(
      name: map['original_name'] ?? '',
      image: urlImage,
      character: map['character'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CastModel.fromJson(String source) => CastModel.fromMap(json.decode(source));
}
