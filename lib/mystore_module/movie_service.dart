import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'movie_model.dart';
import 'package:khmenu_mobile/env.dart';

class StoreService {
  static Future read({
    required Function(Future<MyStore>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "${Env.apiBaseUrl}/v1/mystores/&page=1";
    try {
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(myStoreFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }

  static Future readByPage({
    int page = 1,
    required Function(Future<MyStore>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "${Env.apiBaseUrl}/v1/mystores/&page=$page";
    try {
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(myStoreFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }

  static Future search({
    required String movieTitle,
    required Function(Future<MyStore>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "${Env.apiBaseUrl}/v1/mystores/&s=$movieTitle&page=1";
    try {
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(myStoreFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }
}
