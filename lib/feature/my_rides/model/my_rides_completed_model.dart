class MyRideResponse {
  final bool success;
  final String message;
  final List<MyRideModel> data;

  MyRideResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MyRideResponse.fromJson(Map<String, dynamic> json) {
    return MyRideResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MyRideModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class MyRideModel {
  final String id;
  final String pickupLocation;
  final String dropOffLocation;
  final double pickupLat;
  final double pickupLng;
  final double dropOffLat;
  final double dropOffLng;
  final int totalAmount;
  final double distance;
  final String paymentMethod;
  final String paymentStatus;
  final String pickupDate;
  final String pickupTime;
  final int rideTime;
  final int waitingTime;
  final String status;
  final String serviceType;
  final String specialNotes;
  final List<String> beforePickupImages;
  final List<String> afterPickupImages;
  final UserModel? user;
  final VehicleModel? vehicle;

  MyRideModel({
    required this.id,
    required this.pickupLocation,
    required this.dropOffLocation,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropOffLat,
    required this.dropOffLng,
    required this.totalAmount,
    required this.distance,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.pickupDate,
    required this.pickupTime,
    required this.rideTime,
    required this.waitingTime,
    required this.status,
    required this.serviceType,
    required this.specialNotes,
    required this.beforePickupImages,
    required this.afterPickupImages,
    this.user,
    this.vehicle,
  });

  factory MyRideModel.fromJson(Map<String, dynamic> json) {
    return MyRideModel(
      id: json['id'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      dropOffLocation: json['dropOffLocation'] ?? '',
      pickupLat: (json['pickupLat'] ?? 0).toDouble(),
      pickupLng: (json['pickupLng'] ?? 0).toDouble(),
      dropOffLat: (json['dropOffLat'] ?? 0).toDouble(),
      dropOffLng: (json['dropOffLng'] ?? 0).toDouble(),
      totalAmount: json['totalAmount'] ?? 0,
      distance: (json['distance'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      pickupDate: json['pickupDate'] ?? '',
      pickupTime: json['pickupTime'] ?? '',
      rideTime: json['rideTime'] ?? 0,
      waitingTime: json['waitingTime'] ?? 0,
      status: json['status'] ?? '',
      serviceType: json['serviceType'] ?? '',
      specialNotes: json['specialNotes'] ?? '',
      beforePickupImages: List<String>.from(json['beforePickupImages'] ?? []),
      afterPickupImages: List<String>.from(json['afterPickupImages'] ?? []),
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      vehicle:
      json['vehicle'] != null ? VehicleModel.fromJson(json['vehicle']) : null,
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String profileImage;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class VehicleModel {
  final String id;
  final String manufacturer;
  final String model;
  final String licensePlateNumber;
  final String image;
  final String color;
  final DriverModel? driver;

  VehicleModel({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.licensePlateNumber,
    required this.image,
    required this.color,
    this.driver,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      model: json['model'] ?? '',
      licensePlateNumber: json['licensePlateNumber'] ?? '',
      image: json['image'] ?? '',
      color: json['color'] ?? '',
      driver:
      json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
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
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
