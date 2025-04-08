// lib/features/attractions/domain/entities/category_entity.dart

class CategoryEntity {
  final int id;
  final String name;
  final String? image;         // URL or file path
  final int? attractionsCount; // optional, used if the backend returns it
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    this.image,
    this.attractionsCount,
    this.createdAt,
    this.updatedAt,
  });
}
