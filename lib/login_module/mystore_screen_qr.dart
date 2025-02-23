import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:khmenu_mobile/env.dart';

class StoreScreenQR extends StatelessWidget {
  final String storeLogo;
  final String storeBanner;
  final String storeName;
  final String storeContact;
  final String storeUrl;

  const StoreScreenQR({
    super.key,
    required this.storeLogo,
    required this.storeBanner,
    required this.storeName,
    required this.storeContact,
    required this.storeUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Store Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display Store Banner
            Image.network("${Env.apiBaseUrl}/uploads/$storeBanner",
                width: double.infinity, height: 200, fit: BoxFit.cover),
            SizedBox(height: 10),
            // Display Store Logo
            CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage("${Env.apiBaseUrl}/uploads/$storeLogo")),
            SizedBox(height: 10),
            // Store Name (Centered)
            Center(
              child: Text(
                storeName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            // Store Contact and URL
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Contact: $storeContact",
                      style: TextStyle(fontSize: 18)),
                  Text("URL: ${Env.apiBaseUrl}/stores/$storeUrl",
                      style: TextStyle(fontSize: 14)),
                  SizedBox(height: 20),
                  Center(
                    child: QrImageView(
                      data: "${Env.apiBaseUrl}/stores/$storeUrl",
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ), // Generate QR Code for Store URL
                ],
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: "${Env.apiBaseUrl}/stores/$storeUrl"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Store link copied!")),
                  );
                },
                icon: Icon(Icons.copy),
                label: Text("Copy Store URL"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
