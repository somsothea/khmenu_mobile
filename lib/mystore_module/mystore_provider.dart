import 'package:flutter/material.dart';
import 'package:khmenu_mobile/mystore_module/mystore_app.dart';
import 'package:khmenu_mobile/mystore_module/mystore_logic.dart';
import 'package:provider/provider.dart';

Widget storeProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StoreLogic()),
    ],
    child: StoreApp(),
  );
}
