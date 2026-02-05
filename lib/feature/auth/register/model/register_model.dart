class RegisterModel {
  final String id;
  final String phoneNumber;
  final String role;
  final String? email;
  final int otp;
  final String createdAt;
  final String updatedAt;
  final String? referralCode;
  final bool isExist;

  RegisterModel({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.email,
    required this.otp,
    required this.createdAt,
    required this.updatedAt,
    this.referralCode,
    required this.isExist,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      email: json['email'],
      otp: json['otp'] is int
          ? json['otp']
          : int.tryParse(json['otp']?.toString() ?? '0') ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      referralCode: json['referralCode'],
      isExist: json['isExist'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'role': role,
      'email': email,
      'otp': otp,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'referralCode': referralCode,
      'isExist': isExist,
    };
  }
}
