import 'package:app_filmes/services/movies/movies_service.dart';
import 'package:get/get.dart';
import './movie_detail_controller.dart';

class MovieDetailBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(
      MovieDetailController(moviesService: Get.find<MoviesService>()),
    );
  }
}
