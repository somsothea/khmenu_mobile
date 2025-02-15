import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khmenu_mobile/env.dart';

import 'login_service.dart';
import 'login_models.dart';

class FakestoreLoginLogic extends ChangeNotifier {
  MyResponseModel _responseModel = MyResponseModel();
  MyResponseModel get responseModel => _responseModel;
 final _cache = FlutterSecureStorage();
  Future read() async {
    String? tk = await _cache.read(key: Env.apiKey);
    debugPrint("reading token: $tk");
    _responseModel = MyResponseModel(token: tk);
    notifyListeners();
  }

  Future clear() async {
    _cache.delete(key: Env.apiKey);
    debugPrint("token cleared");
    _responseModel = MyResponseModel(token: null);
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  get http => null;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future<MyResponseModel> login(String email, String password) async {
    _loading = true;
    notifyListeners();

    LoginRequestModel requestModel = LoginRequestModel(
      email: email.trim(),
      password: password.trim(),
    );

    try {
      _responseModel = await FakestoreService.login(request: requestModel);
      debugPrint("Saving token: ${_responseModel.token}");
      await _cache.write(key: Env.apiKey, value: _responseModel.token);
      _error = null;
    } catch (err) {
      _error = err;
      _responseModel = MyResponseModel(token: null, errorText: err.toString());
    }

    _loading = false;
    notifyListeners();
    return _responseModel;
  }

  Future<void> getUserInfo() async {
    String url = "${Env.apiBaseUrl}/v1/auth/me";

    try {
      final token = await _cache.read(key: Env.apiKey);
      if (token == null) {
        _error = "No token found. Please login again.";
        notifyListeners();
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String userId = data["_id"];
        String firstName = data["firstname"];
        String lastName = data["lastname"];

        // Store user details
        await _cache.write(key: "userId", value: userId);
        await _cache.write(key: "firstName", value: firstName);
        await _cache.write(key: "lastName", value: lastName);

        debugPrint("User Data Stored: $userId, $firstName, $lastName");
      } else {
        _error = "Failed to fetch user data: ${response.body}";
      }
    } catch (e) {
      _error = "Network error: ${e.toString()}";
    }

    notifyListeners();
  }
}
