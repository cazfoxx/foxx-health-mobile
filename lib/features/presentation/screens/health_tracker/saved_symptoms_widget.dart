import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class SavedSymptomsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> savedSymptoms;
  final VoidCallback? onEdit;

  const SavedSymptomsWidget({
    Key? key,
    required this.savedSymptoms,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (savedSymptoms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.mauve50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saved Symptoms',
                style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                  color: AppColors.primary01,
                ),
              ),
              if (onEdit != null)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.amethyst.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.amethyst),
                    ),
                    child: Text(
                      'Edit',
                      style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                        color: AppColors.amethyst,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Symptoms List
          ...savedSymptoms.map((symptomDetail) {
            final symptom = symptomDetail['symptom'] as Map<String, dynamic>;
            final symptomName = symptom['info']?['name'] as String? ?? 'Unknown Symptom';
            final answers = symptomDetail['answers'] as Map<String, String>? ?? <String, String>{};
            final notes = symptomDetail['notes'] as String? ?? '';
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.mauve50.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.mauve50),
              ),
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
                  const SizedBox(height: 12),
                  
                  // Dynamic Details based on API response
                  ...answers.entries.map((entry) {
                    final questionId = entry.key;
                    final answer = entry.value;
                    
                    if (answer.isEmpty) return const SizedBox.shrink();
                    
                    // Map question IDs to readable labels
                    String label = _getQuestionLabel(questionId);
                    String value = _getAnswerValue(questionId, answer);
                    
                    return _buildDetailRow(label, value);
                  }).toList(),
                  
                  if (notes.isNotEmpty)
                    _buildDetailRow('Notes', notes),
                ],
              ),
            );
          }).toList(),
          
          // Summary
          if (savedSymptoms.length > 1) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.amethyst.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.amethyst.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.amethyst,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${savedSymptoms.length} symptoms tracked with detailed information',
                      style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                        color: AppColors.amethyst,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                color: AppColors.davysGray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                color: AppColors.primary01,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSeverityText(int severity) {
    switch (severity) {
      case 0:
        return 'None';
      case 1:
        return 'Mild';
      case 2:
        return 'Moderate';
      case 3:
        return 'Severe';
      case 4:
        return 'Debilitating';
      default:
        return 'Unknown';
    }
  }

  String _getFrequencyText(int frequency) {
    switch (frequency) {
      case 0:
        return 'Never';
      case 1:
        return 'Rarely';
      case 2:
        return 'Sometimes';
      case 3:
        return 'Constant';
      default:
        return 'Unknown';
    }
  }

  String _getOnsetText(String onset) {
    switch (onset) {
      case 'sudden':
        return 'Sudden';
      case 'gradual':
        return 'Gradual';
      case 'not_sure':
        return 'Not sure';
      default:
        return onset;
    }
  }

  // Helper methods for dynamic question handling
  String _getQuestionLabel(String questionId) {
    switch (questionId) {
      case 'SEVERITY':
        return 'Severity';
      case 'FREQUENCY':
        return 'Frequency';
      case 'ONSET':
        return 'Onset';
      case 'DURATION':
        return 'Duration';
      case 'TRIGGERS':
        return 'Triggers';
      case 'RELIEF':
        return 'What helps';
      case 'PAIN_RELIEVED_BY_ACTIVITY':
        return 'Pain relieved by activity';
      default:
        // Try to make it more readable
        return questionId.replaceAll('_', ' ').toLowerCase().split(' ').map((word) => 
          word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : ''
        ).join(' ');
    }
  }

  String _getAnswerValue(String questionId, String answer) {
    if (questionId == 'SEVERITY') {
      return _getSeverityText(int.tryParse(answer) ?? 0);
    } else if (questionId == 'FREQUENCY') {
      return _getFrequencyText(int.tryParse(answer) ?? 0);
    } else if (questionId == 'ONSET') {
      return _getOnsetText(answer);
    } else {
      return answer;
    }
  }
}
