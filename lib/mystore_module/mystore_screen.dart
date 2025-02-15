import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:khmenu_mobile/env.dart';
import 'mystore_logic.dart';
import 'mystore_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final _storage = FlutterSecureStorage(); // Secure storage instance
  final _formKey = GlobalKey<FormState>();

  // Controllers for form input fields
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _storeAddressController = TextEditingController();
  final TextEditingController _storeUrlController = TextEditingController();
  final TextEditingController _storeDescriptionController = TextEditingController();
  final TextEditingController _storeContactController = TextEditingController();
  final TextEditingController _storeTelegramController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Stores"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => _showAddStoreDialog(),
            icon: Icon(Icons.add_business),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Object? error = context.watch<StoreLogic>().error;
    bool loading = context.watch<StoreLogic>().loading;
    List<Doc> productList = context.watch<StoreLogic>().storeList;

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _buildErrorMessage(error);
    } else {
      return _buildGridView(productList);
    }
  }

  Widget _buildErrorMessage(Object error) {
    debugPrint(error.toString());
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 50),
          Text("Something went wrong"),
          ElevatedButton(
            onPressed: () {
              context.read<StoreLogic>().setLoading();
              context.read<StoreLogic>().read();
            },
            child: Text("RETRY"),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Doc> items) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StoreLogic>().setLoading();
        context.read<StoreLogic>().read();
      },
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 4 / 6,
        ),
        itemCount: items.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildItem(items[index]);
        },
      ),
    );
  }

  Widget _buildItem(Doc item) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              "${Env.apiBaseUrl}/uploads/${item.storelogo}",
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${item.storename}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStoreDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Store"),
          content: Form(
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
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => _submitStore(),
              child: Text("Add Store"),
            ),
          ],
        );
      },
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
        validator: (value) => value == null || value.isEmpty ? "Required" : null,
      ),
    );
  }

  Future<void> _submitStore() async {
    if (!_formKey.currentState!.validate()) return;

    String? token = await _storage.read(key: 'authToken');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication required")),
      );
      return;
    }

    Map<String, dynamic> storeData = {
      "storename": _storeNameController.text,
      "storeaddress": _storeAddressController.text,
      "storelogo": "https://picsum.photos/100/100?shop",
      "storebanner": "https://picsum.photos/1000/600?shop",
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
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(storeData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Store added successfully")),
        );
        context.read<StoreLogic>().read(); // Refresh store list
        Navigator.pop(context); // Close dialog
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add store: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: ${e.toString()}")),
      );
    }
  }
}
