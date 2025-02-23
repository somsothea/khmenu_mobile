import 'package:flutter/material.dart';
import 'item_model.dart';
import 'item_service.dart';

class ProductLogic extends ChangeNotifier {
  List<ProductModel> _productList = [];
  List<ProductModel> _filteredProducts = []; // Holds filtered products

  List<ProductModel> get productList =>
      _filteredProducts.isEmpty ? _productList : _filteredProducts;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future read() async {
    await ProductService.read(
      onRes: (items) async {
        _productList = await items;
        _filteredProducts.clear(); // Reset filtered results
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
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts.clear(); // Reset to show all products
    } else {
      _filteredProducts = _productList
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
