import 'package:app_filmes/modules/movies/widgets/movies_filters.dart';
import 'package:app_filmes/modules/movies/widgets/movies_header.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './movies_controller.dart';

class MoviesPage extends GetView<MoviesController> {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: ListView(
          children: [
            MoviesHeader(),
            MoviesFilters(),
          ],
        ),
      ),
    );
  }
}
