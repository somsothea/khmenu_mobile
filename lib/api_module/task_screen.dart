import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Screen"),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Hello"),
                ),
              );
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      drawer: Drawer(),
      body: _buildBody(),
    );
  }

  Future<int> _getData(int max) {
    return compute(_getTotal, max);
  }

  Future<String> _getOnlineData() async {
    String url = "https://fakestoreapi.com/products";
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  Widget _buildBody() {
    return Center(
      child: FutureBuilder<String>(
        future: _getOnlineData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("${snapshot.error.toString()}");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return _buildOutput(snapshot.data);
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Widget _buildOutput(String? data) {
    if (data == null) {
      return Icon(Icons.error);
    }

    List list = json.decode(data);
    List<Map<String, dynamic>> records =
        list.map((x) => x as Map<String, dynamic>).toList();

    return _buildListView(records);
  }

  Widget _buildListView(List<Map<String, dynamic>> records) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: records.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> item = records[index];
        return _buildItem(item);
      },
    );
  }

Widget _buildItem(Map<String, dynamic> item) {
    return Card(
      child: ListTile(
        leading: Image.network(
          item['image'],
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(item['title']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: \$${item['price']}",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Category: ${item['category']}"),
            Text("Rating: ${item['rating']['rate']} (Count: ${item['rating']['count']})"),
            Text("\n${item['description']}", maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}

int _getTotal(int max) {
  int total = 0;
  for (int index = 0; index < max; index++) {
    total += index;
  }
  return total;
}
