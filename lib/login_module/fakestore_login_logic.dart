import 'package:flutter/material.dart';

import 'fakestore_service.dart';
import 'fakestore_login_models.dart';

class FakestoreLoginLogic extends ChangeNotifier {
  // LoginResponseModel _responseModel = LoginResponseModel(token: "");
  // LoginResponseModel get responseModel => _responseModel;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future<LoginResponseModel> login(String username, String password) async {
    LoginRequestModel requestModel = LoginRequestModel(
      username: username.trim(),
      password: password.trim(),
    );

    LoginResponseModel _responseModel = LoginResponseModel();

    await FakestoreService.login(
      request: requestModel,
      onRes: (value) async {
        _responseModel = await value;
        _loading = false;
        notifyListeners();
      },
      onError: (err) {
        _error = err;
        _loading = false;
        notifyListeners();
      },
    );
    return _responseModel;
  }
  
}
