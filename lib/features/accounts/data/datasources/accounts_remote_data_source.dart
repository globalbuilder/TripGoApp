import 'package:image_picker/image_picker.dart';

import 'package:trip_go/core/constants/api_endpoints.dart';
import 'package:trip_go/core/utils/api_client.dart';
import '../models/user_model.dart';

abstract class IAccountsRemoteDataSource {
  Future<String> login(String username, String password);
  Future<void> register(Map<String, dynamic> registrationData,
      {dynamic imageFile});
  Future<void> logout();
  Future<void> changePassword(
      {required String oldPassword, required String newPassword});
  Future<UserModel> getUserInfo();
  Future<UserModel> updateProfile(Map<String, dynamic> updatedData,
      {dynamic imageFile});
}

class AccountsRemoteDataSourceImpl implements IAccountsRemoteDataSource {
  final ApiClient apiClient;

  AccountsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<String> login(String username, String password) async {
    final data = {'username': username, 'password': password};
    final response = await apiClient.post(ApiEndpoints.login, body: data);
    return response['token'];
  }

  @override
  Future<void> register(Map<String, dynamic> registrationData,
      {dynamic imageFile}) async {
    // If the user picked an image, do a multipart upload.
    if (imageFile != null) {
      final xFile = imageFile as XFile;
      final Map<String, String> fields = {
        'username': registrationData['username']?.toString() ?? '',
        'password1': registrationData['password1']?.toString() ?? '',
        'password2': registrationData['password2']?.toString() ?? '',
        'first_name': registrationData['first_name']?.toString() ?? '',
        'last_name': registrationData['last_name']?.toString() ?? '',
      };

      await apiClient.uploadMultipart(
        url: ApiEndpoints.register,
        fields: fields,
        filePath: xFile.path,
        fileFieldName: 'image', // Adjust if Django expects a different name
      );
    } else {
      // Otherwise, send a normal JSON POST
      await apiClient.post(ApiEndpoints.register, body: registrationData);
    }
  }

  @override
  Future<void> logout() async {
    await apiClient.post(ApiEndpoints.logout);
  }

  @override
  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
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
  Future<UserModel> updateProfile(Map<String, dynamic> updatedData,
      {dynamic imageFile}) async {
    final response =
        await apiClient.patch(ApiEndpoints.userInfo, body: updatedData);
    return UserModel.fromJson(response);
  }
}
