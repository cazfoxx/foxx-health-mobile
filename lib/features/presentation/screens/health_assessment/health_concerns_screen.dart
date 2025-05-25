import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/health_goals_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class HealthConcernsScreen extends StatefulWidget {
  const HealthConcernsScreen({Key? key}) : super(key: key);

  @override
  State<HealthConcernsScreen> createState() => _HealthConcernsScreenState();
}

class _HealthConcernsScreenState extends State<HealthConcernsScreen> {
  final TextEditingController _concernController = TextEditingController();

  void _setHealthConcerns(BuildContext context) {
    final healthCubit = context.read<HealthAssessmentCubit>();
    healthCubit.setSpecificHealthConcerns(_concernController.text);
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Do you have any specific health concerns?',
      subtitle:
          'Knowing your family history helps us suggest the right preventive steps for you.',
      progress: 0.4,
      onNext: () {
        _setHealthConcerns(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HealthGoalsScreen(),
        ));
      },
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(10.0),
        height: 420,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0),
              blurRadius: 13.0,
              spreadRadius: 6.0,
              color: Colors.black.withOpacity(0.09),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tips: How to get better assessment',
                style: AppTextStyles.bodyOpenSans
                    .copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            Text('Enter any pre- existing conditions or diagnoses below',
                style: AppTextStyles.body2OpenSans),
            SizedBox(height: 10),
            TextField(
              controller: _concernController, // Added controller here
              decoration: InputDecoration(
                hintText: 'Enter "None" if you have no pre-existing condition',
                hintStyle: AppTextStyles.body.copyWith(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _concernController.dispose();
    super.dispose();
  }
}
