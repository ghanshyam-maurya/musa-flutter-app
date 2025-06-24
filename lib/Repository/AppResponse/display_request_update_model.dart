// To parse this JSON data, do
//
//     final displayRequestUpdate = displayRequestUpdateFromJson(jsonString);

import 'dart:convert';

DisplayRequestUpdate displayRequestUpdateFromJson(String str) => DisplayRequestUpdate.fromJson(json.decode(str));

String displayRequestUpdateToJson(DisplayRequestUpdate data) => json.encode(data.toJson());

class DisplayRequestUpdate {
  int? success;
  String? message;
  UpdatedSubject? updatedSubject;

  DisplayRequestUpdate({
    this.success,
    this.message,
    this.updatedSubject,
  });

  factory DisplayRequestUpdate.fromJson(Map<String, dynamic> json) => DisplayRequestUpdate(
    success: json["success"],
    message: json["message"],
    updatedSubject: json["updatedSubject"] == null ? null : UpdatedSubject.fromJson(json["updatedSubject"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "updatedSubject": updatedSubject?.toJson(),
  };
}

class UpdatedSubject {
  String? id;
  String? senderId;
  String? receiverId;
  String? musaId;
  String? status;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  UpdatedSubject({
    this.id,
    this.senderId,
    this.receiverId,
    this.musaId,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory UpdatedSubject.fromJson(Map<String, dynamic> json) => UpdatedSubject(
    id: json["_id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    musaId: json["musa_id"],
    status: json["status"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "musa_id": musaId,
    "status": status,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "__v": v,
  };
}
