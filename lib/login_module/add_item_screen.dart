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
  File? _imageFile;
  String? _filename;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
  if (_imageFile == null) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image")));
    return;
  }

  setState(() => _isLoading = true);

  String url = "${Env.apiBaseUrl}/v1/files/upload-single";
  String? token = await Env.apiStorage.read(key: Env.apiKey);

  if (token == null || token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication token not found")));
    setState(() => _isLoading = false);
    return;
  }

  try {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    final mimeType = lookupMimeType(_imageFile!.path);
    final mimeTypeSplit = mimeType?.split('/') ?? ['image', 'jpeg'];

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      _imageFile!.path,
      contentType: MediaType(mimeTypeSplit[0], mimeTypeSplit[1]),
    ));

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    // Decode the response JSON
    var jsonResponse = json.decode(responseData);

    print("Upload Response: $jsonResponse"); // Debugging output

    if (response.statusCode == 200 && jsonResponse.containsKey("file")) {
      setState(() {
        // Accessing the nested 'file' object and extracting the filename
        _filename = jsonResponse["file"]["filename"];
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image uploaded successfully!")));
    } else {
      throw Exception(jsonResponse["message"] ?? "Upload failed");
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")));
  } finally {
    setState(() => _isLoading = false);
  }
}

Future<void> _submitItem() async {
  if (!_formKey.currentState!.validate() || _filename == null) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please upload an image")));
    return;
  }

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
        "filename": _filename,
        "storeid": widget.storeId,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Item added successfully')));
      Navigator.pop(context);
    } else {
      throw Exception('Failed to add item: ${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Error: $e')));
  } finally {
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter a title' : null,
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
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a price'
                    : (double.tryParse(value) == null
                        ? 'Please enter a valid price'
                        : null),
                onChanged: (value) => setState(() => _price = double.tryParse(value) ?? 0.0),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _pickImage, child: Text('Select Image')),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Upload Image'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Filename'),
                controller: TextEditingController(text: _filename),
                readOnly: true,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _filename != null ? _submitItem : null,
                      child: Text('Submit Item'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
