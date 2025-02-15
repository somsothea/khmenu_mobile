import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khmenu_mobile/env.dart';

import 'login_loading_screen.dart';
import 'login_logic.dart';

class FakestoreHomeScreen extends StatefulWidget {
  const FakestoreHomeScreen({super.key});

  @override
  State<FakestoreHomeScreen> createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
  //final _storage = FlutterSecureStorage();
  Map<String, dynamic>? _userData;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      String? token = await Env.apiStorage.read(key: Env.apiKey);
      if (token == null) {
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
          _buildProfileButton(),
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

  Widget _buildProfileButton() {
    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return IconButton(
        icon: Icon(Icons.error_outline, color: Colors.red),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_error!)),
        ),
      );
    }

    if (_userData != null) {
      return IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            _userData!["firstname"][0] + _userData!["lastname"][0], // Initials
            style: TextStyle(color: Colors.pink),
          ),
        ),
        onPressed: () => _showProfileDialog(),
      );
    }

    return SizedBox.shrink();
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
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                      _userData!["firstname"][0] + _userData!["lastname"][0],
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${_userData!["firstname"]} ${_userData!["lastname"]}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
    );
  }

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("User Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileRow("id:", _userData!["_id"]),
              _buildProfileRow("Username:", _userData!["username"]),
              _buildProfileRow("Name:",
                  "${_userData!["firstname"]} ${_userData!["lastname"]}"),
              _buildProfileRow("Email:", _userData!["email"]),
              _buildProfileRow("Account Type:", _userData!["type"]),
              _buildProfileRow("Permission:", _userData!["permission"]),
              _buildProfileRow("Created Date:", _userData!["createdDate"]),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
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
}
