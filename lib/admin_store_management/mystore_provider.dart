import 'package:flutter/material.dart';
import 'package:khmenu_mobile/admin_store_management/mystore_app.dart';
import 'package:khmenu_mobile/admin_store_management/mystore_logic.dart';
import 'package:provider/provider.dart';

Widget mystoreProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StoreLogic()),
    ],
    child: StoreApp(),
  );
}
