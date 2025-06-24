// To parse this JSON data, do
//
//     final mySectionSubAlbumListResponse = mySectionSubAlbumListResponseFromJson(jsonString);

import 'dart:convert';

MySectionSubAlbumListResponse mySectionSubAlbumListResponseFromJson(
        String str) =>
    MySectionSubAlbumListResponse.fromJson(json.decode(str));

String mySectionSubAlbumListResponseToJson(
        MySectionSubAlbumListResponse data) =>
    json.encode(data.toJson());

class MySectionSubAlbumListResponse {
  int? status;
  String? message;
  List<MySectionSubAlbumData>? data;

  MySectionSubAlbumListResponse({
    this.status,
    this.message,
    this.data,
  });

  factory MySectionSubAlbumListResponse.fromJson(Map<String, dynamic> json) =>
      MySectionSubAlbumListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MySectionSubAlbumData>.from(
                json["data"]!.map((x) => MySectionSubAlbumData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MySectionSubAlbumData {
  String? id;
  String? title;
  String? createdBy;
  String? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  List<FileElement>? file;
  String? albumId; // Added field for album ID

  MySectionSubAlbumData({
    this.id,
    this.title,
    this.createdBy,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.file,
    this.albumId, // Initialize album ID
  });

  factory MySectionSubAlbumData.fromJson(Map<String, dynamic> json) =>
      MySectionSubAlbumData(
        id: json["_id"],
        title: json["title"],
        createdBy: json["created_by"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        file: json["file"] == null
            ? []
            : List<FileElement>.from(
                json["file"]!.map((x) => FileElement.fromJson(x))),
        albumId: json["album_id"], // Parse album ID from JSON
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "created_by": createdBy,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "file": file == null
            ? []
            : List<dynamic>.from(file!.map((x) => x.toJson())),
        "album_id": albumId, // Include album ID in JSON output
      };
}

class FileElement {
  String? id;
  String? fileLink;

  FileElement({
    this.id,
    this.fileLink,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["_id"],
        fileLink: json["file_link"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "file_link": fileLink,
      };
}
