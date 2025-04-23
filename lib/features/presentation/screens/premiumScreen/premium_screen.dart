import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Premium Plan',
          style: TextStyle(
            color: AppColors.amethystViolet,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumBenefits(),
              const SizedBox(height: 24),
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
              const SizedBox(height: 32),
              _buildTestimonial(),
              const SizedBox(height: 24),
              _buildTermsOfService(),
              const SizedBox(height: 24),
              _buildTrialButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBenefits() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.amethystViolet,
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
              color: AppColors.amethystViolet,
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Text('• ', style: TextStyle(color: AppColors.amethystViolet)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
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
        color: isSelected ? AppColors.amethystViolet : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.amethystViolet : Colors.grey.shade300,
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const Text(
                  'Cancel Anytime',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
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
              color: AppColors.amethystViolet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '"It\'s a great app that gives you so much more insight to how you\'re feeling at certain times of the month. It\'s really helping me."',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTermsOfService() {
    return const Center(
      child: Text(
        'Terms Of Service',
        style: TextStyle(
          color: AppColors.amethystViolet,
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
          backgroundColor: AppColors.amethystViolet,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Start Free 3-day Trial',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}