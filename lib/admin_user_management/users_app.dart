import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_logic.dart';
import 'user_screen.dart';
import 'users_splashscreen.dart';

class ProductApp extends StatefulWidget {
  const ProductApp({super.key});

  @override
  State<ProductApp> createState() => _ProductAppState();
}

class _ProductAppState extends State<ProductApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildLoadingScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return FutureBuilder(
      future: context.read<RandomUserLogic>().read(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return RandomUserScreen();
        } else {
          return ProductSplashscreen();
        }
      },
    );
  }
}
