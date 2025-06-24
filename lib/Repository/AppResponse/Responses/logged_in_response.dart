class LoggedInResponse {
  int? status;
  String? message;
  User? user;
  String? token;

  LoggedInResponse({status, message, user, token});

  LoggedInResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class User {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  var gender;
  String? phone;
  var photo;
  var voiceFile;
  var bio;
  String? postalCode;
  bool? isSignupComplete;

  User(
      {id,
      email,
      firstName,
      lastName,
      dateOfBirth,
      gender,
      phone,
      photo,
      voiceFile,
      bio,
      postalCode,
      isSignupComplete});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    phone = json['phone'];
    photo = json['photo'];
    voiceFile = json['voice_file'];
    bio = json['bio'];
    postalCode = json['postal_code'];
    isSignupComplete = json['is_signup_complete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['phone'] = phone;
    data['photo'] = photo;
    data['voice_file'] = voiceFile;
    data['bio'] = bio;
    data['postal_code'] = postalCode;
    data['is_signup_complete'] = isSignupComplete;
    return data;
  }
}
