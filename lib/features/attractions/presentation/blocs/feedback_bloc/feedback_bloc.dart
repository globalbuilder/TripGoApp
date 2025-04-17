// lib/features/attractions/presentation/blocs/feedback_bloc/feedback_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

import '../../../domain/usecases/get_attraction_feedbacks.dart';
import '../../../domain/usecases/create_feedback.dart';
import '../../../domain/usecases/delete_feedback.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final GetAttractionFeedbacks _getList;
  final CreateFeedback _create;
  final DeleteFeedback _delete;

  FeedbackBloc({
    required GetAttractionFeedbacks getAttractionFeedbacks,
    required CreateFeedback createFeedback,
    required DeleteFeedback deleteFeedback,
  })  : _getList = getAttractionFeedbacks,
        _create = createFeedback,
        _delete = deleteFeedback,
        super(FeedbackState.initial()) {
    on<FetchFeedbacksEvent>(_onFetch);
    on<CreateFeedbackEvent>(_onCreate);
    on<DeleteFeedbackEvent>(_onDelete);
  }

  //---------------------------------------------------------------------------
  Future<void> _onFetch(
      FetchFeedbacksEvent e, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(
        status: FeedbackStatus.loading, currentAttractionId: e.attractionId));

    final res = await _getList(e.attractionId);
    res.fold(
      (f) => emit(state.copyWith(
          status: FeedbackStatus.error, errorMessage: f.message)),
      (list) => emit(state.copyWith(
          status: FeedbackStatus.loaded,
          feedbacks: list,
          errorMessage: null)),
    );
  }

  //---------------------------------------------------------------------------
  Future<void> _onCreate(
      CreateFeedbackEvent e, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(status: FeedbackStatus.loading));

    final res = await _create(
      attractionId: e.attractionId,
      rating: e.rating,
      comment: e.comment,
    );

    res.fold(
      (f) => emit(state.copyWith(
          status: FeedbackStatus.error, errorMessage: f.message)),
      (_) {
        // re‑pull list after successful post
        add(FetchFeedbacksEvent(e.attractionId));
      },
    );
  }

  //---------------------------------------------------------------------------
  Future<void> _onDelete(
      DeleteFeedbackEvent e, Emitter<FeedbackState> emit) async {
    emit(state.copyWith(status: FeedbackStatus.loading));

    final res = await _delete(e.feedbackId);

    res.fold(
      (f) => emit(state.copyWith(
          status: FeedbackStatus.error, errorMessage: f.message)),
      (_) {
        // refresh list the same way
        add(FetchFeedbacksEvent(e.attractionId));
      },
    );
  }
}
