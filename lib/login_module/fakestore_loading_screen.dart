import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fakestore_home_screen.dart';
import 'fakestore_login_logic.dart';
import 'fakestore_login_models.dart';
import 'fakestore_login_screen.dart';
import 'fakestore_splashscreen.dart';

import 'package:khmenu_mobile/mystore_module/movie_provider.dart';

class FakeStoreLoadingScreen extends StatefulWidget {
  const FakeStoreLoadingScreen({super.key});

  @override
  State<FakeStoreLoadingScreen> createState() => _FakeStoreLoadingScreenState();
}

class _FakeStoreLoadingScreenState extends State<FakeStoreLoadingScreen> {
  Future _readData() async {
    await Future.delayed(Duration(seconds: 1), () {});
    await context.read<FakestoreLoginLogic>().read();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _readData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          MyResponseModel responseModel =
              context.watch<FakestoreLoginLogic>().responseModel;
          if (responseModel.token == null) {
            return FakeStoreLoginScreen();
          } else {
            debugPrint("responseModel.token: ${responseModel.token}");
            return movieProvider();
          }
        } else {
          return FakeStoreSplashscreen();
        }
      },
    );
  }
}
