import 'package:app_filmes/models/movie_detail_model.dart';
import 'package:flutter/material.dart';

class MovieDetailHeader extends StatelessWidget {
  final MovieDetailModel? movie;
  const MovieDetailHeader({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    if (movie != null) {
      return SizedBox(
        height: 278,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: movie!.urlImage.length,
          itemBuilder: (context, index) {
            final image = movie!.urlImage[index];
            return Padding(
              padding: EdgeInsets.all(2),
              child: Image.network(image),
            );
          },
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
