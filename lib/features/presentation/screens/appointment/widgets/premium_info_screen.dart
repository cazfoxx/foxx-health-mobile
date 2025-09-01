import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class PremiumInfoScreen extends StatefulWidget {
  final Function(Map<String, String>) onDataUpdate;

  const PremiumInfoScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<PremiumInfoScreen> createState() => _PremiumInfoScreenState();
}

class _PremiumInfoScreenState extends State<PremiumInfoScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update data after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Map<String, String> premiumInfo = {
        'premium_benefits_shown': 'true',
        'timestamp': DateTime.now().toIso8601String(),
      };
      widget.onDataUpdate(premiumInfo);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        const SizedBox(height: 60),
        
        // Central Icon
        Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star,
              size: 80,
              color: AppColors.backgroundHighlighted,
            ),
          ),
          const SizedBox(height: 40),
      Container(
        decoration: AppColors.glassCardDecoration,
        padding: const EdgeInsets.symmetric( vertical: 40.0),
        child: Column(
          children: [  

          
          // Title
          Text(
            'More questions, even better support',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Description
          Text(
            'As a Premium member, you get extra questions to help us prepare something even more personal. These questions go a little deeper, into your past, your needs, and what\'s been on your mind, so we can show up for *all* of you.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),],
        ),
      ),
        const Spacer(),
        
                 // Spacer for bottom padding
         const SizedBox(height: 20),
      ],
    );
  }
}
