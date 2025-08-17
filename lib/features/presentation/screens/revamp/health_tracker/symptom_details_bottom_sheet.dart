import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';

class SymptomDetailsBottomSheet extends StatefulWidget {
  final Symptom symptom;
  final Map<String, dynamic>? symptomDetails;

  const SymptomDetailsBottomSheet({
    Key? key,
    required this.symptom,
    this.symptomDetails,
  }) : super(key: key);

  @override
  State<SymptomDetailsBottomSheet> createState() => _SymptomDetailsBottomSheetState();
}

class _SymptomDetailsBottomSheetState extends State<SymptomDetailsBottomSheet> {
  Map<String, String> _answers = {};

  @override
  Widget build(BuildContext context) {
    print('🔍 Building SymptomDetailsBottomSheet');
    print('🔍 Symptom: ${widget.symptom.name}');
    print('🔍 SymptomDetails: ${widget.symptomDetails != null ? 'Available' : 'Null'}');
    if (widget.symptomDetails != null) {
      print('🔍 Root question map: ${widget.symptomDetails!['question_map'] != null ? 'Available' : 'Null'}');
      print('🔍 Info question map: ${widget.symptomDetails!['info'] != null && widget.symptomDetails!['info']['question_map'] != null ? 'Available' : 'Null'}');
      final questions = _getQuestionMap();
      print('🔍 Final question map: ${questions != null ? 'Available (${questions.length} questions)' : 'Null'}');
    }
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFFFDFCF8), // Very light warm background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Symptom Name
                  Text(
                    widget.symptom.name,
                    style: AppHeadingTextStyles.h2.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Questions Section
                  if (widget.symptomDetails != null && 
                      _getQuestionMap() != null) ...[
                    _buildQuestionsSection(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close,
                size: 20,
                color: AppColors.primary01,
              ),
            ),
          ),
          Text(
            'Details that matter',
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: AppColors.primary01,
            ),
          ),
          GestureDetector(
            onTap: _saveAnswers,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.amethyst,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Save',
                style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List? _getQuestionMap() {
    if (widget.symptomDetails == null) return null;
    
    // Try to get question_map from the root level first (for mock data)
    if (widget.symptomDetails!['question_map'] != null) {
      return widget.symptomDetails!['question_map'] as List;
    }
    
    // Try to get question_map from the info object (for API response)
    if (widget.symptomDetails!['info'] != null && 
        widget.symptomDetails!['info']['question_map'] != null) {
      return widget.symptomDetails!['info']['question_map'] as List;
    }
    
    return null;
  }

  Widget _buildQuestionsSection() {
    final questions = _getQuestionMap();
    if (questions == null) {
      print('🔍 No questions found');
      return const SizedBox.shrink();
    }
    
    print('🔍 Building questions section with ${questions.length} questions');
    
    return Column(
      children: questions.map((question) {
        print('🔍 Question: ${question['question_text']}');
        return _buildQuestionCard(question);
      }).toList(),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    final questionId = question['question_id'];
    final questionText = question['question_text'];
    final questionType = question['question_type'];
    final options = question['question_options'] as List;
    final description = question['question_description'];
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6F3), // Light beige
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE8E4E0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
          const SizedBox(height: 12),
          
          // Question Description (if available)
          if (description != null) ...[
            Text(
              description,
              style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                color: AppColors.davysGray,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Options
          if (questionType == 'multiple_choice') ...[
            if (_isScaleQuestion(questionId)) ...[
              _buildScaleOptions(questionId, options),
            ] else if (_isStatementQuestion(questionId)) ...[
              _buildStatementQuestion(questionId, options),
            ] else ...[
              _buildMultipleChoiceOptions(questionId, options),
            ],
          ],
        ],
      ),
    );
  }

  bool _isScaleQuestion(String questionId) {
    return questionId == 'SEVERITY' || questionId == 'FREQUENCY';
  }

  bool _isStatementQuestion(String questionId) {
    return questionId.contains('PAIN_RELIEVED_BY_ACTIVITY') || 
           questionId.contains('AGREE') || 
           questionId.contains('STATEMENT');
  }

  Widget _buildScaleOptions(String questionId, List options) {
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
                color: const Color(0xFFE67E22), // Reddish-orange
              ),
            ),
            Text(
              _getScaleLabel(questionId, _answers[questionId]),
              style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                color: const Color(0xFFE67E22), // Reddish-orange
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Scale Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options.map((option) {
            final optionId = option['id'];
            final isSelected = _answers[questionId] == optionId;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _answers[questionId] = optionId;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE67E22) : const Color(0xFFF8F6F3),
                  borderRadius: BorderRadius.circular(8), // Rectangular buttons
                  border: Border.all(
                    color: isSelected ? const Color(0xFFE67E22) : const Color(0xFFD0D0D0),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    option['text'],
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

  Widget _buildStatementQuestion(String questionId, List options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Statement text (if available)
        if (questionId.contains('PAIN_RELIEVED_BY_ACTIVITY')) ...[
          Text(
            'Pain relieved by activity',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 12),
        ],
        
        // Yes/No buttons
        Row(
          children: options.map((option) {
            final optionId = option['id'];
            final optionText = option['text'];
            final isSelected = _answers[questionId] == optionId;
            
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _answers[questionId] = optionId;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.amethyst : const Color(0xFFF8F6F3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? AppColors.amethyst : const Color(0xFFD0D0D0),
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

  Widget _buildMultipleChoiceOptions(String questionId, List options) {
    return Column(
      children: options.map((option) {
        final optionId = option['id'];
        final optionText = option['text'];
        final isSelected = _answers[questionId] == optionId;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              _answers[questionId] = optionId;
            });
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.amethyst : const Color(0xFFF8F6F3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.amethyst : const Color(0xFFD0D0D0),
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
    if (value == null) return '';
    
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

  void _saveAnswers() {
    // TODO: Implement save functionality
    // You can save the answers to the cubit or send them to the API
    print('Saving answers: $_answers');
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Symptom details saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.of(context).pop();
  }
}

class SymptomDetailsHelper {
  static Map<String, dynamic>? getMockSymptomDetails(String symptomId) {
    // Mock data based on the API response structure you provided
    if (symptomId == 'A_LUMP_WARTLIKE_BUMP_OR_AN_OPEN_SORE') {
      return {
        "id": "A_LUMP_WARTLIKE_BUMP_OR_AN_OPEN_SORE",
        "info": {
          "id": "A_LUMP_WARTLIKE_BUMP_OR_AN_OPEN_SORE",
          "name": "A lump, wartlike bump or an open sore ",
          "filter_grouping": [],
          "body_parts": [
            "Pelvis",
            "Skin or Whole Body"
          ],
          "tags": [
            "Raised/Bumpy",
            "Flat",
            "Crusted/Scabbed",
            "Itchy",
            "Painful"
          ],
          "visual_insights": [
            "dot",
            "bar_graph"
          ],
          "question_map": [
            {
              "question_id": "ONSET",
              "question_text": "How did the symptom begin?",
              "question_type": "multiple_choice",
              "question_options": [
                {
                  "id": "sudden",
                  "text": "It came on suddenly"
                },
                {
                  "id": "gradual",
                  "text": "It built up gradually"
                },
                {
                  "id": "not_sure",
                  "text": "I'm not sure / can't remember"
                }
              ],
              "is_starting_question": true,
              "question_description": null
            },
            {
              "question_id": "SEVERITY",
              "question_text": "Severity",
              "question_type": "multiple_choice",
              "question_options": [
                {
                  "id": "0",
                  "text": "0"
                },
                {
                  "id": "1",
                  "text": "1"
                },
                {
                  "id": "2",
                  "text": "2"
                },
                {
                  "id": "3",
                  "text": "3"
                },
                {
                  "id": "4",
                  "text": "4"
                }
              ],
              "is_starting_question": true,
              "question_description": null
            },
            {
              "question_id": "FREQUENCY",
              "question_text": "Frequency",
              "question_type": "multiple_choice",
              "question_options": [
                {
                  "id": "0",
                  "text": "0"
                },
                {
                  "id": "1",
                  "text": "1"
                },
                {
                  "id": "2",
                  "text": "2"
                },
                {
                  "id": "3",
                  "text": "3"
                }
              ],
              "is_starting_question": true,
              "question_description": null
            },
            {
              "question_id": "PAIN_RELIEVED_BY_ACTIVITY",
              "question_text": "Do you agree with the following statement?",
              "question_type": "multiple_choice",
              "question_options": [
                {
                  "id": "yes",
                  "text": "Yes"
                },
                {
                  "id": "no",
                  "text": "No"
                }
              ],
              "is_starting_question": true,
              "question_description": null
            }
          ]
        },
        "need_help_popup": false,
        "notes": ""
      };
    }
    
    // Add mock data for other symptoms to ensure questions show up
    return {
      "id": symptomId,
      "info": {
        "id": symptomId,
        "name": "Symptom",
        "filter_grouping": [],
        "body_parts": [],
        "tags": [],
        "visual_insights": [],
        "question_map": [
          {
            "question_id": "ONSET",
            "question_text": "How did the symptom begin?",
            "question_type": "multiple_choice",
            "question_options": [
              {
                "id": "sudden",
                "text": "It came on suddenly"
              },
              {
                "id": "gradual",
                "text": "It built up gradually"
              },
              {
                "id": "not_sure",
                "text": "I'm not sure / can't remember"
              }
            ],
            "is_starting_question": true,
            "question_description": null
          },
          {
            "question_id": "SEVERITY",
            "question_text": "Severity",
            "question_type": "multiple_choice",
            "question_options": [
              {
                "id": "0",
                "text": "0"
              },
              {
                "id": "1",
                "text": "1"
              },
              {
                "id": "2",
                "text": "2"
              },
              {
                "id": "3",
                "text": "3"
              },
              {
                "id": "4",
                "text": "4"
              }
            ],
            "is_starting_question": true,
            "question_description": null
          },
          {
            "question_id": "FREQUENCY",
            "question_text": "Frequency",
            "question_type": "multiple_choice",
            "question_options": [
              {
                "id": "0",
                "text": "0"
              },
              {
                "id": "1",
                "text": "1"
              },
              {
                "id": "2",
                "text": "2"
              },
              {
                "id": "3",
                "text": "3"
              }
            ],
            "is_starting_question": true,
            "question_description": null
          },
          {
            "question_id": "PAIN_RELIEVED_BY_ACTIVITY",
            "question_text": "Do you agree with the following statement?",
            "question_type": "multiple_choice",
            "question_options": [
              {
                "id": "yes",
                "text": "Yes"
              },
              {
                "id": "no",
                "text": "No"
              }
            ],
            "is_starting_question": true,
            "question_description": null
          }
        ]
      },
      "need_help_popup": false,
      "notes": ""
    };
  }
}
