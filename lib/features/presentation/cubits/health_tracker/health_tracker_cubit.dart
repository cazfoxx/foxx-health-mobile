import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';

part 'health_tracker_state.dart';

class HealthTrackerCubit extends Cubit<HealthTrackerState> {
  List<Symptom> _selectedSymptoms = [];
  DateTime _selectedDate = DateTime.now();

  HealthTrackerCubit() : super(HealthTrackerInitial());

  List<Symptom> get selectedSymptoms => _selectedSymptoms;
  DateTime get selectedDate => _selectedDate;

  void setSelectedSymptoms(List<Symptom> symptoms) {
    _selectedSymptoms = symptoms;
    emit(HealthTrackerSymptomsUpdated(_selectedSymptoms));
  }

  void addSymptom(Symptom symptom) {
    log('Adding symptom: ');
    if (!_selectedSymptoms.contains(symptom)) {
      _selectedSymptoms.add(symptom);
      emit(HealthTrackerSymptomsUpdated(_selectedSymptoms));
    }
  }

  void removeSymptom(Symptom symptom) {
    _selectedSymptoms.remove(symptom);
    emit(HealthTrackerSymptomsUpdated(_selectedSymptoms));
  }

  void clearSymptoms() {
    _selectedSymptoms.clear();
    emit(HealthTrackerSymptomsUpdated(_selectedSymptoms));
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    emit(HealthTrackerDateUpdated(_selectedDate));
  }
}
