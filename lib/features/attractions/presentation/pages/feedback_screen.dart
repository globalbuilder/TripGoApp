import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/feedback_entity.dart';
import '../blocs/feedback_bloc/feedback_bloc.dart';
import '../blocs/feedback_bloc/feedback_event.dart';
import '../blocs/feedback_bloc/feedback_state.dart';

/// A page that shows existing feedback for an attraction and allows creating new feedback.
class FeedbackPage extends StatefulWidget {
  static const routeName = '/feedback';

  final int attractionId;
  // Optionally pass existing feedback if you have them
  final List<FeedbackEntity> existingFeedback;

  const FeedbackPage({
    Key? key,
    required this.attractionId,
    this.existingFeedback = const [],
  }) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _commentController = TextEditingController();
  int _rating = 3;

  // If you have a BLoC or method to load existing feedback from server, do it in initState.

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onSubmitFeedback() {
    context.read<FeedbackBloc>().add(
          CreateFeedbackEvent(
            attractionId: widget.attractionId,
            rating: _rating,
            comment: _commentController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      listener: (context, state) {
        if (state.status == FeedbackStatus.error) {
          final msg = state.errorMessage ?? "Error submitting feedback";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        } else if (state.status == FeedbackStatus.success) {
          // Reset form
          _commentController.clear();
          setState(() {
            _rating = 3;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Feedback submitted successfully!")),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Feedback"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Existing feedback list (optional)
              if (widget.existingFeedback.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.existingFeedback.length,
                    itemBuilder: (context, index) {
                      final feedback = widget.existingFeedback[index];
                      return _FeedbackListItem(feedback: feedback);
                    },
                  ),
                ),

              // or if you're fetching from an API, you might display a "Load feedback" approach here.

              const SizedBox(height: 16),
              // Divider
              const Divider(),
              const SizedBox(height: 16),

              // Create feedback form
              Text("Leave a Review", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),

              // Rating
              Row(
                children: [
                  const Text("Rating: "),
                  Expanded(
                    child: Slider(
                      value: _rating.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: "$_rating",
                      onChanged: (val) {
                        setState(() => _rating = val.toInt());
                      },
                    ),
                  ),
                  Text("$_rating"),
                ],
              ),
              const SizedBox(height: 8),

              // Comment
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: "Comment (optional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("Submit Feedback"),
                onPressed: _onSubmitFeedback,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackListItem extends StatelessWidget {
  final FeedbackEntity feedback;

  const _FeedbackListItem({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        title: Text(
          "Rating: ${feedback.rating}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(feedback.comment ?? ""),
        trailing: Text(feedback.userUsername ?? "User #${feedback.userId}"),
      ),
    );
  }
}
