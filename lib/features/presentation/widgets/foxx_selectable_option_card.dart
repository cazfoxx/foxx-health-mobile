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

  /// Returns the correct SVG asset based on selected state
  String get _svgAsset {
    switch (variant) {
      case SelectableOptionVariant.brandColor:
        return isSelected
            ? 'assets/svg/icons/circle_check_on_brand-24.svg'
            : 'assets/svg/icons/circle_check_off_brand-24.svg';
      case SelectableOptionVariant.brandSecondary:
        return isSelected
            ? 'assets/svg/icons/circle_check_on_white-24.svg'
            : 'assets/svg/icons/circle_check_off_brand-24.svg';
      case SelectableOptionVariant.error:
        return 'assets/svg/icons/circle_check_off_error-24.svg';
    }
  }

  TextStyle get _textStyle {
    return AppTypography.labelMdSemibold.copyWith(
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
          // Show icon only for multi-select
          if (isMultiSelect) ...[
            SvgPicture.asset(
              _svgAsset,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: AppSpacing.s8),
          ],
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