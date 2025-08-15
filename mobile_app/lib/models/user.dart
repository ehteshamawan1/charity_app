class User {
  final String id;
  final String cnic;
  final String phoneNumber;
  final String location;
  final UserRole role;
  final bool isVerified;
  final Map<String, dynamic>? additionalInfo;

  User({
    required this.id,
    required this.cnic,
    required this.phoneNumber,
    required this.location,
    required this.role,
    this.isVerified = false,
    this.additionalInfo,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      cnic: json['cnic'],
      phoneNumber: json['phoneNumber'],
      location: json['location'],
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
      ),
      isVerified: json['isVerified'] ?? false,
      additionalInfo: json['additionalInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cnic': cnic,
      'phoneNumber': phoneNumber,
      'location': location,
      'role': role.toString().split('.').last,
      'isVerified': isVerified,
      'additionalInfo': additionalInfo,
    };
  }
}

enum UserRole { imam, donor, beneficiary }