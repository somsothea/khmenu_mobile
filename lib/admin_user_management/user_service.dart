import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'package:khmenu_mobile/env.dart';

class RandomUserService {
  //static final _storage = FlutterSecureStorage(); // Secu// Define your API key here

  static Future<void> read({
    required Function(List<Doc>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "${Env.apiBaseUrl}/v1/users";

    try {
      // Retrieve the stored auth token
      String? token = await Env.apiStorage.read(key: Env.apiKey);

      if (token == null || token.isEmpty) {
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
      onError("Network error: ${e.toString()}");
    }
  }

  static Future<void> delete({
    required String userId,
    required Function() onSuccess,
    required Function(Object?) onError,
  }) async {
    String url = "${Env.apiBaseUrl}/v1/users/$userId";

    try {
      String? token = await Env.apiStorage.read(key: Env.apiKey);
      if (token == null || token.isEmpty) {
        onError("Authentication token not found");
        return;
      }

      http.Response response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        onSuccess();
      } else {
        onError("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      onError("Network error: ${e.toString()}");
    }
  }
}
