import 'dart:developer';

import 'package:app_filmes/application/ui/loader/loader_mixin.dart';
import 'package:app_filmes/application/ui/messages/messages_mixin.dart';
import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:get/get.dart';

import 'package:app_filmes/services/movies/movies_service.dart';

class MovieDetailController extends GetxController with LoaderMixin, MessagesMixin {
  final MoviesService _moviesService;

  var movie = Rxn<MovieDetailModel>();
  var loading = false.obs;
  var message = Rxn<MessageModel>();

  MovieDetailController({
    required MoviesService moviesService,
  }) : _moviesService = moviesService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(loading);
    messageListener(message);
  }

  @override
  Future<void> onReady() async {
    try {
      super.onReady();
      final movieId = Get.arguments;
      loading(true);
      final movieDetailData = await _moviesService.getDetail(movieId);
      movie.value = movieDetailData;
      loading(false);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      loading(false);
      MessageModel.error(title: 'Erro', message: 'Erro ao buscar Filmes');
    }
  }
}
