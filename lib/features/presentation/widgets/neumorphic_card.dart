import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class NeumorphicOptionCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const NeumorphicOptionCard({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.progressBarSelected
        : Colors.white.withOpacity(0.15);

    final shadowColor = isSelected
        ? Colors.white.withOpacity(0.5)
        : Colors.white.withOpacity(0.3);

    final textColor = isSelected
        ? Colors.black.withOpacity(0.85)
        : Colors.black.withOpacity(0.85);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color:
              isSelected? AppColors.progressBarSelected:
               Colors.white),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Text(
              text,
              style: AppOSTextStyles.osSmSemiboldLabel.copyWith(),
            ),
          ),
        ),
      ),
    );
  }
}
