import 'package:http/http.dart' as http;
import 'mystore_model.dart';
import 'package:khmenu_mobile/env.dart';

class StoreService {
  static Future<void> read({
    required Function(List<Doc>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "${Env.apiBaseUrl}/v1/mystores/";
    String? token = await Env.apiStorage.read(key: Env.apiKey);

    if (token == null || token.isEmpty) {
      onError("Authentication token not found");
      return;
    }

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // Add token in header
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final body = myStoreFromJson(response.body.toString());
        onRes(body.docs);
      } else {
        onError("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      onError(e);
    }
  }
}
