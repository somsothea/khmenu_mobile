import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khmenu_mobile/login_module/mystore_screen_detail.dart';
import 'package:khmenu_mobile/mystore_module/add_store_screen.dart';
import 'package:khmenu_mobile/mystore_module/mystore_model.dart';
import 'package:provider/provider.dart';
import 'package:khmenu_mobile/env.dart';

import 'login_loading_screen.dart';
import 'login_logic.dart';
import 'store_screen_qr.dart'; // Import the new screen

class FakestoreHomeScreen extends StatefulWidget {
  const FakestoreHomeScreen({super.key});

  @override
  State<FakestoreHomeScreen> createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
  Map<String, dynamic>? _userData;
  bool _loading = true;
  String? _error;
  List<Doc> _stores = []; // List to hold store data

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Fetch user profile and, on success, fetch user stores.
  Future<void> _fetchUserProfile() async {
    try {
      String? token = await Env.apiStorage.read(key: Env.apiKey);
      if (token == null) {
        if (!mounted) return;
        setState(() {
          _error = "Authentication required";
          _loading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse("${Env.apiBaseUrl}/v1/auth/me"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() {
          _userData = jsonDecode(response.body);
          _loading = false;
        });
      } else {
        setState(() {
          _error = "Failed to load profile: ${response.body}";
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = "Network error: ${e.toString()}";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<FakestoreLoginLogic>().clear();
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => FakeStoreLoadingScreen(),
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  

  Widget _buildBody() {
    if (_loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 50, color: Colors.red),
            Text("Error loading profile"),
            ElevatedButton(
              onPressed: _fetchUserProfile,
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }
    return _buildProfileContent(); // Show user profile content in the body
  }

  Widget _buildProfileContent() {
  return InkWell(
    onTap: () => _showProfileDialog(), // Open profile edit dialog on tap
    child: SingleChildScrollView(
      child: Column(
        children: [
          // User Profile Section
          Card(
            margin: EdgeInsets.all(20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.pink.shade100,
                        child: Text(
                          _userData!["firstname"][0] +
                              _userData!["lastname"][0],
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "${_userData!["firstname"]} ${_userData!["lastname"]}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(),
                  _buildProfileRow("Username:", _userData!["username"]),
                  _buildProfileRow("Email:", _userData!["email"]),
                  _buildProfileRow("Account Type:", _userData!["type"]),
                  _buildProfileRow("Permission:", _userData!["permission"]),
                  _buildProfileRow("Created Date:", _userData!["createdDate"]),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  void _showProfileDialog() {
    TextEditingController usernameController =
        TextEditingController(text: _userData!["username"]);
    TextEditingController firstNameController =
        TextEditingController(text: _userData!["firstname"]);
    TextEditingController lastNameController =
        TextEditingController(text: _userData!["lastname"]);
    TextEditingController emailController =
        TextEditingController(text: _userData!["email"]);

    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileRow("ID:", _userData!["_id"]),
                  _buildEditableField(usernameController, "Username"),
                  _buildEditableField(firstNameController, "First Name"),
                  _buildEditableField(lastNameController, "Last Name"),
                  _buildEditableField(emailController, "Email"),
                  _buildProfileRow("Account Type:", _userData!["type"]),
                  _buildProfileRow("Permission:", _userData!["permission"]),
                  _buildProfileRow("Created Date:", _userData!["createdDate"]),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateUserProfile(
                    usernameController.text,
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditableField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "$label is required" : null,
      ),
    );
  }

  Future<void> _updateUserProfile(
      String username, String firstName, String lastName, String email) async {
    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication required")),
      );
      return;
    }

    Map<String, dynamic> updatedData = {
      "username": username,
      "firstname": firstName,
      "lastname": lastName,
      "email": email,
    };

    try {
      final response = await http.put(
        Uri.parse("${Env.apiBaseUrl}/v1/users/${_userData!["_id"]}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
        setState(() {
          _userData!["username"] = username;
          _userData!["firstname"] = firstName;
          _userData!["lastname"] = lastName;
          _userData!["email"] = email;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update profile: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: ${e.toString()}")),
      );
    }
  }
}