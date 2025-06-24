// To parse this JSON data, do
//
//     final mySectionAlbumListResponse = mySectionAlbumListResponseFromJson(jsonString);

import 'dart:convert';

import 'my_section_sub_album_list.dart';

MySectionAlbumListResponse mySectionAlbumListResponseFromJson(String str) => MySectionAlbumListResponse.fromJson(json.decode(str));

String mySectionAlbumListResponseToJson(MySectionAlbumListResponse data) => json.encode(data.toJson());

class MySectionAlbumListResponse {
  int? status;
  String? message;
  List<MySectionAlbumData>? data;

  MySectionAlbumListResponse({
    this.status,
    this.message,
    this.data,
  });

  factory MySectionAlbumListResponse.fromJson(Map<String, dynamic> json) => MySectionAlbumListResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<MySectionAlbumData>.from(json["data"]!.map((x) => MySectionAlbumData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class MySectionAlbumData {
  String? id;
  String? title;
  String? createdBy;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<FileElement>? file;
  int? subAlbumCount;

  MySectionAlbumData({
    this.id,
    this.title,
    this.createdBy,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.file,
    this.subAlbumCount,
  });

  factory MySectionAlbumData.fromJson(Map<String, dynamic> json) => MySectionAlbumData(
    id: json["_id"],
    title: json["title"],
    createdBy: json["created_by"],
    userId: json["user_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    file: json["file"] == null ? [] : List<FileElement>.from(json["file"]!.map((x) => FileElement.fromJson(x))),
    subAlbumCount: json["sub_album_count"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "created_by": createdBy,
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "file": file == null ? [] : List<dynamic>.from(file!.map((x) => x.toJson())),
    "sub_album_count": subAlbumCount,
  };
}
