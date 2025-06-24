// To parse this JSON data, do
//
//     final mySubAlbumListResponse = mySubAlbumListResponseFromJson(jsonString);

import 'dart:convert';

MySubAlbumListResponse mySubAlbumListResponseFromJson(String str) => MySubAlbumListResponse.fromJson(json.decode(str));

String mySubAlbumListResponseToJson(MySubAlbumListResponse data) => json.encode(data.toJson());

class MySubAlbumListResponse {
  int? status;
  List<SubAlbumData>? data;

  MySubAlbumListResponse({
    this.status,
    this.data,
  });

  factory MySubAlbumListResponse.fromJson(Map<String, dynamic> json) => MySubAlbumListResponse(
    status: json["status"],
    data: json["data"] == null ? [] : List<SubAlbumData>.from(json["data"]!.map((x) => SubAlbumData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SubAlbumData {
  String? id;
  String? title;
  String? createdBy;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  SubAlbumData({
    this.id,
    this.title,
    this.createdBy,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory SubAlbumData.fromJson(Map<String, dynamic> json) => SubAlbumData(
    id: json["_id"],
    title: json["title"],
    createdBy: json["created_by"],
    userId: json["user_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "created_by": createdBy,
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
