// To parse this JSON data, do
//
//     final displayRequestModel = displayRequestModelFromJson(jsonString);

import 'dart:convert';

DisplayRequestModel displayRequestModelFromJson(String str) => DisplayRequestModel.fromJson(json.decode(str));

String displayRequestModelToJson(DisplayRequestModel data) => json.encode(data.toJson());

class DisplayRequestModel {
  int? status;
  String? message;
  Data? data;

  DisplayRequestModel({
    this.status,
    this.message,
    this.data,
  });

  factory DisplayRequestModel.fromJson(Map<String, dynamic> json) => DisplayRequestModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? senderId;
  String? receiverId;
  String? musaId;
  String? status;
  dynamic deletedAt;
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Data({
    this.senderId,
    this.receiverId,
    this.musaId,
    this.status,
    this.deletedAt,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    musaId: json["musa_id"],
    status: json["status"],
    deletedAt: json["deleted_at"],
    id: json["_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "sender_id": senderId,
    "receiver_id": receiverId,
    "musa_id": musaId,
    "status": status,
    "deleted_at": deletedAt,
    "_id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
