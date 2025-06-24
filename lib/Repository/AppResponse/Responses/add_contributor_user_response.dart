// To parse this JSON data, do
//
//     final addContributorUserResponse = addContributorUserResponseFromJson(jsonString);

import 'dart:convert';

AddContributorUserResponse addContributorUserResponseFromJson(String str) => AddContributorUserResponse.fromJson(json.decode(str));

String addContributorUserResponseToJson(AddContributorUserResponse data) => json.encode(data.toJson());

class AddContributorUserResponse {
  int? status;
  String? message;
  List<Users>? users;

  AddContributorUserResponse({
    this.status,
    this.message,
    this.users,
  });

  factory AddContributorUserResponse.fromJson(Map<String, dynamic> json) => AddContributorUserResponse(
    status: json["status"],
    message: json["message"],
    users: json["data"] == null ? [] : List<Users>.from(json["data"]!.map((x) => Users.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": users == null ? [] : List<dynamic>.from(users!.map((x) => x.toJson())),
  };
}

class Users {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? photo;
  String? bio;
  int? contributeStatus;
  String? musaId;

  Users({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.photo,
    this.bio,
    this.contributeStatus,
    this.musaId,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    photo: json["photo"],
    bio: json["bio"],
    contributeStatus: json["contributeStatus"],
    musaId: json["musaId"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "photo": photo,
    "bio": bio,
    "contributeStatus": contributeStatus,
    "musaId": musaId,
  };
}
