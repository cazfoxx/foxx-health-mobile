class AppointmentCompanionRequest {
  final List<CompanionItem>? afraidOverlooked;
  final List<CompanionItem>? communicateWithYourHealthcare;
  final List<CompanionItem>? importantSymptomsToDiscuss;
  final CompanionItem? journeyWithThisConcern;
  final String? lastPausedAt;
  final String? lastPausedPage;
  final List<CompanionItem>? lifeStressorsAffectingHealth;
  final CompanionItem? mainReasonForVisit;
  final CompanionItem? prioritizeYourConcerns;
  final String? status;
  final CompanionItem? symptomsBeenChangingOverTime;
  final List<CompanionItem>? tryingToGetCare;
  final CompanionItem? typeOfDoctorProvider;
  final CompanionItem? typeOfVisitOrExam;

  AppointmentCompanionRequest({
    this.afraidOverlooked,
    this.communicateWithYourHealthcare,
    this.importantSymptomsToDiscuss,
    this.journeyWithThisConcern,
    this.lastPausedAt,
    this.lastPausedPage,
    this.lifeStressorsAffectingHealth,
    this.mainReasonForVisit,
    this.prioritizeYourConcerns,
    this.status,
    this.symptomsBeenChangingOverTime,
    this.tryingToGetCare,
    this.typeOfDoctorProvider,
    this.typeOfVisitOrExam,
  });

  factory AppointmentCompanionRequest.fromJson(Map<String, dynamic> json) {
    return AppointmentCompanionRequest(
      afraidOverlooked: json['afraid_overlooked'] != null
          ? (json['afraid_overlooked'] as List)
              .map((item) => CompanionItem.fromJson(item))
              .toList()
          : null,
      communicateWithYourHealthcare: json['communicate_with_your_healthcare'] != null
          ? (json['communicate_with_your_healthcare'] as List)
              .map((item) => CompanionItem.fromJson(item))
              .toList()
          : null,
      importantSymptomsToDiscuss: json['important_symptoms_to_discuss'] != null
          ? (json['important_symptoms_to_discuss'] as List)
              .map((item) => CompanionItem.fromJson(item))
              .toList()
          : null,
      journeyWithThisConcern: json['journey_with_this_concern'] != null
          ? CompanionItem.fromJson(json['journey_with_this_concern'])
          : null,
      lastPausedAt: json['last_paused_at'],
      lastPausedPage: json['last_paused_page'],
      lifeStressorsAffectingHealth: json['life_stressors_affecting_health'] != null
          ? (json['life_stressors_affecting_health'] as List)
              .map((item) => CompanionItem.fromJson(item))
              .toList()
          : null,
      mainReasonForVisit: json['main_reason_for_visit'] != null
          ? CompanionItem.fromJson(json['main_reason_for_visit'])
          : null,
      prioritizeYourConcerns: json['prioritize_your_concerns'] != null
          ? CompanionItem.fromJson(json['prioritize_your_concerns'])
          : null,
      status: json['status'],
      symptomsBeenChangingOverTime: json['symptoms_been_changing_over_time'] != null
          ? CompanionItem.fromJson(json['symptoms_been_changing_over_time'])
          : null,
      tryingToGetCare: json['trying_to_get_care'] != null
          ? (json['trying_to_get_care'] as List)
              .map((item) => CompanionItem.fromJson(item))
              .toList()
          : null,
      typeOfDoctorProvider: json['type_of_doctor_provider'] != null
          ? CompanionItem.fromJson(json['type_of_doctor_provider'])
          : null,
      typeOfVisitOrExam: json['type_of_visit_or_exam'] != null
          ? CompanionItem.fromJson(json['type_of_visit_or_exam'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'afraid_overlooked': afraidOverlooked?.map((item) => item.toJson()).toList(),
      'communicate_with_your_healthcare': communicateWithYourHealthcare?.map((item) => item.toJson()).toList(),
      'important_symptoms_to_discuss': importantSymptomsToDiscuss?.map((item) => item.toJson()).toList(),
      'journey_with_this_concern': journeyWithThisConcern?.toJson(),
      'last_paused_at': lastPausedAt,
      'last_paused_page': lastPausedPage,
      'life_stressors_affecting_health': lifeStressorsAffectingHealth?.map((item) => item.toJson()).toList(),
      'main_reason_for_visit': mainReasonForVisit?.toJson(),
      'prioritize_your_concerns': prioritizeYourConcerns?.toJson(),
      'status': status,
      'symptoms_been_changing_over_time': symptomsBeenChangingOverTime?.toJson(),
      'trying_to_get_care': tryingToGetCare?.map((item) => item.toJson()).toList(),
      'type_of_doctor_provider': typeOfDoctorProvider?.toJson(),
      'type_of_visit_or_exam': typeOfVisitOrExam?.toJson(),
    };
  }
}

class CompanionItem {
  final String description;
  final String value;

  CompanionItem({
    required this.description,
    required this.value,
  });

  factory CompanionItem.fromJson(Map<String, dynamic> json) {
    return CompanionItem(
      description: json['description'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'value': value,
    };
  }
}

class AppointmentCompanionResponse {
  final List<AppointmentCompanion> companions;

  AppointmentCompanionResponse({required this.companions});

  factory AppointmentCompanionResponse.fromJson(dynamic json) {
    if (json is List) {
      // Handle list response (for GET /api/v1/appointment-companions/me)
      return AppointmentCompanionResponse(
        companions: json.map((item) => AppointmentCompanion.fromJson(item)).toList(),
      );
    } else if (json is Map<String, dynamic>) {
      // Handle single object response (for POST /api/v1/appointment-companions)
      return AppointmentCompanionResponse(
        companions: [AppointmentCompanion.fromJson(json)],
      );
    } else {
      throw Exception('Invalid JSON format for AppointmentCompanionResponse');
    }
  }
}

class AppointmentCompanion {
  final AppointmentField typeOfDoctorProvider;
  final AppointmentField typeOfVisitOrExam;
  final AppointmentField mainReasonForVisit;
  final List<AppointmentField> lifeStressorsAffectingHealth;
  final List<AppointmentField> importantSymptomsToDiscuss;
  final AppointmentField journeyWithThisConcern;
  final AppointmentField prioritizeYourConcerns;
  final AppointmentField symptomsBeenChangingOverTime;
  final List<AppointmentField> communicateWithYourHealthcare;
  final List<AppointmentField> tryingToGetCare;
  final List<AppointmentField> afraidOverlooked;
  final String status;
  final String lastPausedPage;
  final DateTime lastPausedAt;
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentCompanion({
    required this.typeOfDoctorProvider,
    required this.typeOfVisitOrExam,
    required this.mainReasonForVisit,
    required this.lifeStressorsAffectingHealth,
    required this.importantSymptomsToDiscuss,
    required this.journeyWithThisConcern,
    required this.prioritizeYourConcerns,
    required this.symptomsBeenChangingOverTime,
    required this.communicateWithYourHealthcare,
    required this.tryingToGetCare,
    required this.afraidOverlooked,
    required this.status,
    required this.lastPausedPage,
    required this.lastPausedAt,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentCompanion.fromJson(Map<String, dynamic> json) {
    return AppointmentCompanion(
      typeOfDoctorProvider: AppointmentField.fromJson(json['type_of_doctor_provider']),
      typeOfVisitOrExam: AppointmentField.fromJson(json['type_of_visit_or_exam']),
      mainReasonForVisit: AppointmentField.fromJson(json['main_reason_for_visit']),
      lifeStressorsAffectingHealth: (json['life_stressors_affecting_health'] as List<dynamic>)
          .map((item) => AppointmentField.fromJson(item))
          .toList(),
      importantSymptomsToDiscuss: (json['important_symptoms_to_discuss'] as List<dynamic>)
          .map((item) => AppointmentField.fromJson(item))
          .toList(),
      journeyWithThisConcern: AppointmentField.fromJson(json['journey_with_this_concern']),
      prioritizeYourConcerns: AppointmentField.fromJson(json['prioritize_your_concerns']),
      symptomsBeenChangingOverTime: AppointmentField.fromJson(json['symptoms_been_changing_over_time']),
      communicateWithYourHealthcare: (json['communicate_with_your_healthcare'] as List<dynamic>)
          .map((item) => AppointmentField.fromJson(item))
          .toList(),
      tryingToGetCare: (json['trying_to_get_care'] as List<dynamic>)
          .map((item) => AppointmentField.fromJson(item))
          .toList(),
      afraidOverlooked: (json['afraid_overlooked'] as List<dynamic>)
          .map((item) => AppointmentField.fromJson(item))
          .toList(),
      status: json['status'] ?? '',
      lastPausedPage: json['last_paused_page'] ?? '',
      lastPausedAt: DateTime.parse(json['last_paused_at']),
      id: json['id'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  String get displayTitle {
    return '${typeOfDoctorProvider.description} - ${typeOfVisitOrExam.description}';
  }

  String get displayDate {
    return _formatDate(createdAt);
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class AppointmentField {
  final String value;
  final String description;

  AppointmentField({
    required this.value,
    required this.description,
  });

  factory AppointmentField.fromJson(Map<String, dynamic> json) {
    return AppointmentField(
      value: json['value'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
