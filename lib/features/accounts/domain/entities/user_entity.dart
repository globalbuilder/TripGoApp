// lib/features/accounts/domain/entities/user_entity.dart

class UserEntity {
  final int id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? address;
  final String? imageUrl;

  const UserEntity({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.imageUrl,
  });
}
