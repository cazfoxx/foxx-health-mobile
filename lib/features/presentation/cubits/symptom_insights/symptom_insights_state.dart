part of 'symptom_insights_cubit.dart';

abstract class SymptomInsightsState {}

class SymptomInsightsInitial extends SymptomInsightsState {}

class SymptomInsightsLoading extends SymptomInsightsState {}

class SymptomInsightsLoaded extends SymptomInsightsState {
  final List<SymptomRecord> records;

  SymptomInsightsLoaded({required this.records});
}

class SymptomInsightsError extends SymptomInsightsState {
  final String message;

  SymptomInsightsError({required this.message});
}

/// Represents a single symptom record for a specific day
class SymptomRecord {
  final String name;
  final DateTime date;
  final int severity;
  final int frequency;
  final String onset;
  final String painRelievedByActivity;
  final String painRelievedByRest;
  final String painWorseAtNight;
  final String painWorseWithMovement;
  final String painWorseWithSitting;
  final String painWorseWithStanding;
  final String impactOnDailyLife;
  final String notes;

  SymptomRecord({
    required this.name,
    required this.date,
    required this.severity,
    required this.frequency,
    required this.onset,
    required this.painRelievedByActivity,
    required this.painRelievedByRest,
    required this.painWorseAtNight,
    required this.painWorseWithMovement,
    required this.painWorseWithSitting,
    required this.painWorseWithStanding,
    required this.impactOnDailyLife,
    required this.notes,
  });

  factory SymptomRecord.fromJson(Map<String, dynamic> json, String symptomName) {
    return SymptomRecord(
      name: symptomName,
      date: DateTime.parse(json['date']),
      severity: json['severity'] ?? 0,
      frequency: json['frequency'] ?? 0,
      onset: json['onset'] ?? '',
      painRelievedByActivity: json['pain_relieved_by_activity'] ?? '',
      painRelievedByRest: json['pain_relieved_by_rest'] ?? '',
      painWorseAtNight: json['pain_worse_at_night'] ?? '',
      painWorseWithMovement: json['pain_worse_with_movement'] ?? '',
      painWorseWithSitting: json['pain_worse_with_sitting'] ?? '',
      painWorseWithStanding: json['pain_worse_with_standing'] ?? '',
      impactOnDailyLife: json['impact_on_daily_life'] ?? '',
      notes: json['notes'] ?? '',
    );
  }
}
