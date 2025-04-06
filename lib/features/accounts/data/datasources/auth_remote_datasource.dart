// lib/features/accounts/data/datasources/auth_remote_datasource.dart

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/api_client.dart';
import '../models/user_model.dart';

abstract class IAuthRemoteDataSource {
  Future<String> login(String username, String password);
  Future<void> register(Map<String, dynamic> registrationData);
  Future<void> logout();
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<UserModel> getUserInfo();
  Future<UserModel> updateProfile(Map<String, dynamic> updatedData);
}

class AuthRemoteDataSourceImpl implements IAuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<String> login(String username, String password) async {
    final data = {'username': username, 'password': password};
    final response = await apiClient.post(ApiEndpoints.login, body: data);
    return response['token'];
  }

  @override
  Future<void> register(Map<String, dynamic> registrationData) async {
    await apiClient.post(ApiEndpoints.register, body: registrationData);
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiEndpoints.logout);
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final body = {
      'old_password': oldPassword,
      'new_password1': newPassword,
      'new_password2': newPassword,
    };
    await apiClient.post(ApiEndpoints.changePassword, body: body);
  }

  @override
  Future<UserModel> getUserInfo() async {
    final response = await apiClient.get(ApiEndpoints.userInfo);
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> updateProfile(Map<String, dynamic> updatedData) async {
    // Typically we use PATCH for partial updates
    final response = await apiClient.patch(ApiEndpoints.userInfo, body: updatedData);
    return UserModel.fromJson(response);
  }
}
