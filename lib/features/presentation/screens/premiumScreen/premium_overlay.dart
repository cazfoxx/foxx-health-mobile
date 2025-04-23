import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class PremiumOverlay extends StatelessWidget {
  const PremiumOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.amethystViolet.withOpacity(0.92),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35),
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    centerTitle: true,
                    title: const Text(
                      'Premium Plan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  _buildPremiumBenefits(),
                  const SizedBox(height: 32),
                  _buildSubscriptionOption(
                    title: 'Yearly Subscription',
                    price: '\$20',
                    description: 'Auto renewal 1 year on expiry.',
                    isSelected: true,
                  ),
                  const SizedBox(height: 16),
                  _buildSubscriptionOption(
                    title: 'Monthly Subscription',
                    price: '\$2',
                    description: 'Auto renewal 1 month on expiry.',
                    isSelected: false,
                  ),
                  const SizedBox(height: 48),
                  _buildTestimonial(),
                  const SizedBox(height: 16),
                  _buildTermsOfService(),
                  const SizedBox(height: 24),
                  _buildTrialButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBenefits() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Premium Benefits',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitItem('Unlock advanced health analysis with AI'),
          _buildBenefitItem('Get customized checklists'),
          _buildBenefitItem('Extra symptoms tracking options, and more!'),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Text('• ', style: TextStyle(color: Colors.white, fontSize: 20)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption({
    required String title,
    required String price,
    required String description,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  'Cancel Anytime',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial() {
    return Text(
      '"It\'s a great app that gives you so much more insight to how you\'re feeling at certain times of the month. It\'s really helping me."',
      style: TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: Colors.white.withOpacity(0.8),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTermsOfService() {
    return Center(
      child: Text(
        'Terms Of Service',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildTrialButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Start Free 3-day Trial',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.amethystViolet,
          ),
        ),
      ),
    );
  }
}
