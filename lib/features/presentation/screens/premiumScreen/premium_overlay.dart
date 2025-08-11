import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:foxxhealth/core/constants/app_constants.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PremiumOverlay extends StatefulWidget {
  const PremiumOverlay({Key? key}) : super(key: key);

  @override
  State<PremiumOverlay> createState() => _PremiumOverlayState();
}

class _PremiumOverlayState extends State<PremiumOverlay> {
  bool isYearlySelected = true;
  bool _isLoading = false;
  final _apiClient = ApiClient();

  Future<void> initializePayment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the FastAPI backend to create a checkout session
      final response = await http.post(
        Uri.parse('https://fastapi-backend-v2-788993188947.us-central1.run.app/api/v1/payments/create-checkout-session'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMTgxYzJiMi1jZjdjLTRiYTUtYTQyNy1mNjBhMmIyOWJjOWUiLCJleHAiOjE3NTM0NDM3ODF9.l0sR6H6hlbGDCI1urYAB8Oc1K2q9YVgCpkL3RMlBKhk',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'billing_cycle': isYearlySelected ? 'yearly' : 'monthly',
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Launch the URL in a browser
        final url = data['url'];
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } else {
        throw 'Failed to create checkout session: ${data['detail'] ?? "Unknown error"}';
      }

    } catch (e) {
      // Handle errors
      log(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.amethystViolet),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('Premium Plan', style: AppTextStyles.heading3),
                    const SizedBox(width: 50),
                  ],
                ),
              ),
              _buildPremiumBenefits(),
                Container(
                  color: AppColors.background,
              child: Column(
                children: [
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
              const SizedBox(height:10),
              
              
                ],
              ),
            ),
           
              _buildTrialButton(),
              const SizedBox(height: 10),
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
            _buildBenefitItem('Unlock the Personal Health Guide'),
            _buildBenefitItem('In-appointment support'),
            _buildBenefitItem('First access to exclusive events'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4,right: 10,left: 10),
      child: Row(
        children: [
          Text('• ', style: AppTextStyles.bodyOpenSans),
          Expanded(
            child: Text(text, style: AppTextStyles.bodyOpenSans.copyWith(fontWeight: FontWeight.w400)),
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
        color: Colors.white,
        border: Border.all(
          width: isSelected ? 3 : 1,
            color: isSelected ? AppColors.amethystViolet : Colors.transparent),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(color: isSelected ? AppColors.amethystViolet : Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.captionOpenSans.copyWith()
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
            style: AppTextStyles.bodyOpenSans.copyWith(fontSize: 22,
            color: isSelected ? AppColors.amethystViolet : Colors.black,
              fontWeight: FontWeight.w600)
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Text(
        "Every woman deserves a tool like the FoXx Health app, designed to empower them to become their own health expert and take control of their well-being",
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
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
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(

        onPressed: _isLoading ? null : initializePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amethystViolet,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Start Free 3-day Trial',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

