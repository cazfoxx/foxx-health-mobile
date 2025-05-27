import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class PhysicalInfoBottomSheet extends StatefulWidget {
  final int initialFeet;
  final int initialInches;
  final double initialWeight;
  final int initialAge;

  const PhysicalInfoBottomSheet({
    Key? key,
    required this.initialFeet,
    required this.initialInches,
    required this.initialWeight,
    required this.initialAge,
  }) : super(key: key);

  @override
  State<PhysicalInfoBottomSheet> createState() =>
      _PhysicalInfoBottomSheetState();
}

class _PhysicalInfoBottomSheetState extends State<PhysicalInfoBottomSheet> {
  late TextEditingController _feetController;
  late TextEditingController _inchesController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _feetController =
        TextEditingController(text: widget.initialFeet.toString());
    _inchesController =
        TextEditingController(text: widget.initialInches.toString());
    _weightController =
        TextEditingController(text: widget.initialWeight.toString());
    _ageController = TextEditingController(text: widget.initialAge.toString());
  }

  @override
  void dispose() {
    _feetController.dispose();
    _inchesController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _updatePhysicalInfo() {
    final feet = int.tryParse(_feetController.text) ?? 0;
    final inches = int.tryParse(_inchesController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final age = int.tryParse(_ageController.text) ?? 0;

    final cubit = context.read<HealthAssessmentCubit>();
    cubit.setHeightInFeet(feet);
    cubit.setHeightInInches(inches);
    cubit.setUserWeight(weight.toInt());
    cubit.setAge(age);

    if (feet > 0 && inches >= 0 && inches < 12 && weight > 0 && age > 0) {
      context.read<HealthAssessmentCubit>().updateHealthAssessment(
            feet: feet,
            inches: inches,
            weight: weight.toInt(),
            age: age,
          );
      SnackbarUtils.showSuccess(
          context: context,
          title: 'Success!',
          message: 'Physical information updated');
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid values')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Update Physical Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _feetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Feet',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _inchesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Inches',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight (lbs)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _updatePhysicalInfo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amethystViolet,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Update'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
