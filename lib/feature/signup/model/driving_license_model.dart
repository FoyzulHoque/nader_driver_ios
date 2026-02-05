class LicenseModel {
  final String? licenseFrontSide;
  final String? licenseBackSide;

  LicenseModel({
    this.licenseFrontSide,
    this.licenseBackSide,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      licenseFrontSide: json["licenseFrontSide"],
      licenseBackSide: json["licenseBackSide"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "licenseFrontSide": licenseFrontSide,
      "licenseBackSide": licenseBackSide,
    };
  }
}
