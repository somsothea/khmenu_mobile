import 'package:flutter/material.dart';
import 'package:khmenu_mobile/item_module/product_app.dart';
import 'package:khmenu_mobile/item_module/product_logic.dart';
import 'package:provider/provider.dart';

Widget itemProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ProductLogic()),
    ],
    child: ProductApp(),
  );
}
