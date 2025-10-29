import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenLoadingDialog extends StatefulWidget {
  const DenLoadingDialog({super.key});

  @override
  State<DenLoadingDialog> createState() => _DenLoadingDialogState();
}

class _DenLoadingDialogState extends State<DenLoadingDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // repeat back and forth

    _scaleAnimation = Tween<double>(begin: 0.95, end: 0.95).animate(  // change the value  if need to animate
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: SvgPicture.asset(
                  'assets/svg/splash/fox_loading_icon.svg',
                  height: 120,
                  width: 120,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "We're getting everything ready for you…",
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: AppColors.davysGray,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
