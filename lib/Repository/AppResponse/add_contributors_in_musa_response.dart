// To parse this JSON data, do
//
//     final addContributorsInMusaResponse = addContributorsInMusaResponseFromJson(jsonString);

import 'dart:convert';

AddContributorsInMusaResponse addContributorsInMusaResponseFromJson(String str) => AddContributorsInMusaResponse.fromJson(json.decode(str));

String addContributorsInMusaResponseToJson(AddContributorsInMusaResponse data) => json.encode(data.toJson());

class AddContributorsInMusaResponse {
  int? status;
  String? message;
  List<Datum>? data;

  AddContributorsInMusaResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AddContributorsInMusaResponse.fromJson(Map<String, dynamic> json) => AddContributorsInMusaResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? contributorId;
  String? status;
  Musa? musa;

  Datum({
    this.contributorId,
    this.status,
    this.musa,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    contributorId: json["contributor_id"],
    status: json["status"],
    musa: json["musa"] == null ? null : Musa.fromJson(json["musa"]),
  );

  Map<String, dynamic> toJson() => {
    "contributor_id": contributorId,
    "status": status,
    "musa": musa?.toJson(),
  };
}

class Musa {
  String? userId;
  String? musaId;
  String? contributorId;
  String? status;
  dynamic deletedAt;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Musa({
    this.userId,
    this.musaId,
    this.contributorId,
    this.status,
    this.deletedAt,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Musa.fromJson(Map<String, dynamic> json) => Musa(
    userId: json["user_id"],
    musaId: json["musa_id"],
    contributorId: json["contributor_id"],
    status: json["status"],
    deletedAt: json["deleted_at"],
    id: json["_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "musa_id": musaId,
    "contributor_id": contributorId,
    "status": status,
    "deleted_at": deletedAt,
    "_id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
