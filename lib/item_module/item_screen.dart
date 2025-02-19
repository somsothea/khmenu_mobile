import 'package:flutter/material.dart';
import 'package:khmenu_mobile/store_module/store_screen_detail.dart';
import 'package:provider/provider.dart';
import 'package:khmenu_mobile/env.dart';
import 'item_logic.dart';
import 'item_model.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({super.key});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchCtrl,
      decoration: InputDecoration(
        hintText: "Search items...",
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _searchCtrl.clear();
            context.read<ProductLogic>().searchProducts(""); // Reset search
          },
        ),
      ),
      onChanged: (query) {
        context.read<ProductLogic>().searchProducts(query);
      },
    );
  }

  Widget _buildBody() {
    Object? error = context.watch<ProductLogic>().error;
    bool loading = context.watch<ProductLogic>().loading;
    List<ProductModel> productList = context.watch<ProductLogic>().productList;

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _buildErrorMessage(error);
    } else {
      return _buildProductGridView(productList);
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
              context.read<ProductLogic>().setLoading();
              context.read<ProductLogic>().read();
            },
            child: Text("RETRY"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGridView(List<ProductModel> items) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductLogic>().setLoading();
        context.read<ProductLogic>().read();
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
          return _buildProductItem(items[index]);
        },
      ),
    );
  }

  Widget _buildProductItem(ProductModel item) {
    return Card(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showProductDialog(item),
            child: Image.network(
              "${Env.apiBaseUrl}/uploads/${item.image}",
              width: double.infinity,
              height: 120, // Fixed height instead of Expanded
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.grey,
                  child: Icon(Icons.image, size: 50, color: Colors.white),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text("\$ ${item.price.toStringAsFixed(2)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(ProductModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(item.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image with fixed dimensions to avoid 'infinity' issues
              Container(
                width: 300, // Set a finite width
                height: 200, // Set a finite height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image:
                        NetworkImage("${Env.apiBaseUrl}/uploads/${item.image}"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: item.image == null || item.image.isEmpty
                    ? Icon(Icons.image, size: 50, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 10),
              // Price text, check if the price is valid and finite
              Text(
                "Price: \$ ${item.price != null && item.price.isFinite ? item.price.toStringAsFixed(2) : 'N/A'}",
              ),
              const SizedBox(height: 5),
              // Description text
              Text(item.description ?? 'No description available'),
              const SizedBox(height: 10),
              // Button to visit store, only if storeid is valid
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  _navigateToStoreDetail(item.storeid);
                },
                icon: Icon(Icons.store),
                label: Text("Visit Store"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _navigateToStoreDetail(String? storeId) {
    if (storeId == null || storeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Store information is missing!")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoreDetailScreen(storeId: storeId),
      ),
    );
  }
}
