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
  final Reviewer reviewee;

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
    required this.reviewee,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["id"],
      reviewerId: json["reviewerId"],
      revieweeId: json["revieweeId"],
      carTransportId: json["carTransportId"],
      rating: json["rating"],
      comment: json["comment"],
      isFlagged: json["isFlagged"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      reviewer: Reviewer.fromJson(json["reviewer"]),
      reviewee: Reviewer.fromJson(json["reviewee"]),
    );
  }
}

class Reviewer {
  final String id;
  final String fullName;

  Reviewer({required this.id, required this.fullName});

  factory Reviewer.fromJson(Map<String, dynamic> json) {
    return Reviewer(
      id: json["id"],
      fullName: json["fullName"],
    );
  }
}
