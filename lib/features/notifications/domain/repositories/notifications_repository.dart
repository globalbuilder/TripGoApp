import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  /// Fetches the user’s entire notifications list.
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

  /// Fetches a single notification and marks it "is_read = true" on the server.
  Future<Either<Failure, NotificationEntity>> getNotificationDetail(int id);
}
