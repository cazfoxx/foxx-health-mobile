import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/symptom_tracker_health_assessment_screen.dart.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class AreaOfConcernScreen extends StatefulWidget {
  const AreaOfConcernScreen({Key? key}) : super(key: key);

  @override
  State<AreaOfConcernScreen> createState() => _AreaOfConcernScreenState();
}

class _AreaOfConcernScreenState extends State<AreaOfConcernScreen> {
  final Set<String> selectedAreas = {};

  final List<String> areas = [
    'Head & neck',
    'Arms',
    'Chest area',
    'Stomach area',
    'Pelvic',
    'Legs',
  ];

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Area of concern',
      subtitle:
          'Choose the body part, system, or area you want to focus on so we can personalize your health assessment.',
      progress: 1.0,
      onNext: () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  const SymptomTrackerHealthAssessmentScreen()),
          (route) => false,
        );
      },
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: areas.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CheckboxListTile(
              value: selectedAreas.contains(areas[index]),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedAreas.add(areas[index]);
                  } else {
                    selectedAreas.remove(areas[index]);
                  }
                });
              },
              title: Text(
                areas[index],
                style: AppTextStyles.bodyOpenSans,
              ),
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Theme.of(context).primaryColor,
              checkboxShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        },
      ),
    );
  }
}
