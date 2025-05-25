import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/base_checklist_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/pescription_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class AddNotesScreen extends StatefulWidget {
  final String appointmentType;
  final List<String> selectedQuestions;

  const AddNotesScreen({
    super.key,
    required this.appointmentType,
    required this.selectedQuestions,
  });

  @override
  State<AddNotesScreen> createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  final _noteController = TextEditingController();
  final List<String> _additionalNotes = [];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() {
    if (_noteController.text.trim().isNotEmpty) {
      setState(() {
        _additionalNotes.add(_noteController.text.trim());
        _noteController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseChecklistScreen(
      title: 'Add Your Own Notes',
      subtitle:
          'Feel more confident and in control by jotting down what matters most to you',
      progress: 0.5,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.lightViolet.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(_additionalNotes.length + 4, (index) {
                        final note = index < _additionalNotes.length
                            ? _additionalNotes[index]
                            : '';

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Question',
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: note.isNotEmpty
                                              ? TextEditingController(text: note)
                                              : null,
                                          decoration: InputDecoration(
                                            hintText: 'Value',
                                            border: InputBorder.none,
                                            hintStyle: AppTextStyles.body.copyWith(
                                              color: Colors.grey,
                                            ),
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          onSubmitted: (value) {
                                            if (value.trim().isNotEmpty) {
                                              setState(() {
                                                if (index <
                                                    _additionalNotes.length) {
                                                  _additionalNotes[index] = value;
                                                } else {
                                                  _additionalNotes.add(value);
                                                }
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      if (note.isNotEmpty)
                                        IconButton(
                                          icon: CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.grey[200],
                                            child: const Icon(Icons.close,
                                                size: 14, color: Colors.grey),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _additionalNotes.removeAt(index);
                                            });
                                          },
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (index < _additionalNotes.length + 3)
                              Divider(
                                  thickness: 1,
                                  color: Colors.grey.withOpacity(0.2)),
                          ],
                        );
                      }),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _additionalNotes.add('');
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Add',
                                style: AppTextStyles.body.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: OnboardingButton(
              text: 'Next',
              onPressed: () {
                
                final checklistCubit = context.read<ChecklistCubit>();
                 FocusScope.of(context).unfocus();
                checklistCubit.setCustomQuestion(_additionalNotes);
                

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
