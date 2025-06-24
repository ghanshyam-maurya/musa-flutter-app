// To parse this JSON data, do
//
//     final socialMusaListResponse = socialMusaListResponseFromJson(jsonString);

import 'dart:convert';

SocialMusaListResponse socialMusaListResponseFromJson(String str) =>
    SocialMusaListResponse.fromJson(json.decode(str));

String socialMusaListResponseToJson(SocialMusaListResponse data) =>
    json.encode(data.toJson());

class SocialMusaListResponse {
  int? status;
  String? message;
  List<MusaData>? data;

  SocialMusaListResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SocialMusaListResponse.fromJson(Map<String, dynamic> json) =>
      SocialMusaListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MusaData>.from(
                json["data"]!.map((x) => MusaData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MusaData {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? albumId;
  String? subAlbumId;
  String? musaType;
  DateTime? createdAt;
  List<FileElement>? file;
  List<UserDetail>? userDetail;
  List<AlbumDetail>? albumDetail;
  List<AlbumDetail>? subAlbumDetail;
  int? likeCount;
  int? commentCount;
  int? audioCommentCount;
  int? textCommentCount;
  int? contributorCount;
  bool? isLikeByMe;
  int? displayCount;
  DisplayStatus? displayStatus;
  bool? isDisplayLoading;

  MusaData({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.albumId,
    this.subAlbumId,
    this.musaType,
    this.createdAt,
    this.file,
    this.userDetail,
    this.albumDetail,
    this.subAlbumDetail,
    this.likeCount,
    this.commentCount,
    this.audioCommentCount,
    this.textCommentCount,
    this.contributorCount,
    this.isLikeByMe,
    this.displayCount,
    this.displayStatus,
    this.isDisplayLoading = false,
  });

  factory MusaData.fromJson(Map<String, dynamic> json) => MusaData(
        id: json["_id"],
        userId: json["user_id"],
        title: json["title"],
        description: json["description"],
        albumId: json["album_id"],
        subAlbumId: json["sub_album_id"],
        musaType: json["musa_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        file: json["file"] == null
            ? []
            : List<FileElement>.from(
                json["file"]!.map((x) => FileElement.fromJson(x))),
        userDetail: json["userDetail"] == null
            ? []
            : List<UserDetail>.from(
                json["userDetail"]!.map((x) => UserDetail.fromJson(x))),
        albumDetail: json["album_detail"] == null
            ? []
            : List<AlbumDetail>.from(
                json["album_detail"]!.map((x) => AlbumDetail.fromJson(x))),
        subAlbumDetail: json["subAlbum_detail"] == null
            ? []
            : List<AlbumDetail>.from(
                json["subAlbum_detail"]!.map((x) => AlbumDetail.fromJson(x))),
        likeCount: json["likeCount"],
        commentCount: json["commentCount"],
        audioCommentCount: json["audioCommentCount"],
        textCommentCount: json["textCommentCount"],
        contributorCount: json["contributorCount"],
        isLikeByMe: json["isLikeByMe"],
        displayCount: json["displayCount"],
        displayStatus: json["displayStatus"] == null
            ? null
            : DisplayStatus.fromJson(json["displayStatus"]),
        isDisplayLoading: json["isDisplayLoading"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "title": title,
        "description": description,
        "album_id": albumId,
        "sub_album_id": subAlbumId,
        "musa_type": musaType,
        "created_at": createdAt?.toIso8601String(),
        "file": file == null
            ? []
            : List<dynamic>.from(file!.map((x) => x.toJson())),
        "userDetail": userDetail == null
            ? []
            : List<dynamic>.from(userDetail!.map((x) => x.toJson())),
        "album_detail": albumDetail == null
            ? []
            : List<dynamic>.from(albumDetail!.map((x) => x.toJson())),
        "subAlbum_detail": subAlbumDetail == null
            ? []
            : List<dynamic>.from(subAlbumDetail!.map((x) => x.toJson())),
        "likeCount": likeCount,
        "commentCount": commentCount,
        "audioCommentCount": audioCommentCount,
        "textCommentCount": textCommentCount,
        "contributorCount": contributorCount,
        "isLikeByMe": isLikeByMe,
        "displayCount": displayCount,
        "displayStatus": displayStatus?.toJson(),
        "isDisplayLoading": isDisplayLoading,
      };
}

class AlbumDetail {
  String? id;
  String? title;

  AlbumDetail({
    this.id,
    this.title,
  });

  factory AlbumDetail.fromJson(Map<String, dynamic> json) => AlbumDetail(
        id: json["_id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
      };
}

class FileElement {
  String? id;
  String? fileLink;
  String? previewLink;

  FileElement({
    this.id,
    this.fileLink,
    this.previewLink,
  });

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        id: json["_id"],
        fileLink: json["file_link"],
        previewLink: json["preview_link"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "file_link": fileLink,
        "preview_link": previewLink,
      };
}

class UserDetail {
  String? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? photo;

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

class DisplayStatus {
  String? id;
  String? status;

  DisplayStatus({
    this.id,
    this.status,
  });

  factory DisplayStatus.fromJson(Map<String, dynamic> json) => DisplayStatus(
        id: json["_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
      };
}
