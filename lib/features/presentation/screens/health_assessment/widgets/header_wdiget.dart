import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/reminder_dialog.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final VoidCallback onNext;
  final double progress;
  final bool isNextEnabled;
  final VoidCallback? onSave;
  final String? appbarTitle;
  final String? appbarTrailing;
  final Widget? customSubtile;

  const HeaderWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.body,
      required this.onNext,
      required this.progress,
      this.isNextEnabled = true,
      this.onSave,
      this.appbarTitle,
      this.appbarTrailing,
      this.customSubtile})
      : super(key: key);

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
          appbarTitle ?? 'Create a Health Assessment',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: onSave ??
                () {
                  ReminderDialog.show(context);
                },
            child: Text(
              appbarTrailing ?? 'Save',
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
      body: Column(
        children: [
          // Progress Indicator

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    color: AppColors.lightViolet,
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LinearProgressIndicator(
                            value: progress,
                            color: AppColors.sunglow,
                            backgroundColor:
                                AppColors.lightViolet.withOpacity(0.2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.amethystViolet,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: AppTextStyles.body2.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          customSubtile != null ? customSubtile! : SizedBox()
                        ],
                      ),
                    ),
                  ),
                  // Dynamic Body Content
                  body,
                ],
              ),
            ),
          ),
          // Next Button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isNextEnabled ? onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isNextEnabled
                      ? AppColors.amethystViolet
                      : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Next',
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
    );
  }
}
