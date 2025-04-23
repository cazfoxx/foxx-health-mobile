import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/health_concers_screen.dart';
import 'create_account_screen.dart';
import 'about_yourself_screen.dart';
import 'age_selection_screen.dart';
import 'health_goals_screen.dart';
import 'hear_about_us_screen.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen(
      {super.key,
      this.isSocialAuth = false,
      required this.email,
      required this.isSignUp});

  bool isSocialAuth;
  bool isSignUp;
  String email;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      CreateAccountScreen(
        isSignUp: widget.isSignUp,
        email: widget.email,
      ),
      const AboutYourselfScreen(),
      const AgeSelectionScreen(),
      const HealthGoalsScreen(),
      const HealthConcersScreen(),
      const HearAboutUsScreen(),
    ];

    if (widget.isSocialAuth) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _pageController.jumpToPage(1);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.641,
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / _pages.length,
                      backgroundColor: Colors.grey[200],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                  if (_currentPage < _pages.length && _currentPage > 1)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Color(0xFF6B4EFF)),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      children: _pages,
                    ),
                  ),
                  OnboardingButton(
                    isEnabled: true,
                    text: _currentPage == 0 ? 'Create an Account' : 'Next',
                    onPressed: () {
                      nextPage();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
