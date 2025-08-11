import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class PersonalInfoReviewScreen extends StatefulWidget {
  final Function(Map<String, String>) onDataUpdate;

  const PersonalInfoReviewScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<PersonalInfoReviewScreen> createState() => _PersonalInfoReviewScreenState();
}

class _PersonalInfoReviewScreenState extends State<PersonalInfoReviewScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update data after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, String> personalInfo = {
        'age': '27 years',
        'gender': 'Female',
        'height': '5ft 4 in',
        'weight': '115 lbs',
        'ethnicity': 'Latino/Hispanic, Asian',
        'income': 'Not specified',
      };
      widget.onDataUpdate(personalInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // Title
          Text(
            'Let\'s make sure everything looks right:',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description paragraphs
          Text(
            'Before we prep for your appointment, take a moment to review your personal info.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            'Little things, like your age, weight, or health background, can make a big difference in how we support you. If anything\'s changed, it\'s easy to update.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Personal information cards
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildInfoCard('Age', '27 years'),
                  const SizedBox(height: 12),
                  _buildInfoCard('Gender', 'Female'),
                  const SizedBox(height: 12),
                  _buildInfoCard('Height', '5ft 4 in'),
                  const SizedBox(height: 12),
                  _buildInfoCard('Weight', '115 lbs'),
                  const SizedBox(height: 12),
                  _buildInfoCard('Ethnicity', 'Latino/Hispanic, Asian'),
                  const SizedBox(height: 12),
                  _buildInfoCard('Income', 'Not specified'),
                ],
              ),
            ),
          ),
          
          // Data update on mount
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppColors.glassCardDecoration,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppOSTextStyles.osMd.copyWith(
                    color: AppColors.davysGray,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.primary01,
            size: 16,
          ),
        ],
      ),
    );
  }
}
