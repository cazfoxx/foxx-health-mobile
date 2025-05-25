import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class SymptomBottomSheet extends StatefulWidget {
  final String title;
  final List<Category> categories;

  const SymptomBottomSheet({
    Key? key,
    required this.title,
    required this.categories,
  }) : super(key: key);

  static Future<void> show(
      BuildContext context, String title, List<Category> categories) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        height: MediaQuery.of(context).size.height * 0.9,
        child: SymptomBottomSheet(
          title: title,
          categories: categories,
        ),
      ),
    );
  }

  @override
  State<SymptomBottomSheet> createState() => _SymptomBottomSheetState();
}

class _SymptomBottomSheetState extends State<SymptomBottomSheet> {
  int? expandedSymptomIndex;
  Set<String> expandedCategories = {};

  void _updateSymptomTracker() {
    final selectedSymptoms = widget.categories.expand((category) {
      return category.symptoms
          .where((symptom) => symptom.isSelected && symptom.severity != null)
          .map((symptom) {
        return SymptomId(
          symptomName: symptom.name,
          symptomType: widget.title,
          symptomCategory:
              category.title, // Now we have access to category.title
          severity: symptom.severity!.toLowerCase(),
        );
      });
    }).toList();

    if (selectedSymptoms.isNotEmpty) {
      final cubit = context.read<SymptomTrackerCubit>();
      cubit.setSymptomIds(selectedSymptoms);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    CupertinoIcons.xmark,
                    color: AppColors.amethystViolet,
                  )),
              Text(
                widget.title,
                style: AppTextStyles.heading3,
              ),
              TextButton(
                  onPressed: () {
                    _updateSymptomTracker();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Save',
                    style: AppTextStyles.body2OpenSans.copyWith(
                      color: AppColors.amethystViolet,
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: widget.categories.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, categoryIndex) {
              final category = widget.categories[categoryIndex];
              final isExpanded = expandedCategories.contains(category.title);
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        category.title,
                        style: AppTextStyles.bodyOpenSans
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      trailing: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.amethystViolet,
                        child: Icon(
                          isExpanded
                              ? CupertinoIcons.chevron_up
                              : CupertinoIcons.chevron_down,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                      collapsedBackgroundColor: AppColors.background,
                      backgroundColor: AppColors.background,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      onExpansionChanged: (expanded) {
                        setState(() {
                          if (expanded) {
                            expandedCategories.add(category.title);
                          } else {
                            expandedCategories.remove(category.title);
                          }
                        });
                      },
                      children: category.symptoms.asMap().entries.map((entry) {
                        final index = entry.key;
                        final symptom = entry.value;
                        final isSymptomExpanded = expandedSymptomIndex ==
                            index; // Remove the && isExpanded condition
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Checkbox(
                                  value: symptom.isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      symptom.isSelected = value ?? false;
                                      if (value == true) {
                                        expandedSymptomIndex = index;
                                      } else {
                                        expandedSymptomIndex = null;
                                        symptom.severity = null;
                                      }
                                    });
                                  },
                                ),
                                title: Text(symptom.name),
                              ),
                              if (symptom
                                  .isSelected) // Only check if symptom is selected
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      _buildSeverityOption('Mild', true,
                                          symptom, AppColors.sunglow),
                                      // const SizedBox(width: 8),
                                      _buildSeverityOption('Moderate', null,
                                          symptom, Colors.orange),
                                      // const SizedBox(width: 8),
                                      _buildSeverityOption(
                                          'Severe', false, symptom, Colors.red),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityOption(
      String label, bool? isleft, SymptomItem symptom, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            symptom.severity = label;
            _updateSymptomTracker();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: isleft == null
                  ? null
                  : isleft!
                      ? BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(9))
                      : BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(9))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  label,
                  style: AppTextStyles.body2OpenSans,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: color.withOpacity(symptom.severity == label ? 1 : 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Category {
  final String title;
  final List<SymptomItem> symptoms;

  Category({
    required this.title,
    required this.symptoms,
  });
}

class SymptomItem {
  final String name;
  bool isSelected;
  String? severity;

  SymptomItem({
    required this.name,
    this.isSelected = false,
    this.severity,
  });
}
