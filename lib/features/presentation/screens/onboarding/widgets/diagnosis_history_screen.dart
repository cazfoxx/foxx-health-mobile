import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/view/onboarding_flow.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_buttons.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

class DiagnosisHistoryScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(Set<String>)? onDataUpdate;

  /// ✅ Pre-fill previously selected diagnoses
  final Set<String>? currentValue;

  const DiagnosisHistoryScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
  });

  @override
  State<DiagnosisHistoryScreen> createState() =>
      _DiagnosisHistoryScreenState();
}

class _DiagnosisHistoryScreenState extends State<DiagnosisHistoryScreen> {
  static const double stackedCards = AppSpacing.s12;

  final Set<String> _selectedAnswers = {};
  final TextEditingController _selfDescribeController = TextEditingController();
  bool _showSelfDescribeField = false;

  /// 🔹 Remember previous self-describe text even if deselected
  String _tempSelfDescribeText = '';

  @override
  void initState() {
    super.initState();

    // ✅ Restore previous selections if any
    if (widget.currentValue != null) {
      for (var option in widget.currentValue!) {
        if (_isOtherLabel(option)) {
          _showSelfDescribeField = true;
          _selfDescribeController.text = option;
          _tempSelfDescribeText = option; // ✅ store for future toggling
        } else {
          _selectedAnswers.add(option);
        }
      }
    }
  }

  /// ✅ Determine if an option is a self-describe / other option
  bool _isOtherLabel(String label) =>
      label.toLowerCase().contains('other') ||
      label.toLowerCase().contains('self-describe');

  /// ✅ Fetch answers (choices) from API, fallback to local defaults
  List<String> get _answers {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_HISTORY');
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

  /// ✅ Fallback for question title
  String get _question {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_HISTORY');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty
        ? 'Do you have any past or current medical diagnoses?'
        : text;
  }

  /// ✅ Fallback for description
  String get _description {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_HISTORY');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'Have you ever been given a diagnosis that still feels relevant?'
        : text;
  }

  /// ✅ Determines if Next button can be pressed
  bool get _canProceed {
    final hasNormalSelection = _selectedAnswers.any((option) => !_isOtherLabel(option));
    final hasValidSelfDescribe =
        _selectedAnswers.any(_isOtherLabel) && _selfDescribeController.text.trim().isNotEmpty;
    return hasNormalSelection || hasValidSelfDescribe;
  }

  /// ✅ Toggle the selection of an option
  void _toggleOption(String option) {
    setState(() {
      final isSelected = _selectedAnswers.contains(option);

      // Handle self-describe / Other input field
      if (_isOtherLabel(option)) {
        if (isSelected) {
          _selectedAnswers.remove(option);
          _showSelfDescribeField = false;

          // 🔹 Store text before clearing
          _tempSelfDescribeText = _selfDescribeController.text;
          _selfDescribeController.clear();
        } else {
          _selectedAnswers.add(option);
          _showSelfDescribeField = true;

          // 🔹 Restore previous text if exists
          _selfDescribeController.text = _tempSelfDescribeText;
        }
        return;
      }

      // Regular multi-select toggling
      if (isSelected) {
        _selectedAnswers.remove(option);
      } else {
        _selectedAnswers.add(option);
      }
    });
  }

  /// ✅ Build a selectable option card
  Widget _buildAnswerOption(String option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: stackedCards),
      child: SelectableOptionCard(
        label: option,
        isSelected: _selectedAnswers.contains(option),
        isMultiSelect: true,
        onTap: () => _toggleOption(option),
      ),
    );
  }

  /// ✅ Build the text input for self-describe / Other
  Widget _buildSelfDescribeField() {
    return Visibility(
      visible: _showSelfDescribeField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _selfDescribeController,
          hintText: 'Please specify',
          size: FoxxTextFieldSize.multiLine,
          onChanged: (_) => setState(() {}), // triggers _canProceed
        ),
      ),
    );
  }

  @override
  void dispose() {
    _selfDescribeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content (scroll handled by parent)
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.textBoxHorizontalWidget,
            0,
            AppSpacing.textBoxHorizontalWidget,
            AppSpacing.s80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ Question + description header with fallbacks
              OnboardingQuestionHeader(
                questions: widget.questions,
                questionType: 'HEALTH_HISTORY',
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              const SizedBox(height: AppSpacing.s12),
              ..._answers.map(_buildAnswerOption),
              _buildSelfDescribeField(),
            ],
          ),
        ),

        // Fixed bottom "Next" button
        Positioned(
          left: AppSpacing.textBoxHorizontalWidget,
          right: AppSpacing.textBoxHorizontalWidget,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          child: AnimatedOpacity(
            opacity: _canProceed ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !_canProceed,
              child: FoxxNextButton(
                text: 'Next',
                isEnabled: _canProceed,
                onPressed: () {
                  // Prepare submission: replace "Other/self-describe" with entered text
                  final selected = Set<String>.from(_selectedAnswers);
                  if (_selectedAnswers.any(_isOtherLabel) &&
                      _selfDescribeController.text.trim().isNotEmpty) {
                    selected.removeWhere(_isOtherLabel);
                    selected.add(_selfDescribeController.text.trim());
                  }
                  widget.onDataUpdate?.call(selected);
                  FocusScope.of(context).unfocus();
                  widget.onNext?.call();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}