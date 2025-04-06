// lib/core/constants/api_endpoints.dart

class ApiEndpoints {
  static const String baseUrl = 'https://tripgoserver.pythonanywhere.com/api';

  // Accounts
  static const String register = '$baseUrl/accounts/register/';
  static const String login = '$baseUrl/accounts/login/';
  static const String logout = '$baseUrl/accounts/logout/';
  static const String changePassword = '$baseUrl/accounts/change-password/';
  static const String userInfo = '$baseUrl/accounts/me/';

  // Attractions
  static const String categories = '$baseUrl/categories/';
  static const String categoryAttractions = '$baseUrl/categories/<id>/attractions/';
  static const String attractions = '$baseUrl/attractions/';
  static const String attractionDetail = '$baseUrl/attractions/<id>/';
  static const String feedbackCreate = '$baseUrl/feedback/';
  static const String feedbackDelete = '$baseUrl/feedback/<id>/';

  // Favorites
  static const String favorites = '$baseUrl/favorites/';
  static const String addFavorite = '$baseUrl/favorites/add/';
  static const String removeFavorite = '$baseUrl/favorites/remove/';

  // Notifications
  static const String notifications = '$baseUrl/notifications/';
  static const String notificationDetail = '$baseUrl/notifications/<id>/';
}
