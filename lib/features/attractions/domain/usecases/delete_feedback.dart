// lib/features/attractions/domain/usecases/delete_feedback.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/attractions_repository.dart';

class DeleteFeedback {
  final AttractionsRepository repository;

  DeleteFeedback(this.repository);

  Future<Either<Failure, void>> call(int feedbackId) async {
    return await repository.deleteFeedback(feedbackId);
  }
}
