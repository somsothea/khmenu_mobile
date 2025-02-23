import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khmenu_mobile/env.dart';
import 'package:khmenu_mobile/login_module/mystore_edit_screen.dart';
import 'mystore_screen_qr.dart';
import 'package:khmenu_mobile/login_module/myitem_add_screen.dart';

class MyStoreScreenDetail extends StatefulWidget {
  final String storeid;

  MyStoreScreenDetail({required this.storeid});

  @override
  _MyStoreScreenDetailState createState() => _MyStoreScreenDetailState();
}

class _MyStoreScreenDetailState extends State<MyStoreScreenDetail> {
  String storeName = "";
  String storeBanner = "";
  String storeLogo = "";
  String storeDescription = "";
  String storeContact = "";
  String storeUrl = "";
  String storeAddress = "";
  String storeTelegram = "";
  List<dynamic> items = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchStoreDetails();
    fetchItems();
  }

  Future<void> fetchStoreDetails() async {
    String url = "${Env.apiBaseUrl}/v1/mystores/${widget.storeid}";

    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null || token.isEmpty) {
      setState(() {
        error = "Authentication token not found";
        loading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // Add token in header
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          storeName = data['storename'];
          storeBanner = data['storebanner'];
          storeLogo = data['storelogo'];
          storeDescription = data['storedescription'];
          storeContact = data['storecontact'];
          storeUrl = data['storeurl'];
          storeAddress = data['storeaddress'];
          storeTelegram = data['storetelegram'];
        });
      } else {
        setState(() {
          error = "Failed to load store details";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Future<void> fetchItems() async {
    String url = "${Env.apiBaseUrl}/v1/items/store/${widget.storeid}";

    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null || token.isEmpty) {
      setState(() {
        error = "Authentication token not found";
        loading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token", // Add token in header
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data;
          loading = false;
        });
      } else {
        setState(() {
          error = "Failed to load items";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  void showItemDialog(Map<String, dynamic> item) {
    TextEditingController titleController =
        TextEditingController(text: item['title']);
    TextEditingController priceController =
        TextEditingController(text: item['price'].toString());
    TextEditingController descriptionController =
        TextEditingController(text: item['description']);
    TextEditingController categoryController =
        TextEditingController(text: item['category'] ?? "");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Item"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  "${Env.apiBaseUrl}/uploads/${item['filename']}",
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image, size: 50, color: Colors.grey),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Price"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: "Category"),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await deleteItem(item['_id']); // Call delete function
                fetchItems(); // Refresh item list
              },
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await saveItem(
                  item['_id'],
                  titleController.text,
                  priceController.text,
                  descriptionController.text,
                  categoryController.text,
                );
                Navigator.pop(context);
                fetchItems(); // Refresh item list after saving
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveItem(String itemId, String title, String price,
      String description, String category) async {
    String url = "${Env.apiBaseUrl}/v1/myitems/$itemId";

    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null || token.isEmpty) {
      setState(() {
        error = "Authentication token not found";
      });
      return;
    }

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "title": title,
          "price": double.tryParse(price) ?? 0.0,
          "description": description,
          "category": category,
        }),
      );

      if (response.statusCode == 200) {
        print("Item updated successfully");
      } else {
        setState(() {
          error = "Failed to update item";
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  Widget storeItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () => showItemDialog(item),
      onLongPress: () => confirmDeleteDialog(item['_id']),
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                "${Env.apiBaseUrl}/uploads/${item['filename']}",
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey,
                  child: Icon(Icons.image, size: 50),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "\$ ${item['price'].toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget storeItemGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 4 / 5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return storeItem(items[index]);
      },
    );
  }

  Widget storeCardInfoRow() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          storeLogo.isNotEmpty
              ? Image.network(
                  "${Env.apiBaseUrl}/uploads/$storeLogo",
                  width: 70,
                  height: 70,
                )
              : Icon(Icons.store, size: 70),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(storeAddress, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(storeContact),
              Text(storeTelegram),
            ],
          )
        ],
      ),
    );
  }

  Future<void> deleteItem(String itemId) async {
    String url = "${Env.apiBaseUrl}/v1/myitems/$itemId";

    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null || token.isEmpty) {
      setState(() {
        error = "Authentication token not found";
      });
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        print("Item deleted successfully");
      } else {
        setState(() {
          error = "Failed to delete item";
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  void confirmDeleteDialog(String itemId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                await deleteItem(itemId); // Call delete function
                fetchItems(); // Refresh item list
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storeName.isEmpty ? "Store" : storeName),
        actions: [
          IconButton(
            icon: Icon(Icons.edit), // Edit store details
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EditStoreScreen(storeId: widget.storeid),
                ),
              );
              fetchStoreDetails(); // Refresh store details after returning
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddItemScreen(storeId: widget.storeid),
                ),
              );
              fetchItems(); // Refresh the item list after returning from AddItemScreen
            },
          ),
          IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoreScreenQR(
                    storeLogo: storeLogo,
                    storeBanner: storeBanner,
                    storeName: storeName,
                    storeContact: storeContact,
                    storeUrl: storeUrl,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              storeBanner.isNotEmpty
                  ? Image.network(
                      "${Env.apiBaseUrl}/uploads/$storeBanner",
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.grey,
                      child: Icon(Icons.store, size: 50, color: Colors.white),
                    ),
              storeCardInfoRow(),
              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : error != null
                        ? Center(child: Text(error!))
                        : storeItemGrid(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
