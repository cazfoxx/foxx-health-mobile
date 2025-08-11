import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';
import 'package:foxxhealth/features/data/services/onboarding_service.dart';

class LifeStageScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final List<OnboardingQuestion> questions;
  
  const LifeStageScreen({super.key, this.onNext, this.questions = const []});

  @override
  State<LifeStageScreen> createState() => _LifeStageScreenState();
}

class _LifeStageScreenState extends State<LifeStageScreen> {
  String? _selectedLifeStage;
  final TextEditingController _otherController = TextEditingController();
  bool _showOtherField = false;

  List<String> get _lifeStages {
    final question = OnboardingService.getQuestionByType(widget.questions, 'CURRENT_STAGE_IN_LIFE');
    if (question != null) {
      return question.choices;
    }
    // Fallback options if API data is not available
    return [
      'Menstruating',
      'Trying to conceive',
      'Pregnant',
      'Postpartum',
      'Peri-menopause',
      'Menopause',
      'Post-menopausal',
    ];
  }

  String get _description {
    final question = OnboardingService.getQuestionByType(widget.questions, 'CURRENT_STAGE_IN_LIFE');
    return question?.description ?? 'What is your current life stage?';
  }

  Widget _buildLifeStageOption(String option) {
    final bool isSelected = _selectedLifeStage == option;
    
    final backgroundColor = isSelected
        ? AppColors.progressBarSelected
        : Colors.white.withOpacity(0.15);

    final shadowColor = isSelected
        ? Colors.white.withOpacity(0.5)
        : Colors.white.withOpacity(0.3);

    final textColor = isSelected
        ? Colors.black.withOpacity(0.85)
        : Colors.black.withOpacity(0.85);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLifeStage = option;
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color:
                isSelected? AppColors.progressBarSelected:
                 Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.amethyst)
                      : Icon(Icons.circle_outlined, color: Colors.grey[400]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: AppTextStyles.bodyOpenSans.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherOption() {
    final bool isSelected = _selectedLifeStage == 'Others';
    
    final backgroundColor = isSelected
        ? AppColors.progressBarSelected
        : Colors.white.withOpacity(0.15);

    final shadowColor = isSelected
        ? Colors.white.withOpacity(0.5)
        : Colors.white.withOpacity(0.3);

    final textColor = isSelected
        ? Colors.black.withOpacity(0.85)
        : Colors.black.withOpacity(0.85);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedLifeStage = null;
              _showOtherField = false;
            } else {
              _selectedLifeStage = 'Others';
              _showOtherField = true;
            }
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color:
                isSelected? AppColors.progressBarSelected:
                 Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.amethyst)
                      : Icon(Icons.circle_outlined, color: Colors.grey[400]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Others',
                      style: AppTextStyles.bodyOpenSans.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherField() {
    return Visibility(
      visible: _showOtherField,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _otherController,
            decoration: InputDecoration(
              hintText: 'Please specify',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: AppTextStyles.bodyOpenSans,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  bool hasValidSelection() {
    return _selectedLifeStage != null || (_showOtherField && _otherController.text.isNotEmpty);
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
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
                    children: [
                      ..._lifeStages.map(_buildLifeStageOption).toList(),
                      _buildOtherOption(),
                      _buildOtherField(),
                    ],
                  ),
                ),
              ),
              if (hasValidSelection())
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