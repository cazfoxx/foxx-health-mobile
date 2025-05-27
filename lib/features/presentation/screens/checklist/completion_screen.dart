import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/checklist_details_screen.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class CompletionScreen extends StatelessWidget {
  const CompletionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create a Check List'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: AppTextStyles.body.copyWith(
                color: AppColors.amethystViolet,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.amethystViolet.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Here to support, not diagnose',
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.amethystViolet,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We\'re here to help you feel informed and prepared, but medical decisions should always be made with your healthcare provider.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              OnboardingButton(
                text: 'Next',
                onPressed: () {
                  final checklistCubit = context.read<ChecklistCubit>();
                  // Log all data before API call
                  checklistCubit.logalldata();
                  // Call the API
                  checklistCubit.createChecklist();
                },
              ),
              BlocListener<ChecklistCubit, ChecklistState>(
                listener: (context, state) {
                  if (state is ChecklistCreated) {
                    // Navigate to next screen only on success
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChecklistDetailsScreen(),
                      ),
                      (route) => false,
                    );
                  } else if (state is ChecklistError) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
