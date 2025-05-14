import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/prepping_assessment_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class SymptomTrackerHealthAssessmentScreen extends StatefulWidget {
  const SymptomTrackerHealthAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<SymptomTrackerHealthAssessmentScreen> createState() =>
      _SymptomTrackerHealthAssessmentScreenState();
}

class _SymptomTrackerHealthAssessmentScreenState
    extends State<SymptomTrackerHealthAssessmentScreen> {
  final _searchController = TextEditingController();
  final Set<String> selectedSymptoms = {};
  List<String> filteredSymptoms = [];

  final List<String> symptoms = [
    'Brain fog',
    'Changes in eating habits',
    'Difficulty completing tasks',
    'Sharp pain - Chest & upper back',
    'Tingling or numbness - Legs & feet',
    'Symptom'
  ];

  @override
  void initState() {
    super.initState();
    filteredSymptoms = List.from(symptoms);
  }

  void _filterSymptoms(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSymptoms = List.from(symptoms);
      } else {
        filteredSymptoms = symptoms
            .where((symptom) =>
                symptom.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showSymptomSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(CupertinoIcons.xmark),
                        ),
                        Text(
                          'Symptoms',
                          style: AppTextStyles.bodyOpenSans.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Create',
                            style: AppTextStyles.bodyOpenSans.copyWith(
                              color: AppColors.amethystViolet,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: AppColors.lightViolet,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _filterSymptoms('');
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filterSymptoms(value);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredSymptoms.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedSymptoms
                              .contains(filteredSymptoms[index])) {
                            selectedSymptoms.remove(filteredSymptoms[index]);
                          } else {
                            selectedSymptoms.add(filteredSymptoms[index]);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Text(
                          filteredSymptoms[index],
                          style: AppTextStyles.bodyOpenSans,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Symptom Tracker',
      subtitle:
          'Select which symptoms you\'d like to feed into the health assessment',
      progress: 0.8,
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreppingAssessmentScreen(
              selectedSymptoms: selectedSymptoms.toList(),
            ),
          ),
        );
      },
      isNextEnabled: selectedSymptoms.isNotEmpty,
      body: GestureDetector(
        onTap: _showSymptomSelector,
        child: Container(
          padding: const EdgeInsets.all(13),
          margin: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select symptoms from the tracker',
                style: AppTextStyles.bodyOpenSans.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              if (selectedSymptoms.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedSymptoms
                      .map(
                        (symptom) => Chip(
                          label: Text(symptom),
                          onDeleted: () {
                            setState(() {
                              selectedSymptoms.remove(symptom);
                            });
                          },
                          backgroundColor: AppColors.optionBG,
                          deleteIconColor: AppColors.amethystViolet,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                readOnly: true,
                onTap: _showSymptomSelector,
                decoration: InputDecoration(
                  hintText: 'Enter',
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
