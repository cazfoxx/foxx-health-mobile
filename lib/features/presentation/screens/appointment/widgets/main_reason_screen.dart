import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';
import 'package:foxxhealth/features/data/models/appointment_question_model.dart';

class MainReasonScreen extends StatefulWidget {
  final Function(String?, Map<String, String>, bool) onDataUpdate;
  final AppointmentQuestion? question;

  const MainReasonScreen({
    Key? key,
    required this.onDataUpdate,
    this.question,
  }) : super(key: key);

  @override
  State<MainReasonScreen> createState() => _MainReasonScreenState();
}

class _MainReasonScreenState extends State<MainReasonScreen> {
  String? selectedReason;
  final TextEditingController _otherController = TextEditingController();
  final Map<String, TextEditingController> _descriptionControllers = {};
  bool isOtherSelected = false;

  List<String> get reasons {
    if (widget.question != null) {
      return widget.question!.choices;
    }
    // Fallback to hardcoded options if API data is not available
    return [
      'Something new is going on and I want to get to the bottom of it',
      'I\'ve been dealing with the same issue and still need answers',
      'I have a known condition and need ongoing care',
      'I\'m due for a check-up or wellness exam',
      'I\'m here for something specific (e.g. test, procedure, birth control)',
      'I can\'t explain it — I just know something feels off',
      'I\'m here because I didn\'t feel taken seriously before',
      'I need a referral, lab, or prescription handled',
    ];
  }

  final List<String> reasonsNeedingDescription = [
    'I\'ve been dealing with the same issue and still need answers',
    'I have a known condition and need ongoing care',
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for reasons that need descriptions
    for (String reason in reasonsNeedingDescription) {
      _descriptionControllers[reason] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _otherController.dispose();
    for (var controller in _descriptionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateData() {
    String? reason = selectedReason;
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      reason = 'Other';
      info['other_reason_description'] = _otherController.text.trim();
    }
    
    // Add descriptions for reasons that need them
    for (String reasonKey in reasonsNeedingDescription) {
      if (selectedReason == reasonKey && _descriptionControllers[reasonKey] != null) {
        String description = _descriptionControllers[reasonKey]!.text.trim();
        if (description.isNotEmpty) {
          info['${reasonKey.toLowerCase().replaceAll(' ', '_')}_description'] = description;
        }
      }
    }
    
    widget.onDataUpdate(reason, info, _canProceed());
  }

  bool _needsDescription(String reason) {
    return reasonsNeedingDescription.contains(reason);
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
            widget.question?.question ?? 'What\'s the main reason for your visit, the one that matters most to you?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            widget.question?.description ?? 'This helps us focus on what matters most to you, whether it\'s something new, something recurring, or something that hasn\'t felt taken seriously.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // Instruction
          Text(
            'Select one that fits best, or write your own',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
            ),
          ),
          const SizedBox(height: 24),
          
          // Reason options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...reasons.map((reason) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NeumorphicOptionCard(
                          text: reason,
                          isSelected: selectedReason == reason,
                          onTap: () {
                            setState(() {
                              selectedReason = reason;
                              isOtherSelected = false;
                            });
                            _updateData();
                          },
                        ),
                      ),
                      // Description field for reasons that need it
                      if (_needsDescription(reason) && selectedReason == reason) ...[
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
                            controller: _descriptionControllers[reason],
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
                        const SizedBox(height: 12),
                      ],
                    ],
                  )),
                  
                  // Other option
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: NeumorphicOptionCard(
                          text: 'Others',
                          isSelected: isOtherSelected,
                          onTap: () {
                            setState(() {
                              isOtherSelected = true;
                              selectedReason = null;
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
    if (selectedReason != null) {
      if (_needsDescription(selectedReason!)) {
        return _descriptionControllers[selectedReason!]?.text.trim().isNotEmpty ?? false;
      }
      return true;
    }
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) return true;
    return false;
  }
}
