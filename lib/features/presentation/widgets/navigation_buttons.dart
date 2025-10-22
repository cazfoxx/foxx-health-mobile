import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_buttons.dart';

class FoxxBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double radius;
  final Color? iconColor;
  final Color? backgroundColor;

  const FoxxBackButton({
    Key? key,
    this.onPressed,
    this.radius = 18,
    this.iconColor = AppColors.amethystViolet,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.5),
        child: Icon(Icons.arrow_back, color: iconColor),
      ),
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
    );
  }
}

class FoxxNextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isEnabled;

  const FoxxNextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.textStyle,
    this.backgroundColor,
    this.borderRadius = 30.0,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color buttonColor = isEnabled
        ? (backgroundColor ?? AppColors.amethystViolet)
        : Colors.grey[400]!;

    final TextStyle defaultTextStyle = AppOSTextStyles.osMdSemiboldLabel.copyWith(
      color: Colors.white,
    );

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: textStyle ?? defaultTextStyle,
        ),
      ),
    );
  }
}