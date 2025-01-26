import 'package:flutter/material.dart';

import 'movie_model.dart';
import 'movie_service.dart';

const startingPage = 2; //important you must set startingPage = 2
const resultPerPage = 10; //based on the API provided results per page

class MovieLogic extends ChangeNotifier {
  List<Search> _records = [];
  List<Search> get records => _records;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  int _page = startingPage;
  int _totalResults = 0;

  bool _endOfResult = false;
  bool get endOfResult => _endOfResult;

  Future readAppend() async {
    int totalPage = (_totalResults / resultPerPage).toInt();
    if (_page <= totalPage) {
      _page++;
      _endOfResult = false;
    } else {
      _endOfResult = true;
    }

    await MovieService.readByPage(
      page: _page,
      onRes: (value) async {
        final data = await value;
        _totalResults = int.parse(data.totalResults);
        if (_endOfResult == false) {
          _records += data.search;
        }
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

  Future read() async {
    await MovieService.read(
      onRes: (value) async {
        final data = await value;
        _records = data.search;
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

  bool get showLoading => _records.length > 10;
}
