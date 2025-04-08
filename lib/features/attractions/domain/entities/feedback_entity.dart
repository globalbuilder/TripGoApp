// lib/features/attractions/domain/entities/feedback_entity.dart

class FeedbackEntity {
  final int id;
  final int userId;
  final String? userUsername;
  final int attractionId;
  final String? attractionName;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const FeedbackEntity({
    required this.id,
    required this.userId,
    this.userUsername,
    required this.attractionId,
    this.attractionName,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
