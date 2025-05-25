import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/hear_about_us_screen.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class HealthConcersScreen extends StatefulWidget {
  const HealthConcersScreen({super.key});

  @override
  State<HealthConcersScreen> createState() => HealthConcersScreenState();
}

class HealthConcersScreenState extends State<HealthConcersScreen> {
  final Set<String> _selectedConcers = {};
  final List<String> _concers = [
    'High blood pressure',
    'Diabetes risk',
    'Irregular periods',
    'Chronic fatigue',
    'Mood swings',
  ];
  List<String> getSelectedConcerns() => _selectedConcers.toList();

  final TextEditingController _otherGoalController = TextEditingController();
  bool _isOtherSelected = false;

  @override
  void dispose() {
    _otherGoalController.dispose();
    super.dispose();
  }

  Widget _buildGoalOption(String goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_selectedConcers.contains(goal)) {
              _selectedConcers.remove(goal);
            } else {
              _selectedConcers.add(goal);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(child: Text(goal, style: AppTextStyles.bodyOpenSans)),
              Checkbox(
                value: _selectedConcers.contains(goal),
                onChanged: (bool? value) {
                  setState(() {
                    if (value ?? false) {
                      _selectedConcers.add(goal);
                    } else {
                      _selectedConcers.remove(goal);
                    }
                  });
                },
                activeColor: AppColors.amethystViolet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtherGoalSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _isOtherSelected = !_isOtherSelected;
            if (_isOtherSelected) {
              _selectedConcers.add('Other: ${_otherGoalController.text}');
            } else {
              _selectedConcers.removeWhere((goal) => goal.startsWith('Other:'));
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text('Other', style: AppTextStyles.bodyOpenSans),
                    const Spacer(),
                    Checkbox(
                      value: _isOtherSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          _isOtherSelected = value ?? false;
                          if (_isOtherSelected) {
                            _selectedConcers
                                .add('Other: ${_otherGoalController.text}');
                          } else {
                            _selectedConcers.removeWhere(
                                (goal) => goal.startsWith('Other:'));
                          }
                        });
                      },
                      activeColor: AppColors.amethystViolet,
                    ),
                  ],
                ),
              ),
              if (_isOtherSelected)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: TextField(
                    controller: _otherGoalController,
                    onChanged: (value) {
                      setState(() {
                        _selectedConcers
                            .removeWhere((goal) => goal.startsWith('Other:'));
                        _selectedConcers.add('Other: $value');
                      });
                    },
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
              title: 'Choose your health concerns',
              subtitle:
                  'This will be used to calibrate Lorem ipsum dolor sit amet consectetur.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ..._concers.map((goal) => _buildGoalOption(goal)).toList(),
                    _buildOtherGoalSection(),
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
