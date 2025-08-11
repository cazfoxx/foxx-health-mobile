import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/neumorphic_card.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';
import 'package:foxxhealth/features/data/services/onboarding_service.dart';

class MedicationsScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  
  const MedicationsScreen({super.key, this.onNext, this.questions = const []});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  String? _selectedOption;

  List<String> get _medicationOptions {
    final question = OnboardingService.getQuestionByType(widget.questions, 'MEDICATIONS_OR_SUPPLEMENTS_INDICATOR');
    if (question != null) {
      return question.choices;
    }
    // Fallback options if API data is not available
    return [
      'Yes',
      'Yes, but I\'d prefer not to share',
      'No',
      'Prefer not to say',
    ];
  }

  String get _description {
    final question = OnboardingService.getQuestionByType(widget.questions, 'MEDICATIONS_OR_SUPPLEMENTS_INDICATOR');
    return question?.description ?? 'Are you currently taking any medications or supplements?';
  }

  Widget _buildMedicationOption(String option) {
    final bool isSelected = _selectedOption == option;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: NeumorphicOptionCard(
        text: option,
        isSelected: isSelected,
        onTap: () {
          setState(() {
            _selectedOption = option;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _description.split('?')[0] + '?',
                style: AppHeadingTextStyles.h4,
              ),
              const SizedBox(height: 8),
              Text(
                _description.split('?').length > 1 ? _description.split('?')[1] : '',
                style: AppOSTextStyles.osMd
                    .copyWith(color: AppColors.primary01),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _medicationOptions.map(_buildMedicationOption).toList(),
                  ),
                ),
              ),
              if (_selectedOption != null)
                SizedBox(
                  width: double.infinity,
                  child: FoxxNextButton(
                    isEnabled: true,
                    onPressed: () {
                      // Close keyboard
                      FocusScope.of(context).unfocus();
                      widget.onNext?.call();
                    },
                    text: 'Next'),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 