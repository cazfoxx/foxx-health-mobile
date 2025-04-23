import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/hear_about_us_screen.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class HealthConcersScreen extends StatefulWidget {
  const HealthConcersScreen({super.key});

  @override
  State<HealthConcersScreen> createState() => _HealthConcersScreenState();
}

class _HealthConcersScreenState extends State<HealthConcersScreen> {
  final Set<String> _selectedGoals = {};
  final List<String> _goals = [
    'Improve overall wellness',
    'Manage a chronic condition',
    'Track symptoms',
    'Preventative care',
    'Increase physical activity',
  ];

  Widget _buildGoalOption(String goal) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_selectedGoals.contains(goal)) {
              _selectedGoals.remove(goal);
            } else {
              _selectedGoals.add(goal);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _selectedGoals.contains(goal)
                  ? AppColors.amethystViolet
                  : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text(goal)),
              Checkbox(
                value: _selectedGoals.contains(goal),
                onChanged: (bool? value) {
                  setState(() {
                    if (value ?? false) {
                      _selectedGoals.add(goal);
                    } else {
                      _selectedGoals.remove(goal);
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
                  children:
                      _goals.map((goal) => _buildGoalOption(goal)).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
