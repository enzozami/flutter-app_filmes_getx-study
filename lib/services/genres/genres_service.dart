import 'package:app_filmes/models/genre_model.dart';

abstract interface class GenresService {
  Future<List<GenreModel>> getGenres();
}
