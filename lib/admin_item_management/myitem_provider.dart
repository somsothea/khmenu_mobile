import 'package:flutter/material.dart';
import 'package:khmenu_mobile/admin_item_management/myitem_app.dart';
import 'package:khmenu_mobile/admin_item_management/myitem_logic.dart';
import 'package:provider/provider.dart';

Widget myitemProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => StoreLogic()),
    ],
    child: StoreApp(),
  );
}
