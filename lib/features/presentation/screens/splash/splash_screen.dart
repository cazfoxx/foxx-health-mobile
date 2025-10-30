import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/screens/loginScreen/login_screen.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
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
                      )
                      ),

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

  List<Widget> get _slides => [
        // Slide 1
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.textBoxHorizontalNoSafeArea,
              ),
              child: Text(
                'FoXX exists because women deserve better. Better answers, better tools, and care that actually listens.',
                textAlign: TextAlign.center,
                style: AppOSTextStyles.osMd
                    .copyWith(fontWeight: AppTypography.semibold),
              ),
            ),
            const SizedBox(height: 10),
            widget.starburstBuilder(),
          ],
        ),
        // Slide 2
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.textBoxHorizontalNoSafeArea,
              ),
              child: Text(
                'We\'ll start with a few questions, and your answers help us give you support that\'s truly personal.\n\nEvery detail matters. Your story, your experience, and your body all deserve to be understood.\n\nWe\'ll keep what you share safe, and always use it with care.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd
                    .copyWith(fontWeight: AppTypography.regular),
              ),
            ),
            const SizedBox(height: 10),
            widget.starburstBuilder(),
          ],
        ),
        // Slide 3
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.textBoxHorizontalNoSafeArea,
              ),
              child: Text(
                'At the end of setup, you\'ll enter your payment details to begin your free trial. You\'re in control - no charge until it ends, and you can cancel anytime.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMd
                    .copyWith(fontWeight: AppTypography.regular),
              ),
            ),
            const SizedBox(height: 10),
            widget.starburstBuilder(),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            // carouselController: _controller,
            itemCount: _slides.length,
            itemBuilder: (context, index, realIndex) {
              return _slides[index];
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
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
        ),

        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _slides.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
