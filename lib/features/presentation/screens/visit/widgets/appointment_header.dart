import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class AppointmentHeader extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String date;

  const AppointmentHeader({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(doctorName, style: AppTextStyles.heading2),
          const SizedBox(height: 4),
          Text(specialization, style: AppTextStyles.body2OpenSans),
          const SizedBox(height: 8),
          Text(date, style: AppTextStyles.body2OpenSans),
        ],
      ),
    );
  }
}
