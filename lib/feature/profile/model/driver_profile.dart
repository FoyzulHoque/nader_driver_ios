class DriverProfile {
  final String id;
  final String fullName;
  final String dob;
  final String gender;
  final String nidNumber;
  final String? referralCode;
  final String? documents;
  final String address;
  final String phoneNumber;
  final String? email;
  final String? city;
  final String location;
  final double lat;
  final double lng;
  final String? password;
  final String role;
  final String status;
  final int otp;
  final String otpExpiresAt;
  final String? phoneVerificationToken;
  final bool isPhoneNumberVerify;
  final String? profileImage;
  final String fcmToken;
  final bool isNotificationOn;
  final bool isUserOnline;
  final bool onBoarding;
  final String? licensePlate;
  final String? drivingLicense;
  final String licenseFrontSide;
  final String licenseBackSide;
  final String? taxiManufacturer;
  final String? bhNumber;
  final String adminApprovedStatus;
  final double rating;
  final double totalDistance;
  final int totalRides;
  final int totalTrips;
  final String createdAt;
  final String updatedAt;

  DriverProfile({
    required this.id,
    required this.fullName,
    required this.dob,
    required this.gender,
    required this.nidNumber,
    this.referralCode,
    this.documents,
    required this.address,
    required this.phoneNumber,
    this.email,
    this.city,
    required this.location,
    required this.lat,
    required this.lng,
    this.password,
    required this.role,
    required this.status,
    required this.otp,
    required this.otpExpiresAt,
    this.phoneVerificationToken,
    required this.isPhoneNumberVerify,
    this.profileImage,
    required this.fcmToken,
    required this.isNotificationOn,
    required this.isUserOnline,
    required this.onBoarding,
    this.licensePlate,
    this.drivingLicense,
    required this.licenseFrontSide,
    required this.licenseBackSide,
    this.taxiManufacturer,
    this.bhNumber,
    required this.adminApprovedStatus,
    required this.rating,
    required this.totalDistance,
    required this.totalRides,
    required this.totalTrips,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json["id"] ?? "",
      fullName: json["fullName"] ?? "",
      dob: json["dob"] ?? "",
      gender: json["gender"] ?? "",
      nidNumber: json["nidNumber"] ?? "",
      referralCode: json["referralCode"],
      documents: json["documents"],
      address: json["address"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      email: json["email"],
      city: json["city"],
      location: json["location"] ?? "",
      lat: (json["lat"] ?? 0).toDouble(),
      lng: (json["lng"] ?? 0).toDouble(),
      password: json["password"],
      role: json["role"] ?? "",
      status: json["status"] ?? "",
      otp: json["otp"] ?? 0,
      otpExpiresAt: json["otpExpiresAt"] ?? "",
      phoneVerificationToken: json["phoneVerificationToken"],
      isPhoneNumberVerify: json["isPhoneNumberVerify"] ?? false,
      profileImage: json["profileImage"],
      fcmToken: json["fcmToken"] ?? "",
      isNotificationOn: json["isNotificationOn"] ?? false,
      isUserOnline: json["isUserOnline"] ?? false,
      onBoarding: json["onBoarding"] ?? false,
      licensePlate: json["licensePlate"],
      drivingLicense: json["drivingLicense"],
      licenseFrontSide: json["licenseFrontSide"] ?? "",
      licenseBackSide: json["licenseBackSide"] ?? "",
      taxiManufacturer: json["taxiManufacturer"],
      bhNumber: json["bhNumber"],
      adminApprovedStatus: json["adminApprovedStatus"] ?? "",
      rating: (json["rating"] ?? 0).toDouble(),
      totalDistance: (json["totalDistance"] ?? 0).toDouble(),
      totalRides: json["totalRides"] ?? 0,
      totalTrips: json["totalTrips"] ?? 0,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullName": fullName,
      "dob": dob,
      "gender": gender,
      "nidNumber": nidNumber,
      "referralCode": referralCode,
      "documents": documents,
      "address": address,
      "phoneNumber": phoneNumber,
      "email": email,
      "city": city,
      "location": location,
      "lat": lat,
      "lng": lng,
      "password": password,
      "role": role,
      "status": status,
      "otp": otp,
      "otpExpiresAt": otpExpiresAt,
      "phoneVerificationToken": phoneVerificationToken,
      "isPhoneNumberVerify": isPhoneNumberVerify,
      "profileImage": profileImage,
      "fcmToken": fcmToken,
      "isNotificationOn": isNotificationOn,
      "isUserOnline": isUserOnline,
      "onBoarding": onBoarding,
      "licensePlate": licensePlate,
      "drivingLicense": drivingLicense,
      "licenseFrontSide": licenseFrontSide,
      "licenseBackSide": licenseBackSide,
      "taxiManufacturer": taxiManufacturer,
      "bhNumber": bhNumber,
      "adminApprovedStatus": adminApprovedStatus,
      "rating": rating,
      "totalDistance": totalDistance,
      "totalRides": totalRides,
      "totalTrips": totalTrips,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
