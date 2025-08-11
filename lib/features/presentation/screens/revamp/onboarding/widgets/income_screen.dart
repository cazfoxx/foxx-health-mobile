import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/neumorphic_card.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';
import 'package:foxxhealth/features/data/services/onboarding_service.dart';

class IncomeScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  
  const IncomeScreen({super.key, this.onNext, this.questions = const []});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  String? _selectedIncome;

  List<String> get _incomeRanges {
    final question = OnboardingService.getQuestionByType(widget.questions, 'HOUSEHOLD_INCOME_RANGE');
    if (question != null) {
      return question.choices;
    }
    // Fallback options if API data is not available
    return [
      'Under 25,000',
      '\$25,000 – \$50,000',
      '\$50,001 – \$75,000',
      '\$75,001 – \$100,000',
      '\$100,001 – \$150,000',
      '\$151,001 – \$200,000',
      'Prefer not to answer',
    ];
  }

  String get _description {
    final question = OnboardingService.getQuestionByType(widget.questions, 'HOUSEHOLD_INCOME_RANGE');
    return question?.description ?? 'What\'s your approximate household income?';
  }

  Widget _buildIncomeOption(String option) {
    final bool isSelected = _selectedIncome == option;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: NeumorphicOptionCard(
        text: option,
        isSelected: isSelected,
        onTap: () {
          setState(() {
            _selectedIncome = option;
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
                    children: _incomeRanges.map(_buildIncomeOption).toList(),
                  ),
                ),
              ),
              if (_selectedIncome != null)
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