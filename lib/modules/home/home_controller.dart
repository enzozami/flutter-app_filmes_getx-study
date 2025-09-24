import 'package:app_filmes/services/login/login_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static const navigatorKey = 1;
  static const indexPageExit = 2;
  final LoginService _loginService;

  HomeController({required LoginService loginServide}) : _loginService = loginServide;

  final _pages = ['/movies', '/favorites'];
  final _pageIndex = 0.obs;

  int get pageIndex => _pageIndex.value;

  void goToPage(int page) {
    _pageIndex(page);
    if (page == indexPageExit) {
      _loginService.logout();
    } else {
      Get.toNamed(_pages[page], id: navigatorKey);
    }
  }
}
