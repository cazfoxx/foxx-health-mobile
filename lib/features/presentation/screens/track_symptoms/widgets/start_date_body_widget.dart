import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:intl/intl.dart';

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
  DateTimeRange? _dateRange;
  bool _isRangeMode = true;

    String _formatDate(DateTime date) {
    return DateFormat('MM-dd-yyyy').format(date); // ✅ Format as MM-dd-yyyy
  }


  @override
  void initState() {
    super.initState();
    _dateRange = widget.dateRange;
  }

  Future<void> _pickDate() async {
    if (_isRangeMode) {
      final pickedRange = await showOmniDateTimeRangePicker(
        type: OmniDateTimePickerType.date,
        context: context,
        startInitialDate: _dateRange?.start ?? DateTime.now(),
        endInitialDate: _dateRange?.end ?? DateTime.now(),
        is24HourMode: false,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      );

      if (pickedRange != null) {
        setState(() {
          _dateRange = DateTimeRange(
            start: pickedRange.first,
            end: pickedRange.last,
          );
        });

        final cubit = context.read<SymptomTrackerCubit>();
        cubit.setFromDate(pickedRange.first);
        cubit.setToDate(pickedRange.last);
        widget.onDateSelected(pickedRange.first);
      }
    } else {
      final picked = await showOmniDateTimePicker(
        type: OmniDateTimePickerType.date,
        context: context,
        initialDate: _dateRange?.start ?? DateTime.now(),
        is24HourMode: false,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      );

      if (picked != null) {
        setState(() {
          _dateRange = DateTimeRange(start: picked, end: picked);
        });

        final cubit = context.read<SymptomTrackerCubit>();
        cubit.setFromDate(picked);
        cubit.setToDate(picked);
        widget.onDateSelected(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rangeText ;
       if (_dateRange != null) {
      if (_isRangeMode) {
        rangeText =
            '${_formatDate(_dateRange!.start)} - ${_formatDate(_dateRange!.end)}';
      } else {
        rangeText = _formatDate(_dateRange!.start);
      }
    } else {
      rangeText = 'Select date';
    }


    return Column(
      children: [
        Row(
          children: [
            Text("Mode: ", style: AppTextStyles.body2),
            Switch(
              value: _isRangeMode,
              onChanged: (val) => setState(() => _isRangeMode = val),
            ),
            Text(
              _isRangeMode ? "Range" : "Single",
              style: AppTextStyles.body2,
            ),
          ],
        ),
        InkWell(
          onTap: _pickDate,
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
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.optionBG,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text((rangeText), style: AppTextStyles.body2),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _isRangeMode
                          ? 'Select date range'
                          : 'Select single date',
                      style: AppTextStyles.body2OpenSans
                          .copyWith(color: AppColors.amethystViolet),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
