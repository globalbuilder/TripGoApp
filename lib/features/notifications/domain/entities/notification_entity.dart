// lib/features/notifications/domain/entities/notification_entity.dart
class NotificationEntity {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });
}