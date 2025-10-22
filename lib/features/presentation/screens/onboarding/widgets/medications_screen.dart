import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';

class MedicationsScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(String)? onDataUpdate;
  final String? currentValue; // ✅ Previously selected option

  const MedicationsScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
  });

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  String? _selectedAnswers;

  @override
  void initState() {
    super.initState();
    // ✅ Initialize with previous value if available
    _selectedAnswers = widget.currentValue;
  }

  List<String> get _medicationOptions {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'MEDICATIONS_OR_SUPPLEMENTS_INDICATOR');
    final cached = OnboardingCubit.cachedChoicesByType['MEDICATIONS_OR_SUPPLEMENTS_INDICATOR'];
    final apiChoices = (question?.choices.isNotEmpty ?? false) ? question!.choices : (cached ?? []);

    return apiChoices.isNotEmpty
        ? apiChoices
        : [
            'Yes, I\'d like to list them',
            'Yes, but I\'d prefer not to share',
            'No',
            'Prefer not to say',
          ];
  }

  String get _question {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'MEDICATIONS_OR_SUPPLEMENTS_INDICATOR');
    final text = question?.question?.trim() ?? '';
    return text.isEmpty ? 'Are you currently taking any medications or supplements?' : text;
  }

  String get _description {
    final question = OnboardingCubit()
        .getQuestionByType(widget.questions, 'MEDICATIONS_OR_SUPPLEMENTS_INDICATOR');
    final text = question?.description?.trim() ?? '';
    return text.isEmpty
        ? 'This helps us tailor guidance to your routine and avoid conflicts.'
        : text;
  }

  bool hasValidSelection() {
    return _selectedAnswers != null && _selectedAnswers!.isNotEmpty;
  }

  Widget _buildAnswerOption(String label) {
    final isSelected = _selectedAnswers == label;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: SelectableOptionCard(
        label: label,
        isSelected: isSelected,
        isMultiSelect: false,
        variant: SelectableOptionVariant.brandSecondary,
        onTap: () => setState(() => _selectedAnswers = label),
      ),
    );
  }

  void _onNext() {
    if (!hasValidSelection()) return;
    widget.onDataUpdate?.call(_selectedAnswers!);
    FocusScope.of(context).unfocus();
    widget.onNext?.call();
  }

  @override
  Widget build(BuildContext context) {
    final canProceed = hasValidSelection();

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
                questionType: 'MEDICATIONS_OR_SUPPLEMENTS_INDICATOR',
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              ..._medicationOptions.map(_buildAnswerOption).toList(),
            ],
          ),
        ),
        Positioned(
          left: AppSpacing.textBoxHorizontalWidget,
          right: AppSpacing.textBoxHorizontalWidget,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          child: AnimatedOpacity(
            opacity: canProceed ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: !canProceed,
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