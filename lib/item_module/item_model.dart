// To parse this JSON data, do
//
import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  String id;
  String title;
  double price;
  String description;
  String category;
  String image;
  String userid;
  String storeid;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.userid,
    required this.storeid,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      id: json["_id"] ?? "", // Ensure id is not null
      title: json["title"] ?? "No title", // Default title
      price: (json["price"] ?? 0).toDouble(), // Default price
      description: json["description"] ?? "No description", // Default description
      category: json["category"] ?? "Uncategorized", // Default category
      image: json["filename"] ?? "", // Default empty string for image
      userid: json["userid"] ?? "", // Default empty string
      storeid: json["storeid"] ?? "", // Default empty strin
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "category": category,
        "image": image,
        "userid": userid,
        "storeid": storeid,
      };
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
        rate: json["rate"]?.toDouble(),
        count: json["count"],
      );
}
