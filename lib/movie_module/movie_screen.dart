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
        context.read<MovieLogic>().readAppend();
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
        title: Text("Movie Screen"),
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
    Object? error = context.watch<MovieLogic>().error;
    bool loading = context.watch<MovieLogic>().loading;
    List<Search> records = context.watch<MovieLogic>().records;

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
              context.read<MovieLogic>().setLoading();
              context.read<MovieLogic>().read();
            },
            child: Text("RETRY"),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<Search> items) {
    bool showLoading = context.watch<MovieLogic>().showLoading;
    bool endOfResult = context.watch<MovieLogic>().endOfResult;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<MovieLogic>().setLoading();
        context.read<MovieLogic>().read();
      },
      child: showLoading == false || endOfResult == true
          ? _buildList(items)
          : _buildListPlusOne(items),
    );
  }

  Widget _buildList(List<Search> items) {
    return ListView.builder(
      controller: _scroller,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildListItem(items[index]);
      },
    );
  }

  Widget _buildListPlusOne(List<Search> items) {
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

  Widget _buildListItem(Search item) {
    return Card(
      child: ListTile(
        title: Image.network(item.poster),
        subtitle: Text("${item.title}"),
      ),
    );
  }

  // Widget _buildGridView(List<Search> items) {
  //   return RefreshIndicator(
  //     onRefresh: () async {
  //       context.read<MovieLogic>().setLoading();
  //       context.read<MovieLogic>().read();
  //     },
  //     child: GridView.builder(
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         mainAxisSpacing: 5,
  //         crossAxisSpacing: 5,
  //         childAspectRatio: 4 / 6,
  //       ),
  //       itemCount: items.length,
  //       physics: BouncingScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         return _buildItem(items[index]);
  //       },
  //     ),
  //   );
  // }

  // Widget _buildItem(Search item) {
  //   return Card(
  //     child: Column(
  //       children: [
  //         Expanded(
  //           child: ClipRRect(
  //             borderRadius: BorderRadius.circular(10),
  //             child: Image.network(
  //               item.poster,
  //               width: double.maxFinite,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             "${item.title}",
  //             maxLines: 1,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
