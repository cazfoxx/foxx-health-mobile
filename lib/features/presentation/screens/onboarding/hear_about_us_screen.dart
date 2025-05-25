import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class HearAboutUsScreen extends StatefulWidget {
  const HearAboutUsScreen({super.key});

  @override
  State<HearAboutUsScreen> createState() => HearAboutUsScreenState();
}

class HearAboutUsScreenState extends State<HearAboutUsScreen> {
  String? _selectedOption;
  final TextEditingController _otherController = TextEditingController();
  bool _isOtherSelected = false;
  String getSelectedOption() {
    return _selectedOption ?? _otherController.text;
  }

  final List<String> _options = [
    'Social Media',
    'Friend or Family',
    'Healthcare Provider',
    'Online Search',
    'Advertisement',
  ];

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  Widget _buildOption(String option) {
    final isSelected = _selectedOption == option;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedOption = option;
            _isOtherSelected = false;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.amethystViolet : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: AppTextStyles.bodyOpenSans.copyWith(
                    color: isSelected ? AppColors.amethystViolet : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherOption() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _isOtherSelected = true;
            _selectedOption = null;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isOtherSelected
                  ? AppColors.amethystViolet
                  : Colors.grey[300]!,
              width: _isOtherSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      'Other',
                      style: AppTextStyles.bodyOpenSans.copyWith(
                        color: _isOtherSelected
                            ? AppColors.amethystViolet
                            : Colors.black,
                        fontWeight: _isOtherSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              if (_isOtherSelected)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: TextField(
                    controller: _otherController,
                    decoration: InputDecoration(
                      hintText: 'Enter',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.amethystViolet),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeadingContainer(
              title: 'How did you hear about us?',
              subtitle:
                  'This will be used to calibrate Lorem ipsum dolor sit amet consectetur.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ..._options.map((option) => _buildOption(option)).toList(),
                    _buildOtherOption(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
