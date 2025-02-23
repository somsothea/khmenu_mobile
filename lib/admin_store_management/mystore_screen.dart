import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khmenu_mobile/login_module/mystore_screen_detail.dart';
import 'package:provider/provider.dart';
import 'package:khmenu_mobile/env.dart';
import 'mystore_logic.dart';
import 'mystore_model.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Stores"),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
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
          crossAxisCount: 4,
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
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(item),
      onTap: () {
        // Move onTap here inside GestureDetector
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyStoreScreenDetail(
              storeid: item.id, // Ensure you pass the correct ID
            ),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                "${Env.apiBaseUrl}/uploads/${item.storelogo}",
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    color: Colors.grey,
                    child: Icon(Icons.image, size: 50, color: Colors.white),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.storename,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Doc item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Store"),
          content: Text("Are you sure you want to delete ${item.storename}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deleteStore(item);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteStore(Doc store) async {
    String? token = await Env.apiStorage.read(key: Env.apiKey);
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Authentication required")),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse("${Env.apiBaseUrl}/v1/mystores/${store.id}"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${store.storename} deleted successfully")),
        );
        context.read<StoreLogic>().read(); // Refresh store list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete store: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: ${e.toString()}")),
      );
    }
  }
}
