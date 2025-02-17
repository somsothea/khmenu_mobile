import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';

class AboutStateScreen extends StatelessWidget {
  int _counter = 0;

  AboutStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _counter = context.watch<CounterLogic>().counter;

    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().decrease();
              debugPrint("counter: $_counter");
            },
            icon: Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().increase();
              debugPrint("counter: $_counter");
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mission",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              "We offer free digital menu platform for traders, without any hidden fees or complicated contracts. Our goal is to provide a straightforward and cost-effective solution that meets the needs of your business, allowing you to focus on delivering exceptional digital experiences to your customers.",
            ),
            SizedBox(height: 20), // Added spacing
            Text(
              "Features",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 10),
            _buildContentsCards(), // Call to the new method that builds the team cards
          ],
        ),
      ),
    );
  }

  Widget _buildContentsCards() {
    final List<Map<String, String>> contents = [
      {
        "title": "Mobile Friendly",
        "description":
            "With just a scan, customers can easily access the menu on their smartphones without the need for physical menus or waiting for a server to bring one. This eliminates the hassle of handling paper menus and allows for a seamless browsing experience, enhancing customer satisfaction.",
        "imageUrl": "https://picsum.photos/200/300?Mobile"
      },
      {
        "title": "Faster Speed",
        "description":
            "Ability to provide a fast and efficient dining experience. With just a quick scan of the QR code, customers can access the menu instantly on their smartphones, eliminating the need for physical menus and reducing wait times.",
        "imageUrl": "https://picsum.photos/200/300?Speed"
      },
      {
        "title": "Easy to Maintain",
        "description":
            "Can be updated quickly and effortlessly, ensuring that the information provided to customers is always accurate and up-to-date.",
        "imageUrl": "https://picsum.photos/200/300?Maintain"
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: contents.map((content) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      content["imageUrl"]!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content["title"]!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          content["description"]!,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
