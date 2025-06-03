import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/save_track_symptoms.dart';
import 'package:foxxhealth/core/utils/screens_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/symptoms/symptoms_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptoms/symptoms_state.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/describe_symptoms_screen.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/widgets/symptom_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/reminder_dialog.dart';

class SelectSymptomsScreen extends StatefulWidget {
  const SelectSymptomsScreen({Key? key}) : super(key: key);

  @override
  State<SelectSymptomsScreen> createState() => _SelectSymptomsScreenState();
}

class _SelectSymptomsScreenState extends State<SelectSymptomsScreen> {
  final List<SymptomCategory> categories = [
    SymptomCategory(
      title: 'Body',
      description:
          'How you\'re feeling physically, like energy levels, sleep, or pain',
    ),
    SymptomCategory(
      title: 'Mood',
      description: 'Your emotions, stress levels, or general mood changes',
    ),
    SymptomCategory(
      title: 'Mind',
      description: 'Things like focus, memory, or mental clarity',
    ),
    SymptomCategory(
      title: 'Habits',
      description:
          'Changes in how you act or interact, like routines, socializing, or motivation',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Select Symptoms',
      subtitle:
          'Tap any category to pick what you want to track — you can choose more than one!',
      progress: 0.5,
      appbarTitle: 'Track Symptoms',
      onSave: () async {
        ReminderDialog.show(
          context,
          onGetReminder: () {
            SaveTrackSymptoms.saveSymptoms(
                context, SymptomScreen.selectSymptoms);
          },
          screen: ScreensEnum.trackSymptoms,
        );
      },
      onNext: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DescribeSymptomsScreen()));
      },
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () async {
                final cubit = context.read<SymptomsCubit>();

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.amethystViolet,
                    ),
                  ),
                );

                await cubit.fetchSymptomsByCategory(category.title);

                if (!mounted) return;
                Navigator.pop(context); // Dismiss loading indicator

                if (cubit.state is SymptomsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text((cubit.state as SymptomsError).message),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                if (cubit.state is SymptomsLoaded) {
                  final symptoms = (cubit.state as SymptomsLoaded).symptoms;
                  final categoryData = Category(
                    title: category.title,
                    symptoms: symptoms
                        .map((symptom) => SymptomItem(
                              name: symptom.symptomName,
                              isSelected: false,
                            ))
                        .toList(),
                  );

                  if (!mounted) return;
                  SymptomBottomSheet.show(
                    context,
                    category.title,
                    [categoryData],
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: AppTextStyles.bodyOpenSans.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.77,
                          child: Text(
                            category.description,
                            style: AppTextStyles.body2OpenSans.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SymptomCategory {
  final String title;
  final String description;

  SymptomCategory({
    required this.title,
    required this.description,
  });
}
