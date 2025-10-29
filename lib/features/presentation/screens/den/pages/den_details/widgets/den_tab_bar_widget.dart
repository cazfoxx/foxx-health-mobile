import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenTabBarWidget extends StatelessWidget {
  const DenTabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
     return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TabBar(
        padding: EdgeInsets.zero,
        isScrollable: true, // Allows tabs to be wider than the screen if needed

        // 1. Text Colors
        labelColor: Colors.black,
        unselectedLabelColor:
            AppColors.secondaryTxt, // Darker grey for inactive tab text

        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: Colors.black, // A deep purple/indigo color
            width: 2.0, // Thicker line
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,

        labelStyle:
            AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: AppTextStyles.heading3.copyWith(
            color: AppColors.secondaryTxt, fontWeight: FontWeight.bold),

        tabs: ['About', 'Feed', 'Talk/Events'].map((title) => Tab(text: title)).toList(),
      ),
    );
  
  }
}