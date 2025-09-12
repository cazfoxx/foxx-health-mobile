import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';

class HealthProfileQuestionsScreen extends StatefulWidget {
  const HealthProfileQuestionsScreen({super.key});

  @override
  State<HealthProfileQuestionsScreen> createState() => _HealthProfileQuestionsScreenState();
}

class _HealthProfileQuestionsScreenState extends State<HealthProfileQuestionsScreen> {
  String selectedFilter = 'All questions';
  String selectedSort = 'Newest';
  
  late SymptomSearchCubit _symptomCubit;
  List<Map<String, dynamic>> questions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _symptomCubit = SymptomSearchCubit();
    _loadQuestions();
  }

  @override
  void dispose() {
    _symptomCubit.close();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final questionsData = await _symptomCubit.getHealthProfileQuestions();
      if (questionsData.isNotEmpty) {
        setState(() {
          questions = questionsData.map((question) => {
            'question': question['question_text'] ?? '',
            'answer': '---', // Default to unanswered
            'isAnswered': false, // Default to unanswered
            'id': question['id'] ?? '',
            'data_usage': question['data_usage'] ?? [],
            'answers': question['answers'] ?? {},
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load questions';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading questions: $e';
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredQuestions {
    List<Map<String, dynamic>> filtered = questions;
    
    if (selectedFilter == 'Unanswered questions') {
      filtered = questions.where((q) => !q['isAnswered']).toList();
    } else if (selectedFilter == 'Answered questions') {
      filtered = questions.where((q) => q['isAnswered']).toList();
    }
    
    // Sort questions
    if (selectedSort == 'Oldest') {
      filtered = filtered.reversed.toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary01),
          ),
          title: const Text(
            'Health Profile Questions',
            style: AppTextStyles.heading3,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showFilterSortModal();
              },
              icon: const Icon(Icons.filter_list, color: AppColors.primary01),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    
                    // Title
                    const Text(
                      'Health Profile Questions',
                      style: AppTextStyles.heading3,
                    ),
                  ],
                ),
              ),
              
              // Questions List
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.amethyst),
                        ),
                      )
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _error!,
                                  style: AppOSTextStyles.osMd.copyWith(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _loadQuestions,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : filteredQuestions.isEmpty
                            ? const Center(
                                child: Text(
                                  'No questions available',
                                  style: AppOSTextStyles.osMd,
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                itemCount: filteredQuestions.length,
                                itemBuilder: (context, index) {
                                  final question = filteredQuestions[index];
                                  return _buildQuestionCard(question);
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    final dataUsage = question['data_usage'] as List<dynamic>? ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.28),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppColors.gray200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question['question'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary01,
                    height: 1.3,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.amethyst,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question['answer'],
            style: TextStyle(
              fontSize: 12,
              color: question['isAnswered'] ? AppColors.gray600 : AppColors.gray400,
              fontStyle: question['isAnswered'] ? FontStyle.normal : FontStyle.italic,
            ),
          ),
          if (dataUsage.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: dataUsage.map((usage) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.amethyst.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.amethyst.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                                  child: Text(
                    usage.toString(),
                    style: AppOSTextStyles.osMd.copyWith(
                      color: AppColors.amethyst,
                      fontSize: 10,
                    ),
                  ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilterSortModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterSortModal(
        selectedFilter: selectedFilter,
        selectedSort: selectedSort,
        onFilterChanged: (filter) {
          setState(() {
            selectedFilter = filter;
          });
        },
        onSortChanged: (sort) {
          setState(() {
            selectedSort = sort;
          });
        },
      ),
    );
  }
}

class _FilterSortModal extends StatefulWidget {
  final String selectedFilter;
  final String selectedSort;
  final Function(String) onFilterChanged;
  final Function(String) onSortChanged;

  const _FilterSortModal({
    required this.selectedFilter,
    required this.selectedSort,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  @override
  State<_FilterSortModal> createState() => _FilterSortModalState();
}

class _FilterSortModalState extends State<_FilterSortModal> {
  late String selectedFilter;
  late String selectedSort;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter;
    selectedSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 20),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Filter by section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.filter_list, color: AppColors.gray600, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Filter by',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildFilterOption('All questions'),
                _buildDivider(),
                _buildFilterOption('Unanswered questions'),
                _buildDivider(),
                _buildFilterOption('Answered questions'),
                
                const SizedBox(height: 24),
                
                // Sort by section
                Row(
                  children: [
                    const Icon(Icons.sort, color: AppColors.gray600, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildSortOption('Newest'),
                _buildDivider(),
                _buildSortOption('Oldest'),
                
                const SizedBox(height: 24),
                
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onFilterChanged(selectedFilter);
                          widget.onSortChanged(selectedSort);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.amethyst,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.amethyst,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String option) {
    final isSelected = selectedFilter == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = option;
        });
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              option,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? AppColors.amethyst : AppColors.gray600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                decoration: isSelected ? TextDecoration.underline : null,
              ),
            ),
          ),
          if (isSelected)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.amethyst,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSortOption(String option) {
    final isSelected = selectedSort == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSort = option;
        });
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              option,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? AppColors.amethyst : AppColors.gray600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (isSelected)
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.amethyst,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 14,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      color: AppColors.gray200,
    );
  }
}

