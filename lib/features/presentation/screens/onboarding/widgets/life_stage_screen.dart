import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';

class LifeStageScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(String)? onDataUpdate;
  final String? currentValue; // ✅ Previously selected life stage

  const LifeStageScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
  });

  @override
  State<LifeStageScreen> createState() => _LifeStageScreenState();
}

class _LifeStageScreenState extends State<LifeStageScreen> {
  final Set<String> _selectedAnswers = {};
  final TextEditingController _selfDescribeController = TextEditingController();
  bool _showSelfDescribeField = false;

  @override
  void initState() {
    super.initState();

    // ✅ Pre-fill previously selected value
    if (widget.currentValue != null && widget.currentValue!.isNotEmpty) {
      final otherLabels = _lifeStages.where(_isOtherLabel);
      if (otherLabels.contains(widget.currentValue)) {
        _selectedAnswers.add(widget.currentValue!);
        _showSelfDescribeField = true;
        _selfDescribeController.text = widget.currentValue!;
      } else {
        _selectedAnswers.add(widget.currentValue!);
      }
    }
  }

  List<String> get _lifeStages {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'CURRENT_STAGE_IN_LIFE');
    final cached = OnboardingCubit.cachedChoicesByType['CURRENT_STAGE_IN_LIFE'];
    final apiChoices = (question?.choices.isNotEmpty ?? false) ? question!.choices : (cached ?? []);

    return apiChoices.isNotEmpty
        ? apiChoices
        : [
            'Menstruating',
            'Trying to conceive',
            'Pregnant',
            'Postpartum',
            'Peri-menopause',
            'Menopause',
            'Post-menopausal',
            'Other',
          ];
  }

  String get _question {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'CURRENT_STAGE_IN_LIFE');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty ? 'What is your current life stage?' : text;
  }

  String get _description {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'CURRENT_STAGE_IN_LIFE');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'This helps us tailor guidance and content to your stage.'
        : text;
  }

  bool _isOtherLabel(String label) =>
      label.toLowerCase().contains('other') ||
      label.toLowerCase().contains('self');

  void _toggleOption(String label) {
    final isOther = _isOtherLabel(label);
    final isSelected = _selectedAnswers.contains(label);

    setState(() {
      if (isSelected) {
        _selectedAnswers.remove(label);
        if (isOther) {
          _showSelfDescribeField = false;
          _selfDescribeController.clear();
        }
      } else {
        _selectedAnswers.add(label);
        if (isOther) {
          _showSelfDescribeField = true;
        }
      }
    });
  }

  Widget _buildAnswerOption(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: SelectableOptionCard(
        label: label,
        isSelected: _selectedAnswers.contains(label),
        isMultiSelect: true,
        onTap: () => _toggleOption(label),
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
          size: FoxxTextFieldSize.singleLine,
          onChanged: (_) => setState(() {}),
        ),
      ),
    );
  }

  bool get _canProceed {
    final hasSelection = _selectedAnswers.isNotEmpty;
    final hasOtherText = _showSelfDescribeField &&
        _selfDescribeController.text.trim().isNotEmpty;
    return hasSelection || hasOtherText;
  }

  void _onNext() {
    final answers = <String>{
      ..._selectedAnswers.where((a) => !_isOtherLabel(a)),
    };

    if (_showSelfDescribeField) {
      final otherText = _selfDescribeController.text.trim();
      if (otherText.isNotEmpty) answers.add(otherText);
    }

    if (answers.isNotEmpty) {
      widget.onDataUpdate?.call(answers.first);
    }

    FocusScope.of(context).unfocus();
    widget.onNext?.call();
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
                questionType: 'CURRENT_STAGE_IN_LIFE',
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              ..._lifeStages.map(_buildAnswerOption),
              _buildSelfDescribeField(),
            ],
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
                onPressed: _onNext,
              ),
            ),
          ),
        ),
      ],
    );
  }
}