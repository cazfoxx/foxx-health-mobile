import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';

class CommunicationPreferencesScreen extends StatefulWidget {
  final Function(List<String>, Map<String, String>, bool) onDataUpdate;

  const CommunicationPreferencesScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<CommunicationPreferencesScreen> createState() => _CommunicationPreferencesScreenState();
}

class _CommunicationPreferencesScreenState extends State<CommunicationPreferencesScreen> {
  final Set<String> selectedPreferences = {};
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  final List<String> communicationOptions = [
    'This is serious and needs attention; give me strong advocacy language',
    'My experience is valid; assertive but still collaborative approach',
    'I want them to ask more, not assume; help me stay curious and informed',
    'Even if they don\'t fully understand; help me redirect without confrontation',
    'I need something to change soon; help me ask for second opinions when needed',
    'I want to be taken seriously without confusion; help me get my concerns in my chart',
    'How to exit and regroup if it\'s not safe or productive',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select "Others" as shown in the image
    selectedPreferences.add('Others');
    isOtherSelected = true;
    
    // Add sample text to the "Others" field
    _otherController.text = 'I want to be treated with respect and have my concerns taken seriously';
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
    List<String> preferences = selectedPreferences.toList();
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      info['other_communication_description'] = _otherController.text.trim();
    }
    
    widget.onDataUpdate(preferences, info, _canProceed());
  }

  void _togglePreference(String preference) {
    setState(() {
      if (selectedPreferences.contains(preference)) {
        selectedPreferences.remove(preference);
      } else {
        selectedPreferences.add(preference);
      }
    });
    _updateData();
  }

  void _toggleOther() {
    setState(() {
      if (isOtherSelected) {
        selectedPreferences.remove('Others');
        isOtherSelected = false;
      } else {
        selectedPreferences.add('Others');
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
            'How do you want to communicate with your healthcare provider and ensure you\'re heard?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            'This helps our AI frame questions and advocacy strategies. We want your concerns to be heard the way you mean them.',
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
          
          // Communication preference options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...communicationOptions.map((preference) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: preference,
                      isSelected: selectedPreferences.contains(preference),
                      onTap: () => _togglePreference(preference),
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
    return selectedPreferences.isNotEmpty;
  }
}
