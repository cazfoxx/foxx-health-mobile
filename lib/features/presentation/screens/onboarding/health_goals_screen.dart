import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class HealthGoalsScreen extends StatefulWidget {
  const HealthGoalsScreen({super.key});

  @override
  State<HealthGoalsScreen> createState() => HealthGoalsScreenState();
  
 
}

class HealthGoalsScreenState extends State<HealthGoalsScreen> {
   List<String> getSelectedGoals() => _selectedGoals.toList();
  final Set<String> _selectedGoals = {};
  final List<String> _goals = [
    'Improve overall wellness',
    'Manage a chronic condition',
    'Track symptoms',
    'Preventative care',
    'Increase physical activity',
  ];

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
          ),
          child: Row(
            children: [
              Expanded(child: Text(goal, style: AppTextStyles.bodyOpenSans)),
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

  Widget _buildOtherGoalSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _isOtherSelected = !_isOtherSelected;
            if (_isOtherSelected) {
              _selectedGoals.add('Other: ${_otherGoalController.text}');
            } else {
              _selectedGoals.removeWhere((goal) => goal.startsWith('Other:'));
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
                            _selectedGoals
                                .add('Other: ${_otherGoalController.text}');
                          } else {
                            _selectedGoals.removeWhere(
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
                        _selectedGoals
                            .removeWhere((goal) => goal.startsWith('Other:'));
                        _selectedGoals.add('Other: $value');
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
              title: 'Choose your health goals',
              subtitle:
                  'This will be used to calibrate Lorem ipsum dolor sit amet consectetur.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ..._goals.map((goal) => _buildGoalOption(goal)).toList(),
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
