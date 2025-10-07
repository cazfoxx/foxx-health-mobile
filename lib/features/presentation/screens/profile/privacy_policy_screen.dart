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
                        'Last Updated: 8.22.25',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.davysGray,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Introduction
                      Text(
                        'This Privacy Policy describes how FoXX Health ("we," "us," or "our") collects, uses, and shares information about you when you use our website (foxxhealth.com) and our mobile application (together, the "Services").',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.primary01,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'We are committed to protecting your privacy and ensuring the security of your personal information.',
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
                          'Contact Information: Name, email address, phone number, and mailing address when you contact us, subscribe to newsletters, or request information.',
                          'Account Information: If you create an account on our App, we may collect your username, password, and other profile details.',
                          'Health-Related Information: If you use features that involve tracking or sharing health concerns, we may collect information you voluntarily provide about your health.',
                          'Communication Preferences: Your preferences for receiving communications from us.',
                          'Other Information: Any other information you voluntarily provide to us.',
                        ],
                      ),
                      const SizedBox(height: 24),

                      _buildSubsection(
                        title: 'Information We Collect Automatically:',
                        items: [
                          'Log Files: IP address, browser type, operating system, referring URLs, device information, pages visited, and timestamps.',
                          'Cookies & Similar Technologies: We use cookies, web beacons, and other tracking technologies to personalize your experience, improve our Services, and analyze traffic. You can manage cookies through your browser settings.',
                          'Analytics Information: We may use third-party analytics tools to understand how users interact with our Services.',
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Section 2
                      _buildSection(
                        title: '2. How We Use Your Information',
                        content: 'We may use your information for purposes including:',
                      ),
                      const SizedBox(height: 16),

                      _buildBulletList([
                        'To Provide & Improve Services: Operate, maintain, and enhance our Website and App.',
                        'To Respond to You: Communicate with you and respond to inquiries.',
                        'To Provide Information & Services: Deliver relevant health-related content, features, and recommendations.',
                        'To Personalize Your Experience: Customize the content and functionality you see.',
                        'To Send Marketing Communications: With your consent, send newsletters, promotions, and other marketing. You can opt-out at any time.',
                        'To Analyze Usage: Monitor and analyze trends and behaviors.',
                        'To Ensure Security: Protect against fraud, breaches, and other harmful activities.',
                        'To Comply with Legal Obligations: Follow applicable laws and government requests.',
                        'For Other Legitimate Business Purposes: Research, data analysis, and development.',
                      ]),
                      const SizedBox(height: 24),

                      // Section 3
                      _buildSection(
                        title: '3. How We Share Your Information',
                        content: 'We may share information with:',
                      ),
                      const SizedBox(height: 16),

                      _buildBulletList([
                        'Service Providers: Third parties supporting hosting, analytics, marketing, or customer support.',
                        'Business Partners: Trusted partners who may provide relevant offerings.',
                        'Legal Authorities: If required by law, legal process, or valid government request.',
                        'Business Transfers: In mergers, acquisitions, or similar transactions.',
                        'With Your Consent: When you explicitly allow us to.',
                        'Aggregated/Anonymized Data: Shared for research and analysis without identifying you.',
                      ]),
                      const SizedBox(height: 12),
                      Text(
                        'Community Features (The Den): If you participate in The Den or other community areas, your posts and shared information may be visible to other users. Do not post personal or health information you do not want shared publicly.',
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.primary01,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section 4
                      _buildSection(
                        title: '4. Your Choices & Rights',
                        content: 'You may have rights under applicable law, including to:',
                      ),
                      const SizedBox(height: 16),

                      _buildBulletList([
                        'Access & Correction: Request access to and update personal information we hold about you.',
                        'Opt-Out of Marketing: Unsubscribe from marketing emails via links provided or by contacting us.',
                        'Cookies: Manage or block cookies in your browser settings.',
                        'Other Rights: Depending on your jurisdiction, you may have rights to deletion, restriction of processing, or data portability. Contact us to exercise these rights.',
                      ]),
                      const SizedBox(height: 24),

                      // Section 5
                      _buildSection(
                        title: '5. Data Security & Compliance',
                        content: 'We take reasonable technical, administrative, and physical measures to safeguard your personal information. However, no method of transmission or storage is completely secure. We are actively building our infrastructure and processes to align with HIPAA standards as we expand in the United States. While FoXX Health is not yet HIPAA compliant, we are working toward this goal to better protect your health-related information. We are also pursuing recognized security certifications such as SOC 2.',
                      ),
                      const SizedBox(height: 24),

                      // Section 6
                      _buildSection(
                        title: '6. Children\'s Privacy',
                        content: 'Our Services are not intended for individuals under 16. We do not knowingly collect personal information from children. If we learn we have collected such data without parental consent, we will delete it promptly.',
                      ),
                      const SizedBox(height: 24),

                      // Section 7
                      _buildSection(
                        title: '7. Links to Other Websites',
                        content: 'Our Services may contain links to third-party websites not controlled by us. We are not responsible for their privacy practices. Please review third-party policies before sharing personal information.',
                      ),
                      const SizedBox(height: 24),

                      // Section 8
                      _buildSection(
                        title: '8. Updates to this Policy',
                        content: 'We may update this Privacy Policy from time to time to reflect changes in our practices or laws. We will post any updates here and revise the "Last Updated" date above.',
                      ),
                      const SizedBox(height: 24),

                      // Section 9
                      _buildSection(
                        title: '9. Contact Us',
                        content: 'If you have questions about this Privacy Policy, please contact us at:',
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
                              'Email: maria@foxxhealth.com',
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
