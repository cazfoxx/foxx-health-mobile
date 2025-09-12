import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';
import 'package:foxxhealth/features/data/models/appointment_question_model.dart';

class CareProviderScreen extends StatefulWidget {
  final Function(String?, Map<String, String>, bool) onDataUpdate;
  final AppointmentQuestion? question;

  const CareProviderScreen({
    Key? key,
    required this.onDataUpdate,
    this.question,
  }) : super(key: key);

  @override
  State<CareProviderScreen> createState() => _CareProviderScreenState();
}

class _CareProviderScreenState extends State<CareProviderScreen> {
  String? selectedProvider;
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  List<String> get careProviders {
    if (widget.question != null) {
      return widget.question!.choices;
    }
    // Fallback to hardcoded options if API data is not available
    return [
      'Cardiologist',
      'Dermatologist',
      'Dentist',
      'Endocrinologist',
      'Gastroenterologist',
      'Gynecologist / OB-GYN',
      'Mental health provider (therapist, psychiatrist)',
      'Primary care',
      'Reproductive specialist / fertility clinic',
      'I\'m not sure',
    ];
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _updateData() {
    String? provider = selectedProvider;
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      provider = 'Other';
      info['other_provider_description'] = _otherController.text.trim();
    }
    
    widget.onDataUpdate(provider, info, _canProceed());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          
          // Title
          Text(
            widget.question?.question ?? 'Do you know the type of care provider you\'re seeing?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Instructional text
          Text(
            widget.question?.description ?? 'If you don\'t see them in the list, please enter in the "other" field below',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
            ),
          ),
          const SizedBox(height: 24),
          
          // Section header
          Text(
            'Type of Doctor / Provider',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Care provider options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...careProviders.map((provider) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: provider,
                      isSelected: selectedProvider == provider,
                      onTap: () {
                        setState(() {
                          selectedProvider = provider;
                          isOtherSelected = false;
                        });
                        _updateData();
                      },
                    ),
                  )),
                  
                  // Other option
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: 'Other',
                      isSelected: isOtherSelected,
                      onTap: () {
                        setState(() {
                          isOtherSelected = true;
                          selectedProvider = null;
                        });
                        _updateData();
                      },
                    ),
                  ),
                  
                  // Other description field
                  if (isOtherSelected) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.gray200,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _otherController,
                        decoration: InputDecoration(
                          hintText: 'Please describe',
                          hintStyle: AppOSTextStyles.osMd.copyWith(
                            color: AppColors.gray600,
                          ),
                          border: InputBorder.none,
                        ),
                        style: AppOSTextStyles.osMd.copyWith(
                          color: AppColors.primary01,
                        ),
                        onChanged: (value) => _updateData(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Spacer for bottom padding
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  bool _canProceed() {
    if (selectedProvider != null) return true;
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) return true;
    return false;
  }
}
