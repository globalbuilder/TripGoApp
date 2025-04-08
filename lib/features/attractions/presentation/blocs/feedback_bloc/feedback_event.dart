// lib/features/attractions/presentation/blocs/feedback_bloc/feedback_event.dart

import 'package:equatable/equatable.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object?> get props => [];
}

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

class DeleteFeedbackEvent extends FeedbackEvent {
  final int feedbackId;

  const DeleteFeedbackEvent(this.feedbackId);

  @override
  List<Object?> get props => [feedbackId];
}
