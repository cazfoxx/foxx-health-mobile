import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
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
import 'package:foxxhealth/features/presentation/screens/onboarding/widgets/otp_verification_screen.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_app_bar.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_buttons.dart';

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

  Future<void> _createAccount() async {
    print('🚀 Starting account creation...');
    setState(() => _isCreatingAccount = true);

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
      print('📩 registerUser() returned: $registrationResponse');

      setState(() => _isCreatingAccount = false);

      if (registrationResponse == null ||
          registrationResponse['direct_login'] == true) {
        // Already registered → direct login, skip OTP
        print('✅ Direct login detected, completing onboarding immediately');
        await _completeOnboardingAfterLogin(onboardingCubit);
        return;
      }

      // Normal registration → navigate to OTP
      print('📬 Navigating to OTPVerificationScreen...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            email: widget.email,
            onSuccess: () async {
              print('✅ OTP verified successfully — completing onboarding');
              await _completeOnboardingAfterLogin(onboardingCubit);
            },
          ),
        ),
      );
    } catch (e, st) {
      print('❌ Error creating account: $e\n$st');
      setState(() => _isCreatingAccount = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating account: $e')),
      );
    }
  }

  // Future<void> _completeOnboardingAfterLogin(
  //     OnboardingCubit onboardingCubit) async {
  //   try {
  //     final token = AppStorage.accessToken;
  //     if (token == null) await AppStorage.loadCredentials();
  //     // await Future.delayed(const Duration(seconds: 2));

  //     onboardingCubit.setOnboardingData(
  //       userName: username,
  //       gender: genderIdentity,
  //       age: age,
  //       weight: weight,
  //       height: height?['feet'] != null
  //           ? (height!['feet'] * 30.48 + height!['inches'] * 2.54)
  //           : null,
  //       ethnicity: ethnicity?.join(', '),
  //       address: location,
  //       householdIncomeRange: income,
  //       healthConcerns: healthConcerns?.toList() ?? [],
  //       healthHistory: diagnoses?.toList() ?? [],
  //       medicationsOrSupplementsIndicator: medicationStatus,
  //       medicationsOrSupplements: medications ?? [],
  //       currentStageInLife: lifeStage != null ? [lifeStage!] : [],
  //       privacyPolicyAccepted: dataPrivacyAccepted ?? false,
  //       sixteenAndOver: true,
  //       isActive: true,
  //       denPrivacy: ['posts'],
  //       profileIconUrl: null,
  //     );

  //     await onboardingCubit.submitOnboardingData();
  //     Navigator.of(context).pushReplacement(
  //       MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text('Error completing onboarding: $e'),
  //           backgroundColor: Colors.red),
  //     );
  //   }
  // }

//   Future<void> _completeOnboardingAfterLogin(OnboardingCubit onboardingCubit) async {
//   setState(() => _isCreatingAccount = true);

//   try {
//     final loginCubit = context.read<LoginCubit>();

//     // Ensure token is loaded
//     final token = AppStorage.accessToken;
//     if (token == null) await AppStorage.loadCredentials();

//     // Submit onboarding data
//     onboardingCubit.setOnboardingData(
//       userName: username,
//       gender: genderIdentity,
//       age: age,
//       weight: weight,
//       height: height?['feet'] != null
//           ? (height!['feet'] * 30.48 + height!['inches'] * 2.54)
//           : null,
//       ethnicity: ethnicity?.join(', '),
//       address: location,
//       householdIncomeRange: income,
//       healthConcerns: healthConcerns?.toList() ?? [],
//       healthHistory: diagnoses?.toList() ?? [],
//       medicationsOrSupplementsIndicator: medicationStatus,
//       medicationsOrSupplements: medications ?? [],
//       currentStageInLife: lifeStage != null ? [lifeStage!] : [],
//       privacyPolicyAccepted: dataPrivacyAccepted ?? false,
//       sixteenAndOver: true,
//       isActive: true,
//       denPrivacy: ['posts'],
//       profileIconUrl: null,
//     );

//     await onboardingCubit.submitOnboardingData();

//     // Optionally: preload critical user info directly from LoginCubit or API
//     // await loginCubit.loadCurrentUserData(); // implement if needed

//     // Navigate directly to MainNavigationScreen
//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error completing onboarding: $e'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   } finally {
//     setState(() => _isCreatingAccount = false);
//   }
// }

// Future<void> _completeOnboardingAfterLogin(OnboardingCubit onboardingCubit) async {
//   setState(() => _isCreatingAccount = true);

//   try {
//     // Load token if not already
//     final token = AppStorage.accessToken;
//     if (token == null) await AppStorage.loadCredentials();

//     // Prepare onboarding data
//     onboardingCubit.setOnboardingData(
//       userName: username,
//       gender: genderIdentity,
//       age: age,
//       weight: weight,
//       height: height?['feet'] != null
//           ? (height!['feet'] * 30.48 + height!['inches'] * 2.54)
//           : null,
//       ethnicity: ethnicity?.join(', '),
//       address: location,
//       householdIncomeRange: income,
//       healthConcerns: healthConcerns?.toList() ?? [],
//       healthHistory: diagnoses?.toList() ?? [],
//       medicationsOrSupplementsIndicator: medicationStatus,
//       medicationsOrSupplements: medications ?? [],
//       currentStageInLife: lifeStage != null ? [lifeStage!] : [],
//       privacyPolicyAccepted: dataPrivacyAccepted ?? false,
//       sixteenAndOver: true,
//       isActive: true,
//       denPrivacy: ['posts'],
//       profileIconUrl: null,
//     );

//     // Submit onboarding
//     await onboardingCubit.submitOnboardingData();

//     final ApiClient apiClient = ApiClient();

//     // Fetch optional appointment companions (silently ignore 404)
//     try {
//       final companionsResponse =
//           await apiClient.get('/api/v1/appointment-companions/me');
//       print('Companions: ${companionsResponse.data}');
//     } catch (error) {
//       if (error is DioError && error.response?.statusCode == 404) {
//         print('No appointment companions found — safe to ignore.');
//       } else {
//         print('Unexpected error fetching companions: $error');
//       }
//     }

//     // Navigate directly to MainNavigationScreen
//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error completing onboarding: $e'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   } finally {
//     setState(() => _isCreatingAccount = false);
//   }
// }

// Future<void> _completeOnboardingAfterLogin(OnboardingCubit onboardingCubit) async {
//   setState(() => _isCreatingAccount = true);

//   try {
//     final token = AppStorage.accessToken;
//     if (token == null) await AppStorage.loadCredentials();

//     onboardingCubit.setOnboardingData(
//       userName: username,
//       gender: genderIdentity,
//       age: age ?? 0,
//       weight: weight ?? 0,
//       height: height?['feet'] != null
//           ? (height!['feet'] * 30.48 + height!['inches'] * 2.54).round()
//           : 0,
//       ethnicity: ethnicity?.join(', ') ?? '',
//       address: location ?? '',
//       householdIncomeRange: income ?? '',
//       healthConcerns: healthConcerns?.toList() ?? [],
//       healthHistory: diagnoses?.toList() ?? [],
//       medicationsOrSupplementsIndicator: medicationStatus ?? '',
//       medicationsOrSupplements: medications ?? [],
//       currentStageInLife: lifeStage != null ? [lifeStage!] : [],
//       // ✅ NEW required fields
//       moodEnergyCognitiveSupport: [],
//       gutAndImmuneSupport: [],
//       overTheCounterMedications: [],
//       vitaminsAndSupplements: [],
//       herbalAndAdaptogens: [],
//       // role: 'user',
//       // Existing
//       privacyPolicyAccepted: dataPrivacyAccepted ?? false,
//       sixteenAndOver: true,
//       isActive: true,
//       denPrivacy: ['posts'],
//       profileIconUrl: null,
//     );

//     await onboardingCubit.submitOnboardingData();

//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
//     );
//   } catch (e) {
//     if (e is DioError && e.response != null) {
//       print('❌ DioError: ${e.response?.statusCode}');
//       print('❌ Response data: ${e.response?.data}');
//     } else {
//       print('❌ Error: $e');
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error completing onboarding: ${e.toString()}'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   } finally {
//     setState(() => _isCreatingAccount = false);
//   }
// }

// Future<void> _completeOnboardingAfterLogin(OnboardingCubit onboardingCubit) async {
//   setState(() => _isCreatingAccount = true);

//   try {
//     final token = AppStorage.accessToken;
//     if (token == null) await AppStorage.loadCredentials();

//     print('🔥 Submitting onboarding data...');
//     await onboardingCubit.submitOnboardingData();
//     print('✅ Onboarding submission done!');

//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
//     );
//   } catch (e) {
//     if (e is DioError && e.response != null) {
//       print('❌ DioError: ${e.response?.statusCode}');
//       print('❌ Response data: ${e.response?.data}');
//     } else {
//       print('❌ Error: $e');
//     }

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Error completing onboarding: ${e.toString()}'),
//         backgroundColor: Colors.red,
//       ),
//     );
//   } finally {
//     setState(() => _isCreatingAccount = false);
//   }
// }


Future<void> _completeOnboardingAfterLogin(OnboardingCubit onboardingCubit) async {
  setState(() => _isCreatingAccount = true);
  try {
    final success = await onboardingCubit.submitOnboardingData();
    if (!mounted) return;

    if (success) {
      // ✅ Onboarding done
      await AppStorage.setBool('onboardingCompleted', true);

      // 🚫 Remove any extra AccountService call here!
      // await AccountService().getCurrentUser(); <-- remove

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  } catch (e) {
    print('❌ Error completing onboarding: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed: $e'), backgroundColor: Colors.red),
    );
  } finally {
    setState(() => _isCreatingAccount = false);
  }
}





  // Future<void> _completeOnboarding() async {
  //   setState(() => _isCreatingAccount = true);

  //   try {
  //     final onboardingCubit = context.read<OnboardingCubit>();

  //     // Prepare data from all pages
  //     onboardingCubit.setOnboardingData(
  //       userName: username,
  //       gender: genderIdentity,
  //       age: age,
  //       weight: weight,
  //       // height: height != null ? 
  //       height: (height?['feet'] != null && height?['inches'] != null) ?//height!['feet'] * 30.48 + height!['inches'] * 2.54
  //          (height?['feet'] * 30.48) + (height?['inches'] * 2.54) : null,
  //       ethnicity: ethnicity?.join(', '),
  //       address: location,
  //       householdIncomeRange: income,
  //       healthConcerns: healthConcerns?.toList() ?? [],
  //       healthHistory: diagnoses?.toList() ?? [],
  //       medicationsOrSupplementsIndicator: medicationStatus,
  //       medicationsOrSupplements: medications ?? [],
  //       currentStageInLife: lifeStage != null ? [lifeStage!] : [],
  //       privacyPolicyAccepted: dataPrivacyAccepted ?? true,
  //       moodEnergyCognitiveSupport: [],
  //       gutAndImmuneSupport: [],
  //       overTheCounterMedications: [],
  //       vitaminsAndSupplements: [],
  //       herbalAndAdaptogens: [],
  //       sixteenAndOver: true,
  //       isActive: true,
  //       denPrivacy: ['posts'],
  //       profileIconUrl: null,
  //     );

  //     await onboardingCubit.submitOnboardingData();

  //     if (!mounted) return;
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error completing onboarding: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   } finally {
  //     setState(() => _isCreatingAccount = false);
  //   }
  // }
  


  Future<void> _completeOnboarding() async {
  setState(() => _isCreatingAccount = true);

  try {
    final onboardingCubit = context.read<OnboardingCubit>();

    // Ensure required fields are valid
    final safeGender = (genderIdentity != null && genderIdentity!.isNotEmpty)
        ? genderIdentity
        : 'unspecified';
    final safeWeight = (weight != null && weight! > 0) ? weight : 50.0; // default 50 kg
    final safeHeight = (height != null &&
            height!['feet'] != null &&
            height!['inches'] != null)
        ? (height!['feet'] * 30.48) + (height!['inches'] * 2.54)
        : 160.0; // default 160 cm
    final safeAge = (age != null && age! > 0) ? age : 25; // default age
    final safePrivacyAccepted = dataPrivacyAccepted ?? true;

    // Normalize strings
    final safeIncome = income?.replaceAll('–', '-') ?? 'Not specified';
    final safeEthnicity = ethnicity?.join(', ') ?? 'Not specified';
    final safeHealthConcerns = healthConcerns?.toList() ?? [];
    final safeDiagnoses = diagnoses?.toList() ?? [];
    final safeMedications = medications ?? [];
    final safeLifeStage = lifeStage != null
    ? [lifeStage.toString()]
    : <String>[];
    // final safeLifeStage = lifeStage != null ? [lifeStage!] : [];

    // Bulk update the cubit with sanitized data
    onboardingCubit.setOnboardingData(
      userName: username ?? 'User',
      gender: safeGender,
      age: safeAge,
      weight: safeWeight,
      height: safeHeight,
      ethnicity: safeEthnicity,
      address: location ?? 'Not specified',
      householdIncomeRange: safeIncome,
      healthConcerns: safeHealthConcerns,
      healthHistory: safeDiagnoses,
      medicationsOrSupplementsIndicator: medicationStatus ?? 'Prefer not to say',
      medicationsOrSupplements: safeMedications,
      currentStageInLife: safeLifeStage,
      moodEnergyCognitiveSupport: [], // optional, leave empty
      gutAndImmuneSupport: [],
      overTheCounterMedications: [],
      vitaminsAndSupplements: [],
      herbalAndAdaptogens: [],
      privacyPolicyAccepted: safePrivacyAccepted,
      sixteenAndOver: true,
      isActive: true,
      denPrivacy: ['posts'],
      profileIconUrl: null,
    );

    // Submit to API
    final success = await onboardingCubit.submitOnboardingData();

    if (!mounted) return;

    if (success) {
      await AppStorage.setBool('onboardingCompleted', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error completing onboarding: $e'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() => _isCreatingAccount = false);
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

  List<Widget> get screens => [
        UsernameScreen(
          onNext: _nextPage,
          onDataUpdate: _updateUsername,
          currentValue: username,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        GenderIdentityScreen(
          onNext: _nextPage,
          questions: _questions,
          onDataUpdate: _updateGender,
          currentValue: genderIdentity,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        AgeSelectionRevampScreen(
          onNext: _nextPage,
          onDataUpdate: _updateAge,
          questions: _questions,
          currentValue: age,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        WeightInputScreen(
          onNext: _nextPage,
          onDataUpdate: _updateWeight,
          questions: _questions,
          currentValue: weight,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        HeightInputScreen(
          onNext: _nextPage,
          onDataUpdate: _updateHeight,
          questions: _questions,
          currentValue: height,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        EthnicityScreen(
          onNext: _nextPage,
          questions: _questions,
          onDataUpdate: _updateEthnicity,
          currentValue: ethnicity,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        LocationScreen(
          onNext: _nextPage,
          onDataUpdate: _updateLocation,
          currentValue: location,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        IncomeScreen(
          onNext: _nextPage,
          questions: _questions,
          onDataUpdate: _updateIncome,
          currentValue: income,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        HealthConcernsScreen(
          onNext: _nextPage,
          questions: _questions,
          onDataUpdate: _updateHealthConcerns,
          currentValue: healthConcerns,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        DiagnosisHistoryScreen(
          onNext: _nextPage,
          questions: _questions,
          onDataUpdate: _updateDiagnoses,
          currentValue: diagnoses,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        MedicationsScreen(
          onNext: _nextPage,
          questions: _questions,
          onDataUpdate: _updateMedicationStatus,
          currentValue: medicationStatus,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        AddMedicationsScreen(
          onNext: _nextPage,
          questions: _questions,
          onDataUpdate: _updateMedications,
          currentValue: medications,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        LifeStageScreen(
          onNext: _nextPage,
          questions: _questions,
          onDataUpdate: _updateLifeStage,
          currentValue: lifeStage,
          onEligibilityChanged: (valid) => _canProceedNotifier.value = valid,
        ),
        DataPrivacyScreen(onNext: _completeOnboarding, onDataUpdate: _updateDataPrivacy,),
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
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Foxxbackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _currentPage > 0
                ? FoxxAppBar(
                    showBack: true,
                    onBack: _previousPage,
                    progress: (_currentPage + 1) / screens.length,
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
                                      Text(
                                          'Please wait while we set up your profile',
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
                                    final noPaddingPages = [
                                      screens.length - 1
                                    ]; // DataPrivacyScreen
                                    final scrollablePages = [
                                      1,
                                      5,
                                      7,
                                      8,
                                      9,
                                      10,
                                      11,
                                      12
                                    ];

                                    if (noPaddingPages.contains(index)) {
                                      return child;
                                    }
                                    if (scrollablePages.contains(index)) {
                                      return SingleChildScrollView(
                                        padding: AppSpacing
                                            .safeAreaHorizontalPadding,
                                        child: child,
                                      );
                                    }
                                    return Padding(
                                      padding:
                                          AppSpacing.safeAreaHorizontalPadding,
                                      child: child,
                                    );
                                  },
                                ),
                ],
              ),
            ),
            // Keyboard-aware bottom bar for consistent actions
            bottomNavigationBar: ValueListenableBuilder<bool>(
              valueListenable: _canProceedNotifier,
              builder: (context, canProceed, _) {
                return KeyboardAwareBottomBar(
                  primaryButton: PrimaryButton(
                    label: 'Next',
                    onPressed: _nextPage,
                    isEnabled: canProceed, // bind eligibility
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
