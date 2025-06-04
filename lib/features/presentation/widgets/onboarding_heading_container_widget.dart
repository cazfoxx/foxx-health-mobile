import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class OnboardingHeadingContainer extends StatelessWidget {
  OnboardingHeadingContainer(
      {super.key, required this.title, required this.subtitle});
  String title;
  String subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13),
      color: AppColors.lightViolet,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF6B4EFF).withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.amethystViolet,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.body2OpenSans.copyWith(
                color: AppColors.davysGray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
