import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:foxxhealth/features/presentation/cubits/health_tracker/health_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/features/presentation/screens/health_tracker/symptom_details_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/screens/health_tracker/body_map_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/screens/health_tracker/symptom_search_screen.dart';
import 'package:foxxhealth/features/data/models/health_tracker_model.dart';
import 'package:foxxhealth/features/presentation/screens/health_tracker/saved_symptoms_widget.dart';

class HealthTrackerScreen extends StatefulWidget {
  const HealthTrackerScreen({Key? key}) : super(key: key);

  @override
  State<HealthTrackerScreen> createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  final TextEditingController _symptomController = TextEditingController();
  List<Map<String, dynamic>> _savedSymptoms = [];

  @override
  void dispose() {
    _symptomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HealthTrackerCubit(),
      child: BlocBuilder<HealthTrackerCubit, HealthTrackerState>(
        builder: (context, healthState) {
          final healthCubit = context.read<HealthTrackerCubit>();
          return BlocBuilder<SymptomSearchCubit, SymptomSearchState>(
            builder: (context, symptomState) {
              final symptomCubit = context.read<SymptomSearchCubit>();
              
              return Foxxbackground(
                child: Scaffold(
                  bottomNavigationBar: symptomCubit.selectedSymptoms.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                          height: 84,
                          color: Colors.white,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.amethyst,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: () => _logSymptom(symptomCubit, healthCubit),
                            child: Text(
                              'Log Symptom',
                              style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : null,
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: FoxxBackButton(),
                  ),
                  body: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Navigation Bar
                           
                            const SizedBox(height: 24),
                        
                            // Header Section
                            Text(
                              'Health Tracker',
                              style: AppHeadingTextStyles.h2.copyWith(
                                color: AppColors.primary01,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Find for your symptom through our clickable body, or by using the search function',
                              style: AppOSTextStyles.osMd.copyWith(
                                color: AppColors.davysGray,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                        
                            // Date Selection Card
                            _buildDateSelectionCard(healthCubit),
                            const SizedBox(height: 24),
                            
                            // Selected Symptoms Section
                            if (symptomCubit.selectedSymptoms.isNotEmpty) ...[
                              Text(
                                'My Symptoms',
                                style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                                  color: AppColors.primary01,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildSelectedSymptomsList(symptomCubit),
                            ],
                            const SizedBox(height: 24),
                            
                            // Saved Symptoms Section
                            if (_savedSymptoms.isNotEmpty) ...[
                              SavedSymptomsWidget(
                                savedSymptoms: _savedSymptoms,
                                onEdit: () => _editSavedSymptoms(),
                              ),
                              const SizedBox(height: 24),
                            ],
                        
                            // Add symptoms section header
                            Text(
                              'Add symptoms',
                              style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                                color: AppColors.primary01,
                              ),
                            ),
                            const SizedBox(height: 16),
                        
                            // Search by Symptom Card
                            _buildSearchBySymptomCard(healthCubit, symptomCubit),
                            const SizedBox(height: 16),
                        
                            // Area of the Body Card
                            _buildAreaOfBodyCard(),
                            const SizedBox(height: 24),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDateSelectionCard(HealthTrackerCubit cubit) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppColors.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date',
                style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                  color: AppColors.primary01,
                ),
              ),
              GestureDetector(
                onTap: () {
                  cubit.toggleDateRangeMode();
                },
                child: Text(
                  cubit.isDateRangeMode ? 'Hide date range' : 'Show date range',
                  style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                    color: AppColors.amethyst,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (cubit.isDateRangeMode) ...[
            // Date Range Input Fields
            _buildDateRangeInputs(cubit),
          ] else ...[
            // Single Date Input Field
            _buildSingleDateInput(cubit),
          ],
        ],
      ),
    );
  }

  Widget _buildSingleDateInput(HealthTrackerCubit cubit) {
    return GestureDetector(
      onTap: () {
        _showDatePicker(cubit);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.gray200,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: AppColors.amethyst,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _formatDate(cubit.selectedDate),
              style: AppOSTextStyles.osMd.copyWith(
                color: AppColors.primary01,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeInputs(HealthTrackerCubit cubit) {
    return Column(
      children: [
        // Start Date Input
        GestureDetector(
          onTap: () {
            _showDateRangePicker(cubit, isStartDate: true);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.amethyst,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Starts: ${cubit.startDate != null ? _formatDateString(cubit.startDate!) : 'Select date'}',
                  style: AppOSTextStyles.osMd.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // End Date Input
        GestureDetector(
          onTap: () {
            _showDateRangePicker(cubit, isStartDate: false);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.gray200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.amethyst,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Ends: ${cubit.endDate != null ? _formatDateString(cubit.endDate!) : 'Select date'}',
                  style: AppOSTextStyles.osMd.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBySymptomCard(HealthTrackerCubit cubit, SymptomSearchCubit symptomCubit) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SymptomSearchScreen(),
          ),
        );
        // The selected symptoms are already updated in the SymptomSearchCubit
        // No need to handle the result since we're using the same cubit instance
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search by symptom',
              style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                color: AppColors.primary01,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.gray200,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: AppColors.amethyst,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enter symptom name',
                      style: AppOSTextStyles.osMd.copyWith(
                        color: AppColors.gray400,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.amethyst,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaOfBodyCard() {
    return GestureDetector(
      onTap: () async {
        final result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const BodyMapBottomSheet(),
        );
        
        // Handle the returned symptom details
        print('🔍 DEBUG: Result received from BodyMapBottomSheet: $result');
        print('🔍 DEBUG: Result type: ${result.runtimeType}');
        print('🔍 DEBUG: Result is null: ${result == null}');
        print('🔍 DEBUG: Result is List: ${result is List}');
        if (result != null) {
          print('🔍 DEBUG: Result is List<Map<String, dynamic>>: ${result is List<Map<String, dynamic>>}');
          if (result is List<Map<String, dynamic>>) {
            print('🔍 DEBUG: Setting _savedSymptoms with ${result.length} symptoms');
            setState(() {
              _savedSymptoms = result;
            });
            print('🔍 DEBUG: _savedSymptoms updated: ${_savedSymptoms.length}');
          } else {
            print('🔍 DEBUG: Result is not List<Map<String, dynamic>>');
            print('🔍 DEBUG: Result content: $result');
          }
        } else {
          print('🔍 DEBUG: Result is null');
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Area of the body',
                    style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Track how you\'re feeling physically, like energy levels, sleep, or pain',
                    style: AppOSTextStyles.osMd.copyWith(
                      color: AppColors.davysGray,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.amethyst,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate == today) {
      return 'Today, ${_formatDateString(date)}';
    } else if (selectedDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${_formatDateString(date)}';
    } else if (selectedDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${_formatDateString(date)}';
    } else {
      return _formatDateString(date);
    }
  }

  String _formatDateString(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showDatePicker(HealthTrackerCubit cubit) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: cubit.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.amethyst,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.primary01,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != cubit.selectedDate) {
      cubit.setSelectedDate(picked);
    }
  }

  void _showDateRangePicker(HealthTrackerCubit cubit, {required bool isStartDate}) {
    showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: AppColors.amethyst,
        dayTextStyle: AppOSTextStyles.osMd.copyWith(color: AppColors.primary01),
        selectedDayTextStyle: AppOSTextStyles.osMd.copyWith(color: Colors.white),
        todayTextStyle: AppOSTextStyles.osMd.copyWith(color: AppColors.primary01),
        calendarViewMode: DatePickerMode.day,
        firstDate: DateTime(2020),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        currentDate: DateTime.now(),
      ),
      dialogSize: const Size(325, 400),
      value: [
        cubit.startDate,
        cubit.endDate,
      ],
    ).then((dates) {
      if (dates != null && dates.isNotEmpty) {
        final startDate = dates.first;
        final endDate = dates.length > 1 ? dates.last : null;
        cubit.setDateRange(startDate, endDate);
      }
    });
  }

  Widget _buildSelectedSymptomsList(SymptomSearchCubit cubit) {
    return Column(
      children: cubit.selectedSymptomsList.map((symptom) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: AppColors.glassCardDecoration,
          child: Row(
            children: [
              // Checkbox
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.amethyst,
                  border: Border.all(
                    color: AppColors.amethyst,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 16),
              
              // Symptom Name
              Expanded(
                child: Text(
                  symptom.name,
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
              ),
              
              // Details Button
              GestureDetector(
                onTap: () {
                  _showSymptomDetails(symptom, cubit);
                },
                child: Text(
                  'Details',
                  style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                    color: AppColors.amethyst,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showSymptomDetails(Symptom symptom, SymptomSearchCubit symptomCubit) async {
    if (!mounted) return;
    
    // Check if we have stored details for this symptom
    final storedDetails = symptomCubit.symptomDetails[symptom.id];
    
    if (storedDetails != null) {
      // Show details sheet with pre-filled data
      final symptomData = {
        'id': symptom.id,
        'info': {
          'name': symptom.name,
          'question_map': storedDetails['symptom']?['info']?['question_map'],
        },
        'answers': storedDetails['answers'] ?? {},
        'notes': storedDetails['notes'] ?? '',
      };
      
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SymptomDetailsBottomSheet(
          symptoms: [symptomData],
          onDetailsSaved: (details) {
            // Update the stored details
            symptomCubit.addSymptomWithDetails(symptom, details.first);
          },
        ),
      ).then((_) {
        // Refresh the state when the sheet is closed
        symptomCubit.refreshSymptoms();
      });
    } else {
      // No stored details, fetch from API
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      
      try {
        final symptomDetails = await symptomCubit.getSymptomDetails(symptom.id);
        
        if (!mounted) return;
        Navigator.of(context).pop(); // Close loading dialog
        
        if (symptomDetails != null) {
          final symptomData = {
            'id': symptom.id,
            'info': {
              'name': symptom.name,
              'question_map': symptomDetails['info']?['question_map'] ?? symptomDetails['question_map'],
            },
          };
          
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => SymptomDetailsBottomSheet(
              symptoms: [symptomData],
              onDetailsSaved: (details) {
                // Store the details
                symptomCubit.addSymptomWithDetails(symptom, details.first);
              },
            ),
          ).then((_) {
            // Refresh the state when the sheet is closed
            symptomCubit.refreshSymptoms();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not load symptom details. Please try again.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        Navigator.of(context).pop(); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading symptom details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _logSymptom(SymptomSearchCubit symptomCubit, HealthTrackerCubit healthCubit) async {
    if (symptomCubit.selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one symptom before logging'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Fetch symptom details for each selected symptom
      final selectedSymptoms = <SelectedSymptom>[];
      
      for (final symptom in symptomCubit.selectedSymptoms) {
        // Try to get symptom details from API
        Map<String, dynamic>? symptomDetails;
        try {
          symptomDetails = await symptomCubit.getSymptomDetails(symptom.id);
        } catch (apiError) {
          print('API Error for symptom ${symptom.id}: $apiError');
          // Skip this symptom if details can't be loaded
          continue;
        }
        
        // Extract question map from symptom details
        List<Map<String, dynamic>> questionMap = [];
        if (symptomDetails != null) {
          final questions = symptomDetails['info']?['question_map'] ?? symptomDetails['question_map'];
          if (questions != null && questions is List) {
            questionMap = questions.cast<Map<String, dynamic>>();
          }
        }
        
        selectedSymptoms.add(SelectedSymptom(
          id: symptom.id,
          info: SymptomInfo(
            id: symptom.id,
            name: symptom.name,
            filterGrouping: symptom.filterGrouping,
            bodyParts: symptom.bodyParts,
            tags: symptom.tags,
            visualInsights: symptom.visualInsights,
            questionMap: questionMap,
          ),
          needHelpPopup: false,
          notes: '',
        ));
      }

      // Create health tracker request
      final request = HealthTrackerRequest(
        accountId: 0, // TODO: Get from user session
        selectedSymptoms: selectedSymptoms,
        fromDate: healthCubit.selectedDate.toIso8601String().split('T')[0],
        toDate: healthCubit.selectedDate.toIso8601String().split('T')[0],
        isActive: true,
        selectedBodyParts: [], // TODO: Get from body map selection
        selectedFilterGroup: 'All', // TODO: Get from filter selection
      );

      // Call the API
      final response = await symptomCubit.createHealthTracker(request.toJson());

      if (!mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      if (response != null) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Symptoms logged successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear selected symptoms after successful logging
        symptomCubit.clearSelectedSymptoms();
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to log symptoms. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      // Close loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging symptoms: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _editSavedSymptoms() {
    // For now, just clear the saved symptoms
    // In a real app, you might want to show the body map again or edit the details
    setState(() {
      _savedSymptoms.clear();
    });
  }
}