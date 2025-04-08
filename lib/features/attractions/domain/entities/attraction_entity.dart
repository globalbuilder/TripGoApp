// lib/features/attractions/domain/entities/attraction_entity.dart

import 'category_entity.dart';

class AttractionEntity {
  final int id;
  final CategoryEntity category;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String? description;
  final String? image;   
  final double price;
  final double averageRating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AttractionEntity({
    required this.id,
    required this.category,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.description,
    this.image,
    required this.price,
    required this.averageRating,
    this.createdAt,
    this.updatedAt,
  });
}
