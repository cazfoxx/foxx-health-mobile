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
                        'Last Updated: 08.22.25',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.davysGray,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Introduction
                      Text(
                        'Welcome to FoXX Health ("FoXX," "we," "our," or "us"). These Terms & Conditions ("Terms") govern your use of the FoXX Health mobile application (the "App") and related services (collectively, the "Services"). By creating an account, accessing, or using the Services, you agree to be bound by these Terms. If you do not agree, you may not use the Services.',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.primary01,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Section 1
                      _buildSection(
                        '1. Eligibility',
                        'You must be at least 16 years old (or the age of majority in your jurisdiction) to use the Services.\n\nBy using the App, you represent that you have the legal capacity to enter into these Terms.',
                      ),
                      
                      // Section 2
                      _buildSection(
                        '2. Health Disclaimer',
                        'FoXX Health does not provide medical advice, diagnosis, or treatment.\n\nThe App is designed for educational and informational purposes only and should not replace consultation with a qualified healthcare professional.\n\nAlways seek the advice of a physician or other qualified health provider with questions regarding medical conditions or treatment.\n\nIf you experience a medical emergency, call your local emergency number immediately.',
                      ),
                      
                      // Section 3
                      _buildSection(
                        '3. User Accounts',
                        'You must create an account to use certain features. You agree to provide accurate, complete, and updated information.\n\nYou are responsible for maintaining the confidentiality of your login credentials and for all activity under your account.\n\nWe reserve the right to suspend or terminate your account if you violate these Terms.',
                      ),
                      
                      // Section 4
                      _buildSection(
                        '4. Subscriptions & Payments',
                        'Some features are available only with a paid subscription. Pricing, billing cycles, and payment methods will be displayed at the time of purchase.\n\nSubscriptions automatically renew unless canceled before the renewal date.\n\nYou may cancel your subscription through your app store or account settings. No refunds will be issued for partially used billing periods, unless required by law.',
                      ),
                      
                      // Section 5
                      _buildSection(
                        '5. User Content',
                        'You may submit health data, journal entries, or community posts ("User Content").\n\nYou retain ownership of your User Content, but grant FoXX a limited, non-exclusive, worldwide license to store, process, and display it solely for operating the Services.\n\nYou agree not to post content that is illegal, harmful, harassing, or violates the rights of others.',
                      ),
                      
                      // Section 6
                      _buildSection(
                        '6. Privacy & Data Protection',
                        'Protecting your privacy and the security of your health data is a core priority at FoXX.\n\nWe follow strict internal standards for data handling and security, and we are actively building toward HIPAA compliance as we expand in the United States.\n\nWhile we are not yet certified as HIPAA compliant, our infrastructure and processes are designed with HIPAA requirements in mind, and we are working toward meeting recognized standards such as SOC 2 and other data security certifications.\n\nOur collection and use of personal data is governed by our Privacy Policy.\n\nBy using the Services, you consent to the processing of your data as described in the Privacy Policy.',
                      ),
                      
                      // Section 7
                      _buildSection(
                        '7. Community Guidelines (The Den)',
                        'The Den is a community feature for peer support. It is not moderated by medical professionals.\n\nBe respectful, avoid harassment or offensive language, and do not share misleading medical information.\n\nFoXX reserves the right to remove content or suspend accounts for violations.',
                      ),
                      
                      // Section 8
                      _buildSection(
                        '8. Intellectual Property',
                        'The Services, including trademarks, software, and content, are owned by FoXX or its licensors.\n\nYou may not copy, distribute, reverse engineer, or exploit any part of the Services without our prior written consent.',
                      ),
                      
                      // Section 9
                      _buildSection(
                        '9. Prohibited Uses',
                        'You agree not to:\n\n• Use the Services for unlawful purposes.\n• Attempt to gain unauthorized access to the App or related systems.\n• Upload viruses or malicious code.\n• Exploit the Services for commercial purposes without consent.',
                      ),
                      
                      // Section 10
                      _buildSection(
                        '10. Termination',
                        'We may suspend or terminate your access if you breach these Terms or misuse the Services. You may stop using the Services at any time by deleting your account.',
                      ),
                      
                      // Section 11
                      _buildSection(
                        '11. Limitation of Liability',
                        'The Services are provided "as is" without warranties of any kind.\n\nTo the maximum extent permitted by law, FoXX disclaims liability for any indirect, incidental, or consequential damages arising from your use of the Services.\n\nFoXX takes commercially reasonable steps to protect your data and is working toward industry-recognized compliance standards, including HIPAA. However, because no system can be 100% secure, you acknowledge that transmission of data via the internet is not completely secure and that we cannot guarantee the absolute security of your information.\n\nOur total liability shall not exceed the amount paid by you for the Services in the 12 months prior to the claim.',
                      ),
                      
                      // Section 12
                      _buildSection(
                        '12. Indemnification',
                        'You agree to indemnify and hold harmless FoXX, its affiliates, and employees from any claims, damages, or expenses arising from your misuse of the Services or violation of these Terms.',
                      ),
                      
                      // Section 13
                      _buildSection(
                        '13. Changes to the Terms',
                        'We may update these Terms from time to time. Material changes will be notified via the App or by email. Continued use after changes means you accept the updated Terms.',
                      ),
                      
                      // Section 14
                      _buildSection(
                        '14. Governing Law & Dispute Resolution',
                        'These Terms are governed by the laws of [Insert Jurisdiction].\n\nAny disputes will be resolved through binding arbitration or small claims court, unless otherwise required by law.',
                      ),
                      
                      // Section 15
                      _buildSection(
                        '15. Contact Us',
                        'If you have questions about these Terms, please contact us at FoXX Health: maria@foxxhealth.com',
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





