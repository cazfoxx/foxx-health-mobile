import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';

class CareExperienceScreen extends StatefulWidget {
  final Function(List<String>, Map<String, String>, bool) onDataUpdate;

  const CareExperienceScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<CareExperienceScreen> createState() => _CareExperienceScreenState();
}

class _CareExperienceScreenState extends State<CareExperienceScreen> {
  final Set<String> selectedExperiences = {};
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  final List<String> careExperienceOptions = [
    'I know how to speak up and get what I need',
    'I try to advocate for myself, but it doesn\'t always land',
    'I often leave wishing I\'d said more or asked different questions',
    'I need help putting things into words or making sense of medical language',
    'I usually just go along, even if something doesn\'t feel right',
    'I\'ve felt judged or overlooked because of my body, identity, or history',
    'I\'ve felt misunderstood, even if I\'m not sure why',
    'I haven\'t experienced bias in my care',
    'I\'d rather not say',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select "Others" as shown in the image
    selectedExperiences.add('Others');
    isOtherSelected = true;
    
    // Add sample text to the "Others" field
    _otherController.text = 'I have had mixed experiences with different healthcare providers';
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
    List<String> experiences = selectedExperiences.toList();
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      info['other_experience_description'] = _otherController.text.trim();
    }
    
    widget.onDataUpdate(experiences, info, _canProceed());
  }

  void _toggleExperience(String experience) {
    setState(() {
      if (selectedExperiences.contains(experience)) {
        selectedExperiences.remove(experience);
      } else {
        selectedExperiences.add(experience);
      }
    });
    _updateData();
  }

  void _toggleOther() {
    setState(() {
      if (isOtherSelected) {
        selectedExperiences.remove('Others');
        isOtherSelected = false;
      } else {
        selectedExperiences.add('Others');
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          
          // Central Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star,
              size: 40,
              color: AppColors.amethyst,
            ),
          ),
          const SizedBox(height: 24),
          
          // Title
          Text(
            'For you, what\'s it been like trying to get care and be heard?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            'Your answer helps us understand where bias or gaps may exist, so we can help you feel seen and not just processed.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          
          // Instruction
          Text(
            'Select all that apply',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          
          // Care experience options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...careExperienceOptions.map((experience) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: experience,
                      isSelected: selectedExperiences.contains(experience),
                      onTap: () => _toggleExperience(experience),
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
    return selectedExperiences.isNotEmpty;
  }
}
