import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'movie_model.dart';


class MovieService {
  static Future read({
    required Function(Future<MovieModel>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "https://www.omdbapi.com/?apikey=f9aa78ee&s=fight&page=1";
    try {
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(movieModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }

  static Future readByPage({
      int page = 1,
      required Function(Future<MovieModel>) onRes,
      required Function(Object?) onError,
    }) async {
      String url =
          "https://www.omdbapi.com/?apikey=f9aa78ee&s=true+crime&page=$page";
      try {
        http.Response response = await http.get(Uri.parse(url));
        final data = compute(movieModelFromJson, response.body);
        onRes(data);
        onError(null);
      } catch (e) {
        onError(e);
      }
    }

  static Future search({
    required String movieTitle,
    required Function(Future<MovieModel>) onRes,
    required Function(Object?) onError,
  }) async {
    String url = "https://www.omdbapi.com/?apikey=f9aa78ee&s=$movieTitle&page=1";
    try {
      http.Response response = await http.get(Uri.parse(url));
      final data = compute(movieModelFromJson, response.body);
      onRes(data);
      onError(null);
    } catch (e) {
      onError(e);
    }
  }
}
