import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/core/utils/save_health_assessment.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessement_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/health_concerns_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class PreExistingConditionsScreen extends StatefulWidget {
  const PreExistingConditionsScreen({Key? key}) : super(key: key);

  @override
  State<PreExistingConditionsScreen> createState() =>
      _PreExistingConditionsScreenState();
}

class _PreExistingConditionsScreenState
    extends State<PreExistingConditionsScreen> {
  final TextEditingController _conditionController = TextEditingController();
  final _analytics = AnalyticsService();

  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'PreExistingConditionsScreen',
      screenClass: 'PreExistingConditionsScreen',
    );
  }

  @override
  void initState() {
    super.initState();
    _logScreenView();
  }

  void _setPreExistingConditions(BuildContext context) {
    final healthCubit = context.read<HealthAssessmentCubit>();
    healthCubit.setPreExistingConditionText(_conditionController.text);
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      onSave: () {
        SaveHealthAssessment.saveAssessment(context, HealthAssessmentScreen.preExistingConditions);
      },
      title: 'Do you have any pre-existing conditions?',
      subtitle:
          'Help us tailor your checklists and insights based on your full health picture',
      progress: 0.2,
      onNext: () {
        _setPreExistingConditions(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HealthConcernsScreen(),
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
              controller: _conditionController,
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
    _conditionController.dispose();
    super.dispose();
  }
}
