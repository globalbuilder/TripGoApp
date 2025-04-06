// lib/features/accounts/domain/repositories/i_auth_repository.dart


import 'package:image_picker/image_picker.dart';
import 'package:trip_go/features/accounts/domain/entities/user_entity.dart';

abstract class IAuthRepository {
  Future<String> login(String username, String password);
  Future<void> register(Map<String, dynamic> registrationData);
  Future<void> logout();
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<UserEntity> getUserInfo();
  Future<UserEntity> updateProfile(Map<String, dynamic> updatedData, {XFile? imageFile});
}
