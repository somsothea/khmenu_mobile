import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:khmenu_mobile/env.dart';
import 'package:mime/mime.dart';

class AddStoreScreen extends StatefulWidget {
  final String userId;

  const AddStoreScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _AddStoreScreenState createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _storeUrlController = TextEditingController();
  final TextEditingController _storeDescriptionController =
      TextEditingController();
  final TextEditingController _storeContactController = TextEditingController();
  final TextEditingController _storeTelegramController =
      TextEditingController();
  final TextEditingController _storeCategoryController =
      TextEditingController();
  File? _logoImage;
  File? _bannerImage;
  String? _logoFilename;
  String? _bannerFilename;
  bool _isLoading = false;

  Future<void> _pickAndUploadImage(bool isLogo) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => isLogo
          ? _logoImage = File(pickedFile.path)
          : _bannerImage = File(pickedFile.path));
      await _uploadFile(isLogo);
    }
  }

  Future<void> _uploadFile(bool isLogo) async {
    File? imageFile = isLogo ? _logoImage : _bannerImage;
    if (imageFile == null) return;
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

      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final mimeTypeSplit = mimeType.split('/');

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
        contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
      ));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseData);

      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey("file")) {
        setState(() {
          if (isLogo) {
            _logoFilename = jsonResponse["file"]["filename"];
          } else {
            _bannerFilename = jsonResponse["file"]["filename"];
          }
        });
      }
    } catch (e) {
      print("Upload error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addStore() async {
    if (!_formKey.currentState!.validate() ||
        _logoFilename == null ||
        _bannerFilename == null) return;
    setState(() => _isLoading = true);

    try {
      String url = "${Env.apiBaseUrl}/v1/mystores";
      String? token = await Env.apiStorage.read(key: Env.apiKey);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({
          "storename": _storeNameController.text,
          "storeaddress": _storeAddressController.text,
          "storelogo": _logoFilename,
          "storebanner": _bannerFilename,
          "storeurl": _storeUrlController.text,
          "storedescription": _storeDescriptionController.text,
          "storecontact": _storeContactController.text,
          "storetelegram": _storeTelegramController.text,
          "category": _storeCategoryController.text,
          "userid": widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true);
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
      appBar: AppBar(title: Text('Add Store')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _storeNameController,
                  decoration: InputDecoration(labelText: 'Store Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter store name'
                      : null,
                ),
                TextFormField(
                  controller: _storeAddressController,
                  decoration: InputDecoration(labelText: 'Store Address'),
                ),
                TextFormField(
                  controller: _storeUrlController,
                  decoration: InputDecoration(labelText: 'Store URL'),
                ),
                TextFormField(
                  controller: _storeCategoryController,
                  decoration: InputDecoration(labelText: 'Store Category'),
                ),
                TextFormField(
                  controller: _storeDescriptionController,
                  decoration: InputDecoration(labelText: 'Store Description'),
                ),
                TextFormField(
                  controller: _storeContactController,
                  decoration: InputDecoration(labelText: 'Store Contact'),
                ),
                TextFormField(
                  controller: _storeTelegramController,
                  decoration: InputDecoration(labelText: 'Store Telegram'),
                ),
                SizedBox(height: 20),
                Text(
                  'Store Logo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _pickAndUploadImage(true),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: _logoImage != null
                        ? Image.file(_logoImage!, fit: BoxFit.cover)
                        : Center(
                            child: Icon(Icons.image,
                                size: 50, color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Store Banner',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () => _pickAndUploadImage(false),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: _bannerImage != null
                        ? Image.file(_bannerImage!, fit: BoxFit.cover)
                        : Center(
                            child: Icon(Icons.image,
                                size: 50, color: Colors.grey)),
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed:
                            _logoFilename != null && _bannerFilename != null
                                ? _addStore
                                : null,
                        child: Text('Add Store'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
