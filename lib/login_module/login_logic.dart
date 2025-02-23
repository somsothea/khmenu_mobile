import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khmenu_mobile/env.dart';

import 'login_service.dart';
import 'login_models.dart';

class LoginLogic extends ChangeNotifier {
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
      _responseModel = await LoginService.login(request: requestModel);
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
}
