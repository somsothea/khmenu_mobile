import 'package:flutter/material.dart';
import 'package:khmenu_mobile/mystore_module/movie_model.dart';
import 'package:khmenu_mobile/mystore_module/movie_service.dart';

const startingPage = 1; // Starts from page 1
const resultPerPage = 10; // Number of results per page

class StoreLogic extends ChangeNotifier {
  List<Doc> _stores = [];
  List<Doc> get stores => _stores;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  int _page = startingPage;
  int _totalResults = 0;
  bool _endOfResult = false;
  bool get endOfResult => _endOfResult;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future readAppend() async {
    int totalPage = (_totalResults / resultPerPage).ceil();

    if (_page < totalPage) {
      _page++;
      _endOfResult = false;
    } else {
      _endOfResult = true;
      return;
    }

    await StoreService.readByPage(
      page: _page,
      onRes: (value) async {
        final data = await value;
        _totalResults = data.totalDocs;

        if (!_endOfResult) {
          _stores.addAll(data.docs);
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
    setLoading();

    await StoreService.read(
      onRes: (value) async {
        final data = await value;
        _stores = data.docs;
        _totalResults = data.totalDocs;
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

  bool get showLoading => _stores.length >= 10;
}
