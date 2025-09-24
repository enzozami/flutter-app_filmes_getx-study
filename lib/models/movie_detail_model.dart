import 'dart:convert';

import 'package:app_filmes/models/cast_model.dart';
import 'package:app_filmes/models/genre_model.dart';

class MovieDetailModel {
  final String title;
  final double stars;
  final List<GenreModel> genres;
  final String urlImage;
  final DateTime releaseDate;
  final String overview;
  final List<String> productionCompanies;
  final String originalLanguage;
  final List<CastModel> cast;
  MovieDetailModel({
    required this.title,
    required this.stars,
    required this.genres,
    required this.urlImage,
    required this.releaseDate,
    required this.overview,
    required this.productionCompanies,
    required this.originalLanguage,
    required this.cast,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'stars': stars,
      'genres': genres.map((x) => x.toMap()).toList(),
      'urlImage': urlImage,
      'releaseDate': releaseDate.millisecondsSinceEpoch,
      'overview': overview,
      'productionCompanies': productionCompanies,
      'originalLanguage': originalLanguage,
      'cast': cast.map((x) => x.toMap()).toList(),
    };
  }

  factory MovieDetailModel.fromMap(Map<String, dynamic> map) {
    return MovieDetailModel(
      title: map['title'] ?? '',
      stars: map['stars']?.toDouble() ?? 0.0,
      genres: List<GenreModel>.from(map['genres']?.map((x) => GenreModel.fromMap(x)) ?? const []),
      urlImage: map['urlImage'] ?? '',
      releaseDate: DateTime.fromMillisecondsSinceEpoch(map['releaseDate']),
      overview: map['overview'] ?? '',
      productionCompanies: List<String>.from(map['productionCompanies'] ?? const []),
      originalLanguage: map['originalLanguage'] ?? '',
      cast: List<CastModel>.from(map['cast']?.map((x) => CastModel.fromMap(x)) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieDetailModel.fromJson(String source) => MovieDetailModel.fromMap(json.decode(source));
}
