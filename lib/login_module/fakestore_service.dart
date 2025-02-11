import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'fakestore_login_models.dart';
import 'package:khmenu_mobile/env.dart';

class FakestoreService {
  static Future<MyResponseModel> login(
      {required LoginRequestModel request}) async {
    String url = "${Env.apiBaseUrl}/v1/auth/login/";

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: request.toJson(),
      );

      final data = compute(loginResponseModelFromJson, response.body);
      return data;
    } catch (e) {
      return MyResponseModel(token: null, errorText: e.toString());
    }
  }
}
