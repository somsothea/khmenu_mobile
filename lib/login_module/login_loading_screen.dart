import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_home_screen.dart';
import 'login_logic.dart';
import 'login_models.dart';
import 'login_screen.dart';
import 'login_splashscreen.dart';

class LoginLoadingScreen extends StatefulWidget {
  const LoginLoadingScreen({super.key});

  @override
  State<LoginLoadingScreen> createState() => _LoginLoadingScreenState();
}

class _LoginLoadingScreenState extends State<LoginLoadingScreen> {
  Future _readData() async {
    await Future.delayed(Duration(seconds: 1), () {});
    await context.read<LoginLogic>().read();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _readData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          MyResponseModel responseModel =
              context.watch<LoginLogic>().responseModel;
          if (responseModel.token == null) {
            return LoginScreen();
          } else {
            debugPrint("responseModel.token: ${responseModel.token}");
            return LoginHomeScreen();
          }
        } else {
          return LoginSplashscreen();
        }
      },
    );
  }
}
