import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_response.dart';
import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptoms/symptoms_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptoms/symptoms_state.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/select_symptoms_screen.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/widgets/symptom_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:get/get.dart';
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

  final _analytics = AnalyticsService();

  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'SymptomsListScreen',
      screenClass: 'SymptomsListScreen',
    );
  }

  @override
  void initState() {
    super.initState();
    _logScreenView();
    _selectedDate = DateTime.now();
    _currentWeekMonday = _getWeekStartDate(DateTime.now());
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
      _fetchSymptoms();
    });
  }

  void _fetchSymptoms() {
    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    context.read<SymptomTrackerCubit>().getSymptomTrackers(
          selectedDate: formattedDate,
        );
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
      _fetchSymptoms();
    }
  }

  Widget _buildSymptomChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.body2OpenSans,
      ),
    );
  }

  Widget _buildSymptomsSection(List<SymptomTrackerResponse> symptoms) {
    if (symptoms.isEmpty) return const SizedBox.shrink();

    final symptomResponse = symptoms.first;
    // Group symptoms by category
    final groupedSymptoms = <String, List<SymptomId>>{};
    for (var symptomResponse in symptoms) {
      for (var symptom in symptomResponse.symptomIds ?? []) {
        if (!groupedSymptoms.containsKey(symptom.symptomCategory)) {
          groupedSymptoms[symptom.symptomCategory] = [];
        }
        groupedSymptoms[symptom.symptomCategory]!.add(symptom);
      }
    }

    // Define the desired order of categories
    final categoryOrder = ['Body', 'Mood', 'Mind', 'Habits'];
    
    // Sort the entries based on the category order
    final sortedEntries = groupedSymptoms.entries.toList()
      ..sort((a, b) {
        final indexA = categoryOrder.indexOf(a.key);
        final indexB = categoryOrder.indexOf(b.key);
        return indexA.compareTo(indexB);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Symptoms', style: AppTextStyles.heading3),
        const SizedBox(height: 16),
        ...sortedEntries.map((entry) {
          // Get the symptom type from the category name
          final symptomType = entry.key;

          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: AppTextStyles.bodyOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final symptomsCubit = context.read<SymptomsCubit>();
                        final trackerCubit =
                            context.read<SymptomTrackerCubit>();
                        symptomsCubit.fetchSymptomsByCategory(entry.key);

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              BlocBuilder<SymptomsCubit, SymptomsState>(
                            builder: (context, state) {
                              if (state is SymptomsLoading) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  child: const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(20.0),
                                      child: CircularProgressIndicator(
                                        color: AppColors.amethystViolet,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (state is SymptomsError) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Error: ${state.message}',
                                            style: AppTextStyles.body
                                                .copyWith(color: Colors.red),
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              symptomsCubit
                                                  .fetchSymptomsByCategory(
                                                      entry.key);
                                            },
                                            child: const Text('Retry'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (state is SymptomsLoaded) {
                                final symptoms = state.symptoms
                                    .map((symptom) => SymptomItem(
                                          name: symptom.symptomName,
                                          isSelected: entry.value.any((s) =>
                                              s.symptomName == symptom.symptomName &&
                                              s.symptomCategory == entry.key),
                                          severity: entry.value
                                              .firstWhere(
                                                (s) =>
                                                    s.symptomName == symptom.symptomName &&
                                                    s.symptomCategory == entry.key,
                                                orElse: () => SymptomId(
                                                  symptomName: '',
                                                  symptomType: entry.key,
                                                  symptomCategory: entry.key,
                                                  severity: '',
                                                ),
                                              )
                                              .severity,
                                        ))
                                    .toList();

                                final categoryData = Category(
                                  title: entry.key,
                                  symptoms: symptoms,
                                );

                                return Container(
                                  decoration: const BoxDecoration(
                                    color: AppColors.background,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.9,
                                  child: NotificationListener<SymptomUpdateNotification>(
                                    onNotification: (notification) {
                                      // Get all symptoms except the ones from current category
                                      final otherSymptoms = symptomResponse.symptomIds
                                              ?.where((s) => s.symptomCategory != entry.key)
                                              .toList() ??
                                          [];

                                      // Add the newly selected symptoms
                                      final updatedSymptoms = [
                                        ...otherSymptoms,
                                        ...notification.updatedSymptoms,
                                      ];

                                      // Update the symptom tracker with correct dates
                                      trackerCubit.updateSymptomTracker(
                                        trackerId: symptomResponse.id ?? 0,
                                        updatedSymptoms: List<SymptomId>.from(updatedSymptoms),
                                        description: symptomResponse.symptomDescription ?? '',
                                        fromDate: symptomResponse.fromDate ?? _selectedDate,
                                        toDate: symptomResponse.toDate ?? _selectedDate,
                                      ).then((_) {
                                        if (mounted) {  // Check if widget is still mounted
                                          Get.back();
                                          // Refresh the symptoms list
                                          _fetchSymptoms();
                                        }
                                      });

                                      return true;
                                    },
                                    child: SymptomBottomSheet(
                                      title: entry.key,
                                      categories: [categoryData],
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'Change',
                        style: AppTextStyles.body2OpenSans.copyWith(
                          color: AppColors.amethystViolet,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: entry.value.map((symptom) {
                    Color chipColor;
                    switch (symptom.severity?.toLowerCase() ?? '') {
                      case 'mild':
                        chipColor = Colors.yellow.shade100;
                        break;
                      case 'moderate':
                        chipColor = Colors.orange.shade100;
                        break;
                      case 'severe':
                        chipColor = Colors.red.shade100;
                        break;
                      default:
                        chipColor = Colors.grey.shade100;
                    }
                    return _buildSymptomChip(
                      '${symptom.symptomName ?? 'Unknown'}\n${symptom.severity ?? 'N/A'}',
                      chipColor,
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDescriptionSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            description.isNotEmpty ? description : 'No description provided',
            style: AppTextStyles.body2OpenSans.copyWith(color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Symptoms',
          style: AppTextStyles.heading3,
        ),
      ),
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
                                      _fetchSymptoms();
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
              child: BlocBuilder<SymptomTrackerCubit, SymptomTrackerState>(
                builder: (context, state) {
                  if (state is SymptomTrackerLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SymptomTrackerError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error loading symptoms',
                            style:
                                AppTextStyles.body.copyWith(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchSymptoms,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SymptomTrackersLoaded) {
                    if (state.symptomTrackers.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14),
                              child: Text('Symptoms',
                                  style: AppTextStyles.heading3),
                            ),
                            Container(
                              padding: const EdgeInsets.all(13),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
                                    final cubit =
                                        context.read<SymptomTrackerCubit>();
                                        cubit.clear();
                                    cubit.setFromDate(_selectedDate);
                                    cubit.setToDate(_selectedDate);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                             SelectSymptomsScreen(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.amethystViolet,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
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
                      );
                    }

                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildSymptomsSection(state.symptomTrackers),
                        const SizedBox(height: 24),
                        Text('Describe your symptoms',
                            style: AppTextStyles.heading3),
                        const SizedBox(height: 8),
                        if (state.symptomTrackers.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.symptomTrackers.length,
                            itemBuilder: (context, index) {
                              return _buildDescriptionSection(
                                state.symptomTrackers[index]
                                        .symptomDescription ??
                                    '',
                              );
                            },
                          )
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
