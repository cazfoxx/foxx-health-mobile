import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/components/foxx_selectable_chips.dart';
import 'package:foxxhealth/core/utils/app_ui_helper.dart';
import 'package:foxxhealth/features/presentation/screens/den/widgets/den_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class ReportCommentPage extends StatefulWidget {
  const ReportCommentPage({super.key});

  @override
  State<ReportCommentPage> createState() => _ReportCommentPageState();
}

class _ReportCommentPageState extends State<ReportCommentPage> {
  final selectedTopics = <String>{};
  final reportTopics = [
    "Harassment",
    "Fraud or scam",
    "Spam",
    "Misinformation",
    "Hateful speech",
    "Threat or violence",
    " Self-harm"
  ];
  @override
  Widget build(BuildContext context) {
    return DenBottomSheet(
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: AppColors.amethyst),
            ),
            const Text(
              "Report this comment",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            TextButton(
                onPressed: selectedTopics.isEmpty
                    ? null
                    : () {
                        // Navigator.pop(context);
                        AppHelper.showBottomModalSheet(
                            context: context,
                            child: const SuccesfulReportingWidget());
                      },
                child: const Text(
                  "Send",
                  style: AppOSTextStyles.osMdBold,
                )), // keeps title centered visually
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select our policy that applies.",
                style: AppOSTextStyles.osLgSemibold
                    .copyWith(color: AppColors.davysGray)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 12,
              alignment: WrapAlignment.start,
              children: reportTopics
                  .map(
                    (topic) => FoxxSelectableChips(
                        isSelected: selectedTopics.contains(topic),
                        // unselectedColor: Colors.transparent,
                        // unselectedBorderColor: AppColors.amethyst,
                        // selectedTextColor: Colors.white,
                        // selectedColor: AppColors.amethyst,
                        // unselectedTextColor: Colors.black87,
                        label: topic,
                        onTap: () {
                          if (selectedTopics.contains(topic)) {
                            setState(() {
                              selectedTopics.remove(topic);
                            });
                          } else {
                            setState(() {
                              selectedTopics.add(topic);
                            });
                          }
                        }),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccesfulReportingWidget extends StatelessWidget {
  const SuccesfulReportingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DenBottomSheet(
      gradientContainerHeight: 80,
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
            .copyWith(top: 24),
        child: const Text(
          "Thanks for speaking up",
          textAlign: TextAlign.center,
          style: AppTextStyles.heading2,
        ),
      ),
      body: Center(
        child: Text(
          "We’ll review the comment to help keep the Den safe and supportive for everyone.",
          style: AppOSTextStyles.osMd.copyWith(color: AppColors.davysGray),
          textAlign: TextAlign.center,
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.all(24),
        child: SvgPicture.asset(
          height: 72,
          width: 72,
          'assets/svg/icons/check_circle.svg',
        ),
      ),
    );
  }
}
