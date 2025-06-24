// To parse this JSON data, do
//
//     final chatHistoryResponse = chatHistoryResponseFromJson(jsonString);

import 'dart:convert';

ChatHistoryResponse chatHistoryResponseFromJson(String str) => ChatHistoryResponse.fromJson(json.decode(str));

String chatHistoryResponseToJson(ChatHistoryResponse data) => json.encode(data.toJson());

class ChatHistoryResponse {
    int? status;
    String? message;
    List<Datum>? data;

    ChatHistoryResponse({
        this.status,
        this.message,
        this.data,
    });

    factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) => ChatHistoryResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    String? id;
    String? senderId;
    String? receiverId;
    String? message;
    DateTime? createdAt;
    ErUserDetail? senderUserDetail;
    ErUserDetail? receiverUserDetail;

    Datum({
        this.id,
        this.senderId,
        this.receiverId,
        this.message,
        this.createdAt,
        this.senderUserDetail,
        this.receiverUserDetail,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        message: json["message"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        senderUserDetail: json["senderUserDetail"] == null ? null : ErUserDetail.fromJson(json["senderUserDetail"]),
        receiverUserDetail: json["receiverUserDetail"] == null ? null : ErUserDetail.fromJson(json["receiverUserDetail"]),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "created_at": createdAt?.toIso8601String(),
        "senderUserDetail": senderUserDetail?.toJson(),
        "receiverUserDetail": receiverUserDetail?.toJson(),
    };
}

class ErUserDetail {
    String? id;
    String? firstName;
    String? lastName;
    String? phone;
    String? photo;

    ErUserDetail({
        this.id,
        this.firstName,
        this.lastName,
        this.phone,
        this.photo,
    });

    factory ErUserDetail.fromJson(Map<String, dynamic> json) => ErUserDetail(
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
