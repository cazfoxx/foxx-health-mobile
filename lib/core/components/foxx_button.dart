import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class FoxxButton extends StatelessWidget {
  final String label;
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final Color? enabledColor;
  final Color? disabledColor;
  final double borderRadius;
   final double ? width;
   final double ? height;
  final double verticalPadding;
  final TextStyle? textStyle;

  const FoxxButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.isEnabled = true,
    this.isLoading = false,
    this.enabledColor = AppColors.amethystViolet,
    this.disabledColor =  Colors.grey,
    this.borderRadius = 25,
    this.verticalPadding = 14,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isEnabled ? enabledColor : disabledColor;
    final txtColor = isEnabled ? Colors.white : Colors.grey[600];

    return SizedBox(
      height: height ,
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: textStyle ??
                    TextStyle(
                      color: txtColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
      ),
    );
  }
}
