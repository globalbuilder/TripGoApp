// lib/features/attractions/presentation/blocs/feedback_bloc/feedback_event.dart
import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();
  @override
  List<Object?> get props => [];
}

/// Pull the whole list for one attraction
class FetchFeedbacksEvent extends FeedbackEvent {
  final int attractionId;
  const FetchFeedbacksEvent(this.attractionId);
  @override
  List<Object?> get props => [attractionId];
}

/// Create / update
class CreateFeedbackEvent extends FeedbackEvent {
  final int attractionId;
  final int rating;
  final String? comment;
  const CreateFeedbackEvent({
    required this.attractionId,
    required this.rating,
    this.comment,
  });
  @override
  List<Object?> get props => [attractionId, rating, comment];
}

/// Delete a specific record, but we still need the attraction id
/// (so the bloc can reload the list afterwards).
class DeleteFeedbackEvent extends FeedbackEvent {
  final int feedbackId;
  final int attractionId;
  const DeleteFeedbackEvent({
    required this.feedbackId,
    required this.attractionId,
  });
  @override
  List<Object?> get props => [feedbackId, attractionId];
}
