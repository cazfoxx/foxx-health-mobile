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

  const OnboardingFlow(
      {super.key, required this.email, required this.password});

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
    if (_currentPage < screens.length - 1) {
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

      // Print all collected onboarding data for debugging
      print('=== ONBOARDING DATA COLLECTED ===');
      print('Email: ${widget.email}');
      print('Password: [HIDDEN]');
      print('Username: $username');
      print('Gender Identity: $genderIdentity');
      print('Age: $age');
      print('Weight: $weight');
      print('Height: $height (feet: ${height?['feet']}, inches: ${height?['inches']})');
      print('Height in CM: ${height?['feet'] != null ? (height!['feet'] * 30.48 + height!['inches'] * 2.54) : null}');
      print('Ethnicity: $ethnicity');
      print('Location: $location');
      print('Income: $income');
      print('Health Concerns: $healthConcerns');
      print('Diagnoses: $diagnoses');
      print('Medication Status: $medicationStatus');
      print('Medications: $medications');
      print('Life Stage: $lifeStage');
      print('Data Privacy Accepted: $dataPrivacyAccepted');
      print('================================');

      // Set all the collected data in the LoginCubit
      loginCubit.setUserDetails(
        email: widget.email,
        password: widget.password,
        username: username,
        age: age?.toString(),
        referralSource: 'Onboarding Flow',
      );

      // Set health goals and concerns if available
      if (healthConcerns != null && healthConcerns!.isNotEmpty) {
        loginCubit.setHealthConcerns(healthConcerns!.toList());
      }

      // Register the user using LoginCubit
      final registrationResponse = await loginCubit.registerUser(context);

      if (registrationResponse != null) {
        setState(() {
          _isCreatingAccount = false;
        });

        // Check if this was a direct login (existing user)
        if (registrationResponse['direct_login'] == true) {
          print('✅ Existing user logged in directly! Proceeding with onboarding...');
          
          // For existing users, proceed directly to onboarding completion
          await _completeOnboardingAfterLogin(onboardingCubit);
        } else {
          print('✅ Registration successful! Showing OTP verification...');
          
          // Show OTP verification bottom sheet for new users
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
        print('❌ Registration failed!');
        // Error is already handled by LoginCubit and shown via Snackbar
        setState(() {
          _isCreatingAccount = false;
        });
      }
    } catch (e) {
      print('❌ Error in onboarding process: $e');
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

  Future<void> _completeOnboardingAfterLogin(OnboardingCubit onboardingCubit) async {
    try {
      // Check if token is available immediately
      final token = AppStorage.accessToken;
      print('🔍 Token immediately after login: ${token != null ? "Present (${token.length} chars)" : "NULL"}');
      
      // If token is null, try to reload credentials
      if (token == null) {
        print('⚠️ Token is null, reloading credentials...');
        await AppStorage.loadCredentials();
        print('🔍 Token after reload: ${AppStorage.accessToken != null ? "Present (${AppStorage.accessToken!.length} chars)" : "NULL"}');
      }
      
      // Add a delay to ensure the login token is properly set
      await Future.delayed(const Duration(seconds: 2));
      
      // Check token again after delay
      final tokenAfterDelay = AppStorage.accessToken;
      print('🔍 Token after 2s delay: ${tokenAfterDelay != null ? "Present (${tokenAfterDelay.length} chars)" : "NULL"}');

      // After successful login, set all onboarding data and submit to onboarding API
      onboardingCubit.setOnboardingData(
        userName: username,
        gender: genderIdentity,
        age: age,
        weight: weight,
        height: height?['feet'] != null
            ? (height!['feet'] * 30.48 + height!['inches'] * 2.54)
            : null,
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
        denPrivacy: ['posts'], // Default value as per API spec
        profileIconUrl: null, // Can be set later if needed
      );

      // Print the data being sent to API
      print('=== API PAYLOAD DATA ===');
      final apiData = onboardingCubit.getOnboardingData();
      apiData.forEach((key, value) {
        print('$key: $value');
      });
      print('========================');

      // Submit onboarding data to API
      final onboardingSuccess = await onboardingCubit.submitOnboardingData();

      if (onboardingSuccess) {
        print('✅ Onboarding API call successful!');
        // Navigate to main navigation screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainNavigationScreen(),
          ),
        );
      } else {
        print('❌ Onboarding API call failed!');
        // Onboarding API failed but login was successful
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Account created successfully! Onboarding data will be saved later.'),
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
    } catch (e) {
      print('❌ Error completing onboarding: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error completing onboarding: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
    context
        .read<OnboardingCubit>()
        .setMedicationsOrSupplementsIndicator(medicationStatus);
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
    context
        .read<OnboardingCubit>()
        .setPrivacyPolicyAccepted(dataPrivacyAccepted);
  }

  PreferredSizeWidget? _headerForPage() {
    return null;
  }

  List<Widget> get screens => [
        UsernameScreen(onNext: _nextPage, onDataUpdate: _updateUsername),
        GenderIdentityScreen(
            onNext: _nextPage,
            questions: _questions,
            onDataUpdate: _updateGender),
        AgeSelectionRevampScreen(onNext: _nextPage, onDataUpdate: _updateAge),
        WeightInputScreen(onNext: _nextPage, onDataUpdate: _updateWeight),
        HeightInputScreen(onNext: _nextPage, onDataUpdate: _updateHeight),
        EthnicityScreen(
            onNext: _nextPage,
            questions: _questions,
            onDataUpdate: _updateEthnicity),
        LocationScreen(onNext: _nextPage, onDataUpdate: _updateLocation),
        IncomeScreen(
            onNext: _nextPage,
            questions: _questions,
            onDataUpdate: _updateIncome),
        HealthConcernsScreen(
            onNext: _nextPage,
            questions: _questions,
            onDataUpdate: _updateHealthConcerns),
        DiagnosisHistoryScreen(
            onNext: _nextPage,
            questions: _questions,
            onDataUpdate: _updateDiagnoses),
        MedicationsScreen(
            onNext: _nextPage,
            questions: _questions,
            onDataUpdate: _updateMedicationStatus),
        AddMedicationsScreen(
            onNext: _nextPage,
            questions: _questions,
            onDataUpdate: _updateMedications),
        LifeStageScreen(
            onNext: _nextPage,
            questions: _questions,
            onDataUpdate: _updateLifeStage),
        DataPrivacyScreen(onNext: _nextPage, onDataUpdate: _updateDataPrivacy),
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
            appBar: _currentPage > 0
                ? AppBar(
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: AppColors.backgroundTopNav,
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.progressBarSelected),
                        minHeight: 4,
                      ),
                    ),
                    actions: [
                      SizedBox(width: 50),
                    ],
                    bottom: _headerForPage(),
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
                              : PageView.builder(
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  onPageChanged: (index) => setState(() => _currentPage = index),
                                  itemCount: screens.length,
                                  itemBuilder: (context, index) {
                                    final child = screens[index];
                                    return (index == 9)
                                        ? SingleChildScrollView(
                                            padding: AppSpacing.safeAreaHorizontalPadding,
                                            child: Builder(
                                              builder: (context) => child,
                                            ),
                                          )
                                        : Padding(
                                            padding: EdgeInsets.zero,
                                            child: child,
                                          );
                                  },
                                ),
                  if (!_isLoading && !_isCreatingAccount && _error == null)
                    Positioned(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      left: 16,
                      right: 16,
                      child: Builder(
                        builder: (context) {
                          final currentChild = screens[_currentPage];
                          bool showButton = false;
                          VoidCallback? onPressed;

                          if (currentChild is HasNextButtonState) {
                            final state =
                                (currentChild as HasNextButtonState).getNextButtonState();
                            showButton = state.show;
                            onPressed = state.onPressed;
                          } else {
                            // Default behavior
                            showButton = true;
                            onPressed = _nextPage;
                          }

                          return AnimatedOpacity(
                            opacity: showButton ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Visibility(
                              visible: showButton,
                              child: FoxxNextButton(
                                text: 'Next',
                                isEnabled: true,
                                onPressed: onPressed,
                              ),
                            ),
                          );
                        },
                      ),
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