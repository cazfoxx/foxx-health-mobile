import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/save_checklist.dart';
import 'package:foxxhealth/core/utils/screens_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_enums.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/add_notes_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/base_checklist_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';
import 'package:foxxhealth/features/presentation/widgets/reminder_dialog.dart';

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
  final Map<String, bool> _selectedQuestions = {};
  List<Map<String, dynamic>> _curatedQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCuratedQuestions();
  }

  Future<void> _fetchCuratedQuestions() async {
    final checklistCubit = context.read<ChecklistCubit>();
    final questions = await checklistCubit.getCuratedQuestions();
    setState(() {
      _curatedQuestions = questions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseChecklistScreen(
      title: 'Suggested Questions',
      onSave: () {
        ReminderDialog.show(
          context,
          onGetReminder: () {
            SaveChecklist.saveSymptoms(context, ChecklistScreen.suggestedQuestions);
          },
          screen: ScreensEnum.checklist,
        );
      },
      subtitle: 'Select questions you\'d like to add to your checklist',
      progress: 0.2,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _curatedQuestions.length,
                      itemBuilder: (context, index) {
                        final question = _curatedQuestions[index];
                        return _buildQuestionItem(
                          question['text'],
                          question['id'],
                        );
                      },
                    ),
            ),
            OnboardingButton(
              text: 'Next',
              onPressed: () {
                final selectedQuestionTexts = <String>[];
                final selectedQuestionIds = <int>[];

                _selectedQuestions.forEach((text, isSelected) {
                  if (isSelected) {
                    selectedQuestionTexts.add(text);
                    // Find the matching question ID
                    int questionId = 0;
                    for (final question in _curatedQuestions) {
                      if (question['text'] == text) {
                        questionId = question['id'] as int;
                        break;
                      }
                    }
                    selectedQuestionIds.add(questionId);
                  }
                });

                // Store selected questions and their IDs in ChecklistCubit
                final checklistCubit = context.read<ChecklistCubit>();
                checklistCubit.updateCuratedQuestions(
                  selectedQuestionTexts,
                  selectedQuestionIds,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotesScreen(
                      appointmentType: widget.appointmentType,
                      selectedQuestions: selectedQuestionTexts,
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

  Widget _buildQuestionItem(String question, int questionId) {
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
        controlAffinity: ListTileControlAffinity.trailing,
        onChanged: (value) {
          setState(() {
            _selectedQuestions[question] = value ?? false;
          });
        },
      ),
    );
  }
}
