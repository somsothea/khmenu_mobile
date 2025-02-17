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
  Mimetype mimetype;
  Encoding encoding;
  Userid userid;
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
        mimetype: mimetypeValues.map[json["mimetype"]]!,
        encoding: encodingValues.map[json["encoding"]]!,
        userid: useridValues.map[json["userid"]]!,
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
        "mimetype": mimetypeValues.reverse[mimetype],
        "encoding": encodingValues.reverse[encoding],
        "userid": useridValues.reverse[userid],
        "createdDate": createdDate.toIso8601String(),
        "__v": v,
      };
}

enum Encoding { THE_7_BIT }

final encodingValues = EnumValues({"7bit": Encoding.THE_7_BIT});

enum Mimetype { IMAGE_JPEG, IMAGE_PNG, IMAGE_WEBP }

final mimetypeValues = EnumValues({
  "image/jpeg": Mimetype.IMAGE_JPEG,
  "image/png": Mimetype.IMAGE_PNG,
  "image/webp": Mimetype.IMAGE_WEBP
});

enum Userid {
  THE_677_A57_C74127_DAD38_B44_A444,
  THE_677_A5_D414127_DAD38_B44_A4_EB,
  THE_677_DF9_E4648_CBD537_BAEA0_C7
}

final useridValues = EnumValues({
  "677a57c74127dad38b44a444": Userid.THE_677_A57_C74127_DAD38_B44_A444,
  "677a5d414127dad38b44a4eb": Userid.THE_677_A5_D414127_DAD38_B44_A4_EB,
  "677df9e4648cbd537baea0c7": Userid.THE_677_DF9_E4648_CBD537_BAEA0_C7
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
