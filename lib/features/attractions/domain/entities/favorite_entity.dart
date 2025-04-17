/// Holds the favourite record **plus just enough attraction info** to draw
/// the favourites list without another network round‑trip.
class FavoriteEntity {
  final int id;

  // --- user ---
  final int userId;
  final String? userUsername;

  // --- attraction ---
  final int attractionId;
  final String? attractionName;
  final String? attractionImage;

  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    this.userUsername,
    required this.attractionId,
    this.attractionName,
    this.attractionImage,
    required this.createdAt,
  });
}
