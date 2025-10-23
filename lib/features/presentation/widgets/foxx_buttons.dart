import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

// Top-level enums and helpers
enum FoxxButtonSize { large, xs }

double _heightForSize(FoxxButtonSize size) {
  switch (size) {
    case FoxxButtonSize.large:
      return 44;
    case FoxxButtonSize.xs:
      return 32;
  }
}

double _radiusForSize(FoxxButtonSize size) {
  switch (size) {
    case FoxxButtonSize.large:
      return 22;
    case FoxxButtonSize.xs:
      return 16;
  }
}

// Base button builder to avoid repetition
class _BaseFoxxButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final bool isEnabled;
  final FoxxButtonSize size;
  final double? height;
  final BorderRadius? borderRadius;

  const _BaseFoxxButton({
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.isEnabled,
    required this.size,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = height ?? _heightForSize(size);
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(_radiusForSize(size));

    return SizedBox(
      width: double.infinity,
      height: effectiveHeight,
      child: Material(
        color: Colors.transparent,
        borderRadius: effectiveRadius,
        child: InkWell(
          borderRadius: effectiveRadius,
          onTap: isEnabled ? onPressed : null,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AppColors.gray900.withOpacity(0.2); // 20% overlay
            }
            return Colors.transparent;
          }),
          child: Ink(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: effectiveRadius,
            ),
            child: Center(
              child: Text(
                label,
                style: AppTypography.labelMdSemibold.copyWith(
                  color: textColor,
                  height: 20 / AppTypography.sizeMd,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------
// Primary Button
// ----------------------------
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isEnabled;
  final FoxxButtonSize size;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height,
    this.borderRadius,
    this.isEnabled = true,
    this.size = FoxxButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseFoxxButton(
      label: label,
      onPressed: onPressed,
      backgroundColor: isEnabled
          ? AppButtonColors.buttonPrimaryBackgroundEnabled
          : AppButtonColors.buttonPrimaryBackgroundDisabled,
      borderColor: isEnabled
          ? AppButtonColors.buttonPrimaryBorderEnabled
          : AppButtonColors.buttonPrimaryBorderDisabled,
      textColor: isEnabled
          ? AppButtonColors.buttonPrimaryTextEnabled
          : AppButtonColors.buttonPrimaryTextDisabled,
      isEnabled: isEnabled,
      size: size,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

// ----------------------------
// Secondary Button
// ----------------------------
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isEnabled;
  final FoxxButtonSize size;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height,
    this.borderRadius,
    this.isEnabled = true,
    this.size = FoxxButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseFoxxButton(
      label: label,
      onPressed: onPressed,
      backgroundColor: isEnabled
          ? AppButtonColors.buttonSecondaryBackgroundEnabled
          : AppButtonColors.buttonSecondaryBackgroundDisabled,
      borderColor: isEnabled
          ? AppButtonColors.buttonSecondaryBorderEnabled
          : AppButtonColors.buttonSecondaryBorderDisabled,
      textColor: isEnabled
          ? AppButtonColors.buttonSecondaryTextEnabled
          : AppButtonColors.buttonSecondaryTextDisabled,
      isEnabled: isEnabled,
      size: size,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

// ----------------------------
// Outline Button
// ----------------------------
class OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isEnabled;
  final FoxxButtonSize size;

  const OutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height,
    this.borderRadius,
    this.isEnabled = true,
    this.size = FoxxButtonSize.large,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseFoxxButton(
      label: label,
      onPressed: onPressed,
      backgroundColor: isEnabled
          ? AppButtonColors.buttonOutlineBackgroundEnabled
          : AppButtonColors.buttonOutlineBackgroundDisabled,
      borderColor: isEnabled
          ? AppButtonColors.buttonOutlineBorderEnabled
          : AppButtonColors.buttonOutlineBorderDisabled,
      textColor: isEnabled
          ? AppButtonColors.buttonOutlineTextEnabled
          : AppButtonColors.buttonOutlineTextDisabled,
      isEnabled: isEnabled,
      size: size,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

// ----------------------------
// Convenience widgets
// ----------------------------
class StackedButtons extends StatelessWidget {
  final Widget top;
  final Widget bottom;

  const StackedButtons({super.key, required this.top, required this.bottom});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        top,
        SizedBox(height: AppSpacing.stackedButtons),
        bottom,
      ],
    );
  }
}

// ----------------------------
// FixedBottomBar: safe area + padding
// ----------------------------
class FixedBottomBar extends StatelessWidget {
  final Widget primaryButton;
  final Widget? secondaryButton;
  final String? copyText;
  final TextStyle? copyTextStyle;
  final EdgeInsets? padding;
  final bool useSafeArea;

  const FixedBottomBar({
    super.key,
    required this.primaryButton,
    this.secondaryButton,
    this.copyText,
    this.copyTextStyle,
    this.padding,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? AppSpacing.bottomBarPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          primaryButton,
          if (secondaryButton != null) ...[
            SizedBox(height: AppSpacing.stackedButtons),
            secondaryButton!,
          ],
          if (copyText != null && copyText!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.stackedButtons),
            Align(
              alignment: Alignment.center,
              child: Text(
                copyText!,
                style: copyTextStyle ??
                    AppTypography.labelSmSemibold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        useSafeArea
            ? SafeArea(top: false, bottom: true, child: content)
            : content,
      ],
    );
  }
}

// ----------------------------
// KeyboardAwareBottomBar: moves above keyboard
// ----------------------------
class KeyboardAwareBottomBar extends StatelessWidget {
  final Widget primaryButton;
  final Widget? secondaryButton;
  final String? copyText;
  final TextStyle? copyTextStyle;
  final EdgeInsets? paddingWhenClosed;

  const KeyboardAwareBottomBar({
    super.key,
    required this.primaryButton,
    this.secondaryButton,
    this.copyText,
    this.copyTextStyle,
    this.paddingWhenClosed,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = bottomInset > 0;

    final innerPadding = isKeyboardOpen
        ? const EdgeInsets.all(AppSpacing.s8)
        : (paddingWhenClosed ?? AppSpacing.bottomBarPadding);

    final content = Container(
      width: double.infinity,
      color: isKeyboardOpen
          ? AppColors.grayWhite.withOpacity(0.8) // make background 80% opacity
          : Colors.transparent,
      child: Padding(
        padding: innerPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            primaryButton,
            if (secondaryButton != null) ...[
              SizedBox(height: AppSpacing.stackedButtons),
              secondaryButton!,
            ],
            if (copyText != null && copyText!.isNotEmpty) ...[
              SizedBox(height: AppSpacing.stackedButtons),
              Align(
                alignment: Alignment.center,
                child: Text(
                  copyText!,
                  style: copyTextStyle ??
                      AppTypography.labelSmSemibold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );

    return SafeArea(
      top: false,
      bottom: true,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: content,
      ),
    );
  }
}