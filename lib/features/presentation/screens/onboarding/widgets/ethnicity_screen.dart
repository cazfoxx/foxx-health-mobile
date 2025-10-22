import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';

class EthnicityScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(String)? onDataUpdate;

  /// ✅ Pre-fill previously selected ethnicity
  final String? currentValue;

  const EthnicityScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
  });

  @override
  State<EthnicityScreen> createState() => _EthnicityScreenState();
}

class _EthnicityScreenState extends State<EthnicityScreen> {
  // Multi-select support
  final Set<String> _selectedAnswers = {};

  /// Controller for self-describe / "Other" text input field
  final TextEditingController _selfDescribeController = TextEditingController();

  /// Visibility state of the self-describe text field
  bool _showSelfDescribeField = false;

  /// Backup of previous selections before "Prefer not to say" was selected
  Set<String>? _previousSelectedAnswers;

  @override
  void initState() {
    super.initState();

    /// 🟩 FIXED: Restore previous selections and self-describe field correctly
    if (widget.currentValue != null && widget.currentValue!.isNotEmpty) {
      final storedValue = widget.currentValue!;
      final values = storedValue.split(',').map((e) => e.trim()).toList();

      for (final value in values) {
        if (_isPreferNotToSayLabel(value)) {
          _selectedAnswers
            ..clear()
            ..add(value);
          _showSelfDescribeField = false;
          break;
        } else if (_answers.contains(value)) {
          // ✅ Only add known options to selection
          _selectedAnswers.add(value);
        } else if (value.isNotEmpty) {
          // ✅ Unknown value → user’s free-text self-description
          final selfDescribeLabel = _answers.firstWhere(
            (e) => _isSelfDescribeLabel(e) || _isOtherLabel(e),
            orElse: () => 'Prefer to self-describe',
          );
          _selectedAnswers.add(selfDescribeLabel);
          _selfDescribeController.text = value;
          _showSelfDescribeField = true;
        }
      }
    }
  }

  /// ✅ Determines if a label represents "Prefer not to say / answer"
  bool _isPreferNotToSayLabel(String label) =>
      label.toLowerCase().trim() == 'prefer not to say' ||
      label.toLowerCase().trim() == 'prefer not to answer';

  /// ✅ Determines if a label represents "Prefer to self-describe"
  bool _isSelfDescribeLabel(String label) =>
      label.toLowerCase().trim() == 'prefer to self-describe';

  /// ✅ Determine if a label is an "Other" option
  bool _isOtherLabel(String label) => label.toLowerCase().trim() == 'other';

  /// ✅ Fetches options from API or returns local default options
  List<String> get _answers {
    final q = OnboardingCubit().getQuestionByType(widget.questions, 'ETHNICITY');
    return q?.choices ?? [
      'Hispanic or Latino',
      'White (Non-Hispanic)',
      'Black or African American',
      'Asian',
      'Native American or Alaska Native',
      'Native Hawaiian or Other Pacific Islander',
      'Middle Eastern or North African',
      'Mixed/Multiracial',
      'Prefer to self-describe',
      'Prefer not to say',
    ];
  }

  /// ✅ Fallback for question text
  String get _question {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'ETHNICITY');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty ? 'What is your ethnicity?' : text;
  }

  /// ✅ Fallback for description text
  String get _description {
    final question =
        OnboardingCubit().getQuestionByType(widget.questions, 'ETHNICITY');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'Please select all that apply. You can self-describe if needed.'
        : text;
  }

  /// ✅ Handles tapping an option, including multi-select and "Prefer not to say"
  void _toggleOption(String option) {
    setState(() {
      final isSelected = _selectedAnswers.contains(option);

      // Handle "Prefer not to say" (mutually exclusive)
      if (_isPreferNotToSayLabel(option)) {
        if (!isSelected) {
          _previousSelectedAnswers = Set<String>.from(_selectedAnswers);
          _selectedAnswers
            ..clear()
            ..add(option);
          _showSelfDescribeField = false;
        } else {
          _selectedAnswers.remove(option);
          if (_previousSelectedAnswers != null) {
            _selectedAnswers.addAll(_previousSelectedAnswers!);
          }
          _previousSelectedAnswers = null;
          _showSelfDescribeField =
              _selectedAnswers.any((s) => _isSelfDescribeLabel(s));
        }
        return;
      }

      // Regular multi-select toggling
      if (isSelected) {
        _selectedAnswers.remove(option);
        if (_isSelfDescribeLabel(option)) {
          _showSelfDescribeField = false; // hide input when deselected
        }
      } else {
        // Remove "Prefer not to say" if selected
        if (_selectedAnswers.any(_isPreferNotToSayLabel)) {
          _selectedAnswers.removeWhere(_isPreferNotToSayLabel);
          if (_previousSelectedAnswers != null) {
            _selectedAnswers.addAll(_previousSelectedAnswers!);
          }
          _previousSelectedAnswers = null;
        }
        _selectedAnswers.add(option);
        if (_isSelfDescribeLabel(option)) {
          _showSelfDescribeField = true; // show input when selected
        }
      }
    });
  }

  /// ✅ Returns true if user made at least one valid selection
  bool get _canProceed {
    final hasNormalSelection =
        _selectedAnswers.any((option) => !_isSelfDescribeLabel(option));
    final hasValidSelfDescribe =
        _selectedAnswers.any(_isSelfDescribeLabel) &&
        _selfDescribeController.text.trim().isNotEmpty;

    return hasNormalSelection || hasValidSelfDescribe;
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

  /// ✅ Builds the self-describe / "Other" text input field
  Widget _buildConditionalTextField({String hintText = 'Please specify'}) {
    return Visibility(
      visible: _showSelfDescribeField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _selfDescribeController,
          hintText: hintText,
          size: FoxxTextFieldSize.multiLine,
          onChanged: (_) => setState(() {}), // triggers _canProceed update
        ),
      ),
    );
  }

  /// ✅ Builds the list of options with self-describe input **below "Prefer to self-describe"**
  List<Widget> _buildOptionList() {
    final List<Widget> widgets = [];

    for (var option in _answers) {
      if (_isPreferNotToSayLabel(option)) continue;
      widgets.add(_buildAnswerOption(option));

      if (_isSelfDescribeLabel(option)) {
        widgets.add(_buildConditionalTextField());
      }
    }

    // Add "Prefer not to say" at the bottom
    final preferNotToSay = _answers.firstWhere(
      _isPreferNotToSayLabel,
      orElse: () => '',
    );
    if (preferNotToSay.isNotEmpty) {
      widgets.add(_buildAnswerOption(preferNotToSay));
    }

    return widgets;
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
              /// ✅ Question + description header
              OnboardingQuestionHeader(
                questions: widget.questions,
                questionType: 'ETHNICITY',
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              const SizedBox(height: AppSpacing.s12),
              ..._buildOptionList(),
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
                  final selected = Set<String>.from(_selectedAnswers);
                  if (_selectedAnswers.any(_isSelfDescribeLabel) &&
                      _selfDescribeController.text.trim().isNotEmpty) {
                    selected.removeWhere(_isSelfDescribeLabel);
                    selected.add(_selfDescribeController.text.trim());
                  }

                  /// 🟩 UPDATED: Ensure persistence for back navigation
                  widget.onDataUpdate?.call(selected.join(', '));
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