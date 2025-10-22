import 'package:flutter/material.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
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
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/otp_verification_sheet.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

abstract class HasNextButtonState {
  NextButtonState getNextButtonState();
}

class NextButtonState {
  final bool show;
  final VoidCallback? onPressed;

  const NextButtonState({required this.show, required this.onPressed});
}

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
  final ValueNotifier<bool> _canProceedNotifier = ValueNotifier<bool>(true);

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
  Set<String>? ethnicity;
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

  // Helper: whether user chose to list medications (API or fallback label)
  bool get _shouldListMedications {
    final normalized = (medicationStatus ?? '').toLowerCase().trim();
    return normalized.contains('list') && normalized.startsWith('yes');
  }

  void _nextPage() {
    if (_currentPage == 10) {
      // Branch from MedicationsScreen
      if (_shouldListMedications) {
        _pageController.jumpToPage(11); // AddMedicationsScreen
      } else {
        _pageController.jumpToPage(12); // LifeStageScreen
      }
      return;
    }

    if (_currentPage < screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _createAccount();
    }
  }

  void _previousPage() {
    if (_currentPage == 12 && !_shouldListMedications) {
      _pageController.jumpToPage(10); // MedicationsScreen
      return;
    }

    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  // Account creation and onboarding submission
  Future<void> _createAccount() async {
    setState(() {
      _isCreatingAccount = true;
    });

    try {
      final loginCubit = context.read<LoginCubit>();
      final onboardingCubit = context.read<OnboardingCubit>();

      loginCubit.setUserDetails(
        email: widget.email,
        password: widget.password,
        username: username,
        age: age?.toString(),
        referralSource: 'Onboarding Flow',
      );

      if (healthConcerns != null && healthConcerns!.isNotEmpty) {
        loginCubit.setHealthConcerns(healthConcerns!.toList());
      }

      final registrationResponse = await loginCubit.registerUser(context);

      setState(() {
        _isCreatingAccount = false;
      });

      if (registrationResponse != null) {
        if (registrationResponse['direct_login'] == true) {
          await _completeOnboardingAfterLogin(onboardingCubit);
        } else {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => OTPVerificationSheet(
              email: widget.email,
              onSuccess: () async {
                Navigator.of(context).pop();
                await _completeOnboardingAfterLogin(onboardingCubit);
              },
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating account: $e'), backgroundColor: Colors.red),
      );
      setState(() {
        _isCreatingAccount = false;
      });
    }
  }

  Future<void> _completeOnboardingAfterLogin(OnboardingCubit onboardingCubit) async {
    try {
      final token = AppStorage.accessToken;
      if (token == null) await AppStorage.loadCredentials();
      await Future.delayed(const Duration(seconds: 2));

      onboardingCubit.setOnboardingData(
        userName: username,
        gender: genderIdentity,
        age: age,
        weight: weight,
        height: height?['feet'] != null
            ? (height!['feet'] * 30.48 + height!['inches'] * 2.54)
            : null,
        ethnicity: ethnicity?.join(', '),
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
        denPrivacy: ['posts'],
        profileIconUrl: null,
      );

      await onboardingCubit.submitOnboardingData();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing onboarding: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Data update methods
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
    if (height['feet'] != null && height['inches'] != null) {
      final heightInCm = (height['feet'] * 30.48) + (height['inches'] * 2.54);
      context.read<OnboardingCubit>().setHeight(heightInCm);
    }
  }

  void _updateEthnicity(Set<String> ethnicity) {
    this.ethnicity = ethnicity;
    context.read<OnboardingCubit>().setEthnicity(ethnicity.join(', '));
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
        UsernameScreen(onNext: _nextPage, onDataUpdate: _updateUsername, currentValue: username),
        GenderIdentityScreen(onNext: _nextPage, questions: _questions, onDataUpdate: _updateGender, currentValue: genderIdentity),
        AgeSelectionRevampScreen(onNext: _nextPage, onDataUpdate: _updateAge, questions: _questions, currentValue: age),
        WeightInputScreen(onNext: _nextPage, onDataUpdate: _updateWeight, questions: _questions, currentValue: weight),
        HeightInputScreen(onNext: _nextPage, onDataUpdate: _updateHeight, questions: _questions, currentValue: height),
        EthnicityScreen(onNext: _nextPage, questions: _questions, onDataUpdate: _updateEthnicity, currentValue: ethnicity),
        LocationScreen(onNext: _nextPage, onDataUpdate: _updateLocation, currentValue: location),
        IncomeScreen(onNext: _nextPage, questions: _questions, onDataUpdate: _updateIncome, currentValue: income),
        HealthConcernsScreen(onNext: _nextPage, questions: _questions, onDataUpdate: _updateHealthConcerns, currentValue: healthConcerns),
        DiagnosisHistoryScreen(onNext: _nextPage, questions: _questions, onDataUpdate: _updateDiagnoses, currentValue: diagnoses),
        MedicationsScreen(onNext: _nextPage, questions: _questions, onDataUpdate: _updateMedicationStatus, currentValue: medicationStatus),
        AddMedicationsScreen(onNext: _nextPage, questions: _questions, onDataUpdate: _updateMedications, currentValue: medications),
        LifeStageScreen(onNext: _nextPage, questions: _questions, onDataUpdate: _updateLifeStage, currentValue: lifeStage),
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
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Foxxbackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _currentPage > 0
                ? AppBar(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: AppColors.backgroundTopNav,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _previousPage,
                    ),
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
                    actions: const [SizedBox(width: 50)],
                  )
                : null,
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Error: $_error'),
                                  ElevatedButton(
                                      onPressed: _loadQuestions,
                                      child: const Text('Retry')),
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
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                )
                              : PageView.builder(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  onPageChanged: (index) =>
                                      setState(() => _currentPage = index),
                                  itemCount: screens.length,
                                  itemBuilder: (context, index) {
                                    final child = screens[index];
                                    final scrollablePages = [1, 5, 7, 8, 9, 10, 11, 12];
                                    if (scrollablePages.contains(index)) {
                                      return SingleChildScrollView(
                                        padding: AppSpacing.safeAreaHorizontalPadding,
                                        child: child,
                                      );
                                    }
                                    return Padding(
                                      padding: AppSpacing.safeAreaHorizontalPadding,
                                      child: child,
                                    );
                                  },
                                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}