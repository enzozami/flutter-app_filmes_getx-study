import 'package:app_filmes/application/modules/module.dart';
import 'package:app_filmes/modules/movies/movies_bindings.dart';
import 'package:app_filmes/modules/movies/movies_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class MoviesModule implements Module {
  @override
  List<GetPage> routers = [
    GetPage(
      name: '/movies',
      binding: MoviesBindings(),
      page: () => MoviesPage(),
    ),
  ];
}
