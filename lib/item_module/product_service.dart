import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'product_model.dart';

class ProductService {
  static Future read({
    required Function(Future<List<ProductModel>>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "https://khmenu.cloud/v1/items";
    try {
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(productModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }
}
