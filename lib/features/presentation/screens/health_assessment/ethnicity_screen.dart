import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/heath_assesment_appointment_screen.dart.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class EthnicityScreen extends StatefulWidget {
  const EthnicityScreen({Key? key}) : super(key: key);

  @override
  State<EthnicityScreen> createState() => _EthnicityScreenState();
}

class _EthnicityScreenState extends State<EthnicityScreen> {
  final List<String> ethnicities = [
    'Indigenous or Alaska Native',
    'Black or African American',
    'East & South East Asian',
    'Native Hawaiian or Pacific Islander',
    'South Asian',
    'Latino/ Hispanic',
    'Middle Eastern/ North African',
    'White or European American',
    'Prefer not to answer',
  ];

  Set<String> selectedEthnicities = {};

  void _setEthnicities(BuildContext context) {
    final healthCubit = context.read<HealthAssessmentCubit>();
    healthCubit.setEthnicities(selectedEthnicities.toList());
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'What is your ethnicity?',
      subtitle:
          'Some health conditions can show up more often in certain communities. Sharing this helps us offer better, more personalized support. It\'s totally up to you, and your info stays private.',
      progress: 0.4,
      onNext: () {
        _setEthnicities(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HealthAssessmentAppointTypeScreen()));
      },
      isNextEnabled: true,
      body: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: ethnicities.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: CheckboxListTile(
              value: selectedEthnicities.contains(ethnicities[index]),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedEthnicities.add(ethnicities[index]);
                  } else {
                    selectedEthnicities.remove(ethnicities[index]);
                  }
                });
              },
              title: Text(
                ethnicities[index],
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
