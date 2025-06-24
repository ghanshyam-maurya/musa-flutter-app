// To parse this JSON data, do
//
//     final createSubAlbumResponse = createSubAlbumResponseFromJson(jsonString);

import 'dart:convert';

CreateSubAlbumResponse createSubAlbumResponseFromJson(String str) => CreateSubAlbumResponse.fromJson(json.decode(str));

String createSubAlbumResponseToJson(CreateSubAlbumResponse data) => json.encode(data.toJson());

class CreateSubAlbumResponse {
  int? status;
  String? message;
  CreateSubAlbumData? data;

  CreateSubAlbumResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateSubAlbumResponse.fromJson(Map<String, dynamic> json) => CreateSubAlbumResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : CreateSubAlbumData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class CreateSubAlbumData {
  String? id;
  String? title;
  String? albumId;

  CreateSubAlbumData({
    this.id,
    this.title,
    this.albumId,
  });

  factory CreateSubAlbumData.fromJson(Map<String, dynamic> json) => CreateSubAlbumData(
    id: json["id"],
    title: json["title"],
    albumId: json["album_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "album_id": albumId,
  };
}
