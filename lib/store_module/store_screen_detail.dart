import 'package:flutter/material.dart';
import 'package:khmenu_mobile/env.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:khmenu_mobile/login_module/mystore_screen_qr.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreDetailScreen extends StatefulWidget {
  final String storeId;

  const StoreDetailScreen({super.key, required this.storeId});

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  String storeName = "";
  String storeBanner = "";
  String storeLogo = "";
  String storeAddress = "";
  String storeUrl = "";
  String storeContact = "";
  String storeTelegram = "";
  List<dynamic> items = [];
  bool loading = true;
  bool storeNotFound = false; // Flag to check if store exists
  String? error;

  @override
  void initState() {
    super.initState();
    fetchStoreDetails();
    fetchItems();
  }

  Future<void> fetchStoreDetails() async {
    String url = "${Env.apiBaseUrl}/v1/stores/${widget.storeId}";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == null || data.isEmpty) {
          setState(() {
            storeNotFound = true;
            loading = false;
          });
          return;
        }

        setState(() {
          storeName = data['storename'] ?? "";
          storeBanner = data['storebanner'] ?? "";
          storeLogo = data['storelogo'] ?? "";
          storeAddress = data['storeaddress'] ?? "";
          storeUrl = data['storeurl'] ?? "";
          storeContact = data['storecontact'] ?? "";
          storeTelegram = data['storetelegram'] ?? "";
          loading = false;
        });
      } else {
        setState(() {
          storeNotFound = true;
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
    String url = "${Env.apiBaseUrl}/v1/items/store/${widget.storeId}";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body);
        });
      } else {
        setState(() {
          error = "Failed to load items";
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  void showItemDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item['title']),
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
                Text(item['description'] ?? 'No description available'),
                SizedBox(height: 10),
                Text("Price: \$ ${item['price']}",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.phone),
                      onPressed: () {
                        _launchInBrowser(storeContact);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.telegram),
                      onPressed: () {
                        _launchInBrowser(storeTelegram);
                      },
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget storeItem(Map<String, dynamic> item) {
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
    if (items.isEmpty) {
      return Center(child: Text("No items available"));
    }
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
              GestureDetector(
                onTap: () => _launchInBrowser(storeTelegram),
                child: Text(
                  storeTelegram,
                  style: TextStyle(
                    color: Colors.blue,
                    decoration:
                        TextDecoration.underline, // Makes it look like a link
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String uri) async {
    Uri url = Uri.parse(uri);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(storeNotFound
            ? "Store Not Found"
            : storeName.isEmpty
                ? "Store"
                : storeName),
        actions: storeNotFound
            ? []
            : [
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
      body: loading
          ? Center(child: CircularProgressIndicator())
          : storeNotFound
              ? Center(
                  child: Text("Store Not Found",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))
              : Column(
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
                            child: Icon(Icons.store,
                                size: 50, color: Colors.white),
                          ),
                    storeCardInfoRow(),
                    Expanded(
                        child: error != null
                            ? Center(child: Text(error!))
                            : storeItemGrid()),
                  ],
                ),
    );
  }
}
