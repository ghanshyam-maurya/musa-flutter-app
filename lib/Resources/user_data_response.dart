// To parse this JSON data, do
//
//     final userDataResponse = userDataResponseFromJson(jsonString);

import 'dart:convert';

import '../Repository/AppResponse/Responses/logged_in_response.dart';

UserDataResponse userDataResponseFromJson(String str) => UserDataResponse.fromJson(json.decode(str));

String userDataResponseToJson(UserDataResponse data) => json.encode(data.toJson());

class UserDataResponse {
  int? status;
  String? message;
  User? user;

  UserDataResponse({
    this.status,
    this.message,
    this.user,
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) => UserDataResponse(
    status: json["status"],
    message: json["message"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user?.toJson(),
  };
}

