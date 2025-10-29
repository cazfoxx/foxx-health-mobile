import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

/// guide line model. For now have kept in same file
/// can be moved to separate file later if needed
///
class DenGuideline {
  final String title;
  final List<String> points;

  DenGuideline({required this.title, required this.points});
}

// guide lines data
final List<DenGuideline> denGuidelines = [
  DenGuideline(
    title: '1. Be kind and respectful',
    points: [
      'Treat everyone with empathy and understanding.',
      'Please don’t disrespect someone’s opinion; instead, you can just provide your own.',
      'Avoid judgmental language, shaming, or personal attacks.',
    ],
  ),
  DenGuideline(
    title: '2. Protect your privacy and others’',
    points: [
      'Don’t share personal details like full names, addresses, phone numbers, or medical records — yours or anyone else’s.',
      'If you’re sharing your own story, feel free to do so in a way that feels safe and comfortable for you.',
    ],
  ),
  DenGuideline(
    title: '3. No medical advice',
    points: [
      'This space is for sharing experiences, not for giving or receiving medical advice.',
      'Please don’t post diagnoses, treatment plans, or anything that could replace professional medical care.',
      'Always speak with your healthcare provider about your personal health questions.',
    ],
  ),
  DenGuideline(
    title: '4. Keep it safe for everyone',
    points: [
      'No harassment, hate speech, or discrimination of any kind.',
      'No content that’s violent, graphic, or otherwise unsafe.',
      'Posts that violate these rules may be removed, and repeat violations could result in losing access to the Den.',
    ],
  ),
  DenGuideline(
    title: '5. Support, don’t sell',
    points: [
      'The Den is a space for connection, not promotion.',
      'Please avoid advertising, self-promotion, or spam.',
      'By participating in the Community Den, you’re helping us create a space where everyone feels valued, heard, and supported.',
    ],
  ),
];

// Community Guidelines Page

class DenCommunityGuidelineScreen extends StatelessWidget {
  const DenCommunityGuidelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Foxxbackground(
        child: Column(
          children: [
            const CustomDenAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Welcome to the community den',
                    style: AppHeadingTextStyles.h2.copyWith(
                      // color: AppColors.primary01,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 8),
                   Text(
                    'This is your space to connect, share experiences, and support one another. '
                    'To keep this a safe and welcoming environment for everyone, please follow these guidelines:',
                    style: AppOSTextStyles.osMd.copyWith(
                      color: AppColors.davysGray,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...denGuidelines
                      .map((guideline) => _buildGuideline(guideline))
                      .toList(),
                  const SizedBox(height: 24),
                  const Text(
                    'Thank you for being part of it!\n\nTeam at Foxx Health',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideline(guideline) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            guideline.title,
            style: AppHeadingTextStyles.h2.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            )
          ),
          const SizedBox(height: 8),
          ...guideline.points.map(
            (point) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style:AppOSTextStyles.osMd.copyWith(
                      color: AppColors.davysGray,
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
}

class CustomDenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomDenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      margin: EdgeInsets.only(top: preferredSize.height),
      decoration: const BoxDecoration(
        color: Color(0xFFFBE9D1), // light beige background
     
      ),
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      // top padding for status bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFFFDF2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.amethystViolet,
                size: 22,
              ),
            ),
          ),

          // Center Title
          const Expanded(
            child: Center(
              child: Text(
                "Den Guidelines",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Right placeholder for alignment (keeps title centered)
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
