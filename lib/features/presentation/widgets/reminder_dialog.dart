import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class ReminderDialog extends StatelessWidget {
  final VoidCallback? onGetReminder;
  final VoidCallback? onNoThanks;

  const ReminderDialog({
    Key? key,
    this.onGetReminder,
    this.onNoThanks,
  }) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFE5DCF1).withOpacity(0.9),
                const Color(0xFFE3D1F7).withOpacity(0.9),
              ],
            ),
          ),
          child: ReminderDialog(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Take all the time you need',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.amethystViolet,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Want a quick reminder to finish your symptom tracker later? We\'ll save your progress in Heatlh menu so you can pick up right where you left off.',
                style: AppTextStyles.body2OpenSans,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onGetReminder?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amethystViolet,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Get A Reminder',
                    style: AppTextStyles.buttonOpenSans.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onNoThanks?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.amethystViolet),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'No Thanks',
                    style: AppTextStyles.buttonOpenSans.copyWith(
                      color: AppColors.amethystViolet,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
