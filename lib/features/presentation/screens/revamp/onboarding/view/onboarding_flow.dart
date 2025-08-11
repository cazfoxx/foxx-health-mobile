import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/data/services/onboarding_service.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/home_screen/revamp_home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/username_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/gender_identity_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/age_selection_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/weight_input_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/height_input_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/ethnicity_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/location_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/income_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/health_concerns_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/diagnosis_history_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/medications_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/add_medications_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/life_stage_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/onboarding/widgets/data_privacy_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';

class OnboardingFlow extends StatefulWidget {
  final String email;
  final String password;
  
  const OnboardingFlow({super.key, required this.email, required this.password});

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
  bool _isCreatingAccount = false;
  
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
      
      final questions = await OnboardingService.getOnboardingQuestions();
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
      // Complete onboarding and create account
      _createAccount();
    }
  }

  Future<void> _createAccount() async {
    setState(() {
      _isCreatingAccount = true;
    });

    try {
      final loginCubit = context.read<LoginCubit>();
      
      // Set all the collected data in the LoginCubit
      loginCubit.setUserDetails(
        email: widget.email,
        password: widget.password,
        username: username,
        age: age?.toString(),
        referralSource: 'Onboarding Flow', // You can customize this
      );

      // Set health goals and concerns if available
      if (healthConcerns != null && healthConcerns!.isNotEmpty) {
        loginCubit.setHealthConcerns(healthConcerns!.toList());
      }

      // Register the user using LoginCubit
      final success = await loginCubit.registerUser(context);

      if (success) {
        // Navigate to revamp home screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const RevampHomeScreen(),
          ),
        );
      } else {
        // Error is already handled by LoginCubit and shown via Snackbar
        setState(() {
          _isCreatingAccount = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating account: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isCreatingAccount = false;
      });
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
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Foxxbackground(
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
              : _isCreatingAccount
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Creating your account...'),
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
      ),
    );
  }
}