import 'package:flutter/material.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_details/widgets/faq_widget.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenAboutPage extends StatelessWidget {
  final CommunityDenModel den;
  const DenAboutPage({super.key, required this.den});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDenInfoSection(den),
                FaqWidget(den: den),
                // _buildFaqSection(den),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDenInfoSection(CommunityDenModel den) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome to ${den.name} den 👋",
              style: AppHeadingTextStyles.h3.copyWith(
                height: 1.3,
                letterSpacing: 1.1,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryTxtLight,
              )),
          const SizedBox(height: 8),
          Text(den.description,
              style: AppOSTextStyles.osMd.copyWith(
                  letterSpacing: 1.1,
                  height: 1.5,
                  color: AppColors.secondaryTxtLight,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
