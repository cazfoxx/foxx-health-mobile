import 'package:flutter/material.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

class DenAppBarWidget extends StatelessWidget {
  final CommunityDenModel den;
  const DenAppBarWidget({super.key, required this.den});

  @override
  Widget build(BuildContext context) {
      return Container(
      color: const Color(0xffFBE9D1),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      height: 56, // optional: standard app bar height
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Title in center
          Text(
            den.name,
            style: AppOSTextStyles.osMdBold,
            textAlign: TextAlign.center,
          ),

          // Back button on the left
          const Positioned(
            left: 0,
            child: FoxxBackButton(),
          ),
        ],
      ),
    );
 
  }
}