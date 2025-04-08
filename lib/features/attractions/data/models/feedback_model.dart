import '../../domain/entities/feedback_entity.dart';

class FeedbackModel extends FeedbackEntity {
  const FeedbackModel({
    required int id,
    required int userId,
    String? userUsername,
    required int attractionId,
    String? attractionName,
    required int rating,
    String? comment,
    required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          userUsername: userUsername,
          attractionId: attractionId,
          attractionName: attractionName,
          rating: rating,
          comment: comment,
          createdAt: createdAt,
        );

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as int,
      userId: (json['user'] is Map) ? json['user']['id'] : json['user'] ?? 0,
      userUsername: json['user_username'] as String?,
      attractionId: (json['attraction'] is Map)
          ? json['attraction']['id']
          : json['attraction'] ?? 0,
      attractionName: json['attraction_name'] as String?,
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String?,
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
