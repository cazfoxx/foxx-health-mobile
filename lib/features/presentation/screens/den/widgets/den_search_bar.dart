import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

class DenSearchBar extends StatelessWidget {
  final Color backgroundColor;
  final TextEditingController? controller;
  final String hintText;
  final bool autoImplyLeading;
  final void Function(String)? onChanged;
  const DenSearchBar(
      {super.key,
      this.autoImplyLeading = true,
      this.controller,
      required this.hintText,
      this.onChanged,
      this.backgroundColor = const Color(0xFFE0CDFA)});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        children: [
          // Back Button

        if(autoImplyLeading)  ...[const FoxxBackButton(),

          const SizedBox(width: 12),],
          // Search Field
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration:  InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF4A4458)),
                  hintText: hintText,
                  hintStyle: AppOSTextStyles.osMd,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                ),
                style: const TextStyle(color: Color(0xFF4A4458)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
