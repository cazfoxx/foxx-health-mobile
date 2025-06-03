import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/privacy_and_security_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class HealthAssessmentScreen extends StatelessWidget {
  const HealthAssessmentScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create a Health Assessment',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle save
            },
            child: Text(
              'Save',
              style: AppTextStyles.body.copyWith(
                color: AppColors.amethystViolet,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.lightViolet,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Health Assessment',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.amethystViolet,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Created to help you prepare for your appointment confidently and thoroughly',
                      style: AppTextStyles.body2OpenSans.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(13),
              margin: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/home/premium_star.svg',
                    color: AppColors.sunglow,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                        'You have 6 days left in your trial. Upgrade now.',
                        style: AppTextStyles.body2OpenSans),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How the health assessment works',
                    style: AppTextStyles.bodyOpenSans.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildWorkItem(
                    'Answer a few quick questions about your health and background (like age, conditions, and visit purpose).',
                  ),
                  _buildWorkItem(
                    'Our AI analyzes your information to understand your specific needs.',
                  ),
                  _buildWorkItem(
                    'Receive a personalized list of tailored questions',
                  ),
                  _buildWorkItem(
                    'Be fully prepared to advocate for yourself at your next appointment.',
                  ),
                  _buildWorkItem(
                    'We know it can sometimes be stressful talking about our health, you can save and resume any time.',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyAndSecurityScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amethystViolet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Start Questionnaire',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyOpenSans,
            ),
          ),
        ],
      ),
    );
  }
}
