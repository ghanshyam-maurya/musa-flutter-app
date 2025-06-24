// To parse this JSON data, do
//
//     final createAlbumResponse = createAlbumResponseFromJson(jsonString);

import 'dart:convert';

CreateAlbumResponse createAlbumResponseFromJson(String str) => CreateAlbumResponse.fromJson(json.decode(str));

String createAlbumResponseToJson(CreateAlbumResponse data) => json.encode(data.toJson());

class CreateAlbumResponse {
  int? status;
  String? message;
  CreateAlbumData? data;

  CreateAlbumResponse({
    this.status,
    this.message,
    this.data,
  });

  factory CreateAlbumResponse.fromJson(Map<String, dynamic> json) => CreateAlbumResponse(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : CreateAlbumData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class CreateAlbumData {
  String? id;
  String? title;

  CreateAlbumData({
    this.id,
    this.title,
  });

  factory CreateAlbumData.fromJson(Map<String, dynamic> json) => CreateAlbumData(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
