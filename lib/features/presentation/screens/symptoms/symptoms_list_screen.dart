import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class SymptomsListScreen extends StatefulWidget {
  const SymptomsListScreen({super.key});

  @override
  State<SymptomsListScreen> createState() => _SymptomsListScreenState();
}

class _SymptomsListScreenState extends State<SymptomsListScreen> {
  late DateTime _selectedDate;
  late DateTime _currentWeekMonday;
  late ScrollController _scrollController;
  bool _hasSymptoms = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentWeekMonday = _getWeekStartDate(DateTime.now());
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDate() {
    if (!_scrollController.hasClients) return;

    final days = _getMonthDays(_selectedDate);
    final selectedIndex = days.indexWhere((date) =>
        date.day == _selectedDate.day &&
        date.month == _selectedDate.month &&
        date.year == _selectedDate.year);

    if (selectedIndex != -1) {
      final scrollPosition =
          (selectedIndex * 53.0) - (MediaQuery.of(context).size.width / 2) + 45;
      _scrollController.animateTo(
        scrollPosition.clamp(0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  DateTime _getWeekStartDate(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> _getMonthDays(DateTime date) {
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    final today = DateTime.now();

    // Get the Monday before the first day if month doesn't start on Monday
    final firstMonday = _getWeekStartDate(firstDayOfMonth);

    // Limit the last day to today
    final lastDay = lastDayOfMonth.isAfter(today) ? today : lastDayOfMonth;
    // Get the Sunday after the last day if month doesn't end on Sunday
    final lastSunday = lastDay.add(Duration(days: 7 - lastDay.weekday));

    final days = <DateTime>[];
    var current = firstMonday;
    while (current.isBefore(lastSunday.add(const Duration(days: 1)))) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  Future<void> _showCalendarPicker() async {
    final today = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today) ? today : _selectedDate,
      firstDate: DateTime(2020),
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.amethystViolet,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _currentWeekMonday = _getWeekStartDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text(
              'My Symptoms',
              style: AppTextStyles.heading3,
            ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
            Container(
              color: AppColors.amethystViolet,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          onTap: _showCalendarPicker,
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Today, ${DateFormat('MMM d').format(_selectedDate)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _getMonthDays(_selectedDate).length,
                      itemBuilder: (context, index) {
                        final date = _getMonthDays(_selectedDate)[index];
                        final today = DateTime.now();
                        final isSelected = date.day == _selectedDate.day &&
                            date.month == _selectedDate.month &&
                            date.year == _selectedDate.year;
                        final isCurrentMonth =
                            date.month == _selectedDate.month;
                        final isFutureDate = date.isAfter(today);

                        return Container(
                          width: 45,
                          height: 45,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : isCurrentMonth
                                    ? AppColors.amethystViolet.withOpacity(0.3)
                                    : AppColors.amethystViolet.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: isFutureDate
                                  ? null
                                  : () {
                                      setState(() {
                                        _selectedDate = date;
                                        _scrollToSelectedDate();
                                      });
                                    },
                              borderRadius: BorderRadius.circular(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('E')
                                        .format(date)
                                        .substring(0, 2)
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color: isFutureDate
                                          ? Colors.white.withOpacity(0.3)
                                          : isSelected
                                              ? AppColors.amethystViolet
                                              : Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    date.day.toString(),
                                    style: TextStyle(
                                      color: isFutureDate
                                          ? Colors.white.withOpacity(0.3)
                                          : isSelected
                                              ? AppColors.amethystViolet
                                              : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _hasSymptoms
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: const [
                        // Add symptom items here
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Text('Symptoms', style: AppTextStyles.heading3),
                          ),
                          Container(
                            padding: const EdgeInsets.all(13),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "I'm all good.",
                                  style: AppTextStyles.bodyOpenSans.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No symptom reported today',
                                  style: AppTextStyles.body2OpenSans.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                             Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement add symptom functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.amethystViolet,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(
                        color: AppColors.amethystViolet,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Add Symptom',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.amethystViolet,
                    ),
                  ),
                ),
              ),
            ),
                        ],
                      ),
                    ),
            ),
         
          ],
        ),
      ),
    );
  }
}
