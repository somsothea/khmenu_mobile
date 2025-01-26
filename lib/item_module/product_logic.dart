import 'package:flutter/material.dart';

import 'product_model.dart';
import 'product_service.dart';

class ProductLogic extends ChangeNotifier {
  List<ProductModel> _productList = [];
  List<ProductModel> get productList => _productList;

  bool _loading = false;
  bool get loading => _loading;

  Object? _error;
  Object? get error => _error;

  void setLoading() {
    _loading = true;
    notifyListeners();
  }

  Future read() async{
    await ProductService.read(
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
