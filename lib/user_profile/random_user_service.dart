import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'random_user_model.dart';

class RandomUserService {
  static final _storage = FlutterSecureStorage(); // Secure storage instance

  static Future<void> read({
    required Function(List<Doc>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "http://198.50.183.209:4000/v1/users";

    try {
      // Retrieve the stored auth token
      String? token = await _storage.read(key: 'authToken');

      if (token == null) {
        onError("Authentication token not found");
        return;
      }

      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Add token in header
        },
      );

      if (response.statusCode == 200) {
        final data = welcomeFromJson(response.body);
        onRes(data.docs);
      } else {
        onError("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      onError(e);
    }
  }
}
