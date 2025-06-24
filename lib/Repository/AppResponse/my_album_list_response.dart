// To parse this JSON data, do
//
//     final myAlbumListResponse = myAlbumListResponseFromJson(jsonString);

import 'dart:convert';

MyAlbumListResponse myAlbumListResponseFromJson(String str) => MyAlbumListResponse.fromJson(json.decode(str));

String myAlbumListResponseToJson(MyAlbumListResponse data) => json.encode(data.toJson());

class MyAlbumListResponse {
  int? status;
  List<AlbumData>? data;

  MyAlbumListResponse({
    this.status,
    this.data,
  });

  factory MyAlbumListResponse.fromJson(Map<String, dynamic> json) => MyAlbumListResponse(
    status: json["status"],
    data: json["data"] == null ? [] : List<AlbumData>.from(json["data"]!.map((x) => AlbumData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AlbumData {
  String? id;
  String? title;
  String? createdBy;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  AlbumData({
    this.id,
    this.title,
    this.createdBy,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory AlbumData.fromJson(Map<String, dynamic> json) => AlbumData(
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
