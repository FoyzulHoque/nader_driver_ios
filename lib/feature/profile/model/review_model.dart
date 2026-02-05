class ReviewModel {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final String carTransportId;
  final int rating;
  final String comment;
  final bool isFlagged;
  final String createdAt;
  final String updatedAt;
  final Reviewer reviewer;

  ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.carTransportId,
    required this.rating,
    required this.comment,
    required this.isFlagged,
    required this.createdAt,
    required this.updatedAt,
    required this.reviewer,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["id"] ?? "",
      reviewerId: json["reviewerId"] ?? "",
      revieweeId: json["revieweeId"] ?? "",
      carTransportId: json["carTransportId"] ?? "",
      rating: json["rating"] ?? 0,
      comment: json["comment"] ?? "",
      isFlagged: json["isFlagged"] ?? false,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      reviewer: Reviewer.fromJson(json["reviewer"] ?? {}),
    );
  }
}

class Reviewer {
  final String id;
  final String fullName;
  final String profileImage;

  Reviewer({
    required this.id,
    required this.fullName,
    required this.profileImage,
  });

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json["id"] ?? "",
      fullName: json["fullName"] ?? "",
      profileImage: json["profileImage"] ?? "",
    );
  }
}
