import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'store_logic.dart';
import 'store_screen.dart';
import 'store_splashscreen.dart';

class StoreApp extends StatefulWidget {
  const StoreApp({super.key});

  @override
  State<StoreApp> createState() => _StoreAppState();
}

class _StoreAppState extends State<StoreApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildLoadingScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return FutureBuilder(
      future: context.read<StoreLogic>().read(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StoreScreen();
        } else {
          return StoreSplashscreen();
        }
      },
    );
  }
}
