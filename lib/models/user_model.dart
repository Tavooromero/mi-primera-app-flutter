class User {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String birthDate;
  final String gender;
  final String address;
  final String occupation;
  final String preferences;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthDate,
    required this.gender,
    required this.address,
    required this.occupation,
    required this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'birthDate': birthDate,
      'gender': gender,
      'address': address,
      'occupation': occupation,
      'preferences': preferences,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      birthDate: json['birthDate'],
      gender: json['gender'],
      address: json['address'],
      occupation: json['occupation'],
      preferences: json['preferences'],
    );
  }
}