import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/screens/loginScreen/login_screen.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_buttons.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.fullWidthButtonsHorizontal,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StackedButtons(
                  top: SecondaryButton(
                    label: 'Create An Account',
                    size: FoxxButtonSize.large,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(isSign: false),
                        ),
                      );
                    },
                  ),
                  bottom: OutlineButton(
                    label: 'Sign In',
                    size: FoxxButtonSize.large,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(isSign: true),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.textBoxHorizontalNoSafeArea,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 100),

                  // Logo
                  Center(
                    child: SvgPicture.asset(
                      'assets/svg/splash/Logo-Icon-Only.svg',
                      height: 120,
                      width: 120,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Welcome Text
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.textBoxHorizontalNoSafeArea,
                    ),
                    child: Text(
                      'Welcome to FoXX',
                      style: AppTypography.heading2,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info Carousel: auto-plays every 2000ms
                  SizedBox(
                      height: 350,
                      child: CarouselWithDotsScreen(
                        starburstBuilder: () => _buildStarburstSeparator(),
                      )),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarburstSeparator() {
    return Opacity(
      opacity: 0.3,
      child: SvgPicture.asset(
        'assets/svg/splash/Starburst.svg',
        width: 32,
        height: 32,
      ),
    );
  }
}

class CarouselWithDotsScreen extends StatefulWidget {
  final Widget Function() starburstBuilder;
  const CarouselWithDotsScreen({super.key, required this.starburstBuilder});

  @override
  State<CarouselWithDotsScreen> createState() => _CarouselWithDotsScreenState();
}

class _CarouselWithDotsScreenState extends State<CarouselWithDotsScreen> {
  int _currentPage = 0;

  // 🧩 1. Centralized data-driven slide definitions
  final List<_SlideData> _slideData = [
    _SlideData(
      text:
          'FoXX exists because women deserve better. Better answers, better tools, and care that actually listens.',
      textStyle: AppOSTextStyles.osMd.copyWith(
        fontWeight: AppTypography.semibold,
      ),
    ),
    _SlideData(
      text:
          'We\'ll start with a few questions, and your answers help us give you support that\'s truly personal.\n\nEvery detail matters. Your story, your experience, and your body all deserve to be understood.\n\nWe\'ll keep what you share safe, and always use it with care.',
      textStyle: AppTypography.bodyMd.copyWith(
        fontWeight: AppTypography.regular,
      ),
    ),
    _SlideData(
      text:
          'At the end of setup, you\'ll enter your payment details to begin your free trial. You\'re in control - no charge until it ends, and you can cancel anytime.',
      textStyle: AppTypography.bodyMd.copyWith(
        fontWeight: AppTypography.regular,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            itemCount: _slideData.length,
            itemBuilder: (context, index, realIndex) {
              final slide = _slideData[index];
              return _SlideContent(
                text: slide.text,
                textStyle: slide.textStyle,
                starburst: widget.starburstBuilder(),
              );
            },
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 2),
              autoPlayAnimationDuration: const Duration(milliseconds: 1500),
              pauseAutoPlayOnTouch: true,
              enableInfiniteScroll: true,
              onPageChanged: (index, reason) {
                setState(() => _currentPage = index);
              },
            ),
          ),
        ),

        // 🟣 Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slideData.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? AppColors.foxxBlack
                    : AppColors.gray600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Extracted model for each slide
class _SlideData {
  final String text;
  final TextStyle textStyle;

  const _SlideData({
    required this.text,
    required this.textStyle,
  });
}

/// Reusable slide widget
class _SlideContent extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Widget starburst;

  const _SlideContent({
    required this.text,
    required this.textStyle,
    required this.starburst,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.textBoxHorizontalNoSafeArea,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle,
          ),
        ),
        const SizedBox(height: 10),
        starburst,
      ],
    );
  }
}
