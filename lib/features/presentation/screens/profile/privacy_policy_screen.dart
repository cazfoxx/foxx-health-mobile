import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: FoxxBackButton(),
          title: Text(
            'Privacy Policy',
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
                        'Privacy Policy',
                        style: AppHeadingTextStyles.h2.copyWith(
                          color: AppColors.primary01,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Last Updated
                      Text(
                        'Last Updated: 4/7/25',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.davysGray,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Introduction
                      Text(
                        'At FoXX Health, we are committed to protecting your privacy and ensuring the security of your personal information. This Privacy Policy explains how we collect, use, and share information when you use our services, including our website foxxhealth.com and mobile application.',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.primary01,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Section 1
                      _buildSection(
                        title: '1. Information We Collect',
                        content: 'We may collect the following types of information from you:',
                      ),
                      const SizedBox(height: 16),
                      
                      _buildSubsection(
                        title: 'Information You Provide Directly:',
                        items: [
                          'Contact Information: We may collect your name, email address, phone number, and mailing address when you contact us through our website, subscribe to our newsletters, or request information about our services.',
                          'Account Information: If you create an account on our app, we may collect your username, password, and other profile information you choose to provide.',
                          'Health-Related Information: If you utilize specific features or services on our platform, we may collect health-related information, symptoms, medical history, and other relevant data you choose to share.',
                          'Communication Data: We may collect information from your communications with us, including customer support inquiries and feedback.',
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      _buildSubsection(
                        title: 'Information We Collect Automatically:',
                        items: [
                          'Device Information: We may collect information about your device, including device type, operating system, unique device identifiers, and mobile network information.',
                          'Usage Information: We collect information about how you use our services, including pages visited, features used, and time spent on our platform.',
                          'Log Information: We automatically collect certain information in our server logs, including IP address, browser type, and access times.',
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Section 2
                      _buildSection(
                        title: '2. How We Use Your Information',
                        content: 'We use the information we collect to:',
                      ),
                      const SizedBox(height: 16),
                      
                      _buildBulletList([
                        'Provide, maintain, and improve our services',
                        'Process transactions and send related information',
                        'Send technical notices, updates, and support messages',
                        'Respond to your comments and questions',
                        'Develop new products and services',
                        'Monitor and analyze trends and usage',
                        'Personalize your experience with our services',
                      ]),
                      const SizedBox(height: 24),
                      
                      // Section 3
                      _buildSection(
                        title: '3. Information Sharing and Disclosure',
                        content: 'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except in the following circumstances:',
                      ),
                      const SizedBox(height: 16),
                      
                      _buildBulletList([
                        'With your explicit consent',
                        'To comply with legal obligations',
                        'To protect our rights and prevent fraud',
                        'With service providers who assist us in operating our platform',
                        'In connection with a business transfer or acquisition',
                      ]),
                      const SizedBox(height: 24),
                      
                      // Section 4
                      _buildSection(
                        title: '4. Data Security',
                        content: 'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure.',
                      ),
                      const SizedBox(height: 24),
                      
                      // Section 5
                      _buildSection(
                        title: '5. Your Rights and Choices',
                        content: 'You have the right to:',
                      ),
                      const SizedBox(height: 16),
                      
                      _buildBulletList([
                        'Access and update your personal information',
                        'Delete your account and associated data',
                        'Opt out of certain communications',
                        'Request a copy of your data',
                        'Object to certain processing activities',
                      ]),
                      const SizedBox(height: 24),
                      
                      // Section 6
                      _buildSection(
                        title: '6. Children\'s Privacy',
                        content: 'Our services are not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information.',
                      ),
                      const SizedBox(height: 24),
                      
                      // Section 7
                      _buildSection(
                        title: '7. Changes to This Privacy Policy',
                        content: 'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date. We encourage you to review this Privacy Policy periodically.',
                      ),
                      const SizedBox(height: 24),
                      
                      // Section 8
                      _buildSection(
                        title: '8. Contact Us',
                        content: 'If you have any questions about this Privacy Policy or our privacy practices, please contact us at:',
                      ),
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.gray200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FoXX Health',
                              style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                                color: AppColors.primary01,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: privacy@foxxhealth.com',
                              style: AppOSTextStyles.osMd.copyWith(
                                color: AppColors.primary01,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Website: foxxhealth.com',
                              style: AppOSTextStyles.osMd.copyWith(
                                color: AppColors.primary01,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildSection({
    required String title,
    required String content,
  }) {
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
      ],
    );
  }

  Widget _buildSubsection({
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
            color: AppColors.primary01,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => _buildBulletItem(item)).toList(),
      ],
    );
  }

  Widget _buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => _buildBulletItem(item)).toList(),
    );
  }

  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8, right: 12),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primary01,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppOSTextStyles.osMd.copyWith(
                color: AppColors.primary01,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
