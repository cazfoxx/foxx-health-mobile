import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/health_tracker/symptom_search_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/health_tracker/body_map_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/health_tracker/symptom_details_bottom_sheet.dart';
import 'package:foxxhealth/features/data/models/symptom_model.dart';
import 'package:foxxhealth/features/data/services/symptom_service.dart';
import 'package:foxxhealth/features/presentation/cubits/health_tracker/health_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';

class HealthTrackerScreen extends StatefulWidget {
  const HealthTrackerScreen({Key? key}) : super(key: key);

  @override
  State<HealthTrackerScreen> createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  final TextEditingController _symptomController = TextEditingController();

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
                  _showDateRangePicker();
                },
                child: Text(
                  'Show date range',
                  style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                    color: AppColors.amethyst,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
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
          ),
        ],
      ),
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
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const BodyMapBottomSheet(),
        );
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

  void _showDateRangePicker() {
    // TODO: Implement date range picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Date range picker coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
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
                  _showSymptomDetails(symptom);
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

  void _showSymptomDetails(Symptom symptom) async {
    if (!mounted) return;
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Fetch symptom details from API
      Map<String, dynamic>? symptomDetails;
      
      // Try to get from API first, fallback to mock data for testing
      try {
        symptomDetails = await SymptomService.getSymptomDetails(symptom.id);
      } catch (apiError) {
        print('API Error, using mock data: $apiError');
        symptomDetails = SymptomDetailsHelper.getMockSymptomDetails(symptom.id);
      }
      
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show symptom details bottom sheet
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SymptomDetailsBottomSheet(
          symptom: symptom,
          symptomDetails: symptomDetails,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading symptom details: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}