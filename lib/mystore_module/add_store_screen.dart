import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:khmenu_mobile/env.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({super.key});

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {

  final _formKey = GlobalKey<FormState>();

  // Controllers for form input fields
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _storeUrlController = TextEditingController();
  final TextEditingController _storeDescriptionController =
      TextEditingController();
  final TextEditingController _storeContactController = TextEditingController();
  final TextEditingController _storeTelegramController =
      TextEditingController();

  File? _selectedLogo;
  File? _selectedBanner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Store"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_storeNameController, "Store Name"),
              _buildTextField(_storeAddressController, "Store Address"),
              _buildTextField(_storeUrlController, "Store URL"),
              _buildTextField(_storeDescriptionController, "Store Description"),
              _buildTextField(_storeContactController, "Store Contact"),
              _buildTextField(_storeTelegramController, "Store Telegram"),
              _buildImagePicker("Upload Store Logo", _selectedLogo,
                  (file) => setState(() => _selectedLogo = file)),
              _buildImagePicker("Upload Store Banner", _selectedBanner,
                  (file) => setState(() => _selectedBanner = file)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitStore(),
                child: Text("Add Store"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _buildImagePicker(
      String label, File? image, Function(File?) onImagePicked) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            final pickedFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              onImagePicked(File(pickedFile.path));
            }
          },
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: image != null
                ? Image.file(image, fit: BoxFit.cover)
                : Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey)),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Future<String?> _uploadFile(File file) async {
    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Authentication required")));
      return null;
    }

    final mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Only image files are allowed")));
      return null;
    }

    var uri = Uri.parse("${Env.apiBaseUrl}/v1/files/upload-single");
    var request = http.MultipartRequest('POST', uri)
      ..headers["Authorization"] = "Bearer $token"
      ..headers["Content-Type"] = "multipart/form-data"
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseData);

      if (response.statusCode == 200 && jsonData.containsKey("filename")) {
        return jsonData["filename"];
      } else {
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload error: ${e.toString()}")));
      return null;
    }
  }

  Future<void> _submitStore() async {
    if (!_formKey.currentState!.validate()) return;

    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Authentication required")));
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Uploading files...")));

    String? logoFilename;
    String? bannerFilename;

    if (_selectedLogo != null) {
      logoFilename = await _uploadFile(_selectedLogo!);
    }

    if (_selectedBanner != null) {
      bannerFilename = await _uploadFile(_selectedBanner!);
    }

    if (logoFilename == null || bannerFilename == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("File upload failed")));
      return;
    }

    Map<String, dynamic> storeData = {
      "storename": _storeNameController.text,
      "storeaddress": _storeAddressController.text,
      "storelogo": logoFilename,
      "storebanner": bannerFilename,
      "storeurl": _storeUrlController.text,
      "storedescription": _storeDescriptionController.text,
      "storecontact": _storeContactController.text,
      "storetelegram": _storeTelegramController.text,
      "category": "Test Store",
      "userid": "6746881eb7888ea088d35c6b",
    };

    try {
      final response = await http.post(
        Uri.parse("${Env.apiBaseUrl}/v1/mystores"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode(storeData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Store added successfully")));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to add store: ${response.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Network error: ${e.toString()}")));
    }
  }
}
