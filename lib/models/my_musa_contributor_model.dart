import 'dart:convert';

// Helper function to decode the JSON response
MusaContributorsResponse musaContributorsResponseFromJson(String str) =>
    MusaContributorsResponse.fromJson(json.decode(str));

// Main response model
class MusaContributorsResponse {
  final int? status;
  final String? message;
  final List<MusaSection>? data;

  MusaContributorsResponse({
    this.status,
    this.message,
    this.data,
  });

  factory MusaContributorsResponse.fromJson(Map<String, dynamic> json) =>
      MusaContributorsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MusaSection>.from(
                json["data"]!.map((x) => MusaSection.fromJson(x))),
      );
}

// Model for each section (e.g., each painting)
class MusaSection {
  final String? id;
  final String? title;
  final String? description;
  final String? musaType;
  final DateTime? createdAt;
  final List<Contributor>? contributors;

  MusaSection({
    this.id,
    this.title,
    this.description,
    this.musaType,
    this.createdAt,
    this.contributors,
  });

  factory MusaSection.fromJson(Map<String, dynamic> json) => MusaSection(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        musaType: json["musa_type"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        contributors: json["contributors"] == null
            ? []
            : List<Contributor>.from(
                json["contributors"]!.map((x) => Contributor.fromJson(x))),
      );
}

// Model for each contributor within a section
class Contributor {
  final String? id;
  final String? status;
  final DateTime? createdAt;
  final ContributorDetails? contributorDetails;

  Contributor({
    this.id,
    this.status,
    this.createdAt,
    this.contributorDetails,
  });

  factory Contributor.fromJson(Map<String, dynamic> json) => Contributor(
        id: json["_id"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        contributorDetails: json["contributor_details"] == null
            ? null
            : ContributorDetails.fromJson(json["contributor_details"]),
      );
}

// Model for the detailed information of a contributor
class ContributorDetails {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? photo;

  ContributorDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.photo,
  });

  factory ContributorDetails.fromJson(Map<String, dynamic> json) =>
      ContributorDetails(
        id: json["_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        photo: json["photo"],
      );
}
