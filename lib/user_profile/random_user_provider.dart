import 'package:flutter/material.dart';
import 'package:khmenu_mobile/random_user/product_app.dart';
import 'package:khmenu_mobile/random_user/random_user_logic.dart';
import 'package:provider/provider.dart';

Widget randomUserProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => RandomUserLogic()),
    ],
    child: ProductApp(),
  );
}
