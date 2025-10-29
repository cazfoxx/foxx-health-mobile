import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

void showRequestDenSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Important to appear above keyboard
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const RequestDenScreen();
    },
  );
}

Widget _buildDragHandle() => Container(
      width: 48,
      height: 2,
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(2),
      ),
    );

class RequestDenScreen extends StatelessWidget {
  const RequestDenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // adjust for keyboard
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFE5AA),
                      Color(0xFFE9D3FF),
                    ]),
                borderRadius:
                     BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDragHandle(),
                ],
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.purple),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Request a new den',
                    style: AppOSTextStyles.osMdBold,
                  ),
                  TextButton(
                    onPressed: () {
                      _onTapSend(context);
                    },
                    child: Text(
                      'Send',
                      style: AppOSTextStyles.osMdSemiboldLabel
                          .copyWith(color: AppColors.amethystViolet),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Input Field
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Den's topic",
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.purpleAccent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.purple),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  _onTapSend(context) async {
    // Implement send functionality here
    Navigator.of(context).pop(); // Close the request den sheet

    final repo = CommunityDenRepository();
    final request =  await repo.requestDen();

    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true, // Important to appear above keyboard
    //   backgroundColor: Colors.transparent,
    //   builder: (context) {
    //     return const SuccessRequestDenSheet();
    //   },
    // );
  }
}

class SuccessRequestDenSheet extends StatelessWidget {
  const SuccessRequestDenSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFE5AA),
                    Color(0xFFE9D3FF),
                  ]),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDragHandle(),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text("Thank You!",
              textAlign: TextAlign.center,
              style: AppHeadingTextStyles.h2.copyWith(
                  color: AppColors.primaryTxt, fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),
          Text(
              "We’ll review your request and let you know if we create the new Den.",
              textAlign: TextAlign.center,
              style: AppOSTextStyles.osMd.copyWith(
                color: AppColors.primaryTxt,
                height: 1.5,
              )),

          // Input Field
          const SizedBox(height: 30),
          SvgPicture.asset(
            'assets/svg/icons/check_circle.svg',
            height: 64,
            width: 64,
          ),
           SizedBox(height: MediaQuery.of( context).viewPadding.bottom + 24),
        ],
      ),
    );
  }
}
