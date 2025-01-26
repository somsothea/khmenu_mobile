import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'fakestore_home_screen.dart';
import 'fakestore_login_models.dart';
import 'fakestore_service.dart';

class FakeStoreLoginScreen extends StatefulWidget {
  @override
  State<FakeStoreLoginScreen> createState() => _FakeStoreLoginScreenState();
}

class _FakeStoreLoginScreenState extends State<FakeStoreLoginScreen> {
  // const LoginScreen({super.key}); //<--remove
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  final _formKey = GlobalKey<FormState>();

  Widget _buildBody(BuildContext context) {
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
                _buildUsernameTextFieldBorder(),
                SizedBox(height: 10),
                _buildPasswordTextFieldBorder(),
                SizedBox(height: 10),
                _buidElevatedButton(),
              ],
            ),
          ),
        ),
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
            LoginRequestModel requestModel = LoginRequestModel(
              username: _usernameCtrl.text.trim(),
              password: _passCtrl.text.trim(),
            );

            await FakestoreService.login(
              request: requestModel,
              onRes: (value) async {
                LoginResponseModel data = await value;
                debugPrint("data.token: ${data.token}");
                debugPrint("data.errorText: ${data.errorText}");
                if (data.token != null) {
                  //success
                  Navigator.of(context).pushReplacement(
                    CupertinoPageRoute(
                      builder: (context) => FakestoreHomeScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${data.errorText}"),
                    ),
                  );
                }
              },
              onError: (err) {},
            );
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
          hintText: "Enter Username",
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
}
