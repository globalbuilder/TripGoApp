import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/utils/api_client.dart';

import '../models/category_model.dart';
import '../models/attraction_model.dart';
import '../models/favorite_model.dart';
import '../models/feedback_model.dart';

abstract class IAttractionsRemoteDataSource {
  // ---------------- CATEGORIES ----------------
  Future<List<CategoryModel>> getCategories();
  Future<List<AttractionModel>> getCategoryAttractions(int categoryId);

  // ---------------- ATTRACTIONS ---------------
  Future<List<AttractionModel>> getAllAttractions();
  Future<AttractionModel> getAttractionDetail(int attractionId);

  // ---------------- SEARCH --------------------
  Future<List<AttractionModel>> searchAttractions(String query);

  // ---------------- FEEDBACK ------------------
  Future<void> createFeedback({
    required int attractionId,
    required int rating,
    String? comment,
  });
  Future<void> deleteFeedback(int feedbackId);

  /// Fetch **all** feedback entries of a single attraction.
  Future<List<FeedbackModel>> getAttractionFeedbacks(int attractionId);

  // ---------------- FAVOURITES ----------------
  Future<List<FavoriteModel>> getFavorites();
  Future<void> addFavorite(int attractionId);
  Future<void> removeFavorite(int attractionId);
}

class AttractionsRemoteDataSourceImpl implements IAttractionsRemoteDataSource {
  final ApiClient apiClient;
  AttractionsRemoteDataSourceImpl({required this.apiClient});

  // ================= 1) CATEGORIES =================
  @override
  Future<List<CategoryModel>> getCategories() async {
    final res = await apiClient.get(ApiEndpoints.categories);
    return (res as List)
        .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AttractionModel>> getCategoryAttractions(int id) async {
    final url = ApiEndpoints.categoryAttractions.replaceAll('<id>', '$id');
    final res = await apiClient.get(url);
    return (res as List)
        .map((e) => AttractionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ================= 2) ATTRACTIONS ================
  @override
  Future<List<AttractionModel>> getAllAttractions() async {
    final res = await apiClient.get(ApiEndpoints.attractions);
    return (res as List)
        .map((e) => AttractionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<AttractionModel> getAttractionDetail(int id) async {
    final url = ApiEndpoints.attractionDetail.replaceAll('<id>', '$id');
    final res = await apiClient.get(url);
    return AttractionModel.fromJson(res as Map<String, dynamic>);
  }

  // ================= 3) SEARCH =====================
  @override
  Future<List<AttractionModel>> searchAttractions(String q) async {
    final res = await apiClient.get(
      ApiEndpoints.attractions,
      queryParameters: {'search': q},
    );
    return (res as List)
        .map((e) => AttractionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ================= 4) FEEDBACK ===================
  @override
  Future<void> createFeedback({
    required int attractionId,
    required int rating,
    String? comment,
  }) async {
    await apiClient.post(
      ApiEndpoints.feedback,
      body: {
        'attraction': '$attractionId',
        'rating': '$rating',
        'comment': comment ?? '',
      },
    );
  }

  @override
  Future<void> deleteFeedback(int id) async {
    final url = ApiEndpoints.feedbackDelete.replaceAll('<id>', '$id');
    await apiClient.delete(url);
  }

  @override
  Future<List<FeedbackModel>> getAttractionFeedbacks(int attractionId) async {
    // We now hit /api/feedback/?attraction=<id>
    final res = await apiClient.get(
      ApiEndpoints.feedback,
      queryParameters: {'attraction': '$attractionId'},
    );
    return (res as List)
        .map((e) => FeedbackModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ================= 5) FAVOURITES ================
  @override
  Future<List<FavoriteModel>> getFavorites() async {
    final res = await apiClient.get(ApiEndpoints.favorites);
    return (res as List)
        .map((e) => FavoriteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addFavorite(int id) async =>
      apiClient.post(ApiEndpoints.addFavorite, body: {'attraction': '$id'});

  @override
  Future<void> removeFavorite(int id) async {
    await apiClient
        .post(ApiEndpoints.removeFavorite, body: {'attraction': '$id'});
  }
}
