// To parse this JSON data, do
//
//     final myFile = myFileFromJson(jsonString);

import 'dart:convert';

List<MyFile> myFileFromJson(String str) =>
    List<MyFile>.from(json.decode(str).map((x) => MyFile.fromJson(x)));

String myFileToJson(List<MyFile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyFile {
  String id;
  String filename;
  String originalname;
  int size;
  String path;
  String key;
  String mimetype;
  String encoding;
  String userid;
  DateTime createdDate;
  int v;

  MyFile({
    required this.id,
    required this.filename,
    required this.originalname,
    required this.size,
    required this.path,
    required this.key,
    required this.mimetype,
    required this.encoding,
    required this.userid,
    required this.createdDate,
    required this.v,
  });

  factory MyFile.fromJson(Map<String, dynamic> json) => MyFile(
        id: json["_id"],
        filename: json["filename"],
        originalname: json["originalname"],
        size: json["size"],
        path: json["path"],
        key: json["key"],
        mimetype: json["mimetype"],
        encoding: json["encoding"],
        userid: json["userid"],
        createdDate: DateTime.parse(json["createdDate"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "filename": filename,
        "originalname": originalname,
        "size": size,
        "path": path,
        "key": key,
        "mimetype": mimetype,
        "encoding": encoding,
        "userid": userid,
        "createdDate": createdDate.toIso8601String(),
        "__v": v,
      };
}
