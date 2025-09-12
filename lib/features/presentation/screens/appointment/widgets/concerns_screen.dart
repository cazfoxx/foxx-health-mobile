import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';

class ConcernsScreen extends StatefulWidget {
  final Function(List<String>, Map<String, String>, bool) onDataUpdate;

  const ConcernsScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<ConcernsScreen> createState() => _ConcernsScreenState();
}

class _ConcernsScreenState extends State<ConcernsScreen> {
  final Set<String> selectedConcerns = {};
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  final List<String> concernOptions = [
    'A specific symptom or pattern',
    'My history with this issue',
    'Emotional or hormonal context',
    'A misdiagnosis or labeling issue',
    'My own explanation of what\'s going on',
    'I have concerns, but I\'m not ready to share details yet.',
    'I don\'t have specific worries about being dismissed right now.',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select "I'm worried they might dismiss..." as shown in the image
    selectedConcerns.add('I\'m worried they might dismiss...');
    isOtherSelected = true;
    
    // Add sample text to the "I'm worried they might dismiss..." field
    _otherController.text = 'My symptoms as just stress or anxiety when they feel more serious';
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
    List<String> concerns = selectedConcerns.toList();
    Map<String, String> info = {};
    
    if (isOtherSelected && _otherController.text.trim().isNotEmpty) {
      info['other_concern_description'] = _otherController.text.trim();
    }
    
    widget.onDataUpdate(concerns, info, _canProceed());
  }

  void _toggleConcern(String concern) {
    setState(() {
      if (selectedConcerns.contains(concern)) {
        selectedConcerns.remove(concern);
      } else {
        selectedConcerns.add(concern);
      }
    });
    _updateData();
  }

  void _toggleOther() {
    setState(() {
      if (isOtherSelected) {
        selectedConcerns.remove('I\'m worried they might dismiss...');
        isOtherSelected = false;
      } else {
        selectedConcerns.add('I\'m worried they might dismiss...');
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
            'When you think about this visit, what are you afraid might get overlooked?',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),
          
          // Description
          Text(
            'You deserve to be taken seriously. Sharing this helps us shape language that\'s firm but respectful so your concerns are harder to ignore and easier to hear.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          
          // Concern options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...concernOptions.map((concern) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: concern,
                      isSelected: selectedConcerns.contains(concern),
                      onTap: () => _toggleConcern(concern),
                    ),
                  )),
                  
                  // "I'm worried they might dismiss..." option
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeumorphicOptionCard(
                      text: 'I\'m worried they might dismiss...',
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
    return selectedConcerns.isNotEmpty;
  }
}
