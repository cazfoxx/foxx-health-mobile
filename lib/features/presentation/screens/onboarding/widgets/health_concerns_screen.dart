import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';

class HealthConcernsScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(Set<String>)? onDataUpdate;
  final ValueChanged<bool>? onEligibilityChanged;

  /// ✅ Pre-fill previously selected concerns
  final Set<String>? currentValue;

  const HealthConcernsScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
    this.onEligibilityChanged,
  });

  @override
  State<HealthConcernsScreen> createState() => _HealthConcernsScreenState();
}

class _HealthConcernsScreenState extends State<HealthConcernsScreen> {
  final Set<String> _selectedAnswers = {};
  final TextEditingController _selfDescribeController = TextEditingController();
  bool _showSelfDescribeField = false;
  String _tempSelfDescribeText = '';

  void _emitEligibility() {
    widget.onEligibilityChanged?.call(_canProceed);
  }

  @override
  void initState() {
    super.initState();

    if (widget.currentValue != null && widget.currentValue!.isNotEmpty) {
      for (final value in widget.currentValue!) {
        final vNorm = value.toLowerCase().trim();
        final canonical = _healthConcerns.firstWhere(
          (opt) => opt.toLowerCase().trim() == vNorm,
          orElse: () => '',
        );

        if (canonical.isNotEmpty) {
          _selectedAnswers.add(canonical);
          if (_isOtherLabel(canonical)) {
            // Show field only if "Other" itself is selected
            if (_tempSelfDescribeText.isNotEmpty) {
              _selfDescribeController.text = _tempSelfDescribeText;
            }
            _showSelfDescribeField = true;
          }
        } else if (value.isNotEmpty) {
          // Free text present, remember but do not auto-select "Other"
          _tempSelfDescribeText = value;
          // Keep field hidden until "Other" is selected again
        }
      }

      // If "Other" currently selected and we have remembered text, prefill
      if (_selectedAnswers.any(_isOtherLabel) &&
          _tempSelfDescribeText.isNotEmpty) {
        _selfDescribeController.text = _tempSelfDescribeText;
        _showSelfDescribeField = true;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _emitEligibility());
  }

  /// ✅ Fetch options from API or use local fallback
  List<String> get _healthConcerns {
    final q =
        OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_CONCERNS');
    final cached = OnboardingCubit.cachedChoicesByType['HEALTH_CONCERNS'];
    final apiChoices = (q?.choices.isNotEmpty ?? false) ? q!.choices : (cached ?? []);

    return apiChoices.isNotEmpty
        ? apiChoices
        : [
            'Chronic pain',
            'Weight management',
            'Sleep problems',
            'Low energy or fatigue',
            'Digestive issues',
            'Skin concerns',
            'Mood or stress',
            'Other',
          ];
  }

  /// ✅ Determine if a label represents "Other"
  bool _isOtherLabel(String label) => label.toLowerCase().trim() == 'other';

  /// ✅ Fallback for question text
  String get _question {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_CONCERNS');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty ? 'What are your main health concerns?' : text;
  }

  /// ✅ Fallback for description text
  String get _description {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'HEALTH_CONCERNS');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'Select all that apply. You can describe other concerns if needed.'
        : text;
  }

  /// ✅ Handles selecting an option
  /// Build payload of selected options plus self-describe text (if any)
  Set<String> _buildPayload() {
    final payload = Set<String>.from(_selectedAnswers);
    final otherText = _selfDescribeController.text.trim();
    if (_selectedAnswers.any(_isOtherLabel) && otherText.isNotEmpty) {
      payload.add(otherText);
    }
    return payload;
  }

  void _toggleOption(String option) {
    setState(() {
      final isSelected = _selectedAnswers.contains(option);
      if (isSelected) {
        _selectedAnswers.remove(option);
        if (_isOtherLabel(option)) {
          _showSelfDescribeField = false;
          // Preserve previously typed text instead of clearing it
          // _tempSelfDescribeText remains as-is
        }
      } else {
        _selectedAnswers.add(option);
        if (_isOtherLabel(option)) {
          _showSelfDescribeField = true;
          if (_tempSelfDescribeText.isNotEmpty &&
              _selfDescribeController.text.trim().isEmpty) {
            _selfDescribeController.text = _tempSelfDescribeText;
          }
        }
      }
    });
    widget.onDataUpdate?.call(_buildPayload());
    _emitEligibility();
  }

  /// ✅ Builds a single selectable option card
  Widget _buildAnswerOption(String option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: SelectableOptionCard(
        label: option,
        isSelected: _selectedAnswers.contains(option),
        isMultiSelect: true,
        onTap: () => _toggleOption(option),
      ),
    );
  }

  /// ✅ Builds the optional self-describe text field
  Widget _buildConditionalTextField({String hintText = 'Please specify'}) {
    return Visibility(
      visible: _showSelfDescribeField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _selfDescribeController,
          hintText: hintText,
          size: FoxxTextFieldSize.multiLine,
          onChanged: (value) {
            _tempSelfDescribeText = value;
            setState(() {});
            widget.onDataUpdate?.call(_buildPayload());
            _emitEligibility();
          },
        ),
      ),
    );
  }

  /// ✅ Builds the option list
  List<Widget> _buildOptionList() {
    final List<Widget> widgets = [];
    for (final option in _healthConcerns) {
      widgets.add(_buildAnswerOption(option));
      if (_isOtherLabel(option)) {
        widgets.add(_buildConditionalTextField());
      }
    }
    return widgets;
  }

  /// ✅ Validates if user can proceed
  bool get _canProceed {
    final hasNormalSelection =
        _selectedAnswers.any((option) => !_isOtherLabel(option));
    final hasValidOther =
        _selectedAnswers.any(_isOtherLabel) &&
        _selfDescribeController.text.trim().isNotEmpty;
    return hasNormalSelection || hasValidOther;
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
        // Main content
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
              OnboardingQuestionHeader(
                questions: widget.questions,
                questionType: 'HEALTH_CONCERNS',
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              const SizedBox(height: AppSpacing.s12),
              ..._buildOptionList(),
            ],
          ),
        ),


      ],
    );
  }
}