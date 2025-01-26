import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'fakestore_app.dart';
import 'fakestore_login_logic.dart';

Widget fakeStoreProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => FakestoreLoginLogic()),
    ],
    child: FakeStoreApp(),
  );
}
