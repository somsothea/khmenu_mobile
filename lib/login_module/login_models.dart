import 'package:flutter/material.dart';
import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  String email;
  String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

MyResponseModel loginResponseModelFromJson(String str) {
  MyResponseModel model;
  debugPrint("str: $str");
  try {
    model = MyResponseModel.fromJson(json.decode(str));
  } on FormatException {
    model = MyResponseModel.fromErrorText(str);
  }
  return model;
}

String loginResponseModelToJson(MyResponseModel data) =>
    json.encode(data.toJson());

class MyResponseModel {
  String? token;
  String? errorText;

  MyResponseModel({this.token, this.errorText});

  factory MyResponseModel.fromJson(Map<String, dynamic> json) =>
      MyResponseModel(
        token: json["accessToken"],
        errorText: null,
      );

  factory MyResponseModel.fromErrorText(text) => MyResponseModel(
        token: null,
        errorText: null,
      );

  Map<String, dynamic> toJson() => {
        "accessToken": token,
      };

  @override
  String toString() {
    return 'MyResponseModel(token: $token, errorText: $errorText)';
  }
}
