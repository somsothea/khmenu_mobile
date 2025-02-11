import 'package:flutter/material.dart';

import 'movie_model.dart';
import 'movie_service.dart';

class MovieSearchLogic extends ChangeNotifier {
  List<Doc> _records = [];
  List<Doc> get records => _records;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future search(String movieTitle) async {
    await StoreService.search(
      movieTitle: movieTitle,
      onRes: (value) async {
        final data = await value;
        _records = data.docs;
        _loading = false;
        notifyListeners();
      },
      onError: (err) {
        _error = err;
        _loading = false;
        notifyListeners();
      },
    );
  }
}
