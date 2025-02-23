import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khmenu_mobile/env.dart';

class UserScreenEdit extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserScreenEdit({super.key, required this.userData});

  @override
  State<UserScreenEdit> createState() => _UserScreenEditState();
}

class _UserScreenEditState extends State<UserScreenEdit> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userData["username"]);
    _emailController = TextEditingController(text: widget.userData["email"]);
    _firstnameController = TextEditingController(text: widget.userData["firstname"]);
    _lastnameController = TextEditingController(text: widget.userData["lastname"]);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null) {
      setState(() {
        _error = "Authentication required";
        _loading = false;
      });
      return;
    }

    final updatedUser = {
      "username": _usernameController.text,
      "email": _emailController.text,
      "firstname": _firstnameController.text,
      "lastname": _lastnameController.text,
    };

    final response = await http.put(
      Uri.parse("${Env.apiBaseUrl}/v1/users/${widget.userData["id"]}"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(updatedUser),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, jsonDecode(response.body)); // Return updated data
    } else {
      setState(() {
        _error = "Failed to update profile: ${response.body}";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: "Username")),
            TextField(controller: _firstnameController, decoration: InputDecoration(labelText: "First Name")),
            TextField(controller: _lastnameController, decoration: InputDecoration(labelText: "Last Name")),
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 20),
            if (_error != null)
              Text(_error!, style: TextStyle(color: Colors.red)),
            if (_loading)
              CircularProgressIndicator()
            else
              ElevatedButton(onPressed: _saveChanges, child: Text("Save Changes")),
          ],
        ),
      ),
    );
  }
}
