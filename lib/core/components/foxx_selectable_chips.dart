import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class FoxxSelectableChips extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor ;
  final Color? unselectedColor ;
  final Color selectedBorderColor;
  final Color unselectedBorderColor ;
  final Color ?selectedTextColor;
  final Color ?unselectedTextColor ;

  const FoxxSelectableChips({
    super.key,
    required this.label,
    this.isSelected = false,
    this.selectedColor = Colors.white,
    this.unselectedColor ,
    this.selectedBorderColor = AppColors.mauve50,
    this.unselectedBorderColor = AppColors.gray600,
    required this.onTap,
    this.selectedTextColor,
    this.unselectedTextColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor: unselectedColor?? Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedBorderColor : unselectedBorderColor,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
            color: isSelected ? (selectedTextColor?? AppColors.gray900) : (unselectedTextColor?? AppColors.davysGray),
          ),
        ),
      ),
    );
  }
}
