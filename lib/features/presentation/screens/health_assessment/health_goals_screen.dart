import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    _goalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Do you have any specific health goals?',
      subtitle:
          'We can personalize your experience and help you track real progress.',
      progress: 0.6,
      onNext: () {
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
            Text('Tips: How to get better assessment',
                style: AppTextStyles.bodyOpenSans
                    .copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 10),
            Text('Enter any pre- existing conditions or diagnoses below',
                style: AppTextStyles.body2OpenSans),
            SizedBox(height: 10),
            Container(
              height: 300,
              padding: EdgeInsets.all(10),
              child: TextField(
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
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
