import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';

class OnboardingQuestionHeader extends StatelessWidget {
  final List<OnboardingQuestion> questions;
  final String questionType;
  final String? questionOverride;
  final String? descriptionOverride;

  const OnboardingQuestionHeader({
    super.key,
    this.questions = const [],
    required this.questionType,
    this.questionOverride,
    this.descriptionOverride,
  });

  @override
  Widget build(BuildContext context) {
    OnboardingQuestion? matched;
    try {
      matched = questions.firstWhere((q) => q.type == questionType);
    } catch (_) {
      matched = null;
    }

    final titleText = (questionOverride ?? matched?.question ?? '').trim();
    final descriptionText = (descriptionOverride ?? matched?.description ?? '').trim();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.textBoxHorizontalWidget,
        AppSpacing.s24,
        AppSpacing.textBoxHorizontalWidget,
        AppSpacing.s16,
      ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleText.isNotEmpty)
          Text(
            titleText,
            style: AppTypography.h4,
          ),
        if (titleText.isNotEmpty) const SizedBox(height: 8),
        if (descriptionText.isNotEmpty)
          Text(
            descriptionText,
            style: AppTypography.bodyMd.copyWith(color: AppColors.textPrimary),
          ),
      ],
      ),
    );
  }
}