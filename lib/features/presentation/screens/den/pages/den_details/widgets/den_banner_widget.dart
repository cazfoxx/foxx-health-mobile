import 'package:flutter/material.dart';
import 'package:foxxhealth/core/components/foxx_button.dart';
import 'package:foxxhealth/core/utils/image_util.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenBannerWidget extends StatelessWidget {
  final CommunityDenModel den;
  final void Function() onTap;
  final bool isMember;
  const DenBannerWidget(
      {super.key,
      required this.den,
      required this.onTap,
      required this.isMember});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
        (den.imageUrls.isNotEmpty && den.imageUrls.first.isNotEmpty)
            ? den.imageUrls.first
            : null; // null if no valid URL

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 180,
          child: imageUrl != null
              ? ImageUtil.getImage(imageUrl,
                  errorWidget: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.black.withOpacity(0.5)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.image_not_supported,
                          color: Colors.white, size: 48),
                    ),
                  ))

              // Image.network(
              //     imageUrl,
              //     fit: BoxFit.cover,
              //     loadingBuilder: (context, child, progress) {
              //       if (progress == null) return child;
              //       return Container(
              //         decoration: BoxDecoration(
              //           color: Colors.black,
              //           gradient: LinearGradient(
              //             colors: [
              //               Colors.black.withOpacity(0.5),
              //               Colors.black.withOpacity(0.5)
              //             ],
              //             begin: Alignment.topCenter,
              //             end: Alignment.bottomCenter,
              //           ),
              //         ),
              //         child: const Center(
              //           child: CircularProgressIndicator(color: Colors.white),
              //         ),
              //       );
              //     },
              //     errorBuilder: (context, error, stackTrace) {
              //       // show placeholder container if image fails
              //       return Container(
              //         decoration: BoxDecoration(
              //           gradient: LinearGradient(
              //             colors: [
              //               Colors.black.withOpacity(0.5),
              //               Colors.black.withOpacity(0.5)
              //             ],
              //             begin: Alignment.topCenter,
              //             end: Alignment.bottomCenter,
              //           ),
              //         ),
              //         child: const Center(
              //           child: Icon(Icons.image_not_supported,
              //               color: Colors.white, size: 48),
              //         ),
              //       );
              //     },
              //   )
              : Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.5)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
        ),

        // Overlay gradient
        Container(
          height: 180,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.5)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        // Title & member count
        Positioned(
          left: 16,
          top: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                den.name,
                style: AppOSTextStyles.osXl.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${den.memberCount} members',
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Join button
        Positioned(
          left: 16,
          bottom: 16,
          child: SizedBox(
            width: 100,
            height: 36,
            child: FoxxButton(
              verticalPadding: 8,
              enabledColor: Colors.white,
              textStyle: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                color: AppColors.amethyst,
              ),
              label: !isMember ? "Join den" : "Leave den",
              onPressed: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
