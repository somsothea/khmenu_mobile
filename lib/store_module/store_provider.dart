import 'package:flutter/material.dart';
import 'package:khmenu_mobile/store_module/store_app.dart';
import 'package:khmenu_mobile/store_module/store_logic.dart';
import 'package:provider/provider.dart';

Widget storeProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StoreLogic()),
    ],
    child: StoreApp(),
  );
}
