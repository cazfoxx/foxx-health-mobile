import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/add_notes_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/base_checklist_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class SuggestedQuestionsScreen extends StatefulWidget {
  final String appointmentType;

  const SuggestedQuestionsScreen({
    super.key,
    required this.appointmentType,
  });

  @override
  State<SuggestedQuestionsScreen> createState() =>
      _SuggestedQuestionsScreenState();
}

class _SuggestedQuestionsScreenState extends State<SuggestedQuestionsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseChecklistScreen(
      title: 'Suggested Questions',
      subtitle: 'Select questions you\'d like to add to your checklist',
      progress: 0.2,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _suggestedQuestions.length,
                itemBuilder: (context, index) {
                  final question = _suggestedQuestions[index];
                  return _buildQuestionItem(question);
                },
              ),
            ),
            OnboardingButton(
              text: 'Next',
              onPressed: () {
                final selectedQuestions = _selectedQuestions.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .toList();

                // Store selected questions in ChecklistCubit
                final checklistCubit = context.read<ChecklistCubit>();
                checklistCubit.setSuggestedQuestion(selectedQuestions);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotesScreen(
                      appointmentType: widget.appointmentType,
                      selectedQuestions: selectedQuestions,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  final Map<String, bool> _selectedQuestions = {};

  List<String> get _suggestedQuestions {
    // Return different questions based on appointment type
    switch (widget.appointmentType) {
      case 'Checkup':
        return [
          'What screenings should I be getting based on my age and family history?',
          'Are my vital signs within normal range?',
          'Do I need any vaccinations?',
          'Are there any specific lifestyle changes I should make?',
        ];
      case 'Gynecological':
        return [
          'Is my menstrual cycle normal?',
          'Should I be concerned about these symptoms?',
          'What birth control options would be best for me?',
          'When should I schedule my next pap smear?',
        ];
      case 'Dermatological':
        return [
          'Is this mole/spot concerning?',
          'What can I do to improve my skin condition?',
          'Are there any treatments for my specific skin issue?',
          'How often should I have a skin check?',
        ];
      default:
        return [
          'What should I know about my condition?',
          'Are there any side effects to my medication?',
          'How can I manage my symptoms better?',
          'When should I schedule a follow-up?',
        ];
    }
  }

  Widget _buildQuestionItem(String question) {
    final isSelected = _selectedQuestions[question] ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CheckboxListTile(
        title: Text(
          question,
          style: AppTextStyles.body2OpenSans,
        ),
        value: isSelected,
        activeColor: AppColors.amethystViolet,

        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity
            .trailing, // Changed from leading to trailing
        onChanged: (value) {
          setState(() {
            _selectedQuestions[question] = value ?? false;
          });
        },
      ),
    );
  }
}
