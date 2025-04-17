// get_notification_detail.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationDetail {
  final NotificationsRepository repository;
  GetNotificationDetail(this.repository);

  /// Returns the full notification; backend marks it read automatically
  Future<Either<Failure, NotificationEntity>> execute(int id) {
    return repository.getNotificationDetail(id);
  }
}
