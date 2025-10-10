import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: FoxxBackButton(),
          title: Text(
            'Terms of Use',
            style: AppOSTextStyles.osMdBold.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Content Card
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Terms of Use',
                        style: AppHeadingTextStyles.h2.copyWith(
                          color: AppColors.primary01,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Last Updated
                      Text(
                        'Last Updated: October 5, 2025',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.davysGray,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Introduction
                      Text(
                        'Welcome to FoXX Health. These Terms of Use ("Terms") govern your use of our mobile application and services. By using our app, you agree to these terms.',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.primary01,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Section 1
                      _buildSection(
                        '1. Acceptance of Terms',
                        'By downloading, installing, or using the FoXX Health mobile application, you agree to be bound by these Terms of Use and our Privacy Policy.',
                      ),
                      
                      // Section 2
                      _buildSection(
                        '2. Description of Service',
                        'FoXX Health is a women\'s health tracking application that provides tools and resources to help users manage their health and wellness. Our service includes health tracking features, community support, and educational content.',
                      ),
                      
                      // Section 3
                      _buildSection(
                        '3. User Accounts',
                        'To access certain features of our app, you may need to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account.',
                      ),
                      
                      // Section 4
                      _buildSection(
                        '4. Health Information',
                        'The information provided through our app is for educational and informational purposes only and is not intended as medical advice. Always consult with a qualified healthcare professional for medical advice, diagnosis, or treatment.',
                      ),
                      
                      // Section 5
                      _buildSection(
                        '5. Subscription Services',
                        'Some features of our app may require a paid subscription. Subscription fees are charged in advance and are non-refundable except as required by law. Subscriptions automatically renew unless cancelled before the renewal date.',
                      ),
                      
                      // Section 6
                      _buildSection(
                        '6. Privacy and Data Protection',
                        'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information.',
                      ),
                      
                      // Section 7
                      _buildSection(
                        '7. Prohibited Uses',
                        'You may not use our app for any unlawful purpose or to solicit others to perform unlawful acts. You may not violate any international, federal, provincial, or state regulations, rules, laws, or local ordinances.',
                      ),
                      
                      // Section 8
                      _buildSection(
                        '8. Intellectual Property',
                        'The app and its original content, features, and functionality are owned by FoXX Health and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
                      ),
                      
                      // Section 9
                      _buildSection(
                        '9. Termination',
                        'We may terminate or suspend your account and access to the app immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
                      ),
                      
                      // Section 10
                      _buildSection(
                        '10. Changes to Terms',
                        'We reserve the right to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days notice prior to any new terms taking effect.',
                      ),
                      
                      // Section 11
                      _buildSection(
                        '11. Contact Information',
                        'If you have any questions about these Terms of Use, please contact us at support@foxxhealth.com.',
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
            color: AppColors.primary01,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppOSTextStyles.osMd.copyWith(
            color: AppColors.primary01,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}


