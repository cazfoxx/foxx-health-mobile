import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class MedicalTermsWidget extends StatelessWidget {
  final List<String> terms;
  final Function(int) onAddNote;
  final Map<String, String> questionNotes;
  final TextEditingController noteController;
  final int? selectedQuestionIndex;
  final bool isAddingNote;
  final String selectedSection;
  final Function() onAddTerm;
  final TextEditingController termController;

  const MedicalTermsWidget({
    Key? key,
    required this.terms,
    required this.onAddNote,
    required this.questionNotes,
    required this.noteController,
    this.selectedQuestionIndex,
    required this.isAddingNote,
    required this.selectedSection,
    required this.onAddTerm,
    required this.termController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Medical Term Explainer',
                style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.amethystViolet)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: terms.length,
              itemBuilder: (context, index) {
                final term = terms[index];
                final hasNote = questionNotes.containsKey('medical_$index');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(term,
                              style: AppTextStyles.body2OpenSans),
                        ),
                        IconButton(
                          icon: const Icon(Icons.note_add),
                          onPressed: () => onAddNote(index),
                        ),
                      ],
                    ),
                    if (hasNote)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 8),
                        child: Text(
                          questionNotes['medical_$index']!,
                          style: AppTextStyles.body2OpenSans.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    if (selectedQuestionIndex == index &&
                        isAddingNote &&
                        selectedSection == 'medical')
                      _buildNoteTextField(),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: termController,
              decoration: InputDecoration(
                hintText: 'Add a medical term',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onAddTerm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: noteController,
        decoration: InputDecoration(
          hintText: 'Add a note',
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}