import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

// Symptom Details Bottom Sheet Widget
class SymptomDetailsBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> symptoms;
  final Function(List<Map<String, dynamic>>) onDetailsSaved;

  const SymptomDetailsBottomSheet({
    Key? key,
    required this.symptoms,
    required this.onDetailsSaved,
  }) : super(key: key);

  @override
  State<SymptomDetailsBottomSheet> createState() => _SymptomDetailsBottomSheetState();
}

class _SymptomDetailsBottomSheetState extends State<SymptomDetailsBottomSheet> {
  final Map<String, Map<String, dynamic>> _symptomDetails = {};

  @override
  void initState() {
    super.initState();
    // Initialize symptom details with default values
    for (final symptom in widget.symptoms) {
      _symptomDetails[symptom['id']] = {
        'symptom': symptom,
        'answers': <String, String>{}, // Dynamic answers based on API response
        'notes': '',
      };
    }
  }

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
                Text(
                  'Symptom Details',
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Save symptom details
                    final detailsList = _symptomDetails.values.toList();
                    print('🔍 DEBUG: Saving symptom details: ${detailsList.length} items');
                    print('🔍 DEBUG: First item structure: ${detailsList.isNotEmpty ? detailsList.first : 'No items'}');
                    
                    // Debug: Check if answers are populated
                    for (final detail in detailsList) {
                      final symptomId = detail['symptom']['id'];
                      final answers = detail['answers'] as Map<String, String>;
                      final notes = detail['notes'] as String;
                      print('🔍 DEBUG: Symptom $symptomId - Answers: $answers, Notes: $notes');
                    }
                    
                    widget.onDetailsSaved(detailsList);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Save',
                    style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                      color: AppColors.amethyst,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Step Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step 3',
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: AppColors.davysGray,
                  ),
                ),
                Text(
                  'Details that matter',
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Symptom Details List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.symptoms.length,
              itemBuilder: (context, index) {
                final symptom = widget.symptoms[index];
                final symptomId = symptom['id'] as String;
                final symptomName = symptom['info']?['name'] as String? ?? 'Unknown Symptom';
                final details = _symptomDetails[symptomId]!;
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: AppColors.glassCardDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Symptom Name
                        Text(
                          symptomName,
                          style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                            color: AppColors.primary01,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Dynamic Questions based on API response
                        if (_getQuestionMap(symptom) != null) ...[
                          ..._buildDynamicQuestions(symptom, details),
                        ] else ...[
                          // Fallback to default questions if no API data
                          _buildDetailRow(
                            'Severity',
                            _buildSeveritySlider(details, 'severity'),
                          ),
                          _buildDetailRow(
                            'Frequency',
                            _buildFrequencySlider(details, 'frequency'),
                          ),
                          _buildDetailRow(
                            'Onset',
                            _buildOnsetDropdown(details, 'onset'),
                          ),
                        ],
                        
                        // Notes
                        _buildDetailRow(
                          'Additional Notes',
                          _buildNotesInput(details),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, Widget input) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 8),
          input,
        ],
      ),
    );
  }



  Widget _buildTextInput(Map<String, dynamic> details, String key, String hint) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: TextEditingController(text: details['answers'][key] as String? ?? ''),
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.mauve50),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.amethyst),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: (value) {
          details['answers'][key] = value;
        },
      ),
    );
  }

  Widget _buildNotesInput(Map<String, dynamic> details) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: TextEditingController(text: details['notes'] as String? ?? ''),
        decoration: InputDecoration(
          hintText: 'Any other details...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.mauve50),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.amethyst),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: (value) {
          details['notes'] = value;
        },
      ),
    );
  }

  // Get question map from symptom data
  List<Map<String, dynamic>>? _getQuestionMap(Map<String, dynamic> symptom) {
    // Try to get question_map from the root level first (for mock data)
    if (symptom['question_map'] != null) {
      return List<Map<String, dynamic>>.from(symptom['question_map']);
    }
    
    // Try to get question_map from the info object (for API response)
    if (symptom['info'] != null && symptom['info']['question_map'] != null) {
      return List<Map<String, dynamic>>.from(symptom['info']['question_map']);
    }
    
    return null;
  }

  // Build dynamic questions based on API response
  List<Widget> _buildDynamicQuestions(Map<String, dynamic> symptom, Map<String, dynamic> details) {
    final questions = _getQuestionMap(symptom);
    if (questions == null) return [];

    List<Widget> widgets = [];
    
    for (final question in questions) {
      final questionId = question['question_id'] as String;
      final questionText = question['question_text'] as String;
      final questionType = question['question_type'] as String;
      final options = question['question_options'] as List<dynamic>?;
      final description = question['question_description'] as String?;
      
      // Initialize answer if not exists
      if (!details['answers'].containsKey(questionId)) {
        details['answers'][questionId] = '';
      }

      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: AppColors.glassCardDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Text
              Text(
                questionText,
                style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                  color: AppColors.primary01,
                ),
              ),
              
              // Question Description (if available)
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: AppColors.davysGray,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Question Input based on type
              if (questionType == 'multiple_choice' && options != null) ...[
                if (_isScaleQuestion(questionId)) ...[
                  _buildScaleOptions(questionId, options, details),
                ] else if (_isStatementQuestion(questionId)) ...[
                  _buildStatementQuestion(questionId, options, details),
                ] else ...[
                  _buildMultipleChoiceOptions(questionId, options, details),
                ],
              ] else ...[
                _buildTextInput(details, questionId, 'Enter your answer...'),
              ],
            ],
          ),
        ),
      );
    }
    
    return widgets;
  }

  bool _isScaleQuestion(String questionId) {
    return questionId == 'SEVERITY' || questionId == 'FREQUENCY';
  }

  bool _isStatementQuestion(String questionId) {
    return questionId.contains('PAIN_RELIEVED_BY_ACTIVITY') || 
           questionId.contains('AGREE') || 
           questionId.contains('STATEMENT');
  }

  Widget _buildScaleOptions(String questionId, List<dynamic> options, Map<String, dynamic> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scale Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              questionId == 'SEVERITY' ? 'Severity' : 'Frequency',
              style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                color: AppColors.amethyst,
              ),
            ),
            Text(
              _getScaleLabel(questionId, details['answers'][questionId]),
              style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                color: AppColors.amethyst,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Scale Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options.map((option) {
            final optionId = option['id'].toString();
            final isSelected = details['answers'][questionId] == optionId;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  details['answers'][questionId] = optionId;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.amethyst : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.amethyst : AppColors.mauve50,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    option['text'] ?? optionId,
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: isSelected ? Colors.white : AppColors.primary01,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatementQuestion(String questionId, List<dynamic> options, Map<String, dynamic> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Yes/No buttons
        Row(
          children: options.map((option) {
            final optionId = option['id'].toString();
            final optionText = option['text'] ?? optionId;
            final isSelected = details['answers'][questionId] == optionId;
            
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    details['answers'][questionId] = optionId;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.amethyst : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.amethyst : AppColors.mauve50,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      optionText,
                      style: AppOSTextStyles.osMd.copyWith(
                        color: isSelected ? Colors.white : AppColors.primary01,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMultipleChoiceOptions(String questionId, List<dynamic> options, Map<String, dynamic> details) {
    return Column(
      children: options.map((option) {
        final optionId = option['id'].toString();
        final optionText = option['text'] ?? optionId;
        final isSelected = details['answers'][questionId] == optionId;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              details['answers'][questionId] = optionId;
            });
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.amethyst : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.amethyst : AppColors.mauve50,
                width: 1,
              ),
            ),
            child: Text(
              optionText,
              style: AppOSTextStyles.osMd.copyWith(
                color: isSelected ? Colors.white : AppColors.primary01,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getScaleLabel(String questionId, String? value) {
    if (value == null || value.isEmpty) return '';
    
    if (questionId == 'SEVERITY') {
      switch (value) {
        case '0': return 'None';
        case '1': return 'Mild';
        case '2': return 'Moderate';
        case '3': return 'Severe';
        case '4': return 'Debilitating';
        default: return '';
      }
    } else if (questionId == 'FREQUENCY') {
      switch (value) {
        case '0': return 'Never';
        case '1': return 'Rarely';
        case '2': return 'Sometimes';
        case '3': return 'Constant';
        default: return '';
      }
    }
    return '';
  }

  // Fallback methods for when no API data is available
  Widget _buildSeveritySlider(Map<String, dynamic> details, String key) {
    // Initialize if not exists
    if (!details['answers'].containsKey(key)) {
      details['answers'][key] = '0';
    }

    return Row(
      children: [
        Text('0', style: AppOSTextStyles.osSmSemiboldLabel),
        Expanded(
          child: Slider(
            value: double.tryParse(details['answers'][key] ?? '0') ?? 0.0,
            min: 0,
            max: 4,
            divisions: 4,
            activeColor: AppColors.amethyst,
            onChanged: (value) {
              setState(() {
                details['answers'][key] = value.toInt().toString();
              });
            },
          ),
        ),
        Text('4', style: AppOSTextStyles.osSmSemiboldLabel),
        Text('${details['answers'][key]}', style: AppOSTextStyles.osSmSemiboldLabel),
      ],
    );
  }

  Widget _buildFrequencySlider(Map<String, dynamic> details, String key) {
    // Initialize if not exists
    if (!details['answers'].containsKey(key)) {
      details['answers'][key] = '0';
    }

    return Row(
      children: [
        Text('0', style: AppOSTextStyles.osSmSemiboldLabel),
        Expanded(
          child: Slider(
            value: double.tryParse(details['answers'][key] ?? '0') ?? 0.0,
            min: 0,
            max: 3,
            divisions: 3,
            activeColor: AppColors.amethyst,
            onChanged: (value) {
              setState(() {
                details['answers'][key] = value.toInt().toString();
              });
            },
          ),
        ),
        Text('3', style: AppOSTextStyles.osSmSemiboldLabel),
        Text('${details['answers'][key]}', style: AppOSTextStyles.osSmSemiboldLabel),
      ],
    );
  }

  Widget _buildOnsetDropdown(Map<String, dynamic> details, String key) {
    // Initialize if not exists
    if (!details['answers'].containsKey(key)) {
      details['answers'][key] = 'sudden';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.mauve50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: details['answers'][key],
        isExpanded: true,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'sudden', child: Text('Sudden')),
          DropdownMenuItem(value: 'gradual', child: Text('Gradual')),
          DropdownMenuItem(value: 'not_sure', child: Text('Not sure')),
        ],
        onChanged: (value) {
          setState(() {
            details['answers'][key] = value!;
          });
        },
      ),
    );
  }
}
