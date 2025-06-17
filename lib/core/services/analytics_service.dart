import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  // Screen tracking
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  // User properties
  Future<void> setUserProperties({
    required String userId,
    String? userRole,
  }) async {
    await _analytics.setUserId(id: userId);
    if (userRole != null) {
      await _analytics.setUserProperty(name: 'user_role', value: userRole);
    }
  }

  // Custom events
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  Future<void> logLogin() async {
    await _analytics.logLogin(loginMethod: 'email');
  }

  Future<void> logSignUp() async {
    await _analytics.logSignUp(signUpMethod: 'email');
  }

  Future<void> logAppointment({
    required String appointmentType,
    required String status,
  }) async {
    await _analytics.logEvent(
      name: 'appointment_created',
      parameters: {
        'appointment_type': appointmentType,
        'status': status,
      },
    );
  }

  Future<void> logHealthAssessment({
    required String assessmentType,
    required String status,
  }) async {
    await _analytics.logEvent(
      name: 'health_assessment',
      parameters: {
        'assessment_type': assessmentType,
        'status': status,
      },
    );
  }

  Future<void> logSymptomTrack({
    required String symptomName,
    required String severity,
  }) async {
    await _analytics.logEvent(
      name: 'symptom_tracked',
      parameters: {
        'symptom_name': symptomName,
        'severity': severity,
      },
    );
  }

  // Error tracking
  Future<void> logError({
    required String errorName,
    required String errorDescription,
  }) async {
    await _analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error_name': errorName,
        'error_description': errorDescription,
      },
    );
  }
} 