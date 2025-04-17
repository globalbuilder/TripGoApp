import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/feedback_entity.dart';
import '../repositories/attractions_repository.dart';

class GetAttractionFeedbacks {
  final AttractionsRepository _repo;
  GetAttractionFeedbacks(this._repo);

  Future<Either<Failure, List<FeedbackEntity>>> call(int attractionId) {
    return _repo.getAttractionFeedbacks(attractionId);
  }
}
