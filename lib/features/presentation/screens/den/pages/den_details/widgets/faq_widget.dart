import 'package:flutter/material.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class FaqWidget extends StatelessWidget {
  final CommunityDenModel den;
  const FaqWidget({super.key, required this.den});

  @override
  Widget build(BuildContext context) {
       if (den.faqs.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ...den.faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final faq = entry.value;
            bool isExpanded = false; // track expansion per tile

            return StatefulBuilder(
              key: Key(index.toString()),
              builder: (context, setState) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      key: PageStorageKey(index),
                      trailing: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.amethyst, // your color
                        child: Icon(
                          isExpanded
                              ? Icons
                                  .keyboard_arrow_down // show down arrow when expanded
                              : Icons
                                  .keyboard_arrow_right, // show forward when collapsed
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                      childrenPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0)
                          .copyWith(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      title: Text(
                        /// question
                        faq.question,
                        style: AppOSTextStyles.osLgSemibold.copyWith(
                          color: AppColors.primaryTxt,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            faq.answer,
                            style: AppOSTextStyles.osMd.copyWith(
                              // color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                      onExpansionChanged: (expanded) {
                        setState(() {
                          isExpanded = expanded;
                        });
                      },
                    ),
                  ),
                );
              },
            );
          })
        ],
      ),
    );
 
  }
}