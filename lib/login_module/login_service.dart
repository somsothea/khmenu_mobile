import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'login_models.dart';
import 'package:khmenu_mobile/env.dart';

class LoginService {
  static Future<MyResponseModel> login(
      {required LoginRequestModel request}) async {
    String url = "${Env.apiBaseUrl}/v1/auth/login";

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"}, // Ensure JSON request
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        // Try to parse JSON response
        try {
          final data = compute(loginResponseModelFromJson, response.body);
          return data;
        } catch (e) {
          return MyResponseModel(
              token: null, errorText: "Invalid JSON response");
        }
      } else {
        // Handle non-JSON error response (like "User not found!")
        return MyResponseModel(token: null, errorText: response.body);
      }
    } catch (e) {
      return MyResponseModel(
          token: null, errorText: "Network error: ${e.toString()}");
    }
  }
}
