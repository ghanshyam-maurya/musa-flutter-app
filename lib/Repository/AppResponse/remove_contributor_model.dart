// To parse this JSON data, do
//
//     final removeContributorResponse = removeContributorResponseFromJson(jsonString);

import 'dart:convert';

RemoveContributorResponse removeContributorResponseFromJson(String str) => RemoveContributorResponse.fromJson(json.decode(str));

String removeContributorResponseToJson(RemoveContributorResponse data) => json.encode(data.toJson());

class RemoveContributorResponse {
  int? status;
  String? message;

  RemoveContributorResponse({
    this.status,
    this.message,
  });

  factory RemoveContributorResponse.fromJson(Map<String, dynamic> json) => RemoveContributorResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
