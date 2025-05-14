import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class StartDateBodyWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const StartDateBodyWidget({
    Key? key,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<StartDateBodyWidget> createState() => _StartDateBodyWidgetState();
}

class _StartDateBodyWidgetState extends State<StartDateBodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
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
          Text('Date', style: AppTextStyles.body2),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: widget.selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != widget.selectedDate) {
                widget.onDateSelected(picked);
              }
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.optionBG,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 8),
                  Text(
                    'Today, ${widget.selectedDate.toString().split(' ')[0]}',
                    style: AppTextStyles.body2,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Handle date range selection
                },
                child: Text(
                  'Enter Date Range',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.amethystViolet,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}