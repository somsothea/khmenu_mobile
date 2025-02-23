import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khmenu_mobile/setting_module/language_data.dart';

class LanguageLogic extends ChangeNotifier {
  Language _lang = Khmer();
  Language get lang => _lang;
  int _langIndex = 0;
  int get langIndex => _langIndex;

  final _secureStorage = FlutterSecureStorage();
  final String _key = "LanguageLogic";

  final _langList = [
    Khmer(),
    Language(),
  ];

  Future read() async {
    String? data = await _secureStorage.read(key: _key);
    _langIndex = int.parse(data ?? "0");
    _lang = _langList[_langIndex];
    notifyListeners();
  }

  void changToKhmer() {
    _langIndex = 0;
    _secureStorage.write(key: _key, value: _langIndex.toString());
    _lang = _langList[_langIndex];
    notifyListeners();
  }

  void changeToEnglish() {
    _langIndex = 1;
    _secureStorage.write(key: _key, value: _langIndex.toString());
    _lang = _langList[_langIndex];
    notifyListeners();
  }
}
