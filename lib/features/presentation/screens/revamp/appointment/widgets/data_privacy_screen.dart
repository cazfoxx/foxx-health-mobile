import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DataPrivacyScreen extends StatefulWidget {
  final Function(Map<String, String>) onDataUpdate;

  const DataPrivacyScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<DataPrivacyScreen> createState() => _DataPrivacyScreenState();
}

class _DataPrivacyScreenState extends State<DataPrivacyScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update data after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, String> privacyInfo = {
        'data_privacy_shown': 'true',
        'timestamp': DateTime.now().toIso8601String(),
      };
      widget.onDataUpdate(privacyInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        
        // Central Icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star,
            size: 80,
            color: AppColors.backgroundHighlighted,
          ),
        ),
        const SizedBox(height: 40),
        
        // Content Container
        Container(
          decoration: AppColors.glassCardDecoration,
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              // Title
              Text(
                'Caring for your data like\nwe care for you',
                style: AppHeadingTextStyles.h4.copyWith(
                  color: AppColors.primary01,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Description
              Text(
                'What you share with us stays safe, always. We treat your health info with the same care we\'d want for ourselves: private, respectful, and only ever used to support you.',
                style: AppOSTextStyles.osMd.copyWith(
                  color: AppColors.davysGray,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const Spacer(),
        
        // Spacer for bottom padding
        const SizedBox(height: 20),
      ],
    );
  }
}
