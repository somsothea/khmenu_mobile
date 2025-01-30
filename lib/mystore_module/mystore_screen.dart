import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'store_logic.dart';
import 'store_model.dart';
import 'add_store_screen.dart';

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
        title: Text("My Stores"),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Navigate to the add store screen or show a dialog
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddStoreScreen()),
        );
      },
      child: Icon(Icons.add),
      tooltip: "Add New Store",
    ),
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
          crossAxisCount: 2,
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
              "https://khmenu.cloud/uploads/${item.storelogo}",
              width: double.infinity,// Ensures it takes full height
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
}
