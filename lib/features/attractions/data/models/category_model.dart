import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required int id,
    required String name,
    String? image,
    int? attractionsCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          name: name,
          image: image,
          attractionsCount: attractionsCount,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      image: json['image'] as String?,
      attractionsCount: json['attractions_count'] as int?,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
