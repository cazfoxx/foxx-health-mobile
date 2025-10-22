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

  /// ✅ Pre-fill previously selected concerns
  final Set<String>? currentValue;

  const HealthConcernsScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
  });

  @override
  State<HealthConcernsScreen> createState() => _HealthConcernsScreenState();
}

class _HealthConcernsScreenState extends State<HealthConcernsScreen> {
  final Set<String> _selectedAnswers = {};
  final TextEditingController _selfDescribeController = TextEditingController();
  bool _showSelfDescribeField = false;
  String _tempSelfDescribeText = '';

  @override
  void initState() {
    super.initState();

    // ✅ Standardized restore logic (matches EthnicityScreen)
    if (widget.currentValue != null && widget.currentValue!.isNotEmpty) {
      final storedValues = widget.currentValue!;

      for (final value in storedValues) {
        final vNorm = value.toLowerCase().trim();

        // Match to known options
        final canonical = _healthConcerns.firstWhere(
          (opt) => opt.toLowerCase().trim() == vNorm,
          orElse: () => '',
        );

        if (canonical.isNotEmpty) {
          _selectedAnswers.add(canonical);
          if (_isOtherLabel(canonical)) {
            _showSelfDescribeField = true;
          }
        } else if (value.isNotEmpty) {
          // Unknown text — treat as self-describe
          final otherLabel = _healthConcerns.firstWhere(
            _isOtherLabel,
            orElse: () => 'Other',
          );
          _selectedAnswers.add(otherLabel);
          _showSelfDescribeField = true;
          _selfDescribeController.text = value;
          _tempSelfDescribeText = value;
        }
      }
    }
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
  void _toggleOption(String option) {
    setState(() {
      final isSelected = _selectedAnswers.contains(option);
      if (isSelected) {
        _selectedAnswers.remove(option);
        if (_isOtherLabel(option)) {
          _showSelfDescribeField = false;
          _tempSelfDescribeText = '';
        }
      } else {
        _selectedAnswers.add(option);
        if (_isOtherLabel(option)) {
          _showSelfDescribeField = true;
        }
      }
    });
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

        // Fixed "Next" button
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

                  /// 🟩 Persist the data before navigating
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