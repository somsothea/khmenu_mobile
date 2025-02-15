import 'package:flutter/material.dart';
import 'package:khmenu_mobile/users_module/users_app.dart';
import 'package:khmenu_mobile/users_module/random_user_logic.dart';
import 'package:provider/provider.dart';

Widget randomUserProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => RandomUserLogic()),
    ],
    child: ProductApp(),
  );
}
