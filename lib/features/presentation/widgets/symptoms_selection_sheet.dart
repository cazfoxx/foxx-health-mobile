import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class SymptomsSelectionSheet extends StatefulWidget {
  final Function(SymptomId) onSymptomSelected;

  const SymptomsSelectionSheet({
    Key? key,
    required this.onSymptomSelected,
  }) : super(key: key);

  @override
  State<SymptomsSelectionSheet> createState() => _SymptomsSelectionSheetState();
}

class _SymptomsSelectionSheetState extends State<SymptomsSelectionSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<SymptomId> _filteredSymptoms = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSymptoms);
    
    // Initialize symptoms list
    _filteredSymptoms = [
      SymptomId(
        symptomName: 'Brain fog',
        symptomCategory: 'Cognitive',
        severity: 'mild',
      ),
      SymptomId(
        symptomName: 'Changes in eating habits',
        symptomCategory: 'Behavioral',
        severity: 'mild',
      ),
      SymptomId(
        symptomName: 'Difficulty completing tasks',
        symptomCategory: 'Cognitive',
        severity: 'moderate',
      ),
      SymptomId(
        symptomName: 'Sharp Pain',
        symptomCategory: 'Chest & Upper Back',
        severity: 'moderate',
      ),
      SymptomId(
        symptomName: 'Tingling or numbness',
        symptomCategory: 'Legs & feet',
        severity: 'mild',
      ),
    ];
  }

  void _filterSymptoms() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSymptoms = _filteredSymptoms
          .where((symptom) => 
              symptom.symptomName.toLowerCase().contains(query) ||
              symptom.symptomCategory.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymptomTrackerCubit, SymptomTrackerState>(
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Symptoms',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle create action
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(color: AppColors.amethystViolet),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                color: AppColors.lightViolet,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _filteredSymptoms.length,
                  itemBuilder: (context, index) {
                    final symptom = _filteredSymptoms[index];
                    return ListTile(
                      title: Text(symptom.symptomName),
                      subtitle: Text('${symptom.symptomCategory} - ${symptom.severity}'),
                      onTap: () => widget.onSymptomSelected(symptom),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}