import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';

class SaveTrackSymptoms {
  static Future<void> saveSymptoms(context, screen) async {
    try {
      final symptomTrackerCubit = BlocProvider.of<SymptomTrackerCubit>(context);

      await symptomTrackerCubit.saveData(screen: screen);

      SnackbarUtils.showSuccess(
        context: context,
        title: 'Success',
        message: 'Symptoms data saved successfully',
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } catch (e) {
      Navigator.of(context).pop();
      SnackbarUtils.showError(
        context: context,
        title: 'Error',
        message: 'Failed to save symptoms data',
      );
    }
  }
}
