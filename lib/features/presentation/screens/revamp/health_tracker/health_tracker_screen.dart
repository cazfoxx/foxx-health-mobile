import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class HealthTrackerScreen extends StatelessWidget {
  const HealthTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Gradient-45 background (45% opacity over white)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Container(
              clipBehavior: Clip.antiAlias,
            decoration:  ShapeDecoration(
              gradient: AppColors.primaryBackgroundGradient,
               shape: RoundedRectangleBorder()
            ),  

          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: CircleAvatar(
                      
                      backgroundColor: Colors.white.withOpacity(0.5),
                      child: const Icon(Icons.arrow_back, color: AppColors.amethyst)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 64),
                  // Title
                  Text(
                    'Health Tracker',
                    style: AppHeadingTextStyles.h2,
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    'Find for your symptom through our clickable body, or by using the search function',
                    style: AppOSTextStyles.osLg.copyWith(color: AppColors.primaryTxt),
                  ),
                  const SizedBox(height: 24),
                  // Date picker card
                  _DateCard(),
                  const SizedBox(height: 24),
                  // Add symptoms
                  Text(
                    'Add symptoms',
                    style: AppTextStyles.heading3.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  // Search by symptom card
                  _SearchBySymptomCard(),
                  const SizedBox(height: 16),
                  // Area of the body card
                  _AreaOfBodyCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
       decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white),
    color: Colors.transparent,// #FFFFFF 28%
    boxShadow: [
      BoxShadow(
        color: const Color.fromRGBO(255, 255, 255, 0.35),
        offset: const Offset(3, 3),
        blurRadius: 4,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color.fromRGBO(255, 255, 255, 0.30),
        offset: const Offset(-3, -6),
        blurRadius: 3,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color.fromRGBO(255, 255, 255, 0.40),
        offset: const Offset(0, 0),
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ],
  ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.amethyst, size: 20),
              const SizedBox(width: 8),
              Text(
                'Today, Apr 14, 2025',
                style: AppTextStyles.body.copyWith(color: Colors.black),
              ),
            ],
          ),
          Text(
            'Show date range',
            style: AppTextStyles.captionOpenSans.copyWith(
              color: AppColors.amethyst,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBySymptomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.amethyst, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter symptom name',
                border: InputBorder.none,
                isDense: true,
              ),
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}

class _AreaOfBodyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
       decoration: BoxDecoration(
    color: const Color.fromRGBO(255, 255, 255, 0.28), // #FFFFFF @ 28%
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: const Color.fromRGBO(255, 255, 255, 0.35), // Shadow 1
        offset: const Offset(3, 3),
        blurRadius: 4,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color.fromRGBO(255, 255, 255, 0.30), // Shadow 2
        offset: const Offset(-3, -6),
        blurRadius: 3,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color.fromRGBO(255, 255, 255, 0.40), // Shadow 3
        offset: Offset.zero,
        blurRadius: 20,
        spreadRadius: 0,
      ),
    ],
  ),
      child: Row(
        children: [
          Icon(Icons.account_circle, color: AppColors.amethyst, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Area of the body',
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(color: AppColors.amethyst),
                ),
                const SizedBox(height: 4),
                Text(
                  'Track how you’re feeling physically, like energy levels, sleep, or pain',
                  style: AppTextStyles.captionOpenSans.copyWith(color: Colors.black.withOpacity(0.7)),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: AppColors.amethyst, size: 18),
        ],
      ),
    );
  }
} 