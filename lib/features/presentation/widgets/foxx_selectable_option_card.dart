import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_neumorphic.dart';

enum SelectableOptionVariant {
  brandColor,
  brandSecondary,
  error,
}

class SelectableOptionCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMultiSelect;
  final SelectableOptionVariant variant;

  const SelectableOptionCard({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isMultiSelect = true,
    this.variant = SelectableOptionVariant.brandSecondary,
  });

  /// Icon color depends on variant & selection state
  Color get _iconColor {
    switch (variant) {
      case SelectableOptionVariant.brandColor:
        return isSelected ? AppColors.foxxWhite : AppColors.amethyst;
      case SelectableOptionVariant.brandSecondary:
        return isSelected ? AppColors.amethyst : AppColors.gray900;
      case SelectableOptionVariant.error:
        return AppColors.darkRed;
    }
  }

  /// Text style fully uses AppTypography labelLargeSemibold token
  TextStyle get _textStyle {
    return AppTypography.labelLgSemibold.copyWith(
      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = isMultiSelect ? AppSpacing.s16 : AppSpacing.s20;

    return FoxxNeumorphicCard(
      isSelected: isSelected,
      onTap: onTap,
      horizontalPadding: horizontalPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isSelected
                ? 'assets/svg/icons/circle_check/circle_check_on-24.svg'
                : 'assets/svg/icons/circle_check/circle_check_off-24.svg',
            width: 24,
            height: 24,
            color: _iconColor,
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Text(
              label,
              style: _textStyle,
            ),
          ),
        ],
      ),
    );
  }
}