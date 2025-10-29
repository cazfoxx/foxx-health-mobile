import 'package:flutter/material.dart';
import 'package:foxxhealth/core/components/foxx_button.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenDialogBox extends StatelessWidget {
  final double gradientContainerHeight;
  final String title;
  final String? subtitle;
  final String buttonLabelText;
  final void Function() onPressed;

  const DenDialogBox(
      {super.key,
      this.gradientContainerHeight = 44,
      required this.title,
      this.subtitle,
      required this.onPressed,
      required this.buttonLabelText});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(44)),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(44), bottom: Radius.circular(44)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGradientContainer(),
          
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold),
                  ),
                    const SizedBox(height: 8,),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppOSTextStyles.osMd,
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Go Back",
                          style: AppOSTextStyles.osMdSemiboldLabel,
                        )),
                  ),
                  const SizedBox(height: 8,),
                  FoxxButton(label: buttonLabelText, onPressed: onPressed),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGradientContainer() {
    return Container(
      height: gradientContainerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFE5AA),
            Color(0xFFE9D3FF),
          ],
        ),
      ),
    );
  }
}
