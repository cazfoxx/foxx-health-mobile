import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class InterestSelectionScreen extends StatelessWidget {
  final List<String> allInterests;
  final Set<String> selectedInterests;
  final ValueChanged<String> onInterestToggle;
  final VoidCallback onSave;

  const InterestSelectionScreen({
    Key? key,
    required this.allInterests,
    required this.selectedInterests,
    required this.onInterestToggle,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.lightViolet,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.amethystViolet.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "What's your interest?",
            style: AppTextStyles.heading2
                .copyWith(fontWeight: FontWeight.w700, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            alignment: WrapAlignment.center,
            children: allInterests.map((interest) {
              final isSelected = selectedInterests.contains(interest);
              return ChoiceChip(
                showCheckmark: false,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      interest,
                      style: AppTextStyles.bodyOpenSans.copyWith(
                        color: isSelected
                            ? AppColors.amethystViolet
                            : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: isSelected
                          ? AppColors.amethystViolet
                          : Colors.grey.shade300,
                      child: Icon(
                        isSelected ? Icons.check : null,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  ],
                ),
                selected: isSelected,
                onSelected: (_) => onInterestToggle(interest),
                selectedColor: Colors.white,
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.amethystViolet
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
              );
            }).toList(),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.amethystViolet,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onSave,
                child: const Text(
                  'Save',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
