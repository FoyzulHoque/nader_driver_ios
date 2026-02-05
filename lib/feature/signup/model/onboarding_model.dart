class OnboardingModel {
  final bool success;
  final String message;
  final OnboardingData data;

  OnboardingModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: OnboardingData.fromJson(json["data"]),
    );
  }
}

class OnboardingData {
  final User user;
  final List<Vehicle> vehicles;

  OnboardingData({
    required this.user,
    required this.vehicles,
  });

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      user: User.fromJson(json["user"]),
      vehicles: List<Vehicle>.from(
          json["vehicles"].map((x) => Vehicle.fromJson(x))),
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String dob;
  final String gender;
  final String phoneNumber;
  final String profileImage;
  final String licenseFrontSide;
  final String licenseBackSide;
  final String role;
  final String adminApprovedStatus;

  User({
    required this.id,
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.phoneNumber,
    required this.profileImage,
    required this.licenseFrontSide,
    required this.licenseBackSide,
    required this.role,
    required this.adminApprovedStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] ?? "",
      fullName: json["fullName"] ?? "",
      dob: json["dob"] ?? "",
      gender: json["gender"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      profileImage: json["profileImage"] ?? "",
      licenseFrontSide: json["licenseFrontSide"] ?? "",
      licenseBackSide: json["licenseBackSide"] ?? "",
      role: json["role"] ?? "",
      adminApprovedStatus: json["adminApprovedStatus"] ?? "",
    );
  }
}

class Vehicle {
  final String id;
  final String manufacturer;
  final String model;
  final int year;
  final String color;
  final String licensePlateNumber;
  final String bh;
  final String image;

  Vehicle({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.year,
    required this.color,
    required this.licensePlateNumber,
    required this.bh,
    required this.image,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"] ?? "",
      manufacturer: json["manufacturer"] ?? "",
      model: json["model"] ?? "",
      year: json["year"] ?? 0,
      color: json["color"] ?? "",
      licensePlateNumber: json["licensePlateNumber"] ?? "",
      bh: json["bh"] ?? "",
      image: json["image"] ?? "",
    );
  }
}
