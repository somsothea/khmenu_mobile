import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:khmenu_mobile/env.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _emailController;
  bool _loading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userData["username"]);
    _firstnameController = TextEditingController(text: widget.userData["firstname"]);
    _lastnameController = TextEditingController(text: widget.userData["lastname"]);
    _emailController = TextEditingController(text: widget.userData["email"]);
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      String? token = await Env.apiStorage.read(key: Env.apiKey);
      final response = await http.put(
        Uri.parse("${Env.apiBaseUrl}/v1/users/${widget.userData['id']}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": _usernameController.text,
          "firstname": _firstnameController.text,
          "lastname": _lastnameController.text,
          "email": _emailController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Return success to previous screen
      } else {
        setState(() {
          _errorMessage = "Update failed: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network error: ${e.toString()}";
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _firstnameController,
                decoration: InputDecoration(labelText: "First Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _lastnameController,
                decoration: InputDecoration(labelText: "Last Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.contains("@") ? null : "Invalid email",
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ),
              SizedBox(height: 20),
              _loading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _updateProfile,
                      child: Text("Save Changes"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
