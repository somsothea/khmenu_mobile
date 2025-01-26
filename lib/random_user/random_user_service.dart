import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'random_user_model.dart';

/* class RandomUserService {
  static Future read({
    required Function(Future<List<Result>>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "https://randomuser.me/api/";
    try {
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(welcomeFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }
} */

class RandomUserService {
  static Future<void> read({
    required Function(List<Result>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "https://randomuser.me/api/?results=20&page=1";
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = randomUserModelFromJson(response.body);
        onRes(data.results); // Pass the list of results
      } else {
        onError("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      onError(e);
    }
  }
}
