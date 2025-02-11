import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie_model.dart';
import 'movie_search_logic.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: SizedBox(),
        ),
      ),
      body: _buildBody(),
    );
  }

  final _searchCtrl = TextEditingController();

  Widget _buildSearchBar() {
    return SearchBar(
      controller: _searchCtrl,
      hintText: "Search...",
      textInputAction: TextInputAction.search,
      trailing: [
        IconButton(
          onPressed: () {
            _searchCtrl.clear();
          },
          icon: Icon(Icons.cancel),
        ),
        IconButton(
          onPressed: () {
            context.read<MovieSearchLogic>().setLoading();
            context.read<MovieSearchLogic>().search(_searchCtrl.text.trim());
          },
          icon: Icon(Icons.search),
        ),
      ],
      onSubmitted: (text) {
        context.read<MovieSearchLogic>().setLoading();
        context.read<MovieSearchLogic>().search(text.trim());
      },
    );
  }

  Widget _buildBody() {
    Object? error = context.watch<MovieSearchLogic>().error;
    bool loading = context.watch<MovieSearchLogic>().loading;
    List<Doc> records = context.watch<MovieSearchLogic>().records;

    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _buildErrorMessage(error);
    } else {
      return _buildGridView(records);
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
              context.read<MovieSearchLogic>().setLoading();
              context.read<MovieSearchLogic>().search(_searchCtrl.text.trim());
            },
            child: Text("RETRY"),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(List<Search> items) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MovieSearchLogic>().setLoading();
        context.read<MovieSearchLogic>().search(_searchCtrl.text.trim());
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

  Widget _buildItem(Search item) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.poster,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${item.title}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
