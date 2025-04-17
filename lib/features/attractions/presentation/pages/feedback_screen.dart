// lib/features/attractions/presentation/pages/feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/feedback_entity.dart';
import '../blocs/feedback_bloc/feedback_bloc.dart';
import '../blocs/feedback_bloc/feedback_event.dart';
import '../blocs/feedback_bloc/feedback_state.dart';

class FeedbackPage extends StatefulWidget {
  static const routeName = '/feedback';

  final int attractionId;
  const FeedbackPage({super.key, required this.attractionId});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _commentCtrl = TextEditingController();
  int _rating = 3;

  @override
  void initState() {
    super.initState();
    // pull list from the server
    context.read<FeedbackBloc>().add(FetchFeedbacksEvent(widget.attractionId));
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<FeedbackBloc>().add(CreateFeedbackEvent(
          attractionId: widget.attractionId,
          rating: _rating,
          comment: _commentCtrl.text.trim(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      listener: (_, s) {
        if (s.status == FeedbackStatus.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(s.errorMessage ?? 'Error')));
        }

        // After a successful create/delete we land in the **loaded** state again
        // with an updated list – reset the form for the next review.
        if (s.status == FeedbackStatus.loaded &&
            s.currentAttractionId == widget.attractionId) {
          _commentCtrl.clear();
          setState(() => _rating = 3);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Feedback')),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<FeedbackBloc, FeedbackState>(
                  builder: (_, s) {
                    if (s.status == FeedbackStatus.loading &&
                        s.feedbacks.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (s.feedbacks.isEmpty) {
                      return const Center(child: Text('No feedback yet.'));
                    }
                    return ListView.separated(
                      itemCount: s.feedbacks.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, i) =>
                          _FeedbackTile(feedback: s.feedbacks[i]),
                    );
                  },
                ),
              ),
              const Divider(height: 32),
              Text(
                'Leave a Review',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  const Text('Rating: '),
                  Expanded(
                    child: Slider(
                      value: _rating.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$_rating',
                      onChanged: (v) => setState(() => _rating = v.toInt()),
                    ),
                  ),
                  Text('$_rating'),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _commentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  final FeedbackEntity feedback;
  const _FeedbackTile({required this.feedback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Rating: ${feedback.rating}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(feedback.comment ?? ''),
      trailing: Text(feedback.userUsername ?? 'User#${feedback.userId}'),
    );
  }
}
