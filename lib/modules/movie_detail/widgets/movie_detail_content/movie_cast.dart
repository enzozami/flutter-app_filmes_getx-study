import 'package:app_filmes/application/ui/theme_extensions.dart';
import 'package:flutter/material.dart';

import 'package:app_filmes/models/cast_model.dart';

class MovieCast extends StatelessWidget {
  final CastModel? cast;
  const MovieCast({super.key, this.cast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                cast?.image ?? '',
                width: 85,
                height: 85,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              cast?.name ?? '',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xff222222),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              cast?.character ?? '',
              style: TextStyle(
                fontSize: 12,
                color: context.themeGrey,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
