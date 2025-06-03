import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';

class SaveChecklist {
  static Future<void> saveSymptoms(context, screen) async {
    try {
      final checklistCubit = BlocProvider.of<ChecklistCubit>(context);

      await checklistCubit.saveData(screen: screen);

      SnackbarUtils.showSuccess(
        context: context,
        title: 'Success',
        message: 'Checklist data saved successfully',
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
        message: 'Failed to save Checklist data',
      );
    }
  }
}
