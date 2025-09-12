import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/username_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/gender_identity_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/age_selection_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/weight_input_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/height_input_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/ethnicity_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/location_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/income_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/health_concerns_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/diagnosis_history_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/medications_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/add_medications_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/life_stage_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/data_privacy_screen.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // API Data
  List<OnboardingQuestion> _questions = [];
  bool _isLoading = true;
  String? _error;
  
  // User data
  String? username;
  String? genderIdentity;
  int? age;
  double? weight;
  Map<String, dynamic>? height; // {feet: int, inches: int}
  String? ethnicity;
  String? location;
  String? income;
  Set<String>? healthConcerns;
  Set<String>? diagnoses;
  String? medicationStatus;
  List<String>? medications;
  String? lifeStage;
  bool? dataPrivacyAccepted;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final questions = await OnboardingCubit().getOnboardingQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < 13) { // Updated to include all 14 screens (0-13)
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding and navigate to home
      // Navigator.of(context).pushReplacement(...)
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate back to previous screen outside onboarding
      Navigator.of(context).pop();
    }
  }
  
  List<Widget> get screens => [
    UsernameScreen(onNext: _nextPage),
    GenderIdentityScreen(onNext: _nextPage, questions: _questions),
    AgeSelectionRevampScreen(onNext: _nextPage),
    WeightInputScreen(onNext: _nextPage),
    HeightInputScreen(onNext: _nextPage),
    EthnicityScreen(onNext: _nextPage, questions: _questions),
    LocationScreen(onNext: _nextPage),
    IncomeScreen(onNext: _nextPage, questions: _questions),
    HealthConcernsScreen(onNext: _nextPage, questions: _questions),
    DiagnosisHistoryScreen(onNext: _nextPage, questions: _questions),
    MedicationsScreen(onNext: _nextPage, questions: _questions),
    AddMedicationsScreen(onNext: _nextPage, questions: _questions),
    LifeStageScreen(onNext: _nextPage, questions: _questions),
    DataPrivacyScreen(onNext: _nextPage),
  ];

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _currentPage > 0 ? AppBar(
          backgroundColor: Colors.white.withOpacity(0.4),
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
               value: (_currentPage + 1) / screens.length,
               backgroundColor: AppColors.progressBarBase,
               valueColor: AlwaysStoppedAnimation<Color>(AppColors.progressBarSelected),
               minHeight: 4,
             ),
          ),
          actions: [
            
            SizedBox(width: 50),
          ],
        
        ) : null,
        body: SafeArea(
          child: _isLoading 
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_error'),
                      ElevatedButton(
                        onPressed: _loadQuestions,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : PageView(
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
      ),
    );
  }
}