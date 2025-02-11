import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie_logic.dart';
import 'movie_model.dart';
import 'movie_search_screen.dart';

class MovieScreen extends StatefulWidget {
  const MovieScreen({super.key});

  @override
  State<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final _scroller = ScrollController();
  bool _showUpButton = false;

  @override
  void initState() {
    super.initState();
    _scroller.addListener(_scrollListener);
  }

  _scrollListener() {
    setState(() {
      if (_scroller.hasClients && _scroller.position.pixels >= 1000) {
        _showUpButton = true;
      } else {
        _showUpButton = false;
      }

      if (_scroller.hasClients &&
          _scroller.position.pixels == _scroller.position.maxScrollExtent) {
        debugPrint("Reached the bottom");
        context.read<StoreLogic>().readAppend();
      }
    });
  }

  @override
  void dispose() {
    _scroller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Store"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => MovieSearchScreen(),
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _showUpButton ? _buildUpButton() : null,
    );
  }

  Widget _buildUpButton() {
    return FloatingActionButton(
      child: Icon(Icons.arrow_upward),
      onPressed: () {
        _scroller.animateTo(
          0.0,
          duration: Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  Widget _buildBody() {
    Object? error = context.watch<StoreLogic>().error;
    bool loading = context.watch<StoreLogic>().loading;
    List<Doc> records = context.watch<StoreLogic>().docs;

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _buildErrorMessage(error);
    } else {
      return _buildListView(records);
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

  Widget _buildListView(List<Doc> items) {
    bool showLoading = context.watch<StoreLogic>().showLoading;
    bool endOfResult = context.watch<StoreLogic>().endOfResult;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<StoreLogic>().setLoading();
        context.read<StoreLogic>().read();
      },
      child: showLoading == false || endOfResult == true
          ? _buildList(items)
          : _buildListPlusOne(items),
    );
  }

  Widget _buildList(List<Doc> items) {
    return ListView.builder(
      controller: _scroller,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildListItem(items[index]);
      },
    );
  }

  Widget _buildListPlusOne(List<Doc> items) {
    return ListView.builder(
      controller: _scroller,
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index < items.length) {
          return _buildListItem(items[index]);
        } else {
          return Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildListItem(Doc item) {
    return Card(
      child: ListTile(
        title: Image.network(item.storelogo),
        subtitle: Text("${item.storename}"),
      ),
    );
  }
}
