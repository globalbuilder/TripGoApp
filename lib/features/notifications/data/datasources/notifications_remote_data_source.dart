import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/api_client.dart';
import '../models/notification_model.dart';

abstract class INotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();

  Future<NotificationModel> getNotificationDetail(int id);
}

class NotificationsRemoteDataSourceImpl
    implements INotificationsRemoteDataSource {
  final ApiClient apiClient;
  NotificationsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      debugPrint('⏩  GET notifications url = ${ApiEndpoints.notifications}');
      final response = await apiClient.get(ApiEndpoints.notifications);
      final data = response as List<dynamic>;
      return data
          .map((json) => NotificationModel.fromJson(json))
          .toList(growable: false);
    } catch (e) {
      debugPrint('Error in getNotifications: $e');
      rethrow;
    }
  }

  @override
  Future<NotificationModel> getNotificationDetail(int id) async {
    try {
      final url = ApiEndpoints.notificationDetail.replaceAll('<id>', '$id');
      final result = await apiClient.patch(url, body: {'is_read': true});
      return NotificationModel.fromJson(result);
    } catch (e) {
      debugPrint('Error in getNotificationDetail: $e');
      rethrow;
    }
  }
}
