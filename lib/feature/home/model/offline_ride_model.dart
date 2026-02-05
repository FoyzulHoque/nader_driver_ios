class OfflineRideModel {
  final String id;
  final String userId;
  final String vehicleId;
  final String pickupLocation;
  final String dropOffLocation;
  final double pickupLat;
  final double pickupLng;
  final double dropOffLat;
  final double dropOffLng;
  final double driverLat;
  final double driverLng;
  final double totalAmount;
  final double distance;
  final double platformFee;
  final String platformFeeType;
  final String paymentMethod;
  final String paymentStatus;
  final bool isPayment;
  final String pickupDate;
  final String pickupTime;
  final int rideTime;
  final int waitingTime;
  final String status;
  final String assignedDriver;
  final String assignedDriverReqStatus;
  final bool isDriverReqCancel;
  final bool arrivalConfirmation;
  final bool journeyStarted;
  final bool journeyCompleted;
  final String serviceType;
  final String specialNotes;
  final List<String> beforePickupImages;
  final List<String> afterPickupImages;
  final String cancelReason;
  final String createdAt;
  final String updatedAt;
  final UserModel? user;
  final VehicleModel? vehicle;

  OfflineRideModel({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropOffLat,
    required this.dropOffLng,
    required this.driverLat,
    required this.driverLng,
    required this.totalAmount,
    required this.distance,
    required this.platformFee,
    required this.platformFeeType,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.isPayment,
    required this.pickupDate,
    required this.pickupTime,
    required this.rideTime,
    required this.waitingTime,
    required this.status,
    required this.assignedDriver,
    required this.assignedDriverReqStatus,
    required this.isDriverReqCancel,
    required this.arrivalConfirmation,
    required this.journeyStarted,
    required this.journeyCompleted,
    required this.serviceType,
    required this.specialNotes,
    required this.beforePickupImages,
    required this.afterPickupImages,
    required this.cancelReason,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.vehicle,
  });

  factory OfflineRideModel.fromJson(Map<String, dynamic> json) {
    return OfflineRideModel(
      id: json["id"] ?? "",
      userId: json["userId"] ?? "",
      vehicleId: json["vehicleId"] ?? "",
      pickupLocation: json["pickupLocation"] ?? "",
      dropOffLocation: json["dropOffLocation"] ?? "",
      pickupLat: (json["pickupLat"] ?? 0).toDouble(),
      pickupLng: (json["pickupLng"] ?? 0).toDouble(),
      dropOffLat: (json["dropOffLat"] ?? 0).toDouble(),
      dropOffLng: (json["dropOffLng"] ?? 0).toDouble(),
      driverLat: (json["driverLat"] ?? 0).toDouble(),
      driverLng: (json["driverLng"] ?? 0).toDouble(),
      totalAmount: (json["totalAmount"] ?? 0).toDouble(),
      distance: (json["distance"] ?? 0).toDouble(),
      platformFee: (json["platformFee"] ?? 0).toDouble(),
      platformFeeType: json["platformFeeType"] ?? "",
      paymentMethod: json["paymentMethod"] ?? "",
      paymentStatus: json["paymentStatus"] ?? "",
      isPayment: json["isPayment"] ?? false,
      pickupDate: json["pickupDate"] ?? "",
      pickupTime: json["pickupTime"] ?? "",
      rideTime: json["rideTime"] ?? 0,
      waitingTime: json["waitingTime"] ?? 0,
      status: json["status"] ?? "",
      assignedDriver: json["assignedDriver"] ?? "",
      assignedDriverReqStatus: json["assignedDriverReqStatus"] ?? "",
      isDriverReqCancel: json["isDriverReqCancel"] ?? false,
      arrivalConfirmation: json["arrivalConfirmation"] ?? false,
      journeyStarted: json["journeyStarted"] ?? false,
      journeyCompleted: json["journeyCompleted"] ?? false,
      serviceType: json["serviceType"] ?? "",
      specialNotes: json["specialNotes"] ?? "",
      beforePickupImages: (json["beforePickupImages"] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      afterPickupImages: (json["afterPickupImages"] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      cancelReason: json["cancelReason"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
      vehicle:
      json["vehicle"] != null ? VehicleModel.fromJson(json["vehicle"]) : null,
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String profileImage;
  final String location;
  final double lat;
  final double lng;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
    required this.location,
    required this.lat,
    required this.lng,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
      profileImage: json["profileImage"] ?? "",
      location: json["location"] ?? "",
      lat: (json["lat"] ?? 0).toDouble(),
      lng: (json["lng"] ?? 0).toDouble(),
    );
  }
}

class VehicleModel {
  final String id;
  final String manufacturer;
  final String model;
  final String licensePlateNumber;
  final String bh;
  final String image;
  final String color;
  final DriverModel? driver;

  VehicleModel({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.licensePlateNumber,
    required this.bh,
    required this.image,
    required this.color,
    this.driver,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json["id"] ?? "",
      manufacturer: json["manufacturer"] ?? "",
      model: json["model"] ?? "",
      licensePlateNumber: json["licensePlateNumber"] ?? "",
      bh: json["bh"] ?? "",
      image: json["image"] ?? "",
      color: json["color"] ?? "",
      driver: json["driver"] != null ? DriverModel.fromJson(json["driver"]) : null,
    );
  }
}

class DriverModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String location;

  DriverModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.location,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json["id"] ?? "",
      fullName: json["fullName"] ?? "",
      email: json["email"] ?? "",
      phoneNumber: json["phoneNumber"] ?? "",
      profileImage: json["profileImage"] ?? "",
      location: json["location"] ?? "",
    );
  }
}
