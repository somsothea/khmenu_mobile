import 'package:flutter/material.dart';

class MovieSplashscreen extends StatelessWidget {
  const MovieSplashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(Icons.movie, size: 100),
      ),
    );
  }
}
