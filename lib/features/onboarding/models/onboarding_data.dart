class OnboardingData {
  final String phoneNumber; // primary auth credential (phone OTP)
  final String firebaseUid; // set after OTP verification
  final String username; // unique store username chosen by user
  final String password; // only set for email-path registrations
  final String email; // store owner's contact email
  final String ownerName;
  final String storeName;
  final String businessType;
  final int footfall;
  final String address;
  final String location;
  final String region;
  final double? latitude;
  final double? longitude;
  final bool consentAccepted;
  final bool privacyAccepted;

  const OnboardingData({
    this.phoneNumber = '',
    this.firebaseUid = '',
    this.username = '',
    this.password = '',
    this.email = '',
    this.ownerName = '',
    this.storeName = '',
    this.businessType = '',
    this.footfall = 40,
    this.address = '',
    this.location = '',
    this.region = '',
    this.latitude,
    this.longitude,
    this.consentAccepted = false,
    this.privacyAccepted = false,
  });

  OnboardingData copyWith({
    String? phoneNumber,
    String? firebaseUid,
    String? username,
    String? password,
    String? email,
    String? ownerName,
    String? storeName,
    String? businessType,
    int? footfall,
    String? address,
    String? location,
    String? region,
    double? latitude,
    double? longitude,
    bool? consentAccepted,
    bool? privacyAccepted,
  }) => OnboardingData(
    phoneNumber: phoneNumber ?? this.phoneNumber,
    firebaseUid: firebaseUid ?? this.firebaseUid,
    username: username ?? this.username,
    password: password ?? this.password,
    email: email ?? this.email,
    ownerName: ownerName ?? this.ownerName,
    storeName: storeName ?? this.storeName,
    businessType: businessType ?? this.businessType,
    footfall: footfall ?? this.footfall,
    address: address ?? this.address,
    location: location ?? this.location,
    region: region ?? this.region,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    consentAccepted: consentAccepted ?? this.consentAccepted,
    privacyAccepted: privacyAccepted ?? this.privacyAccepted,
  );
}
