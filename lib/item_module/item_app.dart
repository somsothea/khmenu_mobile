import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_logic.dart';
import 'item_screen.dart';
import 'item_splashscreen.dart';

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
      future: context.read<ProductLogic>().read(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ItemScreen();
        } else {
          return ProductSplashscreen();
        }
      },
    );
  }
}
