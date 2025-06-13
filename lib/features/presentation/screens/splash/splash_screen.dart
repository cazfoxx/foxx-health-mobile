import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/screens/loginScreen/login_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:Container(
        height: 150,
        color: Colors.white,
        child: Column(
          children: [
             Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(
                                    isSign: false,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amethystViolet,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen(isSign: true)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: AppColors.amethystViolet,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amethystViolet,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/splash/foxx_logo_splash.svg',
                      height: 134,
                      width: 134,
                    ),
                    // const SizedBox(height: 8),
                    // const Text(
                    //   'FoXX Health',
                    //   style: TextStyle(
                    //     fontSize: 24,
                    //     color: AppColors.amethystViolet,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                color: AppColors.background,
                padding: EdgeInsets.only(right: 20, left: 20, bottom: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Your health toolkit',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      'Symptom tracking',
                      'Understand your body. Log symptoms, and spot trends over time',
                      image: 'assets/svg/splash/symptom_tracking.svg',
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      'Appointment preparation',
                      'Personalized questions and checklists to help you advocate for yourself',
                      image: 'assets/svg/splash/appointment.svg',
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      'Trusted health information',
                      'Access expert-backed, science-based guidance when you need it',
                      image: 'assets/svg/splash/health_information.svg',
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureItem(
                      'Personal Health Guide',
                      'A guided assessment to personalize your journey and get you the support you actually need',
                      image: 'assets/svg/splash/personal_health_guide.svg',
                    ),
                  ],
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, {required String image}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: AppColors.amethystViolet,
              width: 1,
            ),
          ),
          child: SvgPicture.asset(image,
            width: 30,
            height: 30,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9A9CAA),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
