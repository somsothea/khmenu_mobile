import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khmenu_mobile/env.dart';

import 'fakestore_loading_screen.dart';
import 'fakestore_login_logic.dart';


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
        title: Text("My Store"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<FakestoreLoginLogic>().clear();
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => FakeStoreLoadingScreen(),
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
