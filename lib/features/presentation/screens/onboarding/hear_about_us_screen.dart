import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class HearAboutUsScreen extends StatefulWidget {
  const HearAboutUsScreen({super.key});

  @override
  State<HearAboutUsScreen> createState() => _HearAboutUsScreenState();
}

class _HearAboutUsScreenState extends State<HearAboutUsScreen> {
  String? _selectedOption;

  final List<String> _options = [
    'Social Media',
    'Friend or Family',
    'Healthcare Provider',
    'Online Search',
    'Advertisement',
    'Other',
  ];

  Widget _buildOption(String option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedOption = option;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _selectedOption == option
                  ? AppColors.amethystViolet
                  : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text(option)),
              if (_selectedOption == option)
                Icon(
                  Icons.check,
                  color: AppColors.amethystViolet,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCompletion() {
    // TODO: Implement onboarding completion
    // For now, just print selected option
    print('Selected option: $_selectedOption');
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
                  children:
                      _options.map((option) => _buildOption(option)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
