class SignUp {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? phoneNumber;

  SignUp({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'password': password,
    'phone_number': phoneNumber,
  };

  factory SignUp.fromJson(Map<String, dynamic> json) {
    return SignUp(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phone_number'],
    );
  }
}
