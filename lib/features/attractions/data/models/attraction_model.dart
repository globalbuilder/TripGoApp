import '../../domain/entities/attraction_entity.dart';
import 'category_model.dart';

class AttractionModel extends AttractionEntity {
  const AttractionModel({
    required int id,
    required CategoryModel category,
    required String name,
    required double latitude,
    required double longitude,
    String? address,
    String? description,
    String? image,
    required double price,
    required double averageRating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          category: category,
          name: name,
          latitude: latitude,
          longitude: longitude,
          address: address,
          description: description,
          image: image,
          price: price,
          averageRating: averageRating,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory AttractionModel.fromJson(Map<String, dynamic> json) {
    return AttractionModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      category: CategoryModel.fromJson(json['category'] is Map
          ? json['category']
          : {
              // If you only get category ID or name, you need to create a minimal CategoryModel
              'id': json['category'] ?? 0,
              'name': json['category_name'] ?? '',
            }),
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      address: json['address'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      price: _toDouble(json['price']),
      averageRating: _toDouble(json['average_rating']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
