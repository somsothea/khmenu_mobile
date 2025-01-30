// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
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
    dynamic nextPage;

    Welcome({
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

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
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
    String storename;
    String storeaddress;
    String storelogo;
    String storebanner;
    String storeurl;
    String storedescription;
    String storecontact;
    String storetelegram;
    String category;
    String userid;
    DateTime createdDate;
    int v;

    Doc({
        required this.id,
        required this.storename,
        required this.storeaddress,
        required this.storelogo,
        required this.storebanner,
        required this.storeurl,
        required this.storedescription,
        required this.storecontact,
        required this.storetelegram,
        required this.category,
        required this.userid,
        required this.createdDate,
        required this.v,
    });

    factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"],
        storename: json["storename"],
        storeaddress: json["storeaddress"],
        storelogo: json["storelogo"],
        storebanner: json["storebanner"],
        storeurl: json["storeurl"],
        storedescription: json["storedescription"],
        storecontact: json["storecontact"],
        storetelegram: json["storetelegram"],
        category: json["category"],
        userid: json["userid"],
        createdDate: DateTime.parse(json["createdDate"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "storename": storename,
        "storeaddress": storeaddress,
        "storelogo": storelogo,
        "storebanner": storebanner,
        "storeurl": storeurl,
        "storedescription": storedescription,
        "storecontact": storecontact,
        "storetelegram": storetelegram,
        "category": category,
        "userid": userid,
        "createdDate": createdDate.toIso8601String(),
        "__v": v,
    };
}
