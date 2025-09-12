import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class CreateAppointmentIntroScreen extends StatelessWidget {
  final VoidCallback onNext;

  const CreateAppointmentIntroScreen({
    Key? key,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          // Central Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.mauve50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 60,
              color: AppColors.amethyst,
            ),
          ),
          const SizedBox(height: 32),
          
          // Title
          Text(
            'Let\'s plan your visit together',
            style: AppHeadingTextStyles.h2.copyWith(
              color: AppColors.primary01,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 24),
          
          // Introductory Text
          Text(
            'The questions you\'re about to answer are often overlooked, yet they can reveal patterns and insights that help you understand your body in a new way.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 24),
          
          // Bulleted List Introduction
          Text(
            'By sharing them, you give your Appointment Companion the insight to:',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
              height: 1.5,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          
          // Bullet Points
          _buildBulletPoint('See the full picture of your health'),
          const SizedBox(height: 8),
          _buildBulletPoint('Guide you to the questions that really count'),
          const SizedBox(height: 8),
          _buildBulletPoint('Keep the focus exactly where it belongs, on you'),
          const SizedBox(height: 24),
          
          // Bottom Privacy Section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius:  BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Privacy Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: AppColors.davysGray,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.lock,
                        color: AppColors.davysGray,
                        size: 24,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Privacy Text
                  Text(
                    'Everything you tell us stays private and',
                    style: AppOSTextStyles.osMd.copyWith(
                      color: AppColors.davysGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  
                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amethyst,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: AppOSTextStyles.osMdSemiboldLink.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 8, right: 12),
          decoration: BoxDecoration(
            color: AppColors.primary01,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
