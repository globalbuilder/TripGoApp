import 'package:trip_go/core/utils/api_client.dart';
import 'package:trip_go/core/constants/api_endpoints.dart';

import '../models/category_model.dart';
import '../models/attraction_model.dart';
import '../models/favorite_model.dart';

abstract class IAttractionsRemoteDataSource {
  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<List<AttractionModel>> getCategoryAttractions(int categoryId);

  // Attractions
  Future<List<AttractionModel>> getAllAttractions();
  Future<AttractionModel> getAttractionDetail(int attractionId);

  // Search
  Future<List<AttractionModel>> searchAttractions(String query);

  // Feedback
  Future<void> createFeedback({
    required int attractionId,
    required int rating,
    String? comment,
  });
  Future<void> deleteFeedback(int feedbackId);

  // Favorites
  Future<List<FavoriteModel>> getFavorites();
  Future<void> addFavorite(int attractionId);
  Future<void> removeFavorite(int attractionId);
}

class AttractionsRemoteDataSourceImpl implements IAttractionsRemoteDataSource {
  final ApiClient apiClient;

  AttractionsRemoteDataSourceImpl({required this.apiClient});

  // -----------------------
  // 1) CATEGORIES
  // -----------------------
  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get(ApiEndpoints.categories);
    // response is likely a list of JSON objects
    return (response as List)
        .map((json) => CategoryModel.fromJson(json))
        .toList();
  }

  @override
  Future<List<AttractionModel>> getCategoryAttractions(int categoryId) async {
    final url = ApiEndpoints.categoryAttractions.replaceAll('<id>', categoryId.toString());
    final response = await apiClient.get(url);
    return (response as List)
        .map((json) => AttractionModel.fromJson(json))
        .toList();
  }

  // -----------------------
  // 2) ATTRACTIONS
  // -----------------------
  @override
  Future<List<AttractionModel>> getAllAttractions() async {
    final response = await apiClient.get(ApiEndpoints.attractions);
    return (response as List)
        .map((json) => AttractionModel.fromJson(json))
        .toList();
  }

  @override
  Future<AttractionModel> getAttractionDetail(int attractionId) async {
    final url = ApiEndpoints.attractionDetail.replaceAll('<id>', attractionId.toString());
    final response = await apiClient.get(url);
    return AttractionModel.fromJson(response);
  }

  // -----------------------
  // 3) SEARCH
  // -----------------------
  @override
  Future<List<AttractionModel>> searchAttractions(String query) async {
    // Using ?search= if your DRF endpoint supports search filtering
    final response = await apiClient.get(
      ApiEndpoints.attractions,
      queryParameters: {'search': query},
    );
    return (response as List)
        .map((json) => AttractionModel.fromJson(json))
        .toList();
  }

  // -----------------------
  // 4) FEEDBACK
  // -----------------------
  @override
  Future<void> createFeedback({
    required int attractionId,
    required int rating,
    String? comment,
  }) async {
    final body = {
      'attraction': attractionId.toString(),
      'rating': rating.toString(),
      'comment': comment ?? '',
    };
    await apiClient.post(ApiEndpoints.feedbackCreate, body: body);
  }

  @override
  Future<void> deleteFeedback(int feedbackId) async {
    final url = ApiEndpoints.feedbackDelete.replaceAll('<id>', feedbackId.toString());
    await apiClient.delete(url);
  }

  // -----------------------
  // 5) FAVORITES
  // -----------------------
  @override
  Future<List<FavoriteModel>> getFavorites() async {
    final response = await apiClient.get(ApiEndpoints.favorites);
    return (response as List)
        .map((json) => FavoriteModel.fromJson(json))
        .toList();
  }

  @override
  Future<void> addFavorite(int attractionId) async {
    final body = {'attraction': attractionId.toString()};
    await apiClient.post(ApiEndpoints.addFavorite, body: body);
  }

  @override
  Future<void> removeFavorite(int attractionId) async {
    // The removeFavorite endpoint expects a DELETE with body {"attraction": id}
    final body = {'attraction': attractionId.toString()};
    await apiClient.delete(ApiEndpoints.removeFavorite, queryParameters: body);
    // Alternatively, if your backend expects a JSON body, you'd do:
    // await apiClient.delete(ApiEndpoints.removeFavorite, headers: {...}, body: {...});
    // but many HTTP clients don’t allow body in DELETE, so you might have
    // to do a custom approach or pass the ID via query parameters.
  }
}
