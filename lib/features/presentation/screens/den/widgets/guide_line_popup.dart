import 'package:flutter/material.dart';
import 'package:foxxhealth/core/components/foxx_button.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_community_guideline_screen.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/join_conversation_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

/// the popup is shown only for the first time user opens the den screen

class GuideLinePopup extends StatelessWidget {
  const GuideLinePopup({super.key});

  static const String title = 'Welcome to the Community Den';
  static const String introText =
      'This is a space to connect, share, and support each other. To keep it safe and welcoming for everyone:';
  static const List<String> rules = [
    'Be kind and respectful',
    "Protect your privacy and others'",
    'No medical advice or harmful content',
  ];
  static const String conclusionText =
      "By joining in, you're helping us build a thoughtful, supportive community.";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(32), topLeft: Radius.circular(32)),
        child: Foxxbackground(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top drag handle
            _buildDragHandle(),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                color: Colors.white.withOpacity(0.6),
                margin: const EdgeInsets.only(top: 40),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      title,
                      style: AppHeadingTextStyles.h2.copyWith(
                          color: AppColors.primaryTxt,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    // Description
                    Text(introText,
                        textAlign: TextAlign.justify,
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.primaryTxt,
                          height: 1.5,
                        )),
                    const SizedBox(height: 12),
                    ...rules.map((rule) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12.0, left: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Custom Bullet Point
                              Container(
                                margin: const EdgeInsets.only(top: 7.0),
                                height: 4,
                                width: 4,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary01,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  rule,
                                  style: AppOSTextStyles.osMd.copyWith(
                                    color: AppColors.primaryTxt,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 16),
                    Text(conclusionText,
                        textAlign: TextAlign.justify,
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.primaryTxt,
                          height: 1.5,
                        )),

                           const SizedBox(height: 16),
                    // "View community guideline"
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          // push to  community guidelines page
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const DenCommunityGuidelineScreen(),
                          ));
                        },
                        child: const Text(
                          'View community guideline',
                          style: TextStyle(
                            color: AppColors.amethystViolet,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    // "I understand" button

                    FoxxButton(
                        label: "I understand",
                        onPressed: () async {
                          if (context.mounted) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const JoinConversationScreen(),
                            ));
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  /// Builds the top drag handle
  static Widget _buildDragHandle() => Container(
        width: 48,
        height: 2,
        margin: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(2),
        ),
      );
}
