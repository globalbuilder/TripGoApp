import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final INotificationsRemoteDataSource remote;
  NotificationsRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final list = await remote.getNotifications();
      return Right(list);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> getNotificationDetail(int id) async {
    try {
      final model = await remote.getNotificationDetail(id);
      return Right(model);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
