import 'package:flutter/material.dart';
import 'login_loading_screen.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginLoadingScreen(),
    );
  }
}
