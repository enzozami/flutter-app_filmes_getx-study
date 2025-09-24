import 'package:app_filmes/models/movie_model.dart';

abstract interface class MoviesService {
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRated();
}
