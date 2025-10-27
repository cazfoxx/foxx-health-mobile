import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';
import 'package:foxxhealth/features/data/models/appointment_question_model.dart';

class SymptomSelectionScreen extends StatefulWidget {
  final Function(List<String>, Map<String, String>, bool) onDataUpdate;
  final AppointmentQuestion? question;

  const SymptomSelectionScreen({
    super.key,
    required this.onDataUpdate,
    this.question,
  });

  @override
  State<SymptomSelectionScreen> createState() => _SymptomSelectionScreenState();
}

class _SymptomSelectionScreenState extends State<SymptomSelectionScreen> {
  final Set<String> selectedSymptoms = {};
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  final List<String> trackedSymptoms = [
    'Headache',
    'Fatigue',
    'Anxiety',
    'Insomnia',
    'Nausea',
    'Dizziness',
    'Chest Pain',
    'Shortness of Breath',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select first two symptoms as shown in the image
    // selectedSymptoms.add(trackedSymptoms[0]);
    // selectedSymptoms.add(trackedSymptoms[1]);
    // selectedSymptoms.add('Something else feels more important');
    isOtherSelected = false;
    
    // Add sample text to the "Something else" field
    _otherController.text = 'Chronic back pain that has been worsening over the past month';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update data after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateData();
    });
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _updateData() {
    List<String> symptoms = selectedSymptoms.toList();
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      info['other_symptom_description'] = _otherController.text.trim();
    }
    
    widget.onDataUpdate(symptoms, info, _canProceed());
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (selectedSymptoms.contains(symptom)) {
        selectedSymptoms.remove(symptom);
      } else {
        selectedSymptoms.add(symptom);
      }
    });
    _updateData();
  }

  void _toggleOther() {
    setState(() {
      if (isOtherSelected) {
        selectedSymptoms.remove('Something else feels more important');
        isOtherSelected = false;
      } else {
        selectedSymptoms.add('Something else feels more important');
        isOtherSelected = true;
      }
    });
    _updateData();
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
            widget.question?.question ?? 'Which of your tracked symptoms feel most important to discuss at this appointment?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description paragraphs
          Text(
            'You might be tracking a lot of things but not all of them feel urgent today. This question helps us focus on what you care about, not just what shows up in a chart.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          
          Text(
            'We\'ll show you the symptoms you\'ve been tracking. Select the ones that feel most relevant for this visit.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Symptom options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...trackedSymptoms.map((symptom) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: symptom,
                      isSelected: selectedSymptoms.contains(symptom),
                      onTap: () => _toggleSymptom(symptom),
                    ),
                  )),
                  
                  // Something else option
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: 'Something else feels more important',
                      isSelected: isOtherSelected,
                      onTap: _toggleOther,
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
    return true;//selectedSymptoms.isNotEmpty;
  }
}
