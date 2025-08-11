import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/screens/loginScreen/login_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  
                  // Logo
                  Center(
                    child: SvgPicture.asset(
                      'assets/svg/splash/foxx_logo_splash.svg',
                      height: 120,
                      width: 120,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Welcome Text
                   Text(
                    'Welcome to FoXX',
                    style: AppHeadingTextStyles.h2.copyWith(color: AppColors.primary01),
                  ),
                  
                  
                  const SizedBox(height: 40),
                  
                  // First Text Block
                   Text(
                    'FoXX exists because women deserve better. Better answers, better tools, and care that actually listens.',
                    textAlign: TextAlign.center,
                    style: AppOSTextStyles.osMdSemiboldBody.copyWith(color: AppColors.primary01),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Starburst Separator
                  _buildStarburstSeparator(),
                  
                  const SizedBox(height: 10),
                  
                  // Second Text Block
                   Text(
                    'We don\'t miss the details, because your story, your experience, and your body all matter. From the questions we ask to how we protect your data, everything is built on trust and intention.',
                    textAlign: TextAlign.center,
                    style: AppOSTextStyles.osMd.copyWith(color: AppColors.primary01),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Starburst Separator
                  _buildStarburstSeparator(),
                  
                  const SizedBox(height: 10),
                  
                  // Third Text Block
                   Text(
                    'At the end of setup, you\'ll enter your payment details to begin your free trial. You\'re in control - no charge until it ends, and you can cancel anytime.',
                    textAlign: TextAlign.center,
                    style: AppOSTextStyles.osMd.copyWith(color: AppColors.primary01),
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Buttons
                  SizedBox(
                    width: double.infinity,

                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(isSign: false),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Create An Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,

                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(isSign: true),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        side: const BorderSide(
                          color: Color(0xFF805EC9),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStarburstSeparator() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E6F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.star,
        size: 12,
        color: Color(0xFFB8B5C7),
      ),
    );
  }
}
