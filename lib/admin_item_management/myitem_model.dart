// To parse this JSON data, do
//
//     final myItem = myItemFromJson(jsonString);

import 'dart:convert';

MyItem myItemFromJson(String str) => MyItem.fromJson(json.decode(str));

String myItemToJson(MyItem data) => json.encode(data.toJson());

class MyItem {
  List<Doc> docs;
  int totalDocs;
  int offset;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  int nextPage;

  MyItem({
    required this.docs,
    required this.totalDocs,
    required this.offset,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.prevPage,
    required this.nextPage,
  });

  factory MyItem.fromJson(Map<String, dynamic> json) => MyItem(
        docs: List<Doc>.from(json["docs"].map((x) => Doc.fromJson(x))),
        totalDocs: json["totalDocs"],
        offset: json["offset"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        page: json["page"],
        pagingCounter: json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"],
        hasNextPage: json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
        "totalDocs": totalDocs,
        "offset": offset,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class Doc {
  String id;
  int price;
  String title;
  String category;
  String description;
  String filename;
  String userid;
  String storeid;
  DateTime createdDate;
  int v;

  Doc({
    required this.id,
    required this.price,
    required this.title,
    required this.category,
    required this.description,
    required this.filename,
    required this.userid,
    required this.storeid,
    required this.createdDate,
    required this.v,
  });

  factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"] ?? "", // Default empty string if null
        price: json["price"] ?? 0, // Default to 0 if null
        title: json["title"] ?? "No Title",
        category: json["category"] ?? "Uncategorized",
        description: json["description"] ?? "",
        filename: json["filename"] ?? "",
        userid: json["userid"] ?? "",
        storeid: json["storeid"] ?? "",
        createdDate: json["createdDate"] != null
            ? DateTime.parse(json["createdDate"])
            : DateTime.now(),
        v: json["__v"] ?? 0, // Default to 0 if null
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "price": price,
        "title": title,
        "category": category,
        "description": description,
        "filename": filename,
        "userid": userid,
        "storeid": storeid,
        "createdDate": createdDate.toIso8601String(),
        "__v": v,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
