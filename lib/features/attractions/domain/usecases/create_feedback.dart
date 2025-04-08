// lib/features/attractions/domain/usecases/create_feedback.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/attractions_repository.dart';

class CreateFeedback {
  final AttractionsRepository repository;

  CreateFeedback(this.repository);

  Future<Either<Failure, void>> call({
    required int attractionId,
    required int rating,
    String? comment,
  }) async {
    return await repository.createFeedback(
      attractionId: attractionId,
      rating: rating,
      comment: comment,
    );
  }
}
