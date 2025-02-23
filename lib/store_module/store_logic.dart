import 'package:flutter/material.dart';
import 'store_model.dart';
import 'store_service.dart';

class StoreLogic extends ChangeNotifier {
  List<Welcome> _storeList = [];
  List<Welcome> _filteredStores = []; // Holds filtered results

  List<Welcome> get storeList =>
      _filteredStores.isEmpty ? _storeList : _filteredStores;

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
        _filteredStores.clear(); // Reset filtered results
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

  // Search function
  void searchStores(String query) {
    if (query.isEmpty) {
      _filteredStores.clear(); // Reset to show all stores
    } else {
      _filteredStores = _storeList
          .where((store) =>
              store.storename.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
