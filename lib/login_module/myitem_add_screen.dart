import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:khmenu_mobile/env.dart';
import 'package:mime/mime.dart';

class AddItemScreen extends StatefulWidget {
  final String storeId;
  AddItemScreen({required this.storeId});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _price = 0.0;
  String _category = '';
  File? _imageFile;
  String? _filename;
  bool _isLoading = false;

  Future<void> _pickAndUploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await _uploadFile();
    }
  }

  Future<void> _uploadFile() async {
    if (_imageFile == null) return;
    setState(() => _isLoading = true);

    String url = "${Env.apiBaseUrl}/v1/files/upload-single";
    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null || token.isEmpty) return;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      final mimeType = lookupMimeType(_imageFile!.path) ?? 'image/jpeg';
      final mimeTypeSplit = mimeType.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        _imageFile!.path,
        contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
      ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey("file")) {
        setState(() => _filename = jsonResponse["file"]["filename"]);
      }
    } catch (e) {
      print("Upload error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitItem() async {
    if (!_formKey.currentState!.validate() || _filename == null) return;
    setState(() => _isLoading = true);

    try {
      String url = "${Env.apiBaseUrl}/v1/myitems";
      String? token = await Env.apiStorage.read(key: Env.apiKey);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({
          "title": _title,
          "description": _description,
          "price": _price,
          "category": _category,
          "filename": _filename,
          "storeid": widget.storeId,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(
            context, true); // Pass success flag to refresh MyStoreScreenDetail
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Item')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a title'
                      : null,
                  onChanged: (value) => setState(() => _title = value),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a description'
                      : null,
                  onChanged: (value) => setState(() => _description = value),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value == null ||
                          value.isEmpty ||
                          double.tryParse(value) == null
                      ? 'Please enter a valid price'
                      : null,
                  onChanged: (value) =>
                      setState(() => _price = double.tryParse(value) ?? 0.0),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a category'
                      : null,
                  onChanged: (value) => setState(() => _category = value),
                ),
                SizedBox(height: 20),
                Text(
                  'Item Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : Center(
                            child: Icon(Icons.image,
                                size: 50, color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _filename != null ? _submitItem : null,
                          child: Text('Submit Item'),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
