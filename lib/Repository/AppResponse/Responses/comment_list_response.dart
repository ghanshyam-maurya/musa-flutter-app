class CommentListResponse {
  int? status;
  String? message;
  List<Data>? data;

  CommentListResponse({this.status, this.message, this.data});

  CommentListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? userId;
  String? commentType;
  String? text;
  var fileLink;
  String? createdAt;
  List<UserDetail>? userDetail;

  Data(
      {this.sId,
      this.userId,
      this.commentType,
      this.text,
      this.fileLink,
      this.createdAt,
      this.userDetail});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    commentType = json['comment_type'];
    text = json['text'];
    fileLink = json['file_link'];
    createdAt = json['created_at'];
    if (json['user_detail'] != null) {
      userDetail = <UserDetail>[];
      json['user_detail'].forEach((v) {
        userDetail!.add(UserDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['user_id'] = userId;
    data['comment_type'] = commentType;
    data['text'] = text;
    data['file_link'] = fileLink;
    data['created_at'] = createdAt;
    if (userDetail != null) {
      data['user_detail'] = userDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDetail {
  String? sId;
  String? firstName;
  String? lastName;
  String? phone;
  var photo;

  UserDetail({this.sId, this.firstName, this.lastName, this.phone, this.photo});

  UserDetail.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['photo'] = photo;
    return data;
  }
}
