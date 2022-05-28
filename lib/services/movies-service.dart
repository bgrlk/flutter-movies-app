import 'dart:convert';
import 'dart:ffi';
import 'package:bgrlk_movies_app/models/movie-models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MoviesService {
  final String key = "favs";

  Future<List<MovieModel>> getRemoteMovies([String? term]) async {
    final httpsUri = Uri.http(
        'www.omdbapi.com', '/', {'apikey': '838ad54b', 's': term ?? 'man'});
    http.Response response = await http.get(httpsUri);
    Map l = json.decode(response.body);

    List<MovieModel> current = [];
    if (l != null && l["Search"] != null) {
      current = List<MovieModel>.from(
          l["Search"].map((model) => MovieModel.fromJson(model)));
    }

    setLastSearchTerm(term ?? "");

    return current;
  }

  Future<void> addMoviesFavourites(MovieModel model) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var jsonStr = sharedPreferences.getString(key);
    if (jsonStr == null) {
      List<MovieModel> favs = [model];
      var json = jsonEncode(favs.map((e) => e.toJson()).toList());
      sharedPreferences.setString(key, json);
    } else {
      Iterable l = json.decode(jsonStr);
      List<MovieModel> current =
          List<MovieModel>.from(l.map((model) => MovieModel.fromJson(model)));
      if (!current.any((element) => element.imdbID == model.imdbID)) {
        current.add(model);
        var currentJsonStr =
            jsonEncode(current.map((e) => e.toJson()).toList());
        sharedPreferences.setString(key, currentJsonStr);
      }
    }
  }

  Future<void> removeMoviesFavourites(String id) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var jsonStr = sharedPreferences.getString(key);
    if (jsonStr != null) {
      Iterable l = json.decode(jsonStr);
      List<MovieModel> current =
          List<MovieModel>.from(l.map((model) => MovieModel.fromJson(model)));
      current.removeWhere((MovieModel p) => p.imdbID == id);
      var currentJsonStr = jsonEncode(current.map((e) => e.toJson()).toList());
      sharedPreferences.setString(key, currentJsonStr);
    }
  }

  Future<void> toggleFav(MovieModel model) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var jsonStr = sharedPreferences.getString(key);

    if (jsonStr != null) {
      Iterable l = json.decode(jsonStr);
      List<MovieModel> current =
          List<MovieModel>.from(l.map((model) => MovieModel.fromJson(model)));
      if (current.isNotEmpty && current.any((p) => p.imdbID == model.imdbID)) {
        await removeMoviesFavourites(model.imdbID);
      } else {
        await addMoviesFavourites(model);
      }
    } else {
      await addMoviesFavourites(model);
    }
  }

  Future<List<MovieModel>> getFavs() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var jsonStr = sharedPreferences.getString(key);
    if (jsonStr != null) {
      Iterable l = json.decode(jsonStr);
      List<MovieModel> current =
          List<MovieModel>.from(l.map((model) => MovieModel.fromJson(model)));
      return current;
    } else {
      return [];
    }
  }

  Future<void> setLastSearchTerm(String term) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("term", term);
  }

  Future<String> getLastSearchTerm() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("term") ?? "";
  }
}
