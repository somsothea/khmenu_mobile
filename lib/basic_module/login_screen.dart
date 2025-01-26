import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'register.dart';
import 'package:khmenu_mobile/item_module/item_provider.dart';

class LoginScreen extends StatelessWidget {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _storage = FlutterSecureStorage(); // For storing the token securely

  Future<void> _login(BuildContext context) async {
    final url = Uri.parse('http://172.23.129.61:4000/v1/auth/login');
    final body = json.encode({
      "email": _emailCtrl.text.trim(),
      "password": _passCtrl.text.trim(),
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['accessToken'];

        if (token != null) {
          // Store the token securely
          await _storage.write(key: 'authToken', value: token);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Successful")),
          );

          // Navigate to the next screen
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) =>
                  itemProvider(), // Replace with your next screen
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Token not found in response")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Failed: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmailTextFieldBorder(),
              SizedBox(height: 10),
              _buildPasswordTextFieldBorder(),
              SizedBox(height: 10),
              _buildElevatedButton(context),
              SizedBox(height: 10),
              _buildRegisterButton(context), // Register button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildElevatedButton(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        onPressed: () => _login(context), // Call login function
        child: Text("Login"),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => RegisterScreen(),
          ),
        );
      },
      child: Text(
        "Register",
        style: TextStyle(color: Colors.indigo),
      ),
    );
  }

  Widget _buildEmailTextFieldBorder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink),
      ),
      child: TextField(
        controller: _emailCtrl,
        style: TextStyle(color: Colors.pink),
        decoration: InputDecoration(
          icon: Icon(Icons.email),
          iconColor: Colors.pink,
          hintText: "Enter Email",
          hintStyle: TextStyle(color: Colors.pink.shade300),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
      ),
    );
  }

  Widget _buildPasswordTextFieldBorder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink),
      ),
      child: TextField(
        controller: _passCtrl,
        style: TextStyle(color: Colors.pink),
        decoration: InputDecoration(
          icon: Icon(Icons.key),
          iconColor: Colors.pink,
          hintText: "Enter Password",
          hintStyle: TextStyle(color: Colors.pink.shade300),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.done,
        autocorrect: false,
        obscureText: true,
      ),
    );
  }
}
