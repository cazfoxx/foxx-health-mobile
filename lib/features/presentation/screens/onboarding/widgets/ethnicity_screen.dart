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
  final Function(Set<String>)? onDataUpdate;
  final ValueChanged<bool>? onEligibilityChanged;

  /// ✅ Pre-fill previously selected ethnicity
  final Set<String>? currentValue;

  const EthnicityScreen({
    super.key,
    this.onNext,
    required this.questions,
    this.onDataUpdate,
    this.currentValue,
    this.onEligibilityChanged,
  });

  @override
  State<EthnicityScreen> createState() => _EthnicityScreenState();
}

class _EthnicityScreenState extends State<EthnicityScreen> {
  final Set<String> _selectedAnswers = {};
  final TextEditingController _selfDescribeController = TextEditingController();
  bool _showSelfDescribeField = false;
  String _tempSelfDescribeText = '';
  Set<String>? _previousSelectedAnswers;

  void _emitEligibility() {
    final canProceed = _canProceed; // existing derived boolean
    widget.onEligibilityChanged?.call(canProceed);
  }

  @override
  void initState() {
    super.initState();
    // Restore selections and hidden text using HealthConcerns template
    if (widget.currentValue != null && widget.currentValue!.isNotEmpty) {
      final values = widget.currentValue!;
      final preferNotLabel =
          _answers.firstWhere(_isPreferNotToSayLabel, orElse: () => '');

      // Handle exclusive "Prefer not to say"
      if (preferNotLabel.isNotEmpty &&
          values.any((v) =>
              v.toLowerCase().trim() == preferNotLabel.toLowerCase().trim())) {
        _selectedAnswers
          ..clear()
          ..add(preferNotLabel);
        _showSelfDescribeField = false;
        _selfDescribeController.clear();
      } else {
        for (final v in values) {
          final canonical = _answers.firstWhere(
            (opt) => opt.toLowerCase().trim() == v.toLowerCase().trim(),
            orElse: () => '',
          );
          if (canonical.isNotEmpty) {
            _selectedAnswers.add(canonical);
            if (_isSelfDescribeLabel(canonical)) {
              _showSelfDescribeField = true;
            }
          } else {
            // Remember free text (self-describe) but do not auto-select
            _tempSelfDescribeText = v;
          }
        }
        if (_showSelfDescribeField && _tempSelfDescribeText.isNotEmpty) {
          _selfDescribeController.text = _tempSelfDescribeText;
        }
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _emitEligibility());
  }

  bool _isPreferNotToSayLabel(String label) =>
      label.toLowerCase().trim() == 'prefer not to say' ||
      label.toLowerCase().trim() == 'prefer not to answer';

  bool _isSelfDescribeLabel(String label) {
    final s = label.toLowerCase().trim();
    return s == 'prefer to self-describe' || s == 'prefer to self describe';
  }

  bool _isOtherLabel(String label) => label.toLowerCase().trim() == 'other';

  List<String> get _answers {
    final q = OnboardingCubit().getQuestionByType(widget.questions, 'ETHNICITY');
    final cached = OnboardingCubit.cachedChoicesByType['ETHNICITY'];
    final apiChoices = (q?.choices.isNotEmpty ?? false) ? q!.choices : (cached ?? []);

    return apiChoices.isNotEmpty
        ? apiChoices
        : [
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

  String get _question {
    final question = OnboardingCubit().getQuestionByType(widget.questions, 'ETHNICITY');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty ? 'What is your ethnicity?' : text;
  }

  String get _description {
    final question = OnboardingCubit().getQuestionByType(widget.questions, 'ETHNICITY');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'Please select all that apply. You can self-describe if needed.'
        : text;
  }

  Set<String> _buildPayload() {
    final payload = Set<String>.from(_selectedAnswers);
    final selfText = _selfDescribeController.text.trim();
    if (_selectedAnswers.any(_isSelfDescribeLabel) && selfText.isNotEmpty) {
      payload.add(selfText);
    }
    return payload;
  }

  void _toggleOption(String option) {
    setState(() {
      final isSelected = _selectedAnswers.contains(option);

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

      if (isSelected) {
        _selectedAnswers.remove(option);
        if (_isSelfDescribeLabel(option)) _showSelfDescribeField = false;
      } else {
        if (_selectedAnswers.any(_isPreferNotToSayLabel)) {
          _selectedAnswers.removeWhere(_isPreferNotToSayLabel);
          if (_previousSelectedAnswers != null) {
            _selectedAnswers.addAll(_previousSelectedAnswers!);
          }
          _previousSelectedAnswers = null;
        }
        _selectedAnswers.add(option);
        if (_isSelfDescribeLabel(option)) _showSelfDescribeField = true;
      }
    });
    widget.onDataUpdate?.call(_buildPayload());
    _emitEligibility();
  }

  bool get _canProceed {
    final hasNormalSelection =
        _selectedAnswers.any((option) => !_isSelfDescribeLabel(option));
    final hasValidSelfDescribe =
        _selectedAnswers.any(_isSelfDescribeLabel) &&
        _selfDescribeController.text.trim().isNotEmpty;
    return hasNormalSelection || hasValidSelfDescribe;
  }

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

  Widget _buildConditionalTextField({String hintText = 'Please specify'}) {
    return Visibility(
      visible: _showSelfDescribeField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.s16),
        child: FoxxTextField(
          controller: _selfDescribeController,
          hintText: hintText,
          size: FoxxTextFieldSize.multiLine,
          onChanged: (_) {
            setState(() {});
            widget.onDataUpdate?.call(_buildPayload());
            _emitEligibility();
          },
        ),
      ),
    );
  }

  List<Widget> _buildOptionList() {
    final List<Widget> widgets = [];
    for (var option in _answers) {
      if (_isPreferNotToSayLabel(option)) continue;
      widgets.add(_buildAnswerOption(option));
      if (_isSelfDescribeLabel(option)) widgets.add(_buildConditionalTextField());
    }
    final preferNotToSay = _answers.firstWhere(_isPreferNotToSayLabel, orElse: () => '');
    if (preferNotToSay.isNotEmpty) widgets.add(_buildAnswerOption(preferNotToSay));
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
                questionType: 'ETHNICITY',
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