import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart'
    show AppointmentTypeModel;
import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/widgets/start_date_body_widget.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/widgets/symptom_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class ReviewSymptomsScreen extends StatefulWidget {
  final String? descriptions;

  const ReviewSymptomsScreen({Key? key, this.descriptions}) : super(key: key);

  @override
  State<ReviewSymptomsScreen> createState() => _ReviewSymptomsScreenState();
}

class _ReviewSymptomsScreenState extends State<ReviewSymptomsScreen> {
  String appointment = '';

  Widget _buildHeaderSection() {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                'Review',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.amethystViolet,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.disabledButton.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: _buildAppointmentRow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Appointment',
          style: AppTextStyles.body2OpenSans,
        ),
        SizedBox(
          height: 50,
          child: VerticalDivider(
            color: Colors.grey.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'existing',
                child: Text(
                  'Add to Existing Visit',
                  style: AppTextStyles.body2OpenSans,
                ),
              ),
              PopupMenuItem(
                value: 'new',
                child: Text(
                  'Create New Visit',
                  style: AppTextStyles.body2OpenSans,
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'existing') {
                final AppointmentTypeModel result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.transparent,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.90,
                    maxChildSize: 0.90,
                    minChildSize: 0.5,
                    builder: (context, scrollController) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const AppointmentTypeScreen(),
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    appointment = result.name;
                  });
                }
              } else {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => const NewAppointmentScreen(),
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 4),
                if (appointment.isEmpty) const Icon(Icons.add, size: 18),
                const SizedBox(width: 4),
                Text(
                  appointment.isEmpty ? 'Add' : appointment,
                  style: AppTextStyles.body2OpenSans,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomChip(String label, Color color, VoidCallback? onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.body2OpenSans),
          const SizedBox(width: 8),
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              child: const Icon(Icons.close, size: 16),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymptomTrackerCubit, SymptomTrackerState>(
      builder: (context, state) {
        final cubit = context.read<SymptomTrackerCubit>();

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Track Symptoms',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await cubit.createSymptomTracker();
                    SnackbarUtils.showSuccess(
                      context: context,
                      title: 'Success',
                      message: 'Symptoms tracked successfully',
                    );
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } catch (e) {
                    SnackbarUtils.showError(
                      context: context,
                      title: 'Error',
                      message: 'Failed to track symptoms. Please try again.',
                    );
                  }
                },
                child: Text(
                  'Save',
                  style: AppTextStyles.body2OpenSans.copyWith(
                    color: AppColors.amethystViolet,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(10),
                    children: [
                      StartDateBodyWidget(
                        dateRange: DateTimeRange(
                            start: cubit.fromDate, end: cubit.toDate),
                        onDateSelected: (date) {
                          cubit.setFromDate(date);
                        },
                        selectedDate: cubit.fromDate,
                      ),
                      const SizedBox(height: 24),
                      _buildSymptomsSection(cubit),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(cubit.symptomDescription),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSymptomsSection(SymptomTrackerCubit cubit) {
    final groupedSymptoms = <String, List<SymptomId>>{};
    for (var symptom in cubit.symptomIds) {
      if (!groupedSymptoms.containsKey(symptom.symptomCategory)) {
        groupedSymptoms[symptom.symptomCategory] = [];
      }
      groupedSymptoms[symptom.symptomCategory]!.add(symptom);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Symptoms', style: AppTextStyles.heading3),
        const SizedBox(height: 16),
        ...groupedSymptoms.entries.map((entry) {
          // Get the symptom type from the first symptom in the group
          final symptomType = entry.value.first.symptomType ?? 'Body';

          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 0),
                  blurRadius: 13.0,
                  spreadRadius: 6.0,
                  color: Colors.black.withOpacity(0.09),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: AppTextStyles.bodyOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Show bottom sheet with the correct symptom type
                        SymptomBottomSheet.show(
                          context,
                          symptomType, // Use the symptom type directly
                          cubit.getSymptoms(
                              symptomType), // Get symptoms for this type
                        );
                      },
                      child: Text(
                        'Change',
                        style: AppTextStyles.body2OpenSans.copyWith(
                          color: AppColors.amethystViolet,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: entry.value.map((symptom) {
                    Color chipColor;
                    switch (symptom.severity.toLowerCase()) {
                      case 'mild':
                        chipColor = Colors.yellow.shade100;
                        break;
                      case 'moderate':
                        chipColor = Colors.orange.shade100;
                        break;
                      case 'severe':
                        chipColor = Colors.red.shade100;
                        break;
                      default:
                        chipColor = Colors.grey.shade100;
                    }
                    return _buildSymptomChip(
                      '${symptom.symptomName}\n${symptom.severity}',
                      chipColor,
                      () {
                        final updatedSymptoms =
                            List<SymptomId>.from(cubit.symptomIds)
                              ..removeWhere((s) =>
                                  s.symptomName == symptom.symptomName &&
                                  s.symptomCategory == symptom.symptomCategory);
                        cubit.setSymptomIds(updatedSymptoms);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDescriptionSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Describe your symptoms', style: AppTextStyles.heading3),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            description.isNotEmpty ? description : 'No description provided',
            style: AppTextStyles.body2OpenSans.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
