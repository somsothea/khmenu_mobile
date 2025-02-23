// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    List<Doc> docs;
    int totalDocs;
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
    String username;
    String firstname;
    String lastname;
    String email;
    DateTime createdDate;
    String password;
    String type;
    String permission;
    int v;
    String? refreshToken;

    Doc({
        required this.id,
        required this.username,
        required this.firstname,
        required this.lastname,
        required this.email,
        required this.createdDate,
        required this.password,
        required this.type,
        required this.permission,
        required this.v,
        this.refreshToken,
    });

    factory Doc.fromJson(Map<String, dynamic> json) => Doc(
        id: json["_id"],
        username: json["username"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        createdDate: DateTime.parse(json["createdDate"]),
        password: json["password"],
        type: json["type"],
        permission: json["permission"],
        v: json["__v"],
        refreshToken: json["refreshToken"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "createdDate": createdDate.toIso8601String(),
        "password": password,
        "type": type,
        "permission": permission,
        "__v": v,
        "refreshToken": refreshToken,
    };
}
