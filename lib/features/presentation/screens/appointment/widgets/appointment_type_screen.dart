import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';
import 'package:foxxhealth/features/data/models/appointment_question_model.dart';

class AppointmentTypeScreen extends StatefulWidget {
  final Function(String?, Map<String, String>, bool) onDataUpdate;
  final AppointmentQuestion? question;

  const AppointmentTypeScreen({
    Key? key,
    required this.onDataUpdate,
    this.question,
  }) : super(key: key);

  @override
  State<AppointmentTypeScreen> createState() => _AppointmentTypeScreenState();
}

class _AppointmentTypeScreenState extends State<AppointmentTypeScreen> {
  String? selectedType;
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  List<String> get appointmentTypes {
    if (widget.question != null) {
      return widget.question!.choices;
    }
    // Fallback to hardcoded options if API data is not available
    return [
      'Annual GYN exam / Pap smear',
      'Birth control consultation',
      'Follow-up on a past issue',
      'Lab work, test, or imaging',
      'Medication or prescription refill',
      'Mental health check-in',
      'Pregnancy-related visit',
      'Routine check-up or physical',
      'Symptom evaluation (new or worsening issue)',
      'I\'m not sure',
    ];
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _updateData() {
    String? type = selectedType;
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      type = 'Other';
      info['other_description'] = _otherController.text.trim();
    }
    
    widget.onDataUpdate(type, info, _canProceed());
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
            widget.question?.question ?? 'Do you know what kind of appointment this is for?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Instructional text
          Text(
            widget.question?.description ?? 'You can describe it in your own words, there\'s no wrong way to answer.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
            ),
          ),
          const SizedBox(height: 24),
          
          // Section header
          Text(
            'Type of visit or exam',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Appointment type options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...appointmentTypes.map((type) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: type,
                      isSelected: selectedType == type,
                      onTap: () {
                        setState(() {
                          selectedType = type;
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
                          selectedType = null;
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
    if (selectedType != null) return true;
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) return true;
    return false;
  }
}
