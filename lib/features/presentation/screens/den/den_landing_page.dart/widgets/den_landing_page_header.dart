import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenLandingPageHeader extends StatelessWidget {
  const DenLandingPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Den',
                style: AppHeadingTextStyles.h2.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'A safe & anonymous space to discuss women\'s health',
                style: AppOSTextStyles.osMd.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
   
  }
}