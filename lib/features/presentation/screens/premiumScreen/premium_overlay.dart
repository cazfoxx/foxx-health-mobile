import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class PremiumOverlay extends StatefulWidget {
  const PremiumOverlay({super.key});

  @override
  State<PremiumOverlay> createState() => _PremiumOverlayState();
}

class _PremiumOverlayState extends State<PremiumOverlay> {
  bool isYearlySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Premium Plan', style: AppTextStyles.heading3),
                    const SizedBox(width: 50),
                  ],
                ),
              ),
              _buildPremiumBenefits(),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isYearlySelected = true;
                  });
                },
                child: _buildSubscriptionOption(
                  title: 'Yearly Subscription',
                  price: '\$20',
                  description: 'Auto renewal 1 year on expiry.',
                  isSelected: isYearlySelected,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isYearlySelected = false;
                  });
                },
                child: _buildSubscriptionOption(
                  title: 'Monthly Subscription',
                  price: '\$2',
                  description: 'Auto renewal 1 month on expiry.',
                  isSelected: !isYearlySelected,
                ),
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
    );
  }

  Widget _buildPremiumBenefits() {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Premium Benefits',
                style: AppTextStyles.heading2
                    .copyWith(color: AppColors.amethystViolet)),
            const SizedBox(height: 3),
            _buildBenefitItem('Unlock advanced health analysis with AI'),
            _buildBenefitItem('Get customized checklists'),
            _buildBenefitItem('Extra symptoms tracking options, and more!'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text('• ', style: AppTextStyles.bodyOpenSans),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyOpenSans),
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
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isSelected ? AppColors.amethystViolet : Colors.grey),
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
                Text(
                  'Cancel Anytime',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withOpacity(0.8),
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
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial() {
    return Text(
      "Every woman deserves a tool like the FoXx Health app, designed to empower them to become their own health expert and take control of their well-being",
      style: AppTextStyles.body,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTermsOfService() {
    return Center(
      child: Text(
        'Terms Of Service',
        style: TextStyle(
          color: Colors.black.withOpacity(0.8),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildTrialButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Optional: use `isYearlySelected` here to know which plan was chosen
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amethystViolet,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text('Start Free 3-day Trial',
            style: AppTextStyles.bodyOpenSans.copyWith(color: Colors.white)),
      ),
    );
  }
}
