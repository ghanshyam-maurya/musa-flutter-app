// To parse this JSON data, do
//
//     final musaContributorListModel = musaContributorListModelFromJson(jsonString);

import 'dart:convert';

MusaContributorListModel musaContributorListModelFromJson(String str) => MusaContributorListModel.fromJson(json.decode(str));

String musaContributorListModelToJson(MusaContributorListModel data) => json.encode(data.toJson());

class MusaContributorListModel {
  int? status;
  String? message;
  List<ContributorsData>? data;

  MusaContributorListModel({
    this.status,
    this.message,
    this.data,
  });

  factory MusaContributorListModel.fromJson(Map<String, dynamic> json) => MusaContributorListModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<ContributorsData>.from(json["data"]!.map((x) => ContributorsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ContributorsData {
  String? id;
  String? userId;
  String? musaId;
  String? contributorId;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<UserDetail>? userDetail;
  bool? isLoading;

  ContributorsData({
    this.id,
    this.userId,
    this.musaId,
    this.contributorId,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.userDetail,
    this.isLoading = false,
  });

  factory ContributorsData.fromJson(Map<String, dynamic> json) => ContributorsData(
    id: json["_id"],
    userId: json["user_id"],
    musaId: json["musa_id"],
    contributorId: json["contributor_id"],
    status: json["status"],
    isLoading: json["isLoading"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    v: json["__v"],
    userDetail: json["user_detail"] == null ? [] : List<UserDetail>.from(json["user_detail"]!.map((x) => UserDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "user_id": userId,
    "musa_id": musaId,
    "contributor_id": contributorId,
    "status": status,
    "deleted_at": deletedAt,
    "isLoading": isLoading,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "__v": v,
    "user_detail": userDetail == null ? [] : List<dynamic>.from(userDetail!.map((x) => x.toJson())),
  };
}

class UserDetail {
  String? id;
  String? firstName;
  String? lastName;
  String? phone;
  dynamic photo;

  UserDetail({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.photo,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    id: json["_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
    "photo": photo,
  };
}
