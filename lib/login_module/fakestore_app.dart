import 'package:flutter/material.dart';

import 'fakestore_login_screen.dart';
import 'fakestore_splashscreen.dart';


class FakeStoreApp extends StatefulWidget {
  const FakeStoreApp({super.key});

  @override
  State<FakeStoreApp> createState() => _FakeStoreAppState();
}

class _FakeStoreAppState extends State<FakeStoreApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _buildLoadingScreen(),
    );
  }

  Future _readData() async{
    await Future.delayed(Duration(seconds: 2), (){});
  }

  Widget _buildLoadingScreen(){
    return FutureBuilder(
      future: _readData(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          return FakeStoreLoginScreen();
        }else{
          return FakeStoreSplashscreen();
        }
      },
    );
  }
}