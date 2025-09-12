import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';

class SymptomChangesScreen extends StatefulWidget {
  final Function(List<String>, Map<String, String>, bool) onDataUpdate;

  const SymptomChangesScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<SymptomChangesScreen> createState() => _SymptomChangesScreenState();
}

class _SymptomChangesScreenState extends State<SymptomChangesScreen> {
  final Set<String> selectedChanges = {};
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  final List<String> symptomChangeOptions = [
    'They come and go unpredictably',
    'They\'ve been gradually getting worse',
    'They\'ve been slowly improving',
    'They flare up in cycles or patterns',
    'They change depending on stress, sleep, or other factors',
    'They feel stuck, nothing\'s really changed',
    'I\'m not sure — it\'s hard to track',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select "Others" as shown in the image
    selectedChanges.add('Others');
    isOtherSelected = true;
    
    // Add sample text to the "Others" field
    _otherController.text = 'Symptoms seem to be triggered by certain foods and stress';
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
    List<String> changes = selectedChanges.toList();
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      info['other_change_description'] = _otherController.text.trim();
    }
    
    widget.onDataUpdate(changes, info, _canProceed());
  }

  void _toggleChange(String change) {
    setState(() {
      if (selectedChanges.contains(change)) {
        selectedChanges.remove(change);
      } else {
        selectedChanges.add(change);
      }
    });
    _updateData();
  }

  void _toggleOther() {
    setState(() {
      if (isOtherSelected) {
        selectedChanges.remove('Others');
        isOtherSelected = false;
      } else {
        selectedChanges.add('Others');
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
            'How have your symptoms been changing over time?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            'We ask because the pattern matters, not just the presence. Whether your symptoms are fading, flaring, or all over the place, this helps us track what your body\'s trying to say.',
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
          
          // Symptom change options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...symptomChangeOptions.map((change) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: change,
                      isSelected: selectedChanges.contains(change),
                      onTap: () => _toggleChange(change),
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
    return selectedChanges.isNotEmpty;
  }
}
