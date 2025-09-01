import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/onboarding/onboarding_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/main_navigation/main_navigation_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      
      final onboardingCubit = OnboardingCubit();
      final questions = await onboardingCubit.getOnboardingQuestions();
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
      final onboardingCubit = context.read<OnboardingCubit>();
      
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
      final loginSuccess = await loginCubit.registerUser(context);

      if (loginSuccess) {
        // Add a delay to ensure the login token is properly set
        await Future.delayed(const Duration(seconds: 2));
        
        // After successful login, set all onboarding data and submit to onboarding API
        onboardingCubit.setOnboardingData(
          userName: username,
          gender: genderIdentity,
          age: age,
          weight: weight,
          height: height?['feet'] != null ? (height!['feet'] * 30.48 + height!['inches'] * 2.54) : null,
          ethnicity: ethnicity,
          address: location,
          householdIncomeRange: income,
          healthConcerns: healthConcerns?.toList() ?? [],
          healthHistory: diagnoses?.toList() ?? [],
          medicationsOrSupplementsIndicator: medicationStatus,
          medicationsOrSupplements: medications ?? [],
          currentStageInLife: lifeStage != null ? [lifeStage!] : [],
          privacyPolicyAccepted: dataPrivacyAccepted ?? false,
          sixteenAndOver: true,
          isActive: true,
        );

        // Submit onboarding data to API
        final onboardingSuccess = await onboardingCubit.submitOnboardingData();

        if (onboardingSuccess) {
                              // Navigate to main navigation screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainNavigationScreen(),
                      ),
                    );
        } else {
          // Onboarding API failed but login was successful
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully! Onboarding data will be saved later.'),
              backgroundColor: Colors.green,
            ),
          );
                              // Still navigate to main navigation screen since account was created
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainNavigationScreen(),
                      ),
                    );
        }
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

  // Data update methods for onboarding cubit
  void _updateUsername(String username) {
    this.username = username;
    context.read<OnboardingCubit>().setUserName(username);
  }

  void _updateGender(String gender) {
    genderIdentity = gender;
    context.read<OnboardingCubit>().setGender(gender);
  }

  void _updateAge(int age) {
    this.age = age;
    context.read<OnboardingCubit>().setAge(age);
  }

  void _updateWeight(double weight) {
    this.weight = weight;
    context.read<OnboardingCubit>().setWeight(weight);
  }

  void _updateHeight(Map<String, dynamic> height) {
    this.height = height;
    // Convert feet and inches to cm for the API
    if (height['feet'] != null && height['inches'] != null) {
      final heightInCm = (height['feet'] * 30.48) + (height['inches'] * 2.54);
      context.read<OnboardingCubit>().setHeight(heightInCm);
    }
  }

  void _updateEthnicity(String ethnicity) {
    this.ethnicity = ethnicity;
    context.read<OnboardingCubit>().setEthnicity(ethnicity);
  }

  void _updateLocation(String location) {
    this.location = location;
    context.read<OnboardingCubit>().setAddress(location);
  }

  void _updateIncome(String income) {
    this.income = income;
    context.read<OnboardingCubit>().setHouseholdIncomeRange(income);
  }

  void _updateHealthConcerns(Set<String> healthConcerns) {
    this.healthConcerns = healthConcerns;
    context.read<OnboardingCubit>().setHealthConcerns(healthConcerns.toList());
  }

  void _updateDiagnoses(Set<String> diagnoses) {
    this.diagnoses = diagnoses;
    context.read<OnboardingCubit>().setHealthHistory(diagnoses.toList());
  }

  void _updateMedicationStatus(String medicationStatus) {
    this.medicationStatus = medicationStatus;
    context.read<OnboardingCubit>().setMedicationsOrSupplementsIndicator(medicationStatus);
  }

  void _updateMedications(List<String> medications) {
    this.medications = medications;
    context.read<OnboardingCubit>().setMedicationsOrSupplements(medications);
  }

  void _updateLifeStage(String lifeStage) {
    this.lifeStage = lifeStage;
    context.read<OnboardingCubit>().setCurrentStageInLife([lifeStage]);
  }

  void _updateDataPrivacy(bool dataPrivacyAccepted) {
    this.dataPrivacyAccepted = dataPrivacyAccepted;
    context.read<OnboardingCubit>().setPrivacyPolicyAccepted(dataPrivacyAccepted);
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => OnboardingCubit()),
      ],
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
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
                        SizedBox(height: 8),
                        Text('Please wait while we set up your profile', 
                             style: TextStyle(fontSize: 12, color: Colors.grey)),
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
      ),
    );
  }
}