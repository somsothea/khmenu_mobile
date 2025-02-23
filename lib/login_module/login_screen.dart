import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_home_screen.dart';
import 'login_logic.dart';
import 'login_models.dart';
import 'user_register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // const LoginScreen({super.key}); //<--remove
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget _buildBody() {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImageContainer(),
                SizedBox(height: 10),
                _buildUsernameTextFieldBorder(),
                SizedBox(height: 10),
                _buildPasswordTextFieldBorder(),
                SizedBox(height: 10),
                _buidElevatedButton(),
                SizedBox(height: 10),
                _buildRegisterButton(), // Add Register Button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      width: 200, // Or whatever width you want for the image
      height: 200, // Or whatever height you want for the image
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/loginscreen.png'),
          fit: BoxFit.cover, // Or BoxFit.contain, BoxFit.fill, etc.
        ),
        borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
      ),
    );
  }

  Widget _buidElevatedButton() {
    return Container(
      width: double.maxFinite,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            MyResponseModel responseModel =
                await context.read<LoginLogic>().login(
                      _usernameCtrl.text.trim(),
                      _passCtrl.text.trim(),
                    );

            debugPrint("ResponseModel: ${responseModel.toString()}");

            if (responseModel.token != null) {
              // success
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => LoginHomeScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Login Failed"),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Username and Password formats are not correct"),
                action: SnackBarAction(
                    label: "DONE",
                    onPressed: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    }),
              ),
            );
          }
        },
        child: Text("Login"),
      ),
    );
  }

  final _usernameCtrl = TextEditingController();

  Widget _buildUsernameTextFieldBorder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink),
      ),
      child: TextFormField(
        controller: _usernameCtrl,
        validator: (String? text) {
          if (text!.isEmpty) {
            return "Username is required";
          }
          return null; //no problem
        },
        style: TextStyle(color: Colors.pink),
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          iconColor: Colors.pink,
          hintText: "Enter Email Address",
          hintStyle: TextStyle(color: Colors.pink.shade300),
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.text,
        autocorrect: false,
      ),
    );
  }

  final _passCtrl = TextEditingController();

  bool _hidePassword = true;

  Widget _buildPasswordTextFieldBorder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink),
      ),
      child: TextFormField(
        controller: _passCtrl,
        validator: (String? text) {
          if (text!.isEmpty) {
            return "Password is required";
          } else if (text.length < 6) {
            return "Password needs at least 6 characters";
          }
          return null; //no problem
        },
        style: TextStyle(color: Colors.pink),
        decoration: InputDecoration(
          icon: Icon(Icons.key),
          iconColor: Colors.pink,
          hintText: "Enter Password",
          hintStyle: TextStyle(color: Colors.pink.shade300),
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
              debugPrint("_hidePassword: $_hidePassword");
            },
            icon: Icon(
              _hidePassword ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
        textInputAction: TextInputAction.send,
        autocorrect: false,
        obscureText: _hidePassword, //true => password
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => RegisterScreen(), // Navigate to Register
          ),
        );
      },
      child: Text(
        "Don't have an account? Register",
        style: TextStyle(color: Colors.pink),
      ),
    );
  }
}
