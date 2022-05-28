import 'package:bgrlk_movies_app/movie-box.dart';
import 'package:bgrlk_movies_app/models/movie-models.dart';
import 'package:bgrlk_movies_app/services/movies-service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../constants/theme-data.dart';
import '../movie-title.dart';
import '../themes/theme-provider.dart';

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  run(VoidCallback action) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(
      Duration(milliseconds: Duration.millisecondsPerSecond),
      action,
    );
  }
}

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  List<MovieModel> movies = [];
  final movieService = MoviesService();
  List<MovieModel> favs = [];
  final storageService = MoviesService();
  //Color mainColor = const Color(0xff3C3261);
  final _debouncer = Debouncer();

  Widget appBarTitle = Text(
    "Search a Movie",
  );
  Icon icon = Icon(
    Icons.search,
  );
  final globalKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  String _searchText = "";
  final _defaultTerm = "man";

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  MovieListState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setStateIfMounted(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setStateIfMounted(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
    restoreSearch();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future<void> onBoxClick(MovieModel model) async {
    await storageService.toggleFav(model);
    var _favs = await storageService.getFavs();
    setStateIfMounted(() {
      favs = _favs;
    });
  }

  Future<void> restoreSearch() async {
    final _term = await movieService.getLastSearchTerm();

    setStateIfMounted(() {
      _isSearching = _term.isNotEmpty;
      _searchText = _term;
    });
    _controller.text = _term;
    getData(term: _term.isNotEmpty ? _term : _defaultTerm);
  }

  void getData({String? term}) async {
    var data = await movieService.getRemoteMovies(term);
    var _favs = await storageService.getFavs();

    setStateIfMounted(() {
      movies = data;
      favs = _favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MovieTitle(),
            Expanded(
              child: ListView.builder(
                  itemCount: movies == null ? 0 : movies.length,
                  itemBuilder: (context, i) {
                    return FlatButton(
                      child: MovieBox(
                          movies,
                          i,
                          favs.any(
                              (element) => element.imdbID == movies[i].imdbID)),
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {
                        onBoxClick(movies[i]);
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return AppBar(
        centerTitle: true,
        textTheme: Styles.themeData(themeChange.darkTheme, context).textTheme,
        title: appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (icon.icon == Icons.search) {
                  icon = Icon(
                    Icons.close,
                  );
                  appBarTitle = TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: "Search...",
                    ),
                    onChanged: searchOperation,
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      icon = Icon(
        Icons.search,
      );
      appBarTitle = Text(
        _searchText.isNotEmpty ? _searchText : "Search a Movie",
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    if (_isSearching != null) {
      _debouncer.run(() {
        getData(term: searchText);
      });
    }
  }
}
