import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/view/onboarding_flow.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_buttons.dart';

/// NOTE:
/// - This is a **multi-select** page. The Next button is shown only when the user selects at least one answer.
/// - Screen now handles Next button internally, like IncomeScreen.

class DiagnosisHistoryScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(Set<String>)? onDataUpdate;

  const DiagnosisHistoryScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,

  });

  @override
  State<DiagnosisHistoryScreen> createState() => _DiagnosisHistoryScreenState();
}

class _DiagnosisHistoryScreenState extends State<DiagnosisHistoryScreen>
    implements HasNextButtonState {
  static const double stackedCards = AppSpacing.s12;

  final Set<String> _selectedAnswers = {};
  final TextEditingController _otherController = TextEditingController();
  bool _showOtherField = false;

  List<String> get _answers {
    final onboardingCubit = OnboardingCubit();
    final question = onboardingCubit.getQuestionByType(widget.questions, 'HEALTH_HISTORY');
    return question?.choices ??
        [
          'Anxiety or Depression',
          'Autoimmune condition (e.g., lupus, Hashimoto\'s)',
          'Cancer (any type)',
          'Chronic fatigue or burnout',
          'Diabetes or insulin resistance',
          'Endometriosis',
          'Heart Disease',
          'High blood pressure',
          'IBS or other digestive issues',
          'PCOS (Polycystic Ovary Syndrome)',
          'I\'m not sure / still figuring it out',
        ];
  }

  String get _description {
    final onboardingCubit = OnboardingCubit();
    final question = onboardingCubit.getQuestionByType(widget.questions, 'HEALTH_HISTORY');
    return question?.description ?? 'Have you ever been given a diagnosis that still feels relevant?';
  }

  // ---------------------
  // Validation
  // ---------------------
  bool hasValidSelection() {
    return _selectedAnswers.isNotEmpty || (_showOtherField && _otherController.text.isNotEmpty);
  }

  // ---------------------
  // Build option card
  // ---------------------
  Widget _buildAnswerListOption(String option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: stackedCards),
      child: SelectableOptionCard(
        label: option,
        isSelected: _selectedAnswers.contains(option),
        isMultiSelect: true,
        variant: SelectableOptionVariant.brandSecondary,
        onTap: () {
          setState(() {
            if (_selectedAnswers.contains(option)) {
              _selectedAnswers.remove(option);
            } else {
              _selectedAnswers.add(option);
            }
          });
        },
      ),
    );
  }

  Widget _buildOtherAnswerWithTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: stackedCards),
      child: SelectableOptionCard(
        label: 'Other',
        isSelected: _selectedAnswers.contains('Other'),
        isMultiSelect: true,
        variant: SelectableOptionVariant.brandSecondary,
        onTap: () {
          setState(() {
            if (_selectedAnswers.contains('Other')) {
              _selectedAnswers.remove('Other');
              _showOtherField = false;
            } else {
              _selectedAnswers.add('Other');
              _showOtherField = true;
            }
          });
        },
      ),
    );
  }

  Widget _buildOtherTextInputField() {
    return Visibility(
      visible: _showOtherField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _otherController,
          hintText: 'Please specify',
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  // ---------------------
  // Build screen
  // ---------------------
  @override
  Widget build(BuildContext context) {
    final canProceed = hasValidSelection();
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.textBoxHorizontalWidget,
        0,
        AppSpacing.textBoxHorizontalWidget,
        AppSpacing.s24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OnboardingQuestionHeader(
            questions: widget.questions,
            questionType: 'HEALTH_HISTORY',
            questionOverride: 'Have you ever been given a diagnosis that still feels relevant?',
          ),
          ..._answers.map(_buildAnswerListOption).toList(),
          _buildOtherAnswerWithTextField(),
          _buildOtherTextInputField(),

          // ---------------------
          // Next button handled internally like IncomeScreen
          // ---------------------
          if (canProceed)
            SizedBox(
              width: double.infinity,
              child: FoxxNextButton(
                text: 'Next',
                isEnabled: true,
                onPressed: () {
                  final selectedOptions = Set<String>.from(_selectedAnswers);
                  if (_showOtherField && _otherController.text.isNotEmpty) {
                    selectedOptions.remove('Other');
                    selectedOptions.add(_otherController.text);
                  }
                  widget.onDataUpdate?.call(selectedOptions);
                  FocusScope.of(context).unfocus();
                  widget.onNext?.call();
                },
              ),
            ),
        ],
      ),
    );
  }
}