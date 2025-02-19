// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
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

    Welcome({
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

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        id: json["_id"]?? "",
        storename: json["storename"]?? "No Store",
        storeaddress: json["storeaddress"]?? "",
        storelogo: json["storelogo"]?? "",
        storebanner: json["storebanner"]?? "",
        storeurl: json["storeurl"]?? "",
        storedescription: json["storedescription"]?? "No description",
        storecontact: json["storecontact"]?? "",
        storetelegram: json["storetelegram"]?? "",
        category: json["category"]?? "",
        userid: json["userid"]?? "",
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
