import 'dart:convert';

UserDetail userDetailFromJson(String str) => UserDetail.fromJson(json.decode(str));

String userDetailToJson(UserDetail data) => json.encode(data.toJson());

class UserDetail {
  int? status;
  String? message;
  User? user;

  UserDetail({
    this.status,
    this.message,
    this.user,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    status: json["status"],
    message: json["message"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "user": user?.toJson(),
  };
}

class User {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  dynamic gender;
  String? phone;
  dynamic photo;
  dynamic bio;
  String? postalCode;
  String? voiceFile;
  int? musaCount;
  int? musaContributorCount;

  User({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.phone,
    this.photo,
    this.bio,
    this.postalCode,
    this.voiceFile,
    this.musaCount,
    this.musaContributorCount,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    dateOfBirth: json["date_of_birth"],
    gender: json["gender"],
    phone: json["phone"],
    photo: json["photo"],
    bio: json["bio"],
    postalCode: json["postal_code"],
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
    "postal_code": postalCode,
    "voice_file": voiceFile,
    "musaCount": musaCount,
    "MusaContributorCount": musaContributorCount,

  };
}
