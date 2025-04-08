// lib/features/attractions/presentation/blocs/feedback_bloc/feedback_state.dart

import 'package:equatable/equatable.dart';

enum FeedbackStatus { initial, loading, success, error }

class FeedbackState extends Equatable {
  final FeedbackStatus status;
  final String? errorMessage;

  const FeedbackState({required this.status, this.errorMessage});

  factory FeedbackState.initial() => const FeedbackState(status: FeedbackStatus.initial);

  FeedbackState copyWith({
    FeedbackStatus? status,
    String? errorMessage,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
