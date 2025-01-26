import 'package:flutter/material.dart';

import 'random_user_model.dart';
import 'random_user_service.dart';

class RandomUserLogic extends ChangeNotifier {
  List<Result> _productList = [];
  List<Result> get productList => _productList;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future read() async{
    await RandomUserService.read(
      onRes: (items)  async{
        _productList = await items;
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
 