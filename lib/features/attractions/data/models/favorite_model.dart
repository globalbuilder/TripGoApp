import '../../domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required int id,
    required int userId,
    String? userUsername,
    required int attractionId,
    String? attractionName,
    required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          userUsername: userUsername,
          attractionId: attractionId,
          attractionName: attractionName,
          createdAt: createdAt,
        );

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as int,
      userId: (json['user'] is Map) ? json['user']['id'] : json['user'] ?? 0,
      userUsername: json['user_username'] as String?,
      attractionId: (json['attraction'] is Map)
          ? json['attraction']['id']
          : json['attraction'] ?? 0,
      attractionName: json['attraction_name'] as String?,
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
