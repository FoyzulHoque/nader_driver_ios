class MyRidesHistoryModel {
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
  final UserHistoryModel? user;
  final VehicleHistoryModel? vehicle;

  MyRidesHistoryModel({
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

  factory MyRidesHistoryModel.fromJson(Map<String, dynamic> json) {
    return MyRidesHistoryModel(
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
      user: json['user'] != null
          ? UserHistoryModel.fromJson(json['user'])
          : null,
      vehicle: json['vehicle'] != null
          ? VehicleHistoryModel.fromJson(json['vehicle'])
          : null,
    );
  }
}

class UserHistoryModel {
  final String id;
  final String fullName;
  final String email;
  final String profileImage;

  UserHistoryModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profileImage,
  });

  factory UserHistoryModel.fromJson(Map<String, dynamic> json) {
    return UserHistoryModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class VehicleHistoryModel {
  final String id;
  final String manufacturer;
  final String model;
  final String licensePlateNumber;
  final String image;
  final String color;
  final DriverHistoryModel? driver;

  VehicleHistoryModel({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.licensePlateNumber,
    required this.image,
    required this.color,
    this.driver,
  });

  factory VehicleHistoryModel.fromJson(Map<String, dynamic> json) {
    return VehicleHistoryModel(
      id: json['id'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      model: json['model'] ?? '',
      licensePlateNumber: json['licensePlateNumber'] ?? '',
      image: json['image'] ?? '',
      color: json['color'] ?? '',
      driver: json['driver'] != null
          ? DriverHistoryModel.fromJson(json['driver'])
          : null,
    );
  }
}

class DriverHistoryModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;
  final String location;

  DriverHistoryModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
    required this.location,
  });

  factory DriverHistoryModel.fromJson(Map<String, dynamic> json) {
    return DriverHistoryModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
      location: json['location'] ?? '',
    );
  }
}
