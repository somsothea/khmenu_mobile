import 'package:flutter/material.dart';

class FakeStoreSplashscreen extends StatelessWidget {
  const FakeStoreSplashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(Icons.shopping_bag, size: 100),
      ),
    );
  }
}
