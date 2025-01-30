import 'package:flutter/material.dart';
import 'fakestore_loading_screen.dart';


class FakeStoreApp extends StatefulWidget {
  const FakeStoreApp({super.key});

  @override
  State<FakeStoreApp> createState() => _FakeStoreAppState();
}

class _FakeStoreAppState extends State<FakeStoreApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FakeStoreLoadingScreen(),
    );
  }  
}
