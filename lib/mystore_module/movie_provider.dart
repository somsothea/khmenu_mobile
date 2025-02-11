import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie_app.dart';
import 'movie_logic.dart';
import 'movie_search_logic.dart';

Widget movieProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StoreLogic()),
      ChangeNotifierProvider(create: (context) => MovieSearchLogic()),
    ],
    child: MovieApp(),
  );
}
