import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';
import 'language_logic.dart';
import 'simple_state_screen.dart';
import 'theme_logic.dart';

Widget providerBasicApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CounterLogic()),
      ChangeNotifierProvider(create: (context) => ThemeLogic()),
      ChangeNotifierProvider(create: (context) => LanguageLogic()),
    ],
    child: BasicApp(),
  );
}

class BasicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeMode mode = context.watch<ThemeLogic>().mode;

    Color lightColor = Colors.pink;
    Color darkColor = Colors.blueGrey.shade900;

    double size = context.watch<CounterLogic>().counter.toDouble();

    final myTextTheme = TextTheme(
      bodyMedium: TextStyle(fontSize: 18 + size),
      displayMedium: TextStyle(
        fontSize: 20 + size,
      ),
      displayLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22 + size,
      ),
      displaySmall: TextStyle(
        fontSize: 14 + size,
        fontStyle: FontStyle.italic,
      ),
    );

    return MaterialApp(
      home: SimpleStateScreen(),
      themeMode: mode,
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: myTextTheme,
        cardTheme: CardTheme(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: lightColor),
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: lightColor,
          textColor: lightColor,
        ),
        listTileTheme: ListTileThemeData(
          iconColor: lightColor,
          textColor: lightColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          iconColor: lightColor,
          border: InputBorder.none,
          suffixIconColor: lightColor,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: lightColor,
          foregroundColor: Colors.white,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: lightColor,
          foregroundColor: Colors.white,
        )),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: lightColor,
          side: BorderSide(color: lightColor),
        )),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: myTextTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColor,
          foregroundColor: Colors.white,
        ),
        drawerTheme: DrawerThemeData(backgroundColor: darkColor),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade800,
          foregroundColor: Colors.white,
        )),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white),
        )),
      ),
    );
  }
}
