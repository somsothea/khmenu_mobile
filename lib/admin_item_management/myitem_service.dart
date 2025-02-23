import 'package:http/http.dart' as http;
import 'myitem_model.dart';
import 'package:khmenu_mobile/env.dart';

class StoreService {
  static Future<void> read({
    required Function(List<Doc>) onRes,
    required Function(Object?) onError,
    int page = 1, // Default to page 1
    int limit = 12, // Default limit per page
  }) async {
    //String url = "${Env.apiBaseUrl}/v1/myitems/?page=$page&limit=$limit";
    String url = "${Env.apiBaseUrl}/v1/myitems?limit=24";
    //String url = "${Env.apiBaseUrl}/v1/myitems";
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
        final body = myItemFromJson(response.body.toString());
        onRes(body.docs);
      } else {
        onError("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      onError(e);
    }
  }
}
