import 'package:app_filmes/application/auth/auth_service.dart';
import 'package:app_filmes/repositories/genres/genres_repository.dart';
import 'package:app_filmes/repositories/genres/genres_repository_impl.dart';
import 'package:app_filmes/services/genres/genres_service.dart';
import 'package:app_filmes/services/genres/genres_service_impl.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';
import './movies_controller.dart';

class MoviesBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenresRepository>(() => GenresRepositoryImpl(restClient: Get.find()));
    Get.lazyPut<GenresService>(
      () => GenresServiceImpl(genresRepository: Get.find()),
    );

    Get.lazyPut<MoviesController>(() => MoviesController(
        genresService: Get.find<GenresService>(),
        moviesService: Get.find<MoviesService>(),
        authService: Get.find<AuthService>()));
  }
}
