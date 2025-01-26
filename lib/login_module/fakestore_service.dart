import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'fakestore_login_models.dart';

class FakestoreService {
  static Future login({
    required LoginRequestModel request,
    required Function(Future<LoginResponseModel>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "https://fakestoreapi.com/auth/login";
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: request.toJson(),
      );
      final data = compute(loginResponseModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }
}
