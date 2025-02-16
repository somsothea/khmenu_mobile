import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:khmenu_mobile/env.dart';

import 'login_loading_screen.dart';
import 'login_logic.dart';
import 'user_screen_edit.dart';

class FakestoreHomeScreen extends StatefulWidget {
  const FakestoreHomeScreen({super.key});

  @override
  State<FakestoreHomeScreen> createState() => _FakestoreHomeScreenState();
}

class _FakestoreHomeScreenState extends State<FakestoreHomeScreen> {
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

  Future<void> _navigateToEditScreen() async {
    final updatedData = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UserScreenEdit(userData: _userData!),
      ),
    );

    // If data is returned, update the profile on the home screen
    if (updatedData != null) {
      setState(() {
        _userData = updatedData;
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
            Text("Error loading data"),
            ElevatedButton(
              onPressed: _fetchUserProfile,
              child: Text("Retry"),
            ),
          ],
        ),
      );
    }

    return _buildProfileContent();
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // User Profile Section
          GestureDetector(
            onTap: _navigateToEditScreen,
            child: Card(
              margin: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.pink.shade100,
                          child: Text(
                            _userData?["firstname"]?[0] ?? "",
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${_userData?["firstname"] ?? ""} ${_userData?["lastname"] ?? ""}",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(),
                    _buildProfileRow(
                        "Username:", _userData?["username"] ?? "N/A"),
                    _buildProfileRow("Email:", _userData?["email"] ?? "N/A"),
                    _buildProfileRow(
                        "Account Type:", _userData?["type"] ?? "N/A"),
                    _buildProfileRow(
                        "Permission:", _userData?["permission"] ?? "N/A"),
                    _buildProfileRow(
                        "Created Date:", _userData?["createdDate"] ?? "N/A"),
                  ],
                ),
              ),
            ),
          ),
        ],
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
}
