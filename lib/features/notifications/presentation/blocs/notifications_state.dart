import 'package:equatable/equatable.dart';
import '../../domain/entities/notification_entity.dart';

enum NotifStatus { initial, loading, loaded, error }

class NotificationsState extends Equatable {
  final NotifStatus status;
  final List<NotificationEntity> list;
  final String? error;

  const NotificationsState({
    this.status = NotifStatus.initial,
    this.list = const [],
    this.error,
  });

  int get unreadCount => list.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    NotifStatus? status,
    List<NotificationEntity>? list,
    String? error,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      list: list ?? this.list,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, list, error];
}
