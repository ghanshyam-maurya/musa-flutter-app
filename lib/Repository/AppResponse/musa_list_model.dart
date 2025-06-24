// import 'dart:convert';
//
// MusaListModal musaListModalFromJson(String str) =>
//     MusaListModal.fromJson(json.decode(str));
//
// String musaListModalToJson(MusaListModal data) => json.encode(data.toJson());
//
// class MusaListModal {
//   int? status;
//   String? message;
//   List<MusaData>? data;
//
//   MusaListModal({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory MusaListModal.fromJson(Map<String, dynamic> json) => MusaListModal(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null
//             ? []
//             : List<MusaData>.from(
//                 json["data"]!.map((x) => MusaData.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class MusaData {
//   String? id;
//   String? userId;
//   String? title;
//   String? description;
//   String? albumId;
//   String? subAlbumId;
//   String? musaType;
//   DateTime? createdAt;
//   List<FileElement>? file;
//   List<UserDetails>? userDetail;
//   List<AlbumDetail?>? albumDetail;
//   List<AlbumDetail?>? subAlbumDetail;
//   int? likeCount;
//   int? commentCount;
//   bool? isLiked;
//   int? contributorCount;
//   bool? isLikeByMe;
//   bool? isDisplayLoading = false;
//   int? displayCount;
//   DisplayStatus? displayStatus;
//
//   MusaData(
//       {this.id,
//       this.userId,
//       this.title,
//       this.description,
//       this.albumId,
//       this.subAlbumId,
//       this.musaType,
//       this.createdAt,
//       this.file,
//       this.userDetail,
//       this.albumDetail,
//       this.subAlbumDetail,
//       this.likeCount,
//       this.commentCount,
//       this.isLiked,
//         this.contributorCount,
//         this.isLikeByMe,
//         this.displayCount,
//         this.displayStatus,
//         this.isDisplayLoading,
//
//       });
//
//   factory MusaData.fromJson(Map<String, dynamic> json) => MusaData(
//         id: json["_id"],
//         userId: json["user_id"],
//         title: json["title"],
//         description: json["description"],
//         albumId: json["album_id"],
//         subAlbumId: json["sub_album_id"],
//         musaType: json["musa_type"],
//         createdAt: json["created_at"] == null
//             ? null
//             : DateTime.parse(json["created_at"]),
//         file: json["file"] == null
//             ? []
//             : List<FileElement>.from(
//                 json["file"]!.map((x) => FileElement.fromJson(x))),
//         userDetail: json["userDetail"] == null
//             ? []
//             : List<UserDetails>.from(
//                 json["userDetail"]!.map((x) => UserDetails.fromJson(x))),
//         albumDetail: json["album_detail"] == null
//             ? []
//             : List<AlbumDetail>.from(
//                 json["album_detail"]!.map((x) => AlbumDetail.fromJson(x))),
//         subAlbumDetail: json["subAlbum_detail"] == null
//             ? []
//             : List<AlbumDetail>.from(
//                 json["subAlbum_detail"]!.map((x) => AlbumDetail.fromJson(x))),
//         likeCount: json["likeCount"],
//         commentCount: json["commentCount"],
//         isLiked: json["isLiked"],
//     contributorCount: json["contributorCount"],
//     isLikeByMe: json["isLikeByMe"],
//     isDisplayLoading: json["isDisplayLoading"],
//     displayCount: json["displayCount"],
//     displayStatus: json["displayStatus"] == null ? null : DisplayStatus.fromJson(json["displayStatus"]),
//
//   );
//
//   Map<String, dynamic> toJson() =>
//       {
//         "_id": id,
//         "user_id": userId,
//         "title": title,
//         "description": description,
//         "album_id": albumId,
//         "sub_album_id": subAlbumId,
//         "musa_type": musaType,
//         "created_at": createdAt?.toIso8601String(),
//         "file": file == null
//             ? []
//             : List<dynamic>.from(file!.map((x) => x.toJson())),
//         "userDetail": userDetail == null
//             ? []
//             : List<dynamic>.from(userDetail!.map((x) => x.toJson())),
//         "album_detail": albumDetail == null
//             ? []
//             : List<dynamic>.from(albumDetail!.map((x) => x?.toJson())),
//         "subAlbum_detail": subAlbumDetail == null
//             ? []
//             : List<dynamic>.from(subAlbumDetail!.map((x) => x)),
//         "likeCount": likeCount,
//         "commentCount": commentCount,
//         "isLiked": isLiked,
//         "contributorCount": contributorCount,
//         "isLikeByMe": isLikeByMe,
//         "displayCount": displayCount,
//         "isDisplayLoading": isDisplayLoading,
//         "displayStatus": displayStatus?.toJson(),
//       };
// }
//
// class AlbumDetail {
//   String? id;
//   String? title;
//
//   AlbumDetail({
//     this.id,
//     this.title,
//   });
//
//   factory AlbumDetail.fromJson(Map<String, dynamic> json) => AlbumDetail(
//         id: json["_id"],
//         title: json["title"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "title": title,
//       };
// }
//
// class DisplayStatus {
//   String? id;
//   String? status;
//
//   DisplayStatus({
//     this.id,
//     this.status,
//   });
//
//   factory DisplayStatus.fromJson(Map<String, dynamic> json) => DisplayStatus(
//     id: json["_id"],
//     status: json["status"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "status": status,
//   };
// }
//
// class UserDetails {
//   String? id;
//   String? firstName;
//   String? lastName;
//   String? phone;
//   String? photo;
//
//   UserDetails({
//     this.id,
//     this.firstName,
//     this.lastName,
//     this.phone,
//     this.photo,
//   });
//
//   factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
//         id: json["_id"],
//         firstName: json["first_name"],
//         lastName: json["last_name"],
//         phone: json["phone"],
//         photo: json["photo"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "first_name": firstName,
//         "last_name": lastName,
//         "phone": phone,
//         "photo": photo,
//       };
// }
//
// class FileElement {
//   String? id;
//   String? fileLink;
//
//   FileElement({
//     this.id,
//     this.fileLink,
//   });
//
//   factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
//     id: json["_id"],
//     fileLink: json["file_link"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "file_link": fileLink,
//   };
// }
