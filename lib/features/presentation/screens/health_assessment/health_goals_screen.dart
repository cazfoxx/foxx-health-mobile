import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/save_health_assessment.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessement_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/household_income_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class HealthGoalsScreen extends StatefulWidget {
  const HealthGoalsScreen({Key? key}) : super(key: key);

  @override
  State<HealthGoalsScreen> createState() => _HealthGoalsScreenState();
}

class _HealthGoalsScreenState extends State<HealthGoalsScreen> {
  final TextEditingController _goalsController = TextEditingController();

  void _setHealthGoals(BuildContext context) {
    final healthCubit = context.read<HealthAssessmentCubit>();
    healthCubit.setSpecificHealthGoals(_goalsController.text);
  }

  @override
  void dispose() {
    _goalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      onSave: () {
        SaveHealthAssessment.saveAssessment(context, HealthAssessmentScreen.healthGoals);
      },
      title: 'Do you have any specific health goals?',
      subtitle:
          'We can personalize your experience and help you track real progress.',
      progress: 0.6,
      onNext: () {
        _setHealthGoals(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HouseholdIncomeScreen(),
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
            Text('Tips: How to get more from your health guide',
                style: AppTextStyles.bodyOpenSans
                    .copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 5),
            Text('Enter information such as wanting to improve cardiovascular fitness, or improve your immune system.',
                style: AppTextStyles.body2OpenSans),
            TextField(
              decoration: InputDecoration(
                hintText: 'Type here',
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
              maxLines: 9,
            ),
          ],
        ),
      ),
    );
  }
}
