import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CounterLogic extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  final _secureStorage = FlutterSecureStorage();
  final String _counterKey = "CounterLogic";

  Future read() async {
    String? data = await _secureStorage.read(key: _counterKey);
    _counter = int.parse(data ?? "0");
    notifyListeners();
  }

  void increase() {
    _counter += 2;
    _secureStorage.write(key: _counterKey, value: _counter.toString());
    notifyListeners();
  }

  void decrease() {
    _counter -= 2;
    _secureStorage.write(key: _counterKey, value: _counter.toString());
    notifyListeners();
  }
}
