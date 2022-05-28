import 'package:flutter/material.dart';

class MovieModel {
  final String title;
  final String year;
  final String poster;
  final String imdbID;

  MovieModel(this.imdbID, this.title, this.poster, this.year);

  MovieModel.fromJson(Map<String, dynamic> json)
      : title = json['Title'],
        year = json['Year'],
        poster = json['Poster'],
        imdbID = json['imdbID'];

  Map<String, dynamic> toJson() =>
      {'Title': title, 'Year': year, 'Poster': poster, 'imdbID': imdbID};
}
