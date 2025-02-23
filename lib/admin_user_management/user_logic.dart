import 'package:flutter/material.dart';

import 'user_model.dart';
import 'user_service.dart';

class RandomUserLogic extends ChangeNotifier {
  List<Doc> _productList = [];
  List<Doc> get productList => _productList;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future read() async {
    await RandomUserService.read(
      onRes: (items) async {
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

  void deleteUser(String userId) {
    RandomUserService.delete(
      userId: userId,
      onSuccess: () {
        productList.removeWhere((user) => user.id == userId);
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Delete failed: $error");
      },
    );
  }
}
