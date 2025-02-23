import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_app.dart';
import 'login_logic.dart';

Widget loginProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginLogic()),
    ],
    child: LoginApp(),
  );
}
