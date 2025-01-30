import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddStoreScreen extends StatefulWidget {
  @override
  _AddStoreScreenState createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameCtrl = TextEditingController();
  final _storeAddressCtrl = TextEditingController();
  final _storeUrlCtrl = TextEditingController();
  final _storeDescriptionCtrl = TextEditingController();
  final _storeContactCtrl = TextEditingController();
  final _storeTelegramCtrl = TextEditingController();

  File? _logoFile;
  File? _bannerFile;
  String? _logoUrl;
  String? _bannerUrl;

  Future<String?> _uploadFile(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://khmenu.cloud/v1/files/upload-single'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);
      return jsonData['filename'];
    }
    return null;
  }

  Future<void> _pickImage(bool isLogo) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isLogo) {
          _logoFile = File(pickedFile.path);
        } else {
          _bannerFile = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_logoFile != null) _logoUrl = await _uploadFile(_logoFile!);
      if (_bannerFile != null) _bannerUrl = await _uploadFile(_bannerFile!);

      final body = jsonEncode({
        "storename": _storeNameCtrl.text,
        "storeaddress": _storeAddressCtrl.text,
        "storelogo": _logoUrl ?? "",
        "storebanner": _bannerUrl ?? "",
        "storeurl": _storeUrlCtrl.text,
        "storedescription": _storeDescriptionCtrl.text,
        "storecontact": _storeContactCtrl.text,
        "storetelegram": _storeTelegramCtrl.text,
        "category": "Test Store",
        "userid": "6746881eb7888ea088d35c6b",
      });

      final response = await http.post(
        Uri.parse('https://khmenu.cloud/v1/mystores'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Store added successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add store")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Store")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _storeNameCtrl,
                  decoration: InputDecoration(labelText: "Store Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter store name" : null,
                ),
                TextFormField(
                  controller: _storeAddressCtrl,
                  decoration: InputDecoration(labelText: "Store Address"),
                ),
                TextFormField(
                  controller: _storeUrlCtrl,
                  decoration: InputDecoration(labelText: "Store URL"),
                ),
                TextFormField(
                  controller: _storeDescriptionCtrl,
                  decoration: InputDecoration(labelText: "Store Description"),
                ),
                TextFormField(
                  controller: _storeContactCtrl,
                  decoration: InputDecoration(labelText: "Contact"),
                ),
                TextFormField(
                  controller: _storeTelegramCtrl,
                  decoration: InputDecoration(labelText: "Telegram"),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(true),
                      child: Text("Upload Logo"),
                    ),
                    if (_logoFile != null)
                      Image.file(_logoFile!, width: 50, height: 50),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(false),
                      child: Text("Upload Banner"),
                    ),
                    if (_bannerFile != null)
                      Image.file(_bannerFile!, width: 100, height: 50),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
