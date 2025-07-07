import 'dart:convert';

class AuthResponseModel {
  final String? message;
  final int? statusCode;
  final AuthUserData? data;

  AuthResponseModel({this.message, this.statusCode, this.data});

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        message: json["message"],
        statusCode: json["status_code"],
        data: json["data"] == null ? null : AuthUserData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
    "message": message,
    "status_code": statusCode,
    "data": data?.toMap(),
  };
}

class AuthUserData {
  final int? id;
  final String? name;
  final String? email;
  final String? role;
  final String? token;

  AuthUserData({this.id, this.name, this.email, this.role, this.token});

  factory AuthUserData.fromJson(String str) => AuthUserData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AuthUserData.fromMap(Map<String, dynamic> json) => AuthUserData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    role: json["role"],
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "email": email,
    "role": role,
    "token": token,
  };
}
