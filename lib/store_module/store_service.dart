import 'package:http/http.dart' as http;
import 'store_model.dart';
import 'package:khmenu_mobile/env.dart';

class StoreService {
  static Future<void> read({
    required Function(List<Welcome>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "${Env.apiBaseUrl}/v1/stores/";

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = welcomeFromJson(response.body);
        onRes(data);
      } else {
        onError("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      onError(e);
    }
  }
}
