import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/health_concers_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'about_yourself_screen.dart';
import 'age_selection_screen.dart';
import 'health_goals_screen.dart';
import 'hear_about_us_screen.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({
    super.key,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<Widget> _pages;
  final _aboutYourselfKey = GlobalKey<AboutYourselfScreenState>();
  final _ageSelectionKey = GlobalKey<AgeSelectionScreenState>();
  final _healthGoalsKey = GlobalKey<HealthGoalsScreenState>();
  final _healthConcernsKey = GlobalKey<HealthConcersScreenState>();
  final _hearAboutUsKey = GlobalKey<HearAboutUsScreenState>();

  @override
  void initState() {
    super.initState();
    _pages = [
      AboutYourselfScreen(key: _aboutYourselfKey),
      AgeSelectionScreen(key: _ageSelectionKey),
      HealthGoalsScreen(key: _healthGoalsKey),
      HealthConcersScreen(key: _healthConcernsKey),
      HearAboutUsScreen(key: _hearAboutUsKey),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_currentPage == 0) {
      // Get the AboutYourselfScreen state using the key
      final aboutYourselfState = _aboutYourselfKey.currentState;

      if (aboutYourselfState != null) {
        // Get user details
        final username = aboutYourselfState.getUserName();
        final pronoun = aboutYourselfState.getPronoun();

        // Update LoginCubit
        final loginCubit = context.read<LoginCubit>();
        loginCubit.setUserDetails(
          fullName: username.trim(),
          username: username.trim(),
          pronoun: pronoun,
        );
      }
    } else if (_currentPage == 1) {
      // Get the AgeSelectionScreen state using the key
      final ageSelectionState = _ageSelectionKey.currentState;

      if (ageSelectionState != null) {
        // Get age range
        final ageRange = ageSelectionState.getSelectedAgeRange();

        // Update LoginCubit
        final loginCubit = context.read<LoginCubit>();
        loginCubit.setUserDetails(
          age: ageRange,
        );
      }
    } else if (_currentPage == 2) {
      // Get the HealthGoalsScreen state
      final healthGoalsState = _healthGoalsKey.currentState;

      if (healthGoalsState != null) {
        // Get selected health goals
        final selectedGoals = healthGoalsState.getSelectedGoals();

        // Update LoginCubit
        final loginCubit = context.read<LoginCubit>();
        loginCubit.setHealthGoals(selectedGoals);
      }
    } else if (_currentPage == 3) {
      // Get the HealthConcernsScreen state
      final healthConcernsState = _healthConcernsKey.currentState;

      if (healthConcernsState != null) {
        // Get selected health concerns
        final selectedConcerns = healthConcernsState.getSelectedConcerns();

        // Update LoginCubit
        final loginCubit = context.read<LoginCubit>();
        loginCubit.setHealthConcerns(selectedConcerns);
      }
    } else if (_currentPage == 4) {
      // Get the HearAboutUsScreen state
      final hearAboutUsState = _hearAboutUsKey.currentState;

      if (hearAboutUsState != null) {
        // Get referral source
        final referralSource = hearAboutUsState.getSelectedOption();

        // Update LoginCubit
        final loginCubit = context.read<LoginCubit>();
        loginCubit.setUserDetails(
          referralSource: referralSource,
        );
      }
    }
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Get the LoginCubit
      final loginCubit = context.read<LoginCubit>();

      // Register the user
      loginCubit.registerUser();

      // Navigate to HomeScreen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (_currentPage > 0) {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        title: LinearProgressIndicator(
          value: (_currentPage + 1) / _pages.length,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sunglow),
          minHeight: 4,
        ),
        titleSpacing: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFF6B4EFF),
                fontSize: 16,
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
                children: _pages,
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 16.0),
                OnboardingButton(
                  text: _currentPage == _pages.length - 1 ? 'Finish' : 'Next',
                  onPressed: () {
                    nextPage();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
