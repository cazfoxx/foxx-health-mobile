import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class HealthDetailsSheet extends StatefulWidget {
  final String existingCondition;
  final String healthGoals;
  final String healthConcerns;
  final String currentIncome;

  const HealthDetailsSheet({
    Key? key,
    required this.existingCondition,
    required this.healthGoals,
    required this.healthConcerns,
    required this.currentIncome,
  }) : super(key: key);

  @override
  State<HealthDetailsSheet> createState() => _HealthDetailsSheetState();
}

class _HealthDetailsSheetState extends State<HealthDetailsSheet> {
  late TextEditingController _conditionController;
  late TextEditingController _goalsController;
  late TextEditingController _concernsController;
  String _selectedIncome = '';
  bool _isIncomeExpanded = false;

  final List<String> incomeRanges = [
    'Under \$25,000',
    '\$25,000 - \$50,000',
    '\$50,001 - \$75,000',
    '\$75,001 - \$100,000',
    '\$100,001+',
    'Prefer not to answer'
  ];

  @override
  void initState() {
    super.initState();
    _conditionController =
        TextEditingController(text: widget.existingCondition);
    _goalsController = TextEditingController(text: widget.healthGoals);
    _concernsController = TextEditingController(text: widget.healthConcerns);
    _selectedIncome = widget.currentIncome;
  }

  @override
  void dispose() {
    _conditionController.dispose();
    _goalsController.dispose();
    _concernsController.dispose();
    super.dispose();
  }

  void _updateHealthDetails() {
    final cubit = context.read<HealthAssessmentCubit>();

    if (_conditionController.text.isNotEmpty && _selectedIncome.isNotEmpty) {
      context.read<HealthAssessmentCubit>().updateHealthAssessment();
      cubit.setPreExistingConditionText(_conditionController.text);
      cubit.setSpecificHealthGoals(_goalsController.text);
      cubit.setSpecificHealthConcerns(_concernsController.text);
      cubit.setIncomeRange(_selectedIncome);
      Navigator.pop(context);
      SnackbarUtils.showSuccess(
          context: context, title: 'Success!', message: 'Information updated');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Health Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _conditionController,
                    decoration: const InputDecoration(
                      labelText: 'Existing Conditions *',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _goalsController,
                    decoration: const InputDecoration(
                      labelText: 'Health Goals',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _concernsController,
                    decoration: const InputDecoration(
                      labelText: 'Health Concerns',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ExpansionTile(
                    title: Text(
                      'Income Range *',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    initiallyExpanded: _isIncomeExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _isIncomeExpanded = expanded;
                      });
                    },
                    children: incomeRanges
                        .map((income) => RadioListTile(
                              title: Text(income),
                              value: income,
                              groupValue: _selectedIncome,
                              onChanged: (value) {
                                setState(() {
                                  _selectedIncome = value.toString();
                                });
                              },
                              activeColor: AppColors.amethystViolet,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _updateHealthDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.amethystViolet,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Update'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
