import 'package:app_filmes/application/auth/auth_service.dart';
import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';
import './favorites_controller.dart';

class FavoritesBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      FavoritesController(
        authService: Get.find<AuthService>(),
        moviesService: Get.find<MoviesService>(),
      ),
    );
  }
}
