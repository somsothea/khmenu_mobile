import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  String username;
  String password;

  LoginRequestModel({
    required this.username,
    required this.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        username: json["username"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}

LoginResponseModel loginResponseModelFromJson(String str) {
  LoginResponseModel model;
  try {
    model = LoginResponseModel.fromJson(json.decode(str));
  } on FormatException catch (e) {
    model = LoginResponseModel.fromErrorText(str);
  }
  return model;
}

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  String? token;
  String? errorText;

  LoginResponseModel({this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        token: json["token"],
      );

  LoginResponseModel.fromErrorText(String text) {
    errorText = text;
  }

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
