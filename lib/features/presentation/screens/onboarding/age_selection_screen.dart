import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/health_goals_screen.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class AgeSelectionScreen extends StatefulWidget {
  const AgeSelectionScreen({super.key});

  @override
  State<AgeSelectionScreen> createState() => AgeSelectionScreenState();
}

class AgeSelectionScreenState extends State<AgeSelectionScreen> {
  String? _selectedAgeRange;

    String? getSelectedAgeRange() {
    return _selectedAgeRange;
  }

  final List<String> _ageRanges = [
    'Younger than 16',
    '16-24',
    '25-34',
    '35-44',
    '45+',
  ];

  Widget _buildAgeOption(String ageRange) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedAgeRange = ageRange;
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _selectedAgeRange == ageRange
                  ? const Color(0xFF6B4EFF)
                  : Colors.grey[300]!,
            ),
          ),
          child: Text(ageRange),
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
              title: 'Choose your age',
              subtitle:
                  'This will be used to calibrate Lorem ipsum dolor sit amet consectetur.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children:
                      _ageRanges.map((age) => _buildAgeOption(age)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add this method to your AgeSelectionScreenState class

}
