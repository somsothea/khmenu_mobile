import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khmenu_mobile/env.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final response = await http.post(
      Uri.parse("${Env.apiBaseUrl}/v1/auth/sign-up"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstname": _firstnameController.text,
        "lastname": _lastnameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "confirmPassword": _confirmPasswordController.text,
      }),
    );

    setState(() => _loading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Registration successful! Please log in.")),
      );
      Navigator.pop(context);
    } else {
      setState(() => _errorMessage =
          jsonDecode(response.body)['message'] ?? "Registration failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  Icons.account_circle,
                  size: 120,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _firstnameController,
                            decoration: InputDecoration(
                              labelText: "First Name",
                              prefixIcon: const Icon(Icons.person),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Enter your first name" : null,
                          ),
                          TextFormField(
                            controller: _lastnameController,
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            validator: (value) =>
                                value!.isEmpty ? "Enter your last name" : null,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value!.isEmpty ? "Enter a valid email" : null,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock),
                            ),
                            obscureText: true,
                            validator: (value) => value!.length < 8
                                ? "Password must be at least 8 characters"
                                : null,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                            ),
                            obscureText: true,
                            validator: (value) =>
                                value != _passwordController.text
                                    ? "Passwords do not match"
                                    : null,
                          ),
                          const SizedBox(height: 10),
                          if (_errorMessage != null)
                            Text(_errorMessage!,
                                style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 10),
                          _loading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _register,
                                  child: const Text("Register"),
                                ),
                          const SizedBox(height: 20),
                          const Text("Or sign up with"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const FaIcon(FontAwesomeIcons.google,
                                    color: Colors.red),
                                onPressed: () {},
                              ),
                              const SizedBox(width: 20),
                              IconButton(
                                icon: const FaIcon(FontAwesomeIcons.facebook,
                                    color: Colors.blue),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
