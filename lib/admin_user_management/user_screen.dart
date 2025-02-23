import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khmenu_mobile/login_module/login_screen.dart';
import 'package:khmenu_mobile/setting_module/basic_app.dart';
import 'package:provider/provider.dart';
import 'user_logic.dart';
import 'user_model.dart';

class RandomUserScreen extends StatefulWidget {
  const RandomUserScreen({super.key});

  @override
  State<RandomUserScreen> createState() => _RandomUserScreenState();
}

class _RandomUserScreenState extends State<RandomUserScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => providerBasicApp(),
                ),
              );
            }),
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search by email...",
            border: InputBorder.none,
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = "";
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Object? error = context.watch<RandomUserLogic>().error;
    bool loading = context.watch<RandomUserLogic>().loading;
    List<Doc> productList = context.watch<RandomUserLogic>().productList;

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _buildErrorMessage(error);
    } else {
      return _buildListView(productList);
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
              context.read<RandomUserLogic>().setLoading();
              context.read<RandomUserLogic>().read();
            },
            child: Text("RETRY"),
          ),
          SizedBox(height: 10), // Add spacing between buttons
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            child: Text("Login again!"),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Doc> items) {
    // Filter users based on search query
    List<Doc> filteredItems = items.where((user) {
      return user.email.toLowerCase().contains(_searchQuery);
    }).toList();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<RandomUserLogic>().setLoading();
        context.read<RandomUserLogic>().read();
      },
      child: filteredItems.isEmpty
          ? Center(child: Text("No users found"))
          : ListView.builder(
              itemCount: filteredItems.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildUserRow(filteredItems[index]);
              },
            ),
    );
  }

  Widget _buildUserRow(Doc item) {
    return GestureDetector(
      onLongPress: () => _showDeleteDialog(item),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              SizedBox(width: 16),
              CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_640.png"),
                radius: 24,
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${item.firstname} ${item.lastname}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("Email: ${item.email}"),
                    Text("Permission: ${item.permission}"),
                    Text("Created: ${item.createdDate}"),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(Doc item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete ${item.firstname}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _deleteUser(item.id);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(String userId) {
    context.read<RandomUserLogic>().deleteUser(userId);
  }
}
