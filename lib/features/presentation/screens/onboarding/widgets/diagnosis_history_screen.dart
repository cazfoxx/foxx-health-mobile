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

class _DiagnosisHistoryScreenState extends State<DiagnosisHistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 🩵 FIX: preserves state when navigating back

  static const double stackedCards = AppSpacing.s12;

  final Set<String> _selectedAnswers = {};
  final TextEditingController _selfDescribeController = TextEditingController();
  bool _showSelfDescribeField = false;
  String _tempSelfDescribeText = ''; // 🔹 store previous custom text

  @override
  void initState() {
    super.initState();

    // 🩵 FIX: Restore previous selections, including custom "Other/self-describe" text
    if (widget.currentValue != null) {
      for (var option in widget.currentValue!) {
        if (_isOtherLabel(option) || !_answers.contains(option)) {
          _showSelfDescribeField = true;
          _selfDescribeController.text = option;
          _tempSelfDescribeText = option;
          _selectedAnswers.add(option); // ensure it stays selected
        } else {
          _selectedAnswers.add(option);
        }
      }
    }
  }

  bool _isOtherLabel(String label) =>
      label.toLowerCase().contains('other') ||
      label.toLowerCase().contains('self-describe') ||
      label.toLowerCase().contains('self describe');

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
          'Other',
        ];
  }

  String get _question {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_HISTORY');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty
        ? 'Do you have any past or current medical diagnoses?'
        : text;
  }

  String get _description {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_HISTORY');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'Have you ever been given a diagnosis that still feels relevant?'
        : text;
  }

  bool get _canProceed {
    final hasNormalSelection =
        _selectedAnswers.any((option) => !_isOtherLabel(option));
    final hasValidSelfDescribe =
        _selectedAnswers.any(_isOtherLabel) &&
            _selfDescribeController.text.trim().isNotEmpty;
    return hasNormalSelection || hasValidSelfDescribe;
  }

  void _toggleOption(String option) {
    setState(() {
      final isSelected = _selectedAnswers.contains(option);

      if (_isOtherLabel(option)) {
        if (isSelected) {
          _selectedAnswers.remove(option);
          _showSelfDescribeField = false;

          _tempSelfDescribeText = _selfDescribeController.text;
          _selfDescribeController.clear();
        } else {
          _selectedAnswers.add(option);
          _showSelfDescribeField = true;

          _selfDescribeController.text = _tempSelfDescribeText;
        }
        return;
      }

      if (isSelected) {
        _selectedAnswers.remove(option);
      } else {
        _selectedAnswers.add(option);
      }
    });
  }

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

  Widget _buildSelfDescribeField() {
    return Visibility(
      visible: _showSelfDescribeField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _selfDescribeController,
          hintText: 'Please specify',
          size: FoxxTextFieldSize.multiLine,
          onChanged: (_) => setState(() {}), // refresh _canProceed
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
    super.build(context); // 🩵 needed for AutomaticKeepAliveClientMixin
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.textBoxHorizontalWidget,
            0,
            AppSpacing.textBoxHorizontalWidget,
            AppSpacing.s80,
          ),
          child: SingleChildScrollView( // 🩵 FIX: ensures proper scroll when coming back
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
        ),
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