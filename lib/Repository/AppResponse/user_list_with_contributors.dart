// To parse this JSON data, do
//
//     final userListWithContributorStatus = userListWithContributorStatusFromJson(jsonString);

import 'dart:convert';

UserListWithContributorStatus userListWithContributorStatusFromJson(String str) => UserListWithContributorStatus.fromJson(json.decode(str));

String userListWithContributorStatusToJson(UserListWithContributorStatus data) => json.encode(data.toJson());

class UserListWithContributorStatus {
  int? status;
  String? message;
  List<UserData>? data;

  UserListWithContributorStatus({
    this.status,
    this.message,
    this.data,
  });

  factory UserListWithContributorStatus.fromJson(Map<String, dynamic> json) => UserListWithContributorStatus(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<UserData>.from(json["data"]!.map((x) => UserData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class UserData {
  String? id;
  String? firstName;
  String? lastName;
  dynamic photo;
  int? contributeStatus;
  String? musaId;
  bool? isLoading;

  UserData({
    this.id,
    this.firstName,
    this.lastName,
    this.photo,
    this.contributeStatus,
    this.musaId,
    this.isLoading = false
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    id: json["_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    photo: json["photo"],
    contributeStatus: json["contributeStatus"],
    musaId: json["musaId"],
    isLoading: json["isLoading"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "first_name": firstName,
    "last_name": lastName,
    "photo": photo,
    "contributeStatus": contributeStatus,
    "musaId": musaId,
    "isLoading": isLoading,
  };
}
