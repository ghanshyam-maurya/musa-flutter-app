class SignUpRegisterResponse {
  int? status;
  String? message;
  User? user;

  SignUpRegisterResponse({this.status, this.message, this.user});

  SignUpRegisterResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? email;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  Null gender;
  String? phone;
  Null photo;
  Null bio;
  String? postalCode;
  bool? isSignupComplete;

  User(
      {this.id,
      this.email,
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.gender,
      this.phone,
      this.photo,
      this.bio,
      this.postalCode,
      this.isSignupComplete});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    phone = json['phone'];
    photo = json['photo'];
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
    data['bio'] = bio;
    data['postal_code'] = postalCode;
    data['is_signup_complete'] = isSignupComplete;
    return data;
  }
}
