import 'package:app_filmes/application/modules/module.dart';
import 'package:app_filmes/modules/favorites/favorites_bindings.dart';
import 'package:app_filmes/modules/favorites/favorites_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class FavoritesModule implements Module {
  @override
  List<GetPage> routers = [
    GetPage(
      name: '/favorites',
      binding: FavoritesBindings(),
      page: () => FavoritesPage(),
    ),
  ];
}
