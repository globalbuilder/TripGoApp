// lib/features/accounts/data/models/user_model.dart

class UserModel {
  final int id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? address;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.imageUrl,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] ?? '',
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      address: json['address'] as String?,
      imageUrl: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'address': address,
      'image': imageUrl,
    };
  }
}
