import 'package:bgrlk_movies_app/models/movie-models.dart';
import 'package:flutter/material.dart';

class MovieBox extends StatelessWidget {
  final List<MovieModel> movies;
  final i;
  final isFav;

  MovieBox(this.movies, this.i, this.isFav);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                margin: const EdgeInsets.all(16.0),
                // ignore: sized_box_for_whitespace, sort_child_properties_last
                child: Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey,
                  image: DecorationImage(
                      image: NetworkImage(movies[i].poster), fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).primaryColor,
                        blurRadius: 5.0,
                        offset: Offset(2.0, 5.0))
                  ],
                ),
              ),
            ),
            Expanded(
                child: Container(
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                // ignore: sort_child_properties_last
                children: [
                  Text(
                    movies[i].title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Arvo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  Padding(padding: const EdgeInsets.all(2.0)),
                  Text(
                    movies[i].year,
                    maxLines: 3,
                    // ignore: prefer_const_constructors
                    style: TextStyle(fontFamily: 'Arvo'),
                  ),
                  if (isFav)
                    // ignore: prefer_const_constructors
                    Icon(
                      Icons.favorite,
                      color: Colors.pink,
                      size: 24.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )),
          ],
        ),
        Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );
  }
}
