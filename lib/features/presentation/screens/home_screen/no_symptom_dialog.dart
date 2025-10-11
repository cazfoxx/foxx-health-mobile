import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class NoSymptomsDialog extends StatefulWidget {

  const NoSymptomsDialog({
    super.key,
  });

  @override
  State<NoSymptomsDialog> createState() => _NoSymptomsDialogState();
}

class _NoSymptomsDialogState extends State<NoSymptomsDialog> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient header
          Container(
            height: 44,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.86, -0.5),
                end: Alignment(0.86, 0.5),
                colors: [
                  Color(0xFFE9D3FF),
                  Color(0xFFFFE5AA),
                ],
                stops: [0.0022, 0.9528],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            alignment: Alignment.center,
            // Handle bar
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Body
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 24,
              left: 24,
              right: 24,
              bottom: 48,
            ),
            decoration: const ShapeDecoration(
              color: Color(0xFFFFFCFC) /* sheet-color-background-light */,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 24,
              children: [
                Container(
                  width: double.infinity,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      SizedBox(
                        width: 580,
                        child: Text(
                          'Great!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF3E3D48) /* text-color-primary */,
                            fontSize: 28,
                            fontFamily: 'Merriweather',
                            fontWeight: FontWeight.w700,
                            height: 1.29,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 550,
                        child: Text(
                          'Thanks for tracking a good day, these matter just as much as the rest.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF3E3D48) /* text-color-primary */,
                            fontSize: 16,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_outline_outlined,
                    color: AppColors.amethyst, size: 72)
              ],
            ),
          )
        ],
      ),
    );
  }
}
