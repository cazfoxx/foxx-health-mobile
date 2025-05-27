import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_response.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/prepping_assessment_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/symptoms_selection_sheet.dart';

class SymptomTrackerHealthAssessmentScreen extends StatefulWidget {
  const SymptomTrackerHealthAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<SymptomTrackerHealthAssessmentScreen> createState() =>
      _SymptomTrackerHealthAssessmentScreenState();
}

class _SymptomTrackerHealthAssessmentScreenState
    extends State<SymptomTrackerHealthAssessmentScreen> {
  final _searchController = TextEditingController();
  List<SymptomTrackerResponse> selectedSymptoms = [];

  final List<String> symptoms = [
    'Brain fog',
    'Changes in eating habits',
    'Difficulty completing tasks',
    'Sharp pain - Chest & upper back',
    'Tingling or numbness - Legs & feet',
    'Symptom'
  ];

  void _showSymptomSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SymptomsSelectionSheet(
        onSymptomSelected: (SymptomTrackerResponse symptom) {
          context.read<HealthAssessmentCubit>().setSymptoms(symptom);
          setState(() {
            selectedSymptoms.add(symptom);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Symptom Tracker',
      subtitle:
          'Select which symptoms you\'d like to feed into the health assessment',
      progress: 0.8,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreppingAssessmentScreen(),
          ),
        );
      },
      isNextEnabled: selectedSymptoms.isNotEmpty,
      body: GestureDetector(
        onTap: _showSymptomSelector,
        child: Container(
          padding: const EdgeInsets.all(13),
          margin: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select symptoms from the tracker',
                style: AppTextStyles.bodyOpenSans.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (selectedSymptoms.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedSymptoms
                      .map(
                        (symptom) => Chip(
                          label:
                              Text(symptom.symptomIds?.first.symptomName ?? ''),
                          onDeleted: () {
                            setState(() {
                              selectedSymptoms.remove(symptom);
                            });
                          },
                          backgroundColor: AppColors.optionBG,
                          deleteIconColor: AppColors.amethystViolet,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                readOnly: true,
                onTap: _showSymptomSelector,
                decoration: InputDecoration(
                  hintText: 'Enter',
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
