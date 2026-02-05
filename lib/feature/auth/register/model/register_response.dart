class RegisterResponse {
  final bool success;
  final String message;
  final RegisterData? data;

  RegisterResponse({required this.success, required this.message, this.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? RegisterData.fromJson(json['data']) : null,
    );
  }
}

class RegisterData {
  final String id;
  final String phoneNumber;
  final String role;
  final String? email;
  final int otp;
  final String createdAt;
  final String updatedAt;

  RegisterData({
    required this.id,
    required this.phoneNumber,
    required this.role,
    this.email,
    required this.otp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      email: json['email'],
      otp: json['otp'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
