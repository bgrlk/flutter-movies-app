import 'constants/theme-data.dart';
import 'themes/theme-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bgrlk_movies_app/screens/movie-list.dart';
import 'screens/favourites-screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  final pages = [
    MovieList(),
    FavouritesScreen(),
  ];

  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        });
      },
      // ignore: prefer_const_literals_to_create_immutables
      items: [
        // ignore: prefer_const_constructors
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        // ignore: prefer_const_constructors
        BottomNavigationBarItem(
          // ignore: prefer_const_constructors
          icon: Icon(Icons.favorite_outline),
          label: "Favourites",
        ),
      ],
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            return themeChangeProvider;
          })
        ],
        child:
            Consumer<DarkThemeProvider>(builder: (context, themeData, child) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return MaterialApp(
            title: 'Flutter Demo',
            theme: Styles.themeData(themeChangeProvider.darkTheme, context),
            debugShowCheckedModeBanner: false,
            // Start the app with the "/" named route. In this case, the app starts
            // on the FirstScreen widget.
            home: DefaultTabController(
              length: 2,
              child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Test Case App'),
                    actions: [
                      IconButton(
                          icon: Icon(themeData.darkTheme
                              ? Icons.light_mode
                              : Icons.dark_mode),
                          onPressed: () {
                            themeChange.darkTheme = !themeData.darkTheme;
                          })
                    ],
                  ),
                  body: pages[_selectedIndex],
                  bottomNavigationBar: buildBottomNavigationBar()),
            ),
          );
        }));
  }
}
