// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

NotificationListModel notificationListModelFromJson(String str) => NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) => json.encode(data.toJson());

class NotificationListModel {
  bool? status;
  String? message;
  NotificationListData? data;

  NotificationListModel({
    this.status,
    this.message,
    this.data,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) => NotificationListModel(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? null : NotificationListData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class NotificationListData {
  List<Notifications>? notifications;
  int? totalCount;
  int? totalPages;
  int? currentPage;

  NotificationListData({
    this.notifications,
    this.totalCount,
    this.totalPages,
    this.currentPage,
  });

  factory NotificationListData.fromJson(Map<String, dynamic> json) => NotificationListData(
    notifications: json["notifications"] == null ? [] : List<Notifications>.from(json["notifications"]!.map((x) => Notifications.fromJson(x))),
    totalCount: json["totalCount"],
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications == null ? [] : List<dynamic>.from(notifications!.map((x) => x.toJson())),
    "totalCount": totalCount,
    "totalPages": totalPages,
    "currentPage": currentPage,
  };
}

class Notifications {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  String? subjectId;
  String? subjectType;
  bool? status;
  bool? isLoading;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? senderFirstName;
  String? senderLastName;
  String? senderPhoto;
  String? musaName;

  Notifications({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.subjectId,
    this.subjectType,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.senderFirstName,
    this.senderLastName,
    this.senderPhoto,
    this.musaName,
    this.isLoading = false,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
    id: json["_id"],
    senderId: json["sender_id"],
    receiverId: json["receiver_id"],
    message: json["message"],
    subjectId: json["subject_id"],
    subjectType: json["subject_type"],
    status: json["status"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    v: json["__v"],
    senderFirstName: json["senderFirstName"],
    senderLastName: json["senderLastName"],
    senderPhoto: json["senderPhoto"],
    musaName: json["musaName"],
    isLoading: json["isLoading"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "sender_id": senderId,
    "receiver_id": receiverId,
    "message": message,
    "subject_id": subjectId,
    "subject_type": subjectType,
    "status": status,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "__v": v,
    "senderFirstName": senderFirstName,
    "senderLastName": senderLastName,
    "senderPhoto": senderPhoto,
    "musaName": musaName,
    "isLoading": isLoading,
  };
}
