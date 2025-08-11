import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/neumorphic_card.dart';

class LifeSituationScreen extends StatefulWidget {
  final Function(List<String>, Map<String, String>, bool) onDataUpdate;

  const LifeSituationScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<LifeSituationScreen> createState() => _LifeSituationScreenState();
}

class _LifeSituationScreenState extends State<LifeSituationScreen> {
  final Set<String> selectedSituations = {};
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  final List<String> lifeSituations = [
    'Work is demanding and stressful',
    'Caring for family or loved ones',
    'Financial stress is weighing on me',
    'Going through relationship changes',
    'Coping with grief or loss',
    'Life feels pretty stable and manageable',
    'In the middle of a big life transition',
    'Raising young kids and feeling exhausted',
    'I\'d prefer not to share right now',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select some situations as shown in the image
    selectedSituations.add('Work is demanding and stressful');
    selectedSituations.add('Caring for family or loved ones');
    selectedSituations.add('Others');
    isOtherSelected = true;
    
    // Add sample text to the "Others" field
    _otherController.text = 'Recently moved to a new city and feeling isolated';
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
    List<String> situations = selectedSituations.toList();
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      info['other_situation_description'] = _otherController.text.trim();
    }
    
    widget.onDataUpdate(situations, info, _canProceed());
  }

  void _toggleSituation(String situation) {
    setState(() {
      if (selectedSituations.contains(situation)) {
        selectedSituations.remove(situation);
      } else {
        selectedSituations.add(situation);
      }
    });
    _updateData();
  }

  void _toggleOther() {
    setState(() {
      if (isOtherSelected) {
        selectedSituations.remove('Others');
        isOtherSelected = false;
      } else {
        selectedSituations.add('Others');
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
            'What are you carrying right now in life?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            'Stress, responsibilities, and major changes can all affect your health even if they\'re not the reason for your visit. We ask this to better understand the weight behind your symptoms, so our support isn\'t just clinical, but compassionate.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Life situation options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...lifeSituations.map((situation) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: situation,
                      isSelected: selectedSituations.contains(situation),
                      onTap: () => _toggleSituation(situation),
                    ),
                  )),
                  
                  // Others option
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: 'Others',
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
    return selectedSituations.isNotEmpty;
  }
}
