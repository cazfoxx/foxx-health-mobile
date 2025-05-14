import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class PrescriptionsWidget extends StatelessWidget {
  final List<String> prescriptions;
  final Function(int) onAddNote;
  final Map<String, String> questionNotes;
  final TextEditingController noteController;
  final int? selectedQuestionIndex;
  final bool isAddingNote;
  final String selectedSection;
  final Function() onAddPrescription;
  final TextEditingController prescriptionController;

  const PrescriptionsWidget({
    Key? key,
    required this.prescriptions,
    required this.onAddNote,
    required this.questionNotes,
    required this.noteController,
    this.selectedQuestionIndex,
    required this.isAddingNote,
    required this.selectedSection,
    required this.onAddPrescription,
    required this.prescriptionController,
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
            Text('Prescriptions & Supplements',
                style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.amethystViolet)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prescriptions.length,
              itemBuilder: (context, index) {
                final prescription = prescriptions[index];
                final hasNote = questionNotes.containsKey('prescriptions_$index');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(prescription,
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
                          questionNotes['prescriptions_$index']!,
                          style: AppTextStyles.body2OpenSans.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    if (selectedQuestionIndex == index &&
                        isAddingNote &&
                        selectedSection == 'prescriptions')
                      _buildNoteTextField(),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: prescriptionController,
              decoration: InputDecoration(
                hintText: 'Add a prescription or supplement',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onAddPrescription,
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