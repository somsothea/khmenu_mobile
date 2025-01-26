import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie_logic.dart';
import 'movie_screen.dart';
import 'movie_splashscreen.dart';


class MovieApp extends StatefulWidget {
  const MovieApp({super.key});

  @override
  State<MovieApp> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildLoadingScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.light(),
      ),
    );
  }

  Future _fetchData() async{
    await context.read<MovieLogic>().read();
  }

  Widget _buildLoadingScreen(){
    return FutureBuilder(
      future: _fetchData(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return MovieScreen();
        }else{
          return MovieSplashscreen();
        }
      },
    );
  }
}