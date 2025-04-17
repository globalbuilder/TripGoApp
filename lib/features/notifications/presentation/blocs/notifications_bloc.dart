import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  final GetNotifications getList;
  NotificationsBloc({required this.getList})
      : super(const NotificationsState()) {
    on<LoadNotifications>(_onLoad);
  }

  Future<void> _onLoad(
      LoadNotifications e, Emitter<NotificationsState> emit) async {
    emit(state.copyWith(status: NotifStatus.loading, error: null));
    final Either<Failure, List<NotificationEntity>> res =
        await getList.execute();
    res.fold(
      (f) => emit(state.copyWith(status: NotifStatus.error, error: f.message)),
      (list) => emit(state.copyWith(status: NotifStatus.loaded, list: list)),
    );
  }
}
