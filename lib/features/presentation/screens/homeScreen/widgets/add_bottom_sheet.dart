import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class AddBottomSheet extends StatelessWidget {
  const AddBottomSheet({super.key});

  Widget _buildActionItem({
  required Widget icon,
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        icon,
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Icon(
          Icons.add_circle,
          color: AppColors.amethystViolet,
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: AppColors.amethystViolet.withOpacity(0.8),
                ),
              ),
              Positioned(
                top: 35,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50), // avoid close button overlap
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  builder: (_, controller) => Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildActionItem(
                            icon: SvgPicture.asset(
                                'assets/svg/splash/symptom_tracking.svg'),
                            title: 'Track Symptoms',
                            onTap: () {
                              Navigator.pop(context);
                              context.read<SymptomTrackerCubit>().checkAndNavigateToLastScreen(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildActionItem(
                            icon: SvgPicture.asset(
                                'assets/svg/home/create_check_list.svg'),
                            title: 'Create Check List',
                            onTap: () {
                              Navigator.pop(context);
                              context.read<ChecklistCubit>().checkAndNavigateToLastScreen(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildActionItem(
                            icon: SvgPicture.asset(
                                'assets/svg/splash/personal_health_guide.svg'),
                            title: 'Create Health Assessment',
                            onTap: () {
                              Navigator.pop(context);
                              context.read<HealthAssessmentCubit>().checkAndNavigateToLastScreen(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
  }
}