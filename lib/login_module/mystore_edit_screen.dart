import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:khmenu_mobile/env.dart';
import 'package:mime/mime.dart';

class EditStoreScreen extends StatefulWidget {
  final String storeId;
  EditStoreScreen({required this.storeId});

  @override
  _EditStoreScreenState createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _storeNameController;
  late TextEditingController _storeAddressController;
  late TextEditingController _storeUrlController;
  late TextEditingController _storeDescriptionController;
  late TextEditingController _storeContactController;
  late TextEditingController _storeTelegramController;
  late TextEditingController _storeCategoryController;
  File? _logoImage;
  File? _bannerImage;
  String? _logoFilename;
  String? _bannerFilename;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController();
    _storeAddressController = TextEditingController();
    _storeUrlController = TextEditingController();
    _storeDescriptionController = TextEditingController();
    _storeContactController = TextEditingController();
    _storeTelegramController = TextEditingController();
    _storeCategoryController = TextEditingController();

    _fetchStoreDetails();
  }

  Future<void> _fetchStoreDetails() async {
    setState(() => _isLoading = true);
    String url = "${Env.apiBaseUrl}/v1/mystores/${widget.storeId}";
    String? token = await Env.apiStorage.read(key: Env.apiKey);

    try {
      final response = await http.get(Uri.parse(url), headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      if (response.statusCode == 200) {
        final storeData = json.decode(response.body);

        setState(() {
          _storeNameController.text = storeData['storename'] ?? '';
          _storeAddressController.text = storeData['storeaddress'] ?? '';
          _storeUrlController.text = storeData['storeurl'] ?? '';
          _storeDescriptionController.text =
              storeData['storedescription'] ?? '';
          _storeContactController.text = storeData['storecontact'] ?? '';
          _storeTelegramController.text = storeData['storetelegram'] ?? '';
          _storeCategoryController.text = storeData['category'] ?? '';
          _logoFilename = storeData['storelogo'];
          _bannerFilename = storeData['storebanner'];
        });
      }
    } catch (e) {
      print("Error fetching store details: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadImage(bool isLogo) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isLogo) {
          _logoImage = File(pickedFile.path);
        } else {
          _bannerImage = File(pickedFile.path);
        }
      });

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

  Future<void> _updateStore() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      String url = "${Env.apiBaseUrl}/v1/mystores/${widget.storeId}";
      String? token = await Env.apiStorage.read(key: Env.apiKey);

      var response = await http.put(
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
      appBar: AppBar(title: Text('Edit Store')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: _storeNameController,
                          decoration: InputDecoration(labelText: 'Store Name')),
                      TextFormField(
                          controller: _storeAddressController,
                          decoration:
                              InputDecoration(labelText: 'Store Address')),
                      TextFormField(
                          controller: _storeUrlController,
                          decoration: InputDecoration(labelText: 'Store URL')),
                      TextFormField(
                          controller: _storeCategoryController,
                          decoration:
                              InputDecoration(labelText: 'Store Category')),
                      TextFormField(
                          controller: _storeDescriptionController,
                          decoration:
                              InputDecoration(labelText: 'Store Description')),
                      TextFormField(
                          controller: _storeContactController,
                          decoration:
                              InputDecoration(labelText: 'Store Contact')),
                      TextFormField(
                          controller: _storeTelegramController,
                          decoration:
                              InputDecoration(labelText: 'Store Telegram')),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () => _pickAndUploadImage(true),
                          child: Text('Upload Store Logo')),
                      ElevatedButton(
                          onPressed: () => _pickAndUploadImage(false),
                          child: Text('Upload Store Banner')),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: _updateStore, child: Text('Update Store')),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
