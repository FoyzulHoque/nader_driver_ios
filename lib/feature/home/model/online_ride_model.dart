
class OnlineRideModel {
  final String? id;
  final String? userId;
  final String? vehicleId;
  final String? pickupLocation;
  final String? dropOffLocation;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropOffLat;
  final double? dropOffLng;
  final double? driverLat;
  final double? driverLng;
  final double? totalAmount;
  final double? distance;
  final double? platformFee;
  final double? driverFee;
  final String? platformFeeType;
  final String? paymentMethod;
  final String? paymentStatus;
  final bool? isPayment;
  final String? pickupDate;
  final String? pickupTime;
  final int? rideTime;
  final int? waitingTime;
  final String? status;
  final String? assignedDriver;
  final String? assignedDriverReqStatus;
  final bool? isDriverReqCancel;
  final bool? arrivalConfirmation;
  final bool? journeyStarted;
  final bool? journeyCompleted;
  final String? serviceType;
  final String? specialNotes;
  final List<String>? beforePickupImages;
  final List<String>? afterPickupImages;
  final String? cancelReason;
  final String? createdAt;
  final String? updatedAt;
  final String? ridePlanId;
  final User? user;
  final Vehicle? vehicle;
  final List<RecommendedDriver>? recommendedDrivers;

  OnlineRideModel({
    this.id,
    this.userId,
    this.vehicleId,
    this.pickupLocation,
    this.dropOffLocation,
    this.pickupLat,
    this.pickupLng,
    this.dropOffLat,
    this.dropOffLng,
    this.driverLat,
    this.driverLng,
    this.totalAmount,
    this.distance,
    this.platformFee,
    this.driverFee,
    this.platformFeeType,
    this.paymentMethod,
    this.paymentStatus,
    this.isPayment,
    this.pickupDate,
    this.pickupTime,
    this.rideTime,
    this.waitingTime,
    this.status,
    this.assignedDriver,
    this.assignedDriverReqStatus,
    this.isDriverReqCancel,
    this.arrivalConfirmation,
    this.journeyStarted,
    this.journeyCompleted,
    this.serviceType,
    this.specialNotes,
    this.beforePickupImages,
    this.afterPickupImages,
    this.cancelReason,
    this.createdAt,
    this.updatedAt,
    this.ridePlanId,
    this.user,
    this.vehicle,
    this.recommendedDrivers,
  });

  factory OnlineRideModel.fromJson(Map<String, dynamic> json) {
    // Extract driver position from multiple possible sources
    double? driverLat;
    double? driverLng;
    
    // Try to get driver position from direct fields first
    if (json['driverLat'] != null && json['driverLat'] != 0) {
      driverLat = json['driverLat'].toDouble();
    }
    if (json['driverLng'] != null && json['driverLng'] != 0) {
      driverLng = json['driverLng'].toDouble();
    }
    
    // If not found, try to get from vehicle.driver
    if ((driverLat == null || driverLng == null) && json['vehicle'] != null) {
      final vehicle = json['vehicle'] as Map<String, dynamic>?;
      if (vehicle != null && vehicle['driver'] != null) {
        final driver = vehicle['driver'] as Map<String, dynamic>?;
        if (driver != null) {
          if (driverLat == null && driver['lat'] != null && driver['lat'] != 0) {
            driverLat = driver['lat'].toDouble();
          }
          if (driverLng == null && driver['lng'] != null && driver['lng'] != 0) {
            driverLng = driver['lng'].toDouble();
          }
        }
      }
    }
    
    // Fallback to default values if still not found
    driverLat ??= 23.76986878620318; // Default Dhaka coordinates
    driverLng ??= 90.40331684214348;
    
    print("🔍 [OnlineRideModel] Driver position parsed: lat=$driverLat, lng=$driverLng");

    return OnlineRideModel(
      id: json['id'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
      pickupLocation: json['pickupLocation'],
      dropOffLocation: json['dropOffLocation'],
      pickupLat: (json['pickupLat'] ?? 0).toDouble(),
      pickupLng: (json['pickupLng'] ?? 0).toDouble(),
      dropOffLat: (json['dropOffLat'] ?? 0).toDouble(),
      dropOffLng: (json['dropOffLng'] ?? 0).toDouble(),
      driverLat: driverLat,
      driverLng: driverLng,
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      platformFee: (json['platformFee'] ?? 0).toDouble(),
      driverFee: (json['driverFee'] ?? 0).toDouble(),
      platformFeeType: json['platformFeeType'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      isPayment: json['isPayment'],
      pickupDate: json['pickupDate'],
      pickupTime: json['pickupTime'],
      rideTime: json['rideTime'],
      waitingTime: json['waitingTime'],
      status: json['status'],
      assignedDriver: json['assignedDriver'],
      assignedDriverReqStatus: json['assignedDriverReqStatus'],
      isDriverReqCancel: json['isDriverReqCancel'],
      arrivalConfirmation: json['arrivalConfirmation'],
      journeyStarted: json['journeyStarted'],
      journeyCompleted: json['journeyCompleted'],
      serviceType: json['serviceType'],
      specialNotes: json['specialNotes'],
      beforePickupImages: List<String>.from(json['beforePickupImages'] ?? []),
      afterPickupImages: List<String>.from(json['afterPickupImages'] ?? []),
      cancelReason: json['cancelReason'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      ridePlanId: json['ridePlanId'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      vehicle: json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      recommendedDrivers: json['recommendedDrivers'] != null
          ? List<RecommendedDriver>.from(
        (json['recommendedDrivers']).map(
              (x) => RecommendedDriver.fromJson(x),
        ),
      )
          : null,
    );

  }
}


class User {
  final String? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? profileImage;
  final String? location;
  final double? lat;
  final double? lng;

  User({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.profileImage,
    this.location,
    this.lat,
    this.lng,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      profileImage: json['profileImage'],
      location: json['location'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'profileImage': profileImage,
      'location': location,
      'lat': lat,
      'lng': lng,
    };
  }
}

class Vehicle {
  final String? id;
  final String? manufacturer;
  final String? model;
  final String? licensePlateNumber;
  final String? image;
  final String? color;
  final Driver? driver;

  Vehicle({
    this.id,
    this.manufacturer,
    this.model,
    this.licensePlateNumber,
    this.image,
    this.color,
    this.driver,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      manufacturer: json['manufacturer'],
      model: json['model'],
      licensePlateNumber: json['licensePlateNumber'],
      image: json['image'],
      color: json['color'],
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'manufacturer': manufacturer,
      'model': model,
      'licensePlateNumber': licensePlateNumber,
      'image': image,
      'color': color,
      'driver': driver?.toJson(),
    };
  }
}

class Driver {
  final String? id;
  final String? fullName;
  final String? email;
  final String? referralCode;
  final double? lat;
  final double? lng;
  final String? phoneNumber;
  final String? profileImage;
  final String? location;
  final int? totalTrips;
  final double? averageRating;
  final int? reviewCount;

  Driver({
    this.id,
    this.fullName,
    this.email,
    this.referralCode,
    this.lat,
    this.lng,
    this.phoneNumber,
    this.profileImage,
    this.location,
    this.totalTrips,
    this.averageRating,
    this.reviewCount,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      referralCode: json['referralCode'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      phoneNumber: json['phoneNumber'],
      profileImage: json['profileImage'],
      location: json['location'],
      totalTrips: json['totalTrips'],
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'referralCode': referralCode,
      'lat': lat,
      'lng': lng,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'location': location,
      'totalTrips': totalTrips,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }
}

class RecommendedDriver {
  final String? id;
  final String? fullName;
  final String? phone;
  final String? profileImage;
  final String? vehicleId;
  final double? lat;
  final double? lng;
  final double? distanceFromPickup;

  RecommendedDriver({
    this.id,
    this.fullName,
    this.phone,
    this.profileImage,
    this.vehicleId,
    this.lat,
    this.lng,
    this.distanceFromPickup,
  });

  factory RecommendedDriver.fromJson(Map<String, dynamic> json) {
    return RecommendedDriver(
      id: json['id'],
      fullName: json['fullName'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      vehicleId: json['vehicleId'],
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      distanceFromPickup: (json['distanceFromPickup'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phone': phone,
      'profileImage': profileImage,
      'vehicleId': vehicleId,
      'lat': lat,
      'lng': lng,
      'distanceFromPickup': distanceFromPickup,
    };
  }
}