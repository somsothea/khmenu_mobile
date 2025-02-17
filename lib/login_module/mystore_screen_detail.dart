import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khmenu_mobile/env.dart';
import 'store_screen_qr.dart';

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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item['title']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                "${Env.apiBaseUrl}/uploads/${item['filename']}",
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image, size: 50, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(item['description']),
              SizedBox(height: 10),
              Text("Price: \$${item['price']}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            )
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
              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : error != null
                        ? Center(child: Text(error!))
                        : GridView.builder(
                            padding: EdgeInsets.all(10),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              childAspectRatio: 4 / 5,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              var item = items[index];
                              return GestureDetector(
                                onTap: () => showItemDialog(item),
                                child: Card(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          "${Env.apiBaseUrl}/uploads/${item['filename']}",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                            color: Colors.grey,
                                            child: Icon(Icons.image, size: 50),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['title'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              "\$${item['price']}",
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
                            },
                          ),
              )
            ],
          ),
        ],
      ),
    );
  }
}