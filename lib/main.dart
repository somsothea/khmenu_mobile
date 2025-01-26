import 'package:flutter/material.dart';

import 'package:khmenu_mobile/basic_module/login_screen.dart';
import 'package:khmenu_mobile/movie_module/movie_provider.dart';
import 'package:khmenu_mobile/item_module/item_provider.dart';
import 'package:khmenu_mobile/random_user/random_user_provider.dart';
import 'package:khmenu_mobile/basic_module/basic_app.dart';
import 'package:khmenu_mobile/login_module/fakestore_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Module Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of screens for the modules
  final List<Widget> _screens = [
    LoginScreen(),
    fakeStoreProvider(),
    itemProvider(),
    movieProvider(),
    randomUserProvider(),
    providerBasicApp(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the current module's widget
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.black, // Set background to black
        selectedItemColor: Colors.blue, // White for selected item
        unselectedItemColor: Colors.grey, // Grey for unselected items
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Items',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
