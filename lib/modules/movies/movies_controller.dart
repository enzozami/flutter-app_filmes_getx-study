import 'dart:developer';

import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:app_filmes/services/genres/genres_service.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';

class MoviesController extends GetxController with MessagesMixin {
  final GenresService _genresService;
  final MoviesService _moviesService;
  final _message = Rxn<MessageModel>();
  final genres = <GenreModel>[].obs;

  final popularMovies = <MovieModel>[].obs;
  final topRatedMovies = <MovieModel>[].obs;

  final _popularMoviesOriginal = <MovieModel>[];
  final _topRatedMoviesOriginal = <MovieModel>[];

  final genreSelected = Rxn<GenreModel>();

  MoviesController({required GenresService genresService, required MoviesService moviesService})
      : _genresService = genresService,
        _moviesService = moviesService;

  @override
  void onInit() {
    super.onInit();
    messageListener(_message);
  }

  @override
  void onReady() async {
    super.onReady();
    try {
      final genresData = await _genresService.getGenres();
      genres.assignAll(genresData);

      final popularMoviesData = await _moviesService.getPopularMovies();
      final topRatedMoviesData = await _moviesService.getTopRated();

      popularMovies.assignAll(popularMoviesData);
      _popularMoviesOriginal.addAll(popularMoviesData);

      topRatedMovies.assignAll(topRatedMoviesData);
      _topRatedMoviesOriginal.addAll(topRatedMoviesData);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      _message(MessageModel.error(title: 'Erro', message: 'Erro ao carregar dados da página'));
    }
  }

  void filterByName(String title) {
    if (title.isNotEmpty) {
      var newPopularMovies = _popularMoviesOriginal.where(
        (movie) {
          return movie.title.toLowerCase().contains(title.toLowerCase());
        },
      );
      var newTopRatedMovies = _topRatedMoviesOriginal.where(
        (movie) {
          return movie.title.toLowerCase().contains(title.toLowerCase());
        },
      );

      popularMovies.assignAll(newPopularMovies);
      topRatedMovies.assignAll(newTopRatedMovies);
    } else {
      popularMovies.assignAll(_popularMoviesOriginal);
      topRatedMovies.assignAll(_topRatedMoviesOriginal);
    }
  }

  void filterMoviesByGenre(GenreModel? genreModel) {
    var filter = genreModel;
    if (filter?.id == genreSelected.value?.id) {
      genreSelected.value = null;
    } else {
      genreSelected.value = filter;
    }

    if (genreSelected.value == null) {
      popularMovies.assignAll(_popularMoviesOriginal);
      topRatedMovies.assignAll(_topRatedMoviesOriginal);
      return;
    }

    var genreId = genreSelected.value!.id;

    log('Filtrando por genreId: $genreId');
    for (var movie in _popularMoviesOriginal) {
      log('Movie: ${movie.title}, genres: ${movie.genres}');
    }

    var newPopularMovies =
        _popularMoviesOriginal.where((movie) => movie.genres.contains(genreId)).toList();
    var newTopRatedMovies =
        _topRatedMoviesOriginal.where((movie) => movie.genres.contains(genreId)).toList();

    popularMovies.assignAll(newPopularMovies);
    topRatedMovies.assignAll(newTopRatedMovies);
  }
}
