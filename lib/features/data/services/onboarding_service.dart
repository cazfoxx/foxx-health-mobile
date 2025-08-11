import 'package:dio/dio.dart';
import 'package:foxxhealth/core/network/api_client.dart';

class OnboardingQuestion {
  final List<String> choices;
  final bool isActive;
  final String type;
  final String fieldName;
  final bool isPremium;
  final String description;
  final String dataType;
  final String flowType;
  final int id;
  final String createdAt;
  final String updatedAt;

  OnboardingQuestion({
    required this.choices,
    required this.isActive,
    required this.type,
    required this.fieldName,
    required this.isPremium,
    required this.description,
    required this.dataType,
    required this.flowType,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnboardingQuestion.fromJson(Map<String, dynamic> json) {
    return OnboardingQuestion(
      choices: List<String>.from(json['choices']),
      isActive: json['is_active'],
      type: json['type'],
      fieldName: json['field_name'],
      isPremium: json['is_premium'],
      description: json['description'],
      dataType: json['data_type'],
      flowType: json['flow_type'],
      id: json['id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class OnboardingService {
  static final ApiClient _apiClient = ApiClient();

  static Future<List<OnboardingQuestion>> getOnboardingQuestions() async {
    try {
      final response = await _apiClient.get('/api/v1/questions/onboarding');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data;
        return jsonData.map((json) => OnboardingQuestion.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load onboarding questions: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error fetching onboarding questions: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching onboarding questions: $e');
    }
  }

  static OnboardingQuestion? getQuestionByType(List<OnboardingQuestion> questions, String type) {
    try {
      return questions.firstWhere((question) => question.type == type);
    } catch (e) {
      return null;
    }
  }
}
