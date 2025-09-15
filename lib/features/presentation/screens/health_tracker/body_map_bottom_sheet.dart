import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/screens/health_tracker/symptom_details_bottom_sheet.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';

/*
MANUAL POSITIONING GUIDE FOR BODY PARTS:

1. COORDINATE SYSTEM:
   - X-axis: 0 = left edge, 300 = right edge (assuming 300px container width)
   - Y-axis: 0 = top edge, 400 = bottom edge (assuming 400px container height)
   - Center point: (150, 200)

2. HOW TO ADJUST POSITIONS:
   - Find the body part you want to move in the _bodyParts map
   - Modify the 'frontPosition' and 'backPosition' values
   - Use Offset(x, y) where x and y are pixel values
   - The position represents the center of the body part

3. POSITIONING TIPS:
   - Start with rough positions and fine-tune
   - Use the _printCurrentPositions() method to debug
   - Use the _adjustBodyPartPosition() method for runtime adjustments
   - Consider the size of each body part when positioning
   - Positions remain stable during selection/deselection

4. EXAMPLE ADJUSTMENTS:
   - Move head up: Offset(150, 20) instead of Offset(150, 40)
   - Move eyes left: Offset(140, 25) instead of Offset(150, 25)
   - Make chest wider: Increase size.width from 100 to 120

5. CURRENT LAYOUT:
   - Front view: Shows only interactive body parts (no background outline)
   - Back view: Shows only the Body Back.svg as a selectable element
   - Each body part is clickable and shows selection state by color change only
   - No containers or borders around selected items
   - SVG sizes increased for better visibility and interaction
   - Body Back.svg is selectable when in back view mode
*/

class BodyMapBottomSheet extends StatefulWidget {
  const BodyMapBottomSheet({Key? key}) : super(key: key);

  @override
  State<BodyMapBottomSheet> createState() => _BodyMapBottomSheetState();
}

class _BodyMapBottomSheetState extends State<BodyMapBottomSheet> {
  Set<String> _selectedBodyParts = {};
  bool _showFrontView = true;
  bool _isLoadingSymptoms = false;
  String? _errorMessage;

  // Body parts positioning guide:
  // - Use absolute pixel values for precise control
  // - X coordinate: 0 = left edge, 300 = right edge (assuming 300px width)
  // - Y coordinate: 0 = top edge, 400 = bottom edge (assuming 400px height)
  // - Center point is around (150, 200)
  // - Adjust these values to match your body outline
  final Map<String, Map<String, dynamic>> _bodyParts = {
    'Head & neck': {
      'svg': 'assets/svg/body_parts_selector/Head & neck.svg',
      'frontPosition': const Offset(184, 200),  // Center top
      'backPosition': const Offset(150, 40),
      'size': const Size(50, 50),
    },
    'Eyes': {
      'svg': 'assets/svg/body_parts_selector/Eyes.svg',
      'frontPosition': const Offset(166, 192),// Above head
      'backPosition': const Offset(150, 25),
      'size': const Size(10, 10),
    },
    'Ear, Nose & Throat': {
      'svg': 'assets/svg/body_parts_selector/Ear, Nose & Throat.svg',
      'frontPosition': const Offset(162.5, 198),  // Below eyes
      'backPosition': const Offset(150, 60),
      'size': const Size(15, 15),
    },
    'Hair': {
      'svg': 'assets/svg/body_parts_selector/Hair.svg',
      'frontPosition': const Offset(172.5, 178),  // Top of head
      'backPosition': const Offset(150, 15),
      'size': const Size(30, 30),
    },
    'Mouth & Jaw': {
      'svg': 'assets/svg/body_parts_selector/Mouth & Jaw.svg',
      'frontPosition': const Offset(168, 208),  // Below ears/nose
      'backPosition': const Offset(150, 80),
      'size': const Size(18, 18),
    },
    'Arms & Shoulder': {
      'svg': 'assets/svg/body_parts_selector/Arms & Shoulder.svg',
      'frontPosition': const Offset(195, 290), // Upper body
      'backPosition': const Offset(150, 120),
      'size': const Size(130, 130),
    },
    'Chest Area': {
      'svg': 'assets/svg/body_parts_selector/Chest Area.svg',
      'frontPosition': const Offset(175, 245), // Middle chest
      'backPosition': const Offset(150, 160),
      'size': const Size(50, 50),
    },
    'Abdomen': {
      'svg': 'assets/svg/body_parts_selector/Abdomen.svg',
      'frontPosition': const Offset(169, 288), // Lower chest
      'backPosition': const Offset(150, 220),
      'size': const Size(40, 40),
    },
    'Pelvis': {
      'svg': 'assets/svg/body_parts_selector/Pelvis.svg',
      'frontPosition': const Offset(160, 322), // Hip area
      'backPosition': const Offset(210, 330),
      'size': const Size(32, 32),
    },
    'Legs': {
      'svg': 'assets/svg/body_parts_selector/Legs.svg',
      'frontPosition': const Offset(220, 395), // Lower body
      'backPosition': const Offset(200, 100),
      'size': const Size(150, 150),
    },
    'Skin & Whole Body': {
      'svg': 'assets/svg/body_parts_selector/Skin & Whole Body.svg',
      'frontPosition': const Offset(150, 200), // Center of body
      'backPosition': const Offset(150, 200),
      'size': const Size(250, 350),
    },
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE4C4), Color(0xFFE6E6FA)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Step Indicator
          _buildStepIndicator(),
          
          // Error Message Display
          if (_errorMessage != null) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _clearErrorMessage,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Selected Body Parts Tags - Fixed height container to prevent UI shifting
          Container(
            height: 60, // Fixed height for chips area
            child: _selectedBodyParts.isNotEmpty 
                ? _buildSelectedTags() 
                : const SizedBox.shrink(),
          ),
          
          // Body Map
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // View Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFrontView = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: _showFrontView ? AppColors.amethyst : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.amethyst,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Front',
                            style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                              color: _showFrontView ? Colors.white : AppColors.amethyst,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showFrontView = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: !_showFrontView ? AppColors.amethyst : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.amethyst,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Back',
                            style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                              color: !_showFrontView ? Colors.white : AppColors.amethyst,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  
                  // Body Map Content
                  Expanded(
                    child: Stack(
                      children: [
                        // Base body outline - only show for back view
                        if (!_showFrontView)
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedBodyParts.contains('Body Back')) {
                                    _selectedBodyParts.remove('Body Back');
                                  } else {
                                    _selectedBodyParts.add('Body Back');
                                  }
                                  _errorMessage = null; // Clear error when body part is selected
                                });
                              },
                              child: SvgPicture.asset(
                                'assets/svg/body_parts_selector/Body Back.svg',
                                width: 200,
                                height: 300,
                                colorFilter: ColorFilter.mode(
                                  _selectedBodyParts.contains('Body Back')
                                      ? AppColors.amethyst
                                      : AppColors.primary01,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        
                        // Interactive body parts - only show for front view
                        if (_showFrontView) ..._buildInteractiveBodyParts(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Button
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              color: AppColors.primary01,
              size: 24,
            ),
          ),
          Text(
            'Body map',
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: AppColors.primary01,
            ),
          ),
          GestureDetector(
            onTap: _selectedBodyParts.isEmpty || _isLoadingSymptoms
                ? null 
                : () async {
                    // Fetch symptoms for selected body parts
                    await _fetchSymptomsForBodyParts();
                  },
            child: _isLoadingSymptoms
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.amethyst),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Loading...',
                        style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                          color: AppColors.amethyst,
                        ),
                      ),
                    ],
                  )
                : Text(
                    _selectedBodyParts.isEmpty 
                        ? 'Save' 
                        : 'Save (${_selectedBodyParts.length})',
                    style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                      color: _selectedBodyParts.isEmpty 
                          ? AppColors.davysGray 
                          : AppColors.amethyst,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1',
            style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
              color: AppColors.davysGray,
            ),
          ),
          Text(
            'Select body part(s)',
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: AppColors.primary01,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTags() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _selectedBodyParts.map((bodyPart) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.mauve50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bodyPart,
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBodyParts.remove(bodyPart);
                      _errorMessage = null; // Clear error when body part is removed
                    });
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.primary01,
                    size: 16,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }



  List<Widget> _buildInteractiveBodyParts() {
    List<Widget> widgets = [];
    
    _bodyParts.forEach((bodyPart, data) {
      // Skip Skin & Whole Body for individual parts
      if (bodyPart == 'Skin & Whole Body') return;
      
      // Get the correct position based on view
      final position = _showFrontView 
          ? data['frontPosition'] as Offset
          : data['backPosition'] as Offset;
      final size = data['size'] as Size;
      final isSelected = _selectedBodyParts.contains(bodyPart);
      
      widgets.add(
        Positioned(
          left: position.dx - size.width / 2,
          top: position.dy - size.height / 2,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedBodyParts.remove(bodyPart);
                } else {
                  _selectedBodyParts.add(bodyPart);
                }
                _errorMessage = null; // Clear error when body part is selected
              });
            },
            child: SvgPicture.asset(
              data['svg'] as String,
              width: size.width,
              height: size.height,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.amethyst : AppColors.primary01,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      );
    });
    
    return widgets;
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (_selectedBodyParts.contains('Skin & Whole Body')) {
              _selectedBodyParts.remove('Skin & Whole Body');
            } else {
              _selectedBodyParts.clear();
              _selectedBodyParts.add('Skin & Whole Body');
            }
            _errorMessage = null; // Clear error when body part is selected
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedBodyParts.contains('Skin & Whole Body')
                ? AppColors.amethyst
                : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.amethyst,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              'Skin or whole body',
              style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                color: _selectedBodyParts.contains('Skin & Whole Body')
                    ? Colors.white
                    : AppColors.primary01,
              ),
            ),
          ),
        ),
      ),
    );
  }


  // Clear error message
  void _clearErrorMessage() {
    setState(() {
      _errorMessage = null;
    });
  }

  // Fetch symptoms for selected body parts
  Future<void> _fetchSymptomsForBodyParts() async {
    if (_selectedBodyParts.isEmpty) {
      setState(() {
        _errorMessage = 'Please select at least one body part';
      });
      return;
    }

    // Clear any previous error and set loading state
    setState(() {
      _errorMessage = null;
      _isLoadingSymptoms = true;
    });

    try {
      final symptomCubit = context.read<SymptomSearchCubit>();
      
      // For now, we'll use the first selected body part
      // In a real app, you might want to fetch symptoms for all selected body parts
      final firstBodyPart = _selectedBodyParts.first;
      
      // Map body part names to API body part values
      String apiBodyPart = _mapBodyPartToAPI(firstBodyPart);
      
      // Fetch symptoms for the body part
      final symptoms = await symptomCubit.getSymptomsByBodyPart(apiBodyPart);
      
      // Clear loading state
      setState(() {
        _isLoadingSymptoms = false;
      });
      
      if (symptoms.isNotEmpty) {
        // Show symptoms bottom sheet
        _showSymptomsBottomSheet(symptoms);
      } else {
        // Show error message in sheet for empty data
        setState(() {
          _errorMessage = 'No symptoms found for the selected body part. Please try a different area.';
        });
      }
    } catch (e) {
      // Clear loading state on error
      setState(() {
        _isLoadingSymptoms = false;
        _errorMessage = 'Error fetching symptoms: $e';
      });
    }
  }

  // Map body part names to API body part values
  String _mapBodyPartToAPI(String bodyPart) {
    switch (bodyPart) {
      case 'Pelvis':
        return 'Pelvis';
      case 'Abdomen':
        return 'Abdomen';
      case 'Chest Area':
        return 'Chest';
      case 'Head & neck':
        return 'Head';
      case 'Arms & Shoulder':
        return 'Arms';
      case 'Legs':
        return 'Legs';
      case 'Back':
        return 'Back';
      case 'Skin & Whole Body':
        return 'Skin';
      default:
        return 'Pelvis'; // Default fallback
    }
  }

  // Show symptoms bottom sheet
  void _showSymptomsBottomSheet(List<Map<String, dynamic>> symptoms) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SymptomsBottomSheet(
        symptoms: symptoms,
        onSymptomsSelected: (selectedSymptomIds) {
          // This callback is no longer used since we handle selection individually
        },
      ),
    );
  }

}

// Symptoms Bottom Sheet Widget
class _SymptomsBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> symptoms;
  final Function(List<String>) onSymptomsSelected;

  const _SymptomsBottomSheet({
    required this.symptoms,
    required this.onSymptomsSelected,
  });

  @override
  State<_SymptomsBottomSheet> createState() => _SymptomsBottomSheetState();
}

class _SymptomsBottomSheetState extends State<_SymptomsBottomSheet> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFE4C4), Color(0xFFE6E6FA)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: AppColors.primary01,
                    size: 24,
                  ),
                ),

                 Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 2',
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: AppColors.davysGray,
                  ),
                ),
                Text(
                  'Select symptoms',
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
                // Save button removed - symptoms are now handled individually when tapped
              ],
            ),
          ),
          
          // Step Indicator
        
          
          const SizedBox(height: 20),
          
          // Symptoms List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.symptoms.length,
              itemBuilder: (context, index) {
                final symptom = widget.symptoms[index];
                final symptomName = symptom['info']?['name'] as String? ?? 'Unknown Symptom';
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.mauve50,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    leading: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.amethyst,
                      size: 16,
                    ),
                    title: Text(
                      symptomName,
                      style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                    onTap: () {
                      // Show details sheet when symptom is selected

                      _showSymptomDetailsFromBodyMap(symptom);
                    },
                  ),
                );
              },
            ),
          ),
          
         
        ],
      ),
    );
  }

  void _showSymptomDetailsFromBodyMap(Map<String, dynamic> symptom) async {
    try {
      // Get symptom details from API
      final cubit = context.read<SymptomSearchCubit>();
      final symptomDetails = await cubit.getSymptomDetails(symptom['id']);
      
      if (symptomDetails != null) {
        // Convert symptom to the format expected by the details sheet
        final symptomData = {
          'id': symptom['id'],
          'info': {
            'name': symptom['info']?['name'] ?? 'Unknown Symptom',
            'question_map': symptomDetails['info']?['question_map'] ?? symptomDetails['question_map'],
          },
        };
        
        // Show the details sheet
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SymptomDetailsBottomSheet(
            symptoms: [symptomData],
            onDetailsSaved: (details) {
              // Add the symptom with details to selected symptoms
              // Convert the symptom data to Symptom model
              final symptomModel = Symptom.fromJson(symptom);
              context.read<SymptomSearchCubit>().addSymptomWithDetails(symptomModel, details.first);
            },
          ),
        ).then((_) {
          // Refresh the state when the sheet is closed
          context.read<SymptomSearchCubit>().refreshSymptoms();
        });
      } else {
        // Fallback if API fails - show details sheet with basic symptom info
        final symptomData = {
          'id': symptom['id'],
          'info': {
            'name': symptom['info']?['name'] ?? 'Unknown Symptom',
            'question_map': null,
          },
        };
        
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SymptomDetailsBottomSheet(
            symptoms: [symptomData],
            onDetailsSaved: (details) {
              // Add the symptom with details to selected symptoms
              final symptomModel = Symptom.fromJson(symptom);
              context.read<SymptomSearchCubit>().addSymptomWithDetails(symptomModel, details.first);
            },
          ),
        ).then((_) {
          // Refresh the state when the sheet is closed
          context.read<SymptomSearchCubit>().refreshSymptoms();
        });
      }
    } catch (e) {
      // Show error and fallback to basic details sheet
      print('Error loading symptom details: $e');
      
      final symptomData = {
        'id': symptom['id'],
        'info': {
          'name': symptom['info']?['name'] ?? 'Unknown Symptom',
          'question_map': null,
        },
      };
      
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SymptomDetailsBottomSheet(
          symptoms: [symptomData],
          onDetailsSaved: (details) {
            // Add the symptom with details to selected symptoms
            final symptomModel = Symptom.fromJson(symptom);
            context.read<SymptomSearchCubit>().addSymptomWithDetails(symptomModel, details.first);
          },
        ),
      ).then((_) {
        // Refresh the state when the sheet is closed
        context.read<SymptomSearchCubit>().refreshSymptoms();
      });
    }
  }
}

