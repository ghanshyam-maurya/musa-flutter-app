// To parse this JSON data, do
//
//     final deleteAllNotificationsResponse = deleteAllNotificationsResponseFromJson(jsonString);

import 'dart:convert';

DeleteAllNotificationsResponse deleteAllNotificationsResponseFromJson(String str) => DeleteAllNotificationsResponse.fromJson(json.decode(str));

String deleteAllNotificationsResponseToJson(DeleteAllNotificationsResponse data) => json.encode(data.toJson());

class DeleteAllNotificationsResponse {
  int? status;
  String? message;
  int? deletedCount;

  DeleteAllNotificationsResponse({
    this.status,
    this.message,
    this.deletedCount,
  });

  factory DeleteAllNotificationsResponse.fromJson(Map<String, dynamic> json) => DeleteAllNotificationsResponse(
    status: json["status"],
    message: json["message"],
    deletedCount: json["deletedCount"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "deletedCount": deletedCount,
  };
}
