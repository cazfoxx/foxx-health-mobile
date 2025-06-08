import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class SeeFullListScreen extends StatefulWidget {
  final List<String> selectedQuestions;
  final Function(List<String>) onUpdate;

  const SeeFullListScreen({
    Key? key,
    required this.selectedQuestions,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<SeeFullListScreen> createState() => _SeeFullListScreenState();
}

class _SeeFullListScreenState extends State<SeeFullListScreen> {
  late List<String> _selectedQuestions;
  List<Map<String, dynamic>> _curatedQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedQuestions = List.from(widget.selectedQuestions);
    _fetchCuratedQuestions();
  }

  Future<void> _fetchCuratedQuestions() async {
    final checklistCubit = context.read<ChecklistCubit>();
    final questions = await checklistCubit.getCuratedQuestions();
    setState(() {
      _curatedQuestions = questions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Suggested Questions',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _curatedQuestions.length,
                      itemBuilder: (context, index) {
                        final question = _curatedQuestions[index];
                        final questionText = question['text'] as String;
                        final isSelected = _selectedQuestions.contains(questionText);
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  questionText,
                                  style: AppTextStyles.body,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedQuestions.remove(questionText);
                                    } else {
                                      _selectedQuestions.add(questionText);
                                    }
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.amethystViolet
                                          : Colors.grey,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? AppColors.amethystViolet
                                        : Colors.white,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Get the IDs of selected questions
                    final selectedIds = _curatedQuestions
                        .where((q) => _selectedQuestions.contains(q['text']))
                        .map((q) => q['id'] as int)
                        .toList();

                    // Update both texts and IDs in the cubit
                    context.read<ChecklistCubit>().updateCuratedQuestions(
                          _selectedQuestions,
                          selectedIds,
                        );

                    widget.onUpdate(_selectedQuestions);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amethystViolet,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
