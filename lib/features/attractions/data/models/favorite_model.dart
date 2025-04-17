import '../../domain/entities/favorite_entity.dart';

/// DTO that converts backend JSON into [FavoriteEntity].
class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required int id,
    required int userId,
    String? userUsername,
    required int attractionId,
    String? attractionName,
    String? attractionImage,
    required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          userUsername: userUsername,
          attractionId: attractionId,
          attractionName: attractionName,
          attractionImage: attractionImage,
          createdAt: createdAt,
        );

  /// Build from API JSON
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    // `attraction` might be a nested object or just an id
    final attraction = json['attraction'];

    return FavoriteModel(
      id: json['id'] as int,
      userId: (json['user'] is Map) ? json['user']['id'] : json['user'] ?? 0,
      userUsername: json['user_username'] as String?,
      attractionId:
          (attraction is Map) ? attraction['id'] : attraction as int? ?? 0,
      attractionName: json['attraction_name'] ??
          (attraction is Map ? attraction['name'] as String? : null),
      attractionImage: json['attraction_image'] ??
          (attraction is Map ? attraction['image'] as String? : null),
      createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
    );
  }

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());
}
