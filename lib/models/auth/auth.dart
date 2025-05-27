class SignUpRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phoneNumber;
  final String fcmToken;

  SignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'phone_number': phoneNumber,
    'fcmTokens': fcmToken, // Match backend field
  };
}

class LoginRequest {
  final String email;
  final String password;
  final String fcmToken;

  LoginRequest({
    required this.email,
    required this.password,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'fcmTokens': fcmToken,
  };
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User? user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      user: json['data'] != null ? User.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String imageProfile;
  final String imageCover;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.imageProfile,
    required this.imageCover,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      imageProfile: json['image_profile'] ?? '',
      imageCover: json['image_cover'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'phone_number': phoneNumber,
    'image_profile': imageProfile,
    'image_cover': imageCover,
  };

  String get fullName => '$firstName $lastName';
}