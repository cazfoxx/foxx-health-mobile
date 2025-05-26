import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/assessment_results_screen.dart';

class PreppingAssessmentScreen extends StatefulWidget {


  const PreppingAssessmentScreen({
    Key? key,

  }) : super(key: key);

  @override
  State<PreppingAssessmentScreen> createState() =>
      _PreppingAssessmentScreenState();
}

class _PreppingAssessmentScreenState extends State<PreppingAssessmentScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToResults();
  }

  Future<void> _navigateToResults() async {
    final healthAssessmentCubit = context.read<HealthAssessmentCubit>();
    healthAssessmentCubit.submitHealthAssessment();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AssessmentResultsScreen(

          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create a Health Assessment',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: AppTextStyles.body.copyWith(
                color: AppColors.amethystViolet,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.lightViolet,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Prepping your\nassessment...',
              textAlign: TextAlign.center,
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.amethystViolet,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'While we generate your personalized health checklist, know that your privacy is our top priority.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyOpenSans.copyWith(),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'FoXX Health is HIPAA compliant, and every piece of information you share is protected and securely handled. You\'re in safe hands.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyOpenSans.copyWith(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
