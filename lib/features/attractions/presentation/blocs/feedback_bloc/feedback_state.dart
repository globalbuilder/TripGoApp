// lib/features/attractions/presentation/blocs/feedback_bloc/feedback_state.dart
import 'package:equatable/equatable.dart';
import '../../../domain/entities/feedback_entity.dart';

/// Loading stages that the UI cares about
enum FeedbackStatus { initial, loading, loaded, error }

class FeedbackState extends Equatable {
  final FeedbackStatus status;
  final List<FeedbackEntity> feedbacks;
  final String? errorMessage;
  final int? currentAttractionId;         
  const FeedbackState({
    required this.status,
    this.feedbacks = const [],
    this.errorMessage,
    this.currentAttractionId,
  });

  factory FeedbackState.initial() =>
      const FeedbackState(status: FeedbackStatus.initial);

  FeedbackState copyWith({
    FeedbackStatus? status,
    List<FeedbackEntity>? feedbacks,
    String? errorMessage,
    int? currentAttractionId,
  }) =>
      FeedbackState(
        status: status ?? this.status,
        feedbacks: feedbacks ?? this.feedbacks,
        errorMessage: errorMessage,
        currentAttractionId: currentAttractionId ?? this.currentAttractionId,
      );

  @override
  List<Object?> get props =>
      [status, feedbacks, errorMessage, currentAttractionId];
}
