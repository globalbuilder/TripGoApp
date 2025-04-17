import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notification_detail.dart';

class NotificationDetailScreen extends StatefulWidget {
  final int id;
  const NotificationDetailScreen({super.key, required this.id});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  NotificationEntity? _notif;
  String? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetch();
  }

  Future<void> _fetch() async {
    final useCase = GetIt.I<GetNotificationDetail>();
    final res = await useCase.execute(widget.id);
    res.fold(
      (f) => setState(() => _error = f.message),
      (n) => setState(() => _notif = n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat.yMMMMd().add_jm();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Notification'),
      body: _error != null
          ? Center(child: Text(_error!))
          : _notif == null
              ? const CustomLoader()
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _notif!.title,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dateFmt.format(_notif!.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Divider(height: 32),
                      Text(
                        _notif!.message,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
    );
  }
}
