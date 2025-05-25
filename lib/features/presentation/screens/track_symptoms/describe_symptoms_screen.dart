import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/review_symptoms_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DescribeSymptomsScreen extends StatefulWidget {
  const DescribeSymptomsScreen({Key? key}) : super(key: key);

  @override
  State<DescribeSymptomsScreen> createState() => _DescribeSymptomsScreenState();
}

class _DescribeSymptomsScreenState extends State<DescribeSymptomsScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Describe Your Symptoms',
      appbarTitle: 'Track Symptoms',
      subtitle:
          'Take time to think this through. Accuracy will help you better represent yourself.',
      progress: 1.0,
      onSave: () {},
      onNext: () async {
        final cubit = context.read<SymptomTrackerCubit>();
        cubit.setSymptomDescription(_descriptionController.text.trim());
        cubit.loggerall();

        // Call the create symptom tracker API
        // await cubit.createSymptomTracker();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewSymptomsScreen(
                descriptions: _descriptionController.text.trim()),
          ),
        );
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Think about the type of pain, the severity, and it\'s impact on your quality of life (Optional)',
                    style: AppTextStyles.body2OpenSans,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 12,
                    decoration: InputDecoration(
                      hintText: 'Type here',
                      hintStyle: AppTextStyles.body2OpenSans.copyWith(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.grey.shade200,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.amethystViolet,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
