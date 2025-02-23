import 'package:flutter/material.dart';

import 'myitem_model.dart';
import 'myitem_service.dart';

class StoreLogic extends ChangeNotifier {
  List<Doc> _storeList = [];
  List<Doc> get storeList => _storeList;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future read() async {
    await StoreService.read(
      onRes: (items) async {
        _storeList = await items;
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
