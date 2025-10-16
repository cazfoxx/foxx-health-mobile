import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_selectable_option_card.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';

class IncomeScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  final Function(String)? onDataUpdate;

  /// ✅ Optional initial selection to restore when navigating back
  final String? currentValue;

  const IncomeScreen({
    super.key,
    this.onNext,
    this.questions = const [],
    this.onDataUpdate,
    this.currentValue,
  });

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  // ✅ Single-select: tracks selected income
  String? _selectedAnswers;

  @override
  void initState() {
    super.initState();
    // ✅ Restore previous selection if available
    if (widget.currentValue != null) {
      _selectedAnswers = widget.currentValue;
    }
  }

  // ✅ API-first options with local fallback
  List<String> get _incomeRanges {
    final question = OnboardingCubit().getQuestionByType(
      widget.questions,
      'HOUSEHOLD_INCOME_RANGE',
    );
    if (question != null) return question.choices;
    return [
      'Under 25,000',
      '\$25,000 – \$50,000',
      '\$50,001 – \$75,000',
      '\$75,001 – \$100,000',
      '\$100,001 – \$150,000',
      '\$151,001 – \$200,000',
      'Prefer not to answer',
    ];
  }

  // ✅ Question text with API fallback
  String get _question {
    final question = OnboardingCubit().getQuestionByType(
      widget.questions,
      'HOUSEHOLD_INCOME_RANGE',
    );
    return question?.question ?? "What's your approximate household income?";
  }

  // ✅ Description text with API fallback
  String get _description {
    final question = OnboardingCubit().getQuestionByType(
      widget.questions,
      'HOUSEHOLD_INCOME_RANGE',
    );
    return question?.description ??
        'Sharing your household income helps us tailor resources and insights. You can skip if you prefer.';
  }

  // ✅ Only valid if a selection exists
  bool hasValidSelection() => _selectedAnswers != null && _selectedAnswers!.isNotEmpty;

  // ✅ Builds single-select option card
  Widget _buildAnswerOption(String option) {
    final bool isSelected = _selectedAnswers == option;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: SelectableOptionCard(
        label: option,
        isSelected: isSelected,
        isMultiSelect: false,
        variant: SelectableOptionVariant.brandSecondary,
        onTap: () => setState(() => _selectedAnswers = option),
      ),
    );
  }

  // ✅ Next button handler
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
        // ✅ Main content
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
                questionType: 'HOUSEHOLD_INCOME_RANGE',
                questionOverride: _question,
                descriptionOverride: _description,
              ),
              ..._incomeRanges.map(_buildAnswerOption).toList(),
            ],
          ),
        ),

        // ✅ Fixed bottom Next button
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