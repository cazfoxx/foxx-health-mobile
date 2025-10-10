import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/data/models/feedback_model.dart';

class FeedbackService {
  final ApiClient _apiClient = ApiClient();

  Future<bool> submitFeedback(FeedbackModel feedback) async {
    try {
      final response = await _apiClient.post(
        '/api/v1/feedbacks/',
        data: feedback.toJson(),
      );
      
      // Log the response for debugging
      print('Feedback API Response: ${response.statusCode}');
      print('Feedback API Data: ${response.data}');
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Feedback API Error: $e');
      rethrow;
    }
  }

  Future<bool> emailFeedback(FeedbackModel feedback) async {
    try {
      final response = await _apiClient.post(
        '/api/v1/feedbacks/',
        data: feedback.toJson(),
      );
      
      // Log the response for debugging
      print('Feedback API Response: ${response.statusCode}');
      print('Feedback API Data: ${response.data}');
      
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Feedback API Error: $e');
      rethrow;
    }
  }
}
