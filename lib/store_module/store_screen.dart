import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:khmenu_mobile/env.dart';
import 'store_logic.dart';
import 'store_model.dart';
import 'store_screen_detail.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
      ),
      body: _buildScrollView(),
    );
  }

  Widget _buildScrollView() {
    return Consumer<StoreLogic>(
      builder: (context, storeLogic, child) {
        Object? error = storeLogic.error;
        bool loading = storeLogic.loading;
        List<Welcome> storeList = storeLogic.storeList;

        return RefreshIndicator(
          onRefresh: () async {
            storeLogic.setLoading();
            storeLogic.read();
          },
          child: CustomScrollView(
            slivers: [
              // Sliver for the carousel
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 3.0, right: 3.0, bottom: 5.0),
                  child: _buildCarousel(),
                ),
              ),
              // Handle loading and error states
              if (loading)
                SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (error != null)
                SliverFillRemaining(
                  child: _buildErrorMessage(error),
                )
              else
                _buildSliverGrid(storeList),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCarousel() {
    List<String> images = [
      "${Env.apiBaseUrl}/uploads/banner1.jpg",
      "${Env.apiBaseUrl}/uploads/banner2.jpg",
      "${Env.apiBaseUrl}/uploads/banner3.jpg",
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.98,
      ),
      items: images.map((imageUrl) {
        return Builder(
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchCtrl,
      decoration: InputDecoration(
        hintText: "Search stores...",
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _searchCtrl.clear();
            context.read<StoreLogic>().searchStores(""); // Reset search
          },
        ),
      ),
      onChanged: (query) {
        context.read<StoreLogic>().searchStores(query);
      },
    );
  }

  Widget _buildErrorMessage(Object error) {
    debugPrint(error.toString());
    return Column(
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
    );
  }

  Widget _buildSliverGrid(List<Welcome> items) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildItem(items[index]),
          childCount: items.length,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 4 / 6,
        ),
      ),
    );
  }

  Widget _buildItem(Welcome item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreDetailScreen(
              storeId: item.id,
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
}
