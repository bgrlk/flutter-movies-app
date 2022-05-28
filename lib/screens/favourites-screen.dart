import 'package:bgrlk_movies_app/movie-box.dart';
import 'package:bgrlk_movies_app/models/movie-models.dart';
import 'package:bgrlk_movies_app/services/movies-service.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FavouritesScreen extends StatefulWidget {
  @override
  FavouritesScreenState createState() {
    return FavouritesScreenState();
  }
}

class FavouritesScreenState extends State<FavouritesScreen> {
  List<MovieModel> favs = [];
  final movieService = MoviesService();

  Future<void> onBoxClick(MovieModel model) async {
    await movieService.toggleFav(model);
    var _favs = await movieService.getFavs();
    setState(() {
      favs = _favs;
    });
  }

  void getFavs() async {
    var _favs = await movieService.getFavs();

    setState(() {
      favs = _favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    getFavs();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0.3,
        centerTitle: true,
        // ignore: prefer_const_constructors
        title: Text(
          'Favourites',
          // ignore: prefer_const_constructors
          style: TextStyle(fontFamily: 'Arvo', fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (favs != null && favs.length == 0) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Favourites Yet',
                    style: TextStyle(
                      fontFamily: 'Arvo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You can add favourites by clicking on the movie poster',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Arvo',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ] else ...<Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: favs == null ? 0 : favs.length,
                    itemBuilder: (context, i) {
                      return FlatButton(
                        child: MovieBox(favs, i, true),
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          onBoxClick(favs[i]);
                        },
                      );
                    }),
              )
            ]
          ],
        ),
      ),
    );
  }
}
