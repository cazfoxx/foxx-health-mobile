import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

// In foxx_app_bar.dart
class FoxxAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onBack;

  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;

  final double? progress;

  final String? actionText;
  final VoidCallback? onActionPressed;
  final Widget? trailing;

  final double height;
  final double horizontalPadding;
  final double rightSectionWidth;
  final Color? backgroundColor;

  const FoxxAppBar({
    super.key,
    this.showBack = true,
    this.onBack,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.progress,
    this.actionText,
    this.onActionPressed,
    this.trailing,
    this.height = AppSpacing.s52,
    this.horizontalPadding = AppSpacing.s16,
    this.rightSectionWidth = 50.0,
    this.backgroundColor = AppColors.ombre10,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SizedBox(
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Section → Back Button
                if (showBack)
                  GestureDetector(
                    onTap: onBack ??
                        () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          }
                        },
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: SvgPicture.asset(
                        'assets/svg/icons/circle_backbutton-32.svg',
                        width: 32,
                        height: 32,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 48),

                // Add gap between back and middle section
                SizedBox(width: AppSpacing.s8),

                // Middle Section → Title / Progress Bar
                Expanded(
                  child: _buildMiddleSection(context),
                ),

                // Add gap between middle section and right action
                SizedBox(width: AppSpacing.s8),

                // Right Section → Action Text Button
                _buildRightSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleSection(BuildContext context) {
    if (titleWidget != null) {
      return Center(child: titleWidget);
    }

    if (progress != null) {
      return Center(
        child: Container(
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.progressBarBase,
            borderRadius: BorderRadius.circular(3),
          ),
          child: LinearProgressIndicator(
            borderRadius: BorderRadius.circular(3),
            value: (progress!).clamp(0.0, 1.0).toDouble(),
            backgroundColor: AppColors.progressBarBase,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.progressBarSelected),
            minHeight: 4,
          ),
        ),
      );
    }

    if (title != null && title!.isNotEmpty) {
      return Center(
        child: Text(
          title!,
          style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildRightSection() {
    if (trailing != null) {
      return trailing!;
    }

    if (actionText != null && actionText!.isNotEmpty) {
      return SizedBox(
        width: rightSectionWidth,
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onActionPressed,
            child: Text(
              actionText!,
              style: AppTypography.labelMdSemibold.copyWith(
                color: AppButtonColors.buttonSecondaryTextEnabled,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
      );
    }

    return SizedBox(width: rightSectionWidth);
  }
}