import 'package:http/http.dart' as http;
import 'store_model.dart';

class StoreService {
  
  static Future<void> read({
    required Function(List<Doc>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "http://198.50.183.209:4000/v1/stores/";

    try {
      http.Response response = await http.get(Uri.parse(url));
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
