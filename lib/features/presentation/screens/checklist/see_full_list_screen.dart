import 'package:flutter/material.dart';
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
  final List<String> _allQuestions = [
    'How often should I schedule checkups?',
    'What screenings should I be getting based on my age and family history?',
    'Am I up-to-date on my immunizations?',
    'Should I be taking supplements?',
    'Do I need any vaccinations?',
    'Are there any specific lifestyle changes I should make?',
  ];

  @override
  void initState() {
    super.initState();
    _selectedQuestions = List.from(widget.selectedQuestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _allQuestions.length,
              itemBuilder: (context, index) {
                final question = _allQuestions[index];
                final isSelected = _selectedQuestions.contains(question);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question,
                          style: AppTextStyles.body,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedQuestions.remove(question);
                            } else {
                              _selectedQuestions.add(question);
                            }
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isSelected ? AppColors.amethystViolet : Colors.grey,
                              width: 2,
                            ),
                            color: isSelected ? AppColors.amethystViolet : Colors.white,
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
    );
  }
}