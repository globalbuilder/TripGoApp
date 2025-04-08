// lib/features/attractions/presentation/blocs/feedback_bloc/feedback_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

import '../../../domain/usecases/create_feedback.dart';
import '../../../domain/usecases/delete_feedback.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final CreateFeedback createFeedbackUseCase;
  final DeleteFeedback deleteFeedbackUseCase;

  FeedbackBloc({
    required this.createFeedbackUseCase,
    required this.deleteFeedbackUseCase,
  }) : super(FeedbackState.initial()) {
    on<CreateFeedbackEvent>(_onCreateFeedback);
    on<DeleteFeedbackEvent>(_onDeleteFeedback);
  }

  Future<void> _onCreateFeedback(
    CreateFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(state.copyWith(status: FeedbackStatus.loading));

    final result = await createFeedbackUseCase.call(
      attractionId: event.attractionId,
      rating: event.rating,
      comment: event.comment,
    );
    result.fold(
      (failure) => emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: FeedbackStatus.success)),
    );
  }

  Future<void> _onDeleteFeedback(
    DeleteFeedbackEvent event,
    Emitter<FeedbackState> emit,
  ) async {
    emit(state.copyWith(status: FeedbackStatus.loading));

    final result = await deleteFeedbackUseCase.call(event.feedbackId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: FeedbackStatus.error,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(status: FeedbackStatus.success)),
    );
  }
}
