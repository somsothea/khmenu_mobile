import 'package:flutter/material.dart';
import 'package:khmenu_mobile/admin_user_management/users_app.dart';
import 'package:khmenu_mobile/admin_user_management/user_logic.dart';
import 'package:provider/provider.dart';

Widget randomUserProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => RandomUserLogic()),
    ],
    child: ProductApp(),
  );
}
