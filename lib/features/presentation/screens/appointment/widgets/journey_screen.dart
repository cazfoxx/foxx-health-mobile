import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';
import 'package:foxxhealth/features/data/models/appointment_question_model.dart';

class JourneyScreen extends StatefulWidget {
  final Function(List<String>, Map<String, String>, bool) onDataUpdate;
  final AppointmentQuestion? question;

  const JourneyScreen({
    Key? key,
    required this.onDataUpdate,
    this.question,
  }) : super(key: key);

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  final Set<String> selectedJourneySteps = {};

  List<String> get journeySteps {
    if (widget.question != null) {
      return widget.question!.choices;
    }
    // Fallback to hardcoded options if API data is not available
    return [
      'I just started noticing it and haven\'t done much yet',
      'I\'ve been tracking or thinking about it for a while',
      'I\'ve looked into it on my own (online, books, etc.)',
      'I\'ve talked to a provider, but I still have questions',
      'I\'ve tried treatment, medication, or lifestyle changes',
      'I\'ve had tests, scans, or labs',
      'I\'ve been dismissed or not taken seriously',
      'I\'ve done a lot already, but still don\'t have answers',
      'I\'m not sure what to do next',
      'Prefer not to answer',
    ];
  }

  @override
  void initState() {
    super.initState();
    // Pre-select some journey steps as shown in the image

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update data after the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateData();
    });
  }

  void _updateData() {
    List<String> steps = selectedJourneySteps.toList();
    Map<String, String> info = {};
    
    widget.onDataUpdate(steps, info, _canProceed());
  }

  void _toggleJourneyStep(String step) {
    setState(() {
      if (selectedJourneySteps.contains(step)) {
        selectedJourneySteps.remove(step);
      } else {
        selectedJourneySteps.add(step);
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
            widget.question?.question ?? 'Where are you in your journey with this concern and what have you already tried?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            'Women often have to explain themselves over and over. This helps us understand what you\'ve already been through, so you don\'t have to keep starting over.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // Instruction
          Text(
            'Select anything that feels true for you right now',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Journey step options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...journeySteps.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: step,
                      isSelected: selectedJourneySteps.contains(step),
                      onTap: () => _toggleJourneyStep(step),
                    ),
                  )),
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
    return selectedJourneySteps.isNotEmpty;
  }
}
