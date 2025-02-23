import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khmenu_mobile/login_module/login_screen.dart';
import 'package:khmenu_mobile/login_module/mystore_screen_detail.dart';
import 'package:khmenu_mobile/login_module/mystore_add_screen.dart';
import 'package:khmenu_mobile/admin_store_management/mystore_model.dart';
import 'package:provider/provider.dart';
import 'package:khmenu_mobile/env.dart';

import 'login_loading_screen.dart';
import 'login_logic.dart';

class LoginHomeScreen extends StatefulWidget {
  const LoginHomeScreen({super.key});

  @override
  State<LoginHomeScreen> createState() => _LoginHomeScreenState();
}

class _LoginHomeScreenState extends State<LoginHomeScreen> {
  Map<String, dynamic>? _userData;
  bool _loading = true;
  String? _error;
// List to hold store data

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
        await Env.apiStorage
            .write(key: "userPermission", value: _userData!["permission"]);
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
              await context.read<LoginLogic>().clear();
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => LoginLoadingScreen(),
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
              onPressed: () async {
                await context.read<LoginLogic>().clear();
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (context) => LoginLoadingScreen(),
                  ),
                );
              },
              child: Text("Login again!"),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileContent(), // User Profile Section
          _buildMyStoresSection(), // My Stores Section
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    try {
      if (_userData == null) {
        // If user data is null, navigate to the login screen
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => LoginScreen()),
          );
        });
        throw Exception("User data is not available");
      }

      return InkWell(
        onTap: () => _showProfileDialog(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
                              (_userData!["firstname"]?[0] ?? "") +
                                  (_userData!["lastname"]?[0] ?? ""),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${_userData!["firstname"] ?? ""} ${_userData!["lastname"] ?? ""}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(),
                      _buildProfileRow(
                          "Username:", _userData!["username"] ?? "N/A"),
                      _buildProfileRow("Email:", _userData!["email"] ?? "N/A"),
                      _buildProfileRow(
                          "Account Type:", _userData!["type"] ?? "N/A"),
                      _buildProfileRow(
                          "Permission:", _userData!["permission"] ?? "N/A"),
                      _buildProfileRow(
                          "Created Date:", _userData!["createdDate"] ?? "N/A"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      // If user data is null or there's an error, navigate to the login screen
      if (_userData == null) {
        Future.microtask(() {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => LoginScreen()),
          );
        });
      }
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 50, color: Colors.red),
            Text("Error: ${e.toString()}"),
          ],
        ),
      );
    }
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

  Widget _buildMyStoresSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("My Stores",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.add, color: Colors.pink),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddStoreScreen(userId: _userData!["_id"]),
                    ),
                  );

                  if (result == true) {
                    setState(() {
                      _fetchUserStores(); // Refresh the store list
                    });
                  }
                },
              ),
            ],
          ),
        ),
        FutureBuilder<List<Doc>>(
          future: _fetchUserStores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error loading stores"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No stores available."));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final store = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          "${Env.apiBaseUrl}/uploads/${store.storelogo}"),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    title: Text(store.storename,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text(store.storedescription,
                        style: TextStyle(color: Colors.grey.shade600)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyStoreScreenDetail(
                            storeid: store.id,
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      _confirmDeleteStore(store.id);
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDeleteStore(store.id);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<List<Doc>> _fetchUserStores() async {
    try {
      String? token = await Env.apiStorage.read(key: Env.apiKey);
      if (token == null) return [];

      final response = await http.get(
        Uri.parse("${Env.apiBaseUrl}/v1/mystores/user/${_userData!["_id"]}"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> stores = data["docs"];
        return stores.map((store) => Doc.fromJson(store)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  void _confirmDeleteStore(String storeId) async {
    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null) return;

    bool hasItems = await _checkStoreHasItems(storeId, token);
    if (hasItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Cannot delete store. Please remove all items in store before delete.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Store"),
        content: Text("Are you sure you want to delete this store?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteStore(storeId);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkStoreHasItems(String storeId, String token) async {
    try {
      final response = await http.get(
        Uri.parse("${Env.apiBaseUrl}/v1/items/store/$storeId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> items = json.decode(response.body);
        return items.isNotEmpty; // Return true if the store has items
      }
    } catch (e) {
      print("Error checking store items: $e");
    }
    return false;
  }

  Future<void> _deleteStore(String storeId) async {
    try {
      String? token = await Env.apiStorage.read(key: Env.apiKey);
      if (token == null) return;

      final response = await http.delete(
        Uri.parse("${Env.apiBaseUrl}/v1/mystores/$storeId"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Store deleted successfully")),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete store: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: ${e.toString()}")),
      );
    }
  }
}
