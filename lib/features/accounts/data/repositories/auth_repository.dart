// lib/features/accounts/data/repositories/auth_repository.dart

import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/preferences_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;
  final PreferencesHelper preferencesHelper;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.preferencesHelper,
  });

  @override
  Future<String> login(String username, String password) async {
    // Call remoteDataSource to login and get token.
    final token = await remoteDataSource.login(username, password);
    // Save token locally to persist the login
    await preferencesHelper.saveToken(token);
    return token;
  }

  @override
  Future<void> register(Map<String, dynamic> registrationData) async {
    // Registration is performed via remoteDataSource.
    await remoteDataSource.register(registrationData);
  }

  @override
  Future<void> logout() async {
    // Inform the backend about the logout.
    await remoteDataSource.logout();
    // Remove token from SharedPreferences.
    await preferencesHelper.clearToken();
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await remoteDataSource.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<UserEntity> getUserInfo() async {
    // Always fetch fresh user data from backend.
    final userModel = await remoteDataSource.getUserInfo();
    return _mapModelToEntity(userModel);
  }

  @override
  Future<UserEntity> updateProfile(Map<String, dynamic> updatedData, {XFile? imageFile}) async {
    final userModel = await remoteDataSource.updateProfile(updatedData);
    return _mapModelToEntity(userModel);
  }

  UserEntity _mapModelToEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      username: model.username,
      email: model.email,
      firstName: model.firstName,
      lastName: model.lastName,
      phoneNumber: model.phoneNumber,
      address: model.address,
      imageUrl: model.imageUrl,
    );
  }
}
