import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class StartDateBodyWidget extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final DateTimeRange? dateRange;

  const StartDateBodyWidget({
    Key? key,
    required this.selectedDate,
    this.dateRange,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<StartDateBodyWidget> createState() => _StartDateBodyWidgetState();
}

class _StartDateBodyWidgetState extends State<StartDateBodyWidget> {
  @override
  void initState() { 
    super.initState();
    _dateRange = widget.dateRange;
  }
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          initialDateRange: _dateRange ??
              DateTimeRange(
                start: widget.selectedDate,
                end: widget.selectedDate,
              ),
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _dateRange = picked;
          });
          final cubit = context.read<SymptomTrackerCubit>();
          cubit.setFromDate(picked.start);
          cubit.setToDate(picked.end);
          widget.onDateSelected(picked.start); // Update parent with start date
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
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
                      _dateRange != null
                          ? '${_dateRange!.start.toString().split(' ')[0]} - ${_dateRange!.end.toString().split(' ')[0]}'
                          : 'Select date range',
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                'Enter date range',
                style: AppTextStyles.body2OpenSans
                    .copyWith(color: AppColors.amethystViolet),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
