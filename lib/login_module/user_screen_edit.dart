import 'package:flutter/material.dart';

class UserScreenEdit extends StatefulWidget {
  final Map<String, dynamic> userData;

  const UserScreenEdit({super.key, required this.userData});

  @override
  State<UserScreenEdit> createState() => _UserScreenEditState();
}

class _UserScreenEditState extends State<UserScreenEdit> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _typeController;
  late TextEditingController _permissionController;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.userData["username"]);
    _emailController = TextEditingController(text: widget.userData["email"]);
    _typeController = TextEditingController(text: widget.userData["type"]);
    _permissionController =
        TextEditingController(text: widget.userData["permission"]);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _typeController.dispose();
    _permissionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Update the userData with new values
    widget.userData["username"] = _usernameController.text;
    widget.userData["email"] = _emailController.text;
    widget.userData["type"] = _typeController.text;
    widget.userData["permission"] = _permissionController.text;

    // Optionally, save this updated data to a server or local storage

    // Return updated data to the home screen
    Navigator.pop(context, widget.userData);
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
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: "Account Type"),
            ),
            TextField(
              controller: _permissionController,
              decoration: InputDecoration(labelText: "Permission"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
