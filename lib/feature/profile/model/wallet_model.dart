class DriverIncomeModel {
  final double totalIncome;
  final double totalDistance;
  final int totalDuration;
  final int totalTrips;
  final List<TransactionModel> transactions;

  DriverIncomeModel({
    required this.totalIncome,
    required this.totalDistance,
    required this.totalDuration,
    required this.totalTrips,
    required this.transactions,
  });

  factory DriverIncomeModel.fromJson(Map<String, dynamic> json) {
    return DriverIncomeModel(
      totalIncome: (json["totalIncome"] ?? 0).toDouble(),
      totalDistance: (json["totalDistance"] ?? 0).toDouble(),
      totalDuration: json["totalDuration"] ?? 0,
      totalTrips: json["totalTrips"] ?? 0,
      transactions: (json["transactions"]["data"] as List)
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
    );
  }
}

class TransactionModel {
  final String id;
  final double totalAmount;
  final double distance;
  final int rideTime;
  final String serviceType;
  final String createdAt;
  final String userName;
  final String userAvatar;
  final String vehicleModel;

  TransactionModel({
    required this.id,
    required this.totalAmount,
    required this.distance,
    required this.rideTime,
    required this.serviceType,
    required this.createdAt,
    required this.userName,
    required this.userAvatar,
    required this.vehicleModel,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["id"] ?? "",
      totalAmount: (json["totalAmount"] ?? 0).toDouble(),
      distance: (json["distance"] ?? 0).toDouble(),
      rideTime: json["actualRideTime"] ?? 0,
      serviceType: json["serviceType"] ?? "",
      createdAt: json["createdAt"] ?? "",
      userName: json["user"]["fullName"] ?? "Unknown",
      userAvatar: json["user"]["profileImage"] ?? "",
      vehicleModel: json["vehicle"]["model"] ?? "",
    );
  }
}
