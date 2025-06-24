// To parse this JSON data, do
//
//     final chatListResponse = chatListResponseFromJson(jsonString);

import 'dart:convert';

ChatListResponse chatListResponseFromJson(String str) => ChatListResponse.fromJson(json.decode(str));

String chatListResponseToJson(ChatListResponse data) => json.encode(data.toJson());

class ChatListResponse {
    int? status;
    String? message;
    List<ChatListData>? data;

    ChatListResponse({
        this.status,
        this.message,
        this.data,
    });

    factory ChatListResponse.fromJson(Map<String, dynamic> json) => ChatListResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<ChatListData>.from(json["data"]!.map((x) => ChatListData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class ChatListData {
    String? id;
    String? senderId;
    String? receiverId;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;
    UserDetail? userDetail;
    LatestChat? latestChat;

    ChatListData({
        this.id,
        this.senderId,
        this.receiverId,
        this.createdAt,
        this.updatedAt,
        this.v,
        this.userDetail,
        this.latestChat,
    });

    factory ChatListData.fromJson(Map<String, dynamic> json) => ChatListData(
        id: json["_id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        v: json["__v"],
        userDetail: json["userDetail"] == null ? null : UserDetail.fromJson(json["userDetail"]),
        latestChat: json["latestChat"] == null ? null : LatestChat.fromJson(json["latestChat"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "__v": v,
        "userDetail": userDetail?.toJson(),
        "latestChat": latestChat?.toJson(),
    };
}

class LatestChat {
    String? id;
    String? message;
    DateTime? createdAt;

    LatestChat({
        this.id,
        this.message,
        this.createdAt,
    });

    factory LatestChat.fromJson(Map<String, dynamic> json) => LatestChat(
        id: json["_id"],
        message: json["message"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "message": message,
        "created_at": createdAt?.toIso8601String(),
    };
}

class UserDetail {
    String? id;
    String? firstName;
    String? lastName;
    String? phone;
    dynamic photo;

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
