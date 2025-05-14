import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key, required this.isSign});
  bool isSign;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController =
      TextEditingController(); // Add password controller
  bool _agreeToTerms = false;
  bool _isOver16 = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to controllers to check form validity
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasLetterAndNumber =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
    final hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);

    return hasMinLength && hasLetterAndNumber && hasCapitalLetter;
  }

  void _updateButtonState() {
    setState(() {
      if (widget.isSign) {
        // For sign in, only check email and password
        _isButtonEnabled = _emailController.text.trim().isNotEmpty &&
            _passwordController.text.trim().isNotEmpty;
      } else {
        // For sign up, check all conditions including terms and age
        _isButtonEnabled = _emailController.text.trim().isNotEmpty &&
            _passwordController.text.trim().isNotEmpty &&
            validatePassword(_passwordController.text) &&
            _agreeToTerms &&
            _isOver16;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          // Remove the Expanded here
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildLoginForm(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/foxx_logo.svg',
            height: 65,
            width: 65,
          ),
          Text(
            widget.isSign ? 'Sign In' : 'Create New Account',
            style: AppTextStyles.body.copyWith(
              color: AppColors.amethystViolet,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Expanded(
            // This will take the remaining space
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  OnboardingHeadingContainer(
                    title: 'Just an email, that\'s it',
                    subtitle:
                        'We prioritize your privacy and security, which is why we only require your email to sign up. No social media logins necessary',
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  widget.isSign
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _agreeToTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _agreeToTerms = value ?? false;
                                        _updateButtonState();
                                      });
                                    },
                                    activeColor: AppColors.amethystViolet,
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          const TextSpan(text: 'I agree to '),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: const TextStyle(
                                              color: AppColors.amethystViolet,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                          const TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Terms and Conditions',
                                            style: const TextStyle(
                                              color: AppColors.amethystViolet,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _isOver16,
                                    onChanged: (value) {
                                      setState(() {
                                        _isOver16 = value ?? false;
                                        _updateButtonState();
                                      });
                                    },
                                    activeColor: AppColors.amethystViolet,
                                  ),
                                  const Text(
                                    'I am 16 years or older',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isSign = !widget.isSign;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.isSign
                              ? "Don’t have an account?"
                              : 'Already have an account?',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          widget.isSign ? ' Sign Up' : ' Sign In',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColors.amethystViolet,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: BlocConsumer<LoginCubit, LoginState>(
                      listener: (context, state) {
                        if (state is LoginSuccess) {
                          if (!widget.isSign) {
                            // If it's sign up, navigate to onboarding
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnboardingScreen(),
                              ),
                            );
                          } else {
                            // If it's sign in, navigate to home
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        } else if (state is LoginError) {
                          // Show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isButtonEnabled
                                ? () {
                                  final loginCubit =  context.read<LoginCubit>();
                                    loginCubit.setUserDetails(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );
                                    if (!widget.isSign) {
                                      // If it's sign up, navigate to onboarding
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OnboardingScreen(),
                                        ),
                                      );
                                    } else {
                                      // If it's sign in, navigate to home
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                        ),
                                      );
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isButtonEnabled
                                  ? AppColors.amethystViolet
                                  : Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: state is LoginLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    widget.isSign
                                        ? 'Sign In'
                                        : 'Create An Account',
                                    style: TextStyle(
                                      color: _isButtonEnabled
                                          ? Colors.white
                                          : Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Add bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
