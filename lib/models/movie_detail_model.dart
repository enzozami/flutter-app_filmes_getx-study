import 'dart:convert';

import 'package:app_filmes/models/cast_model.dart';
import 'package:app_filmes/models/genre_model.dart';

class MovieDetailModel {
  final String title;
  final double stars;
  final List<GenreModel> genres;
  final List<String> urlImage;
  final DateTime releaseDate;
  final String overview;
  final List<dynamic> productionCompanies;
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
      'vote_average': stars,
      'genres': genres.map((x) => x.toMap()).toList(),
      'urlImage': urlImage,
      'release_date': releaseDate.millisecondsSinceEpoch,
      'overview': overview,
      'production_companies': productionCompanies,
      'original_language': originalLanguage,
      'cast': cast.map((x) => x.toMap()).toList(),
    };
  }

  factory MovieDetailModel.fromMap(Map<String, dynamic> map) {
    var urlImagesPosters = map['images']['posters'];
    var urlImage = urlImagesPosters
            ?.map<String>((i) => 'https://image.tmdb.org/t/p/w500${i['file_path']}')
            .toList() ??
        [];

    return MovieDetailModel(
      title: map['title'] ?? '',
      stars: map['vote_average']?.toDouble() ?? 0.0,
      genres: List<GenreModel>.from(map['genres']?.map((x) => GenreModel.fromMap(x)) ?? const []),
      urlImage: urlImage,
      releaseDate: DateTime.parse(map['release_date']),
      overview: map['overview'] ?? '',
      productionCompanies: List<dynamic>.from(map['production_companies'] ?? const [])
          .map((p) => p['name'])
          .toList(),
      originalLanguage: map['original_language'] ?? '',
      cast: List<CastModel>.from(
          map['credits']['cast']?.map((x) => CastModel.fromMap(x)) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory MovieDetailModel.fromJson(String source) => MovieDetailModel.fromMap(json.decode(source));
}
