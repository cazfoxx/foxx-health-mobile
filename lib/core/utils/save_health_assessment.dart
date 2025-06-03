import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessement_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';

class SaveHealthAssessment {
  static Future<void> saveAssessment(
      context, HealthAssessmentScreen screen) async {
    try {
      final healthAssessmentCubit =
          BlocProvider.of<HealthAssessmentCubit>(context);

      await healthAssessmentCubit.saveData(screen: screen);

      SnackbarUtils.showSuccess(
        context: context,
        title: 'Success',
        message: 'Health assessment data saved successfully',
      );

      log('Health assessment data saved successfully');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } catch (e) {
      log('Error saving assessment: $e');
      Navigator.of(context).pop();
      SnackbarUtils.showError(
        context: context,
        title: 'Error',
        message: 'Failed to save health assessment data',
      );
    }
  }
}
