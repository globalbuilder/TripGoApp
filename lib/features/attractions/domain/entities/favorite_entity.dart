// lib/features/attractions/domain/entities/favorite_entity.dart

class FavoriteEntity {
  final int id;
  final int userId;
  final String? userUsername;
  final int attractionId;
  final String? attractionName;
  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    this.userUsername,
    required this.attractionId,
    this.attractionName,
    required this.createdAt,
  });
}
