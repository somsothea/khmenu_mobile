import 'package:flutter/material.dart';

import 'image_data.dart';

class FbScreen extends StatelessWidget {
  const FbScreen({super.key});

  // const FbScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FB Screen"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _buildMainListView();
  }

  Widget _buildMainListView() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        _buildFoodStoryListView(foodList, 300, 180),
        _buildFoodListView(),
        _buildFoodStoryListView(foodList, 300, 180),
        _buildFoodListView(),
      ],
    );
  }

  Widget _buildFoodListView() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10),
      // physics: BouncingScrollPhysics(),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: foodList.length,
      itemBuilder: (context, index) {
        return _buildFoodItem(foodList[index]);
      },
    );
  }

  Widget _buildFoodItem(String image) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          image,
          fit: BoxFit.cover,
          width: double.maxFinite,
        ),
      ),
    );
  }

  Widget _buildFoodStoryListView(
      List<String> items, double height, double width) {
    return Container(
      height: height,
      padding: EdgeInsets.all(10),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildFoodStoryItem(items[index], width);
        },
      ),
    );
  }

  Widget _buildFoodStoryItem(String image, width) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          image,
          fit: BoxFit.cover,
          height: double.maxFinite,
        ),
      ),
    );
  }
}
