import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';

import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/personal_info_review_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/care_provider_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/main_reason_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/symptom_selection_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/life_situation_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/journey_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/premium_info_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/concern_prioritization_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/symptom_changes_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/communication_preferences_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/care_experience_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/concerns_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/widgets/data_privacy_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/view/appointment_companion_screen.dart';

class AppointmentFlow extends StatefulWidget {
  const AppointmentFlow({super.key});

  @override
  State<AppointmentFlow> createState() => _AppointmentFlowState();
}

class _AppointmentFlowState extends State<AppointmentFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // User data collected through the flow
  String? appointmentType;
  String? careProvider;
  String? mainReason;
  List<String> selectedSymptoms = [];
  List<String> lifeSituations = [];
  List<String> journeySteps = [];
  List<String> concernPriorities = [];
  List<String> symptomChanges = [];
  List<String> communicationPreferences = [];
  List<String> careExperiences = [];
  List<String> concerns = [];
  Map<String, String> additionalInfo = {};
  
  // Next button state
  bool _canProceed = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 13) { // 15 screens total (0-14)
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete appointment creation and navigate to companion screen
      _navigateToCompanionScreen();
    }
  }

  void _navigateToCompanionScreen() {
    // Prepare all collected data
    final Map<String, dynamic> appointmentData = {
      'appointmentType': appointmentType,
      'careProvider': careProvider,
      'mainReason': mainReason,
      'selectedSymptoms': selectedSymptoms,
      'lifeSituations': lifeSituations,
      'journeySteps': journeySteps,
      'concernPriorities': concernPriorities,
      'symptomChanges': symptomChanges,
      'communicationPreferences': communicationPreferences,
      'careExperiences': careExperiences,
      'concerns': concerns,
      'additionalInfo': additionalInfo,
    };

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AppointmentCompanionScreen(
          appointmentData: appointmentData,
        ),
      ),
    );
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate back to previous screen outside appointment flow
      Navigator.of(context).pop();
    }
  }

  void _updateAppointmentData({
    String? type,
    String? provider,
    String? reason,
    List<String>? symptoms,
    List<String>? situations,
    List<String>? steps,
    List<String>? priorities,
    List<String>? changes,
    List<String>? preferences,
    List<String>? experiences,
    List<String>? concerns,
    Map<String, String>? info,
    bool canProceed = false,
  }) {
    setState(() {
      if (type != null) appointmentType = type;
      if (provider != null) careProvider = provider;
      if (reason != null) mainReason = reason;
      if (symptoms != null) selectedSymptoms = symptoms;
      if (situations != null) lifeSituations = situations;
      if (steps != null) journeySteps = steps;
      if (priorities != null) concernPriorities = priorities;
      if (changes != null) symptomChanges = changes;
      if (preferences != null) communicationPreferences = preferences;
      if (experiences != null) careExperiences = experiences;
      if (concerns != null) this.concerns = concerns;
      if (info != null) additionalInfo.addAll(info);
      _canProceed = canProceed;
    });
  }
  
  List<Widget> get screens => [
    PersonalInfoReviewScreen(
      onDataUpdate: (info) => _updateAppointmentData(info: info, canProceed: true),
    ),
    AppointmentTypeScreen(
      onDataUpdate: (type, info, canProceed) => _updateAppointmentData(type: type, info: info, canProceed: canProceed),
    ),
    CareProviderScreen(
      onDataUpdate: (provider, info, canProceed) => _updateAppointmentData(provider: provider, info: info, canProceed: canProceed),
    ),
    MainReasonScreen(
      onDataUpdate: (reason, info, canProceed) => _updateAppointmentData(reason: reason, info: info, canProceed: canProceed),
    ),
    SymptomSelectionScreen(
      onDataUpdate: (symptoms, info, canProceed) => _updateAppointmentData(symptoms: symptoms, info: info, canProceed: canProceed),
    ),
    LifeSituationScreen(
      onDataUpdate: (situations, info, canProceed) => _updateAppointmentData(situations: situations, info: info, canProceed: canProceed),
    ),
    JourneyScreen(
      onDataUpdate: (steps, info, canProceed) => _updateAppointmentData(steps: steps, info: info, canProceed: canProceed),
    ),
    PremiumInfoScreen(
      onDataUpdate: (info) => _updateAppointmentData(info: info, canProceed: true),
    ),
    ConcernPrioritizationScreen(
      onDataUpdate: (priorities, info, canProceed) => _updateAppointmentData(priorities: priorities, info: info, canProceed: canProceed),
    ),
    SymptomChangesScreen(
      onDataUpdate: (changes, info, canProceed) => _updateAppointmentData(changes: changes, info: info, canProceed: canProceed),
    ),
    CommunicationPreferencesScreen(
      onDataUpdate: (preferences, info, canProceed) => _updateAppointmentData(preferences: preferences, info: info, canProceed: canProceed),
    ),
    CareExperienceScreen(
      onDataUpdate: (experiences, info, canProceed) => _updateAppointmentData(experiences: experiences, info: info, canProceed: canProceed),
    ),
    ConcernsScreen(
      onDataUpdate: (concerns, info, canProceed) => _updateAppointmentData(concerns: concerns, info: info, canProceed: canProceed),
    ),
    DataPrivacyScreen(
      onDataUpdate: (info) => _updateAppointmentData(info: info, canProceed: true),
    ),
  ];

  double get _progressValue {

    return (_currentPage + 1) / 15.0;
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: FoxxBackButton(onPressed: _previousPage),
          title: Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.progressBarBase,
              borderRadius: BorderRadius.circular(3),
            ),
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(3),
              value: _progressValue,
              backgroundColor: AppColors.progressBarBase,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.progressBarSelected),
              minHeight: 4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // TODO: Implement pause functionality
              },
              child: Text(
                'Pause',
                style: TextStyle(
                  color: AppColors.amethyst,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: screens,
                ),
              ),
              // Centralized Next Button
              if (_currentPage < 14) // Show on all screens except the last one
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _canProceed ? _nextPage : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canProceed ? AppColors.amethyst : AppColors.gray400,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: AppOSTextStyles.osMdSemiboldLink.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 