import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../../core/utils/messages.dart';
import '../blocs/notifications_bloc.dart';
import '../blocs/notifications_event.dart';
import '../blocs/notifications_state.dart';
import 'notification_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notifications';
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const LoadNotifications());
  }

  Future<void> _refresh() async =>
      context.read<NotificationsBloc>().add(const LoadNotifications());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: BlocConsumer<NotificationsBloc, NotificationsState>(
        listenWhen: (prev, curr) =>
            curr.status == NotifStatus.error && curr.error != null,
        listener: (context, state) {
          // show SnackBar AFTER build
          MessageUtils.showErrorMessage(context, state.error!);
        },
        builder: (context, state) {
          if (state.status == NotifStatus.loading) {
            return const CustomLoader();
          }

          if (state.list.isEmpty) {
            return const Center(child: Text('No notifications.'));
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.list.length,
              itemBuilder: (_, i) {
                final n = state.list[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(
                      n.isRead
                          ? Icons.notifications
                          : Icons.notifications_active,
                      color: n.isRead
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                    ),
                    title: Text(
                      n.title,
                      style: n.isRead
                          ? null
                          : theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              NotificationDetailScreen(id: n.id),
                        ),
                      );
                      // refresh after returning
                      context
                          .read<NotificationsBloc>()
                          .add(const LoadNotifications());
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
