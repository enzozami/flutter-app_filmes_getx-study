import 'dart:developer';

import 'package:app_filmes/application/auth/auth_service.dart';
import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/models/genre_model.dart';
import 'package:app_filmes/models/movie_model.dart';
import 'package:app_filmes/services/genres/genres_service.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';

class MoviesController extends GetxController with MessagesMixin {
  final AuthService _authService;

  final GenresService _genresService;
  final MoviesService _moviesService;
  final _message = Rxn<MessageModel>();
  final genres = <GenreModel>[].obs;

  final popularMovies = <MovieModel>[].obs;
  final topRatedMovies = <MovieModel>[].obs;

  var _popularMoviesOriginal = <MovieModel>[];
  var _topRatedMoviesOriginal = <MovieModel>[];

  final genreSelected = Rxn<GenreModel>();

  MoviesController(
      {required AuthService authService,
      required GenresService genresService,
      required MoviesService moviesService})
      : _genresService = genresService,
        _moviesService = moviesService,
        _authService = authService;

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

      getMovies();
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      _message(MessageModel.error(title: 'Erro', message: 'Erro ao carregar dados da página'));
    }
  }

  void getMovies() async {
    try {
      var popularMoviesData = await _moviesService.getPopularMovies();
      var topRatedMoviesData = await _moviesService.getTopRated();

      final user = _authService.user;
      if (user != null) {
        // Escutando a stream de favoritos
        _moviesService.getFavoritiesMovies(user.uid).listen((favoritesList) {
          // Convertendo para Map para facilitar a checagem
          final favoritesMap = {for (var fav in favoritesList) fav.id: fav};

          // Atualizando popularMovies
          final updatedPopular = popularMoviesData.map((m) {
            return m.copyWith(favorite: favoritesMap.containsKey(m.id));
          }).toList();
          popularMovies.assignAll(updatedPopular);
          _popularMoviesOriginal = updatedPopular;

          // Atualizando topRatedMovies
          final updatedTopRated = topRatedMoviesData.map((m) {
            return m.copyWith(favorite: favoritesMap.containsKey(m.id));
          }).toList();
          topRatedMovies.assignAll(updatedTopRated);
          _topRatedMoviesOriginal = updatedTopRated;
        });
      } else {
        // Se não tiver usuário, só carrega os filmes sem favoritos
        popularMovies.assignAll(popularMoviesData);
        _popularMoviesOriginal = popularMoviesData;

        topRatedMovies.assignAll(topRatedMoviesData);
        _topRatedMoviesOriginal = topRatedMoviesData;
      }
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

  Future<void> favoriteMovie(MovieModel movie) async {
    final user = _authService.user;
    if (user != null) {
      var newMovie = movie.copyWith(favorite: !movie.favorite);
      await _moviesService.addOrRemoveFavorite(user.uid, newMovie);
      getMovies();
    }
  }

  Future<Stream<Map<int, MovieModel>>> getFavorites() async {
    final user = _authService.user;
    if (user != null) {
      return _moviesService.getFavoritiesMovies(user.uid).map((favorites) => <int, MovieModel>{
            for (var fav in favorites) fav.id: fav,
          });
    }
    return Stream.value({});
  }
}
