import 'dart:convert';

class User {
  String id;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String address;
  String? profileImage;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.profileImage,
  });

  String get fullName => '$firstName $lastName';

  factory User.empty() {
    return User(
      id: 'default_user',
      firstName: '',
      lastName: '',
      email: '',
      phoneNumber: '',
      address: '',
      profileImage: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImage': profileImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 'default_user',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      profileImage: map['profileImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}