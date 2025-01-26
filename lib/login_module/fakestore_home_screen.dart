import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fakestore_login_screen.dart';

class FakestoreHomeScreen extends StatefulWidget {
  const FakestoreHomeScreen({super.key});

  @override
  State<FakestoreHomeScreen> createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fake Store Home Scren"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (context) => FakeStoreLoginScreen(),
                    ),
                  );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
