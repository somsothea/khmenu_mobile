import 'package:http/http.dart' as http;
import 'store_model.dart';
import 'package:khmenu_mobile/env.dart';

class StoreService {
  static Future<void> read({
    required Function(List<MyStore>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "${Env.apiBaseUrl}/v1/stores";

    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Doc = myStoreFromJson(response.body);
        onRes(Doc);
      } else {
        onError("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      onError(e);
    }
  }
}
