// To parse this JSON data, do
//
//     final userProfileModal = userProfileModalFromJson(jsonString);

import 'dart:convert';

UserProfileModal userProfileModalFromJson(String str) => UserProfileModal.fromJson(json.decode(str));

String userProfileModalToJson(UserProfileModal data) => json.encode(data.toJson());

class UserProfileModal {
  int? status;
  String? message;
  UserInfo? user;

  UserProfileModal({
    this.status,
    this.message,
    this.user,
  });

  factory UserProfileModal.fromJson(Map<String, dynamic> json) => UserProfileModal(
    status: json["status"],
    message: json["message"],
    user: json["user"] == null ? null : UserInfo.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user?.toJson(),
  };
}

class UserInfo {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  dynamic gender;
  String? phone;
  dynamic photo;
  String? bio;
  String? voiceFile;
  int? musaCount;
  int? musaContributorCount;

  UserInfo({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.photo,
    this.bio,
    this.voiceFile,
    this.musaCount,
    this.musaContributorCount,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    dateOfBirth: json["date_of_birth"],
    gender: json["gender"],
    phone: json["phone"],
    photo: json["photo"],
    bio: json["bio"],
    voiceFile: json["voice_file"],
    musaCount: json["musaCount"],
    musaContributorCount: json["MusaContributorCount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "date_of_birth": dateOfBirth,
    "gender": gender,
    "phone": phone,
    "photo": photo,
    "bio": bio,
    "voice_file": voiceFile,
    "musaCount": musaCount,
    "MusaContributorCount": musaContributorCount,

  };
}
