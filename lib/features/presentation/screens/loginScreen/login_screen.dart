import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/api_logger/api_logger_screen.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/screens/forgotPassword/forgot_password_screen.dart';

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
  bool _obscurePassword = true; // Add this variable
  bool _hasMinLength = false;
  bool _hasLetterAndNumber = false;
  bool _hasCapitalLetter = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updatePasswordValidation);
  }

  void _updatePasswordValidation() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasLetterAndNumber =
          RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
      _hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);
      _updateButtonState();
    });
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
        // For sign in, check email validation and password
        _isButtonEnabled = _formKey.currentState?.validate() ??
            false &&
                _emailController.text.trim().isNotEmpty &&
                _passwordController.text.trim().isNotEmpty;
      } else {
        // For sign up, check all conditions including email validation
        _isButtonEnabled = _formKey.currentState?.validate() ??
            false &&
                _emailController.text.trim().isNotEmpty &&
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
    return GestureDetector(
      onDoubleTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ApiLoggerScreen(),
          ),
        );
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildLoginForm() {
    return Expanded(
      child: Column(
        children: [
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.length > 05) {
                                // Regular expression for email validation
                                final emailRegex =
                                    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(value ?? '')) {
                                  return 'Please enter a valid email address';
                                }
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _formKey.currentState?.validate();
                              _updateButtonState();
                            },
                            decoration: InputDecoration(
                              hintText: 'Email Address',
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) return 'Must be at least 8 characters';
                            //   if (value.length < 8) return 'Must be at least 8 characters';
                            //   if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Must contain a capital letter';
                            //   if (!RegExp(r'(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                            //     return 'Must contain letters and numbers';
                            //   }
                            //   return null;
                            // },
                            onChanged: (value) {
                              _updatePasswordValidation();
                              _formKey.currentState?.validate();
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: Colors.white,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        if (!widget.isSign
                            ) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Password must be:',
                                  style: AppTextStyles.captionOpenSans
                                      .copyWith(color: Colors.black),
                                ),
                                _buildPasswordRule(
                                  'Length: at least 8 characters',
                                  _hasMinLength,
                                ),
                                _buildPasswordRule(
                                  'Must include at least one letter and one number',
                                  _hasLetterAndNumber,
                                ),
                                _buildPasswordRule(
                                  'Must include capital letters',
                                  _hasCapitalLetter,
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (widget.isSign) ...[
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16, top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: AppColors.amethystViolet,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10),
                  widget.isSign
                      ? const SizedBox()
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                  RichText(
                                    text: TextSpan(
                                      style: AppTextStyles.captionOpenSans
                                          .copyWith(color: Colors.black),
                                      children: [
                                        TextSpan(text: 'I agree to '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: AppTextStyles.captionOpenSans
                                              .copyWith(color: Colors.black,
                                              decoration: TextDecoration.underline),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Terms and Conditions',
                                          style: AppTextStyles.captionOpenSans
                                              .copyWith(color: Colors.black,decoration: TextDecoration.underline),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                                  Text(
                                    'I am 16 years or older',
                                    style: AppTextStyles.captionOpenSans
                                        .copyWith(color: Colors.black),
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
                              ? "Don't have an account?"
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
                            SnackbarUtils.showSuccess(
                                context: context,
                                title: 'Welcome back',
                                message: _emailController.text.split('@')[0]);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
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
                                    final loginCubit =
                                        context.read<LoginCubit>();
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
                                      // If it's sign in, only call the sign in method
                                      // Navigation will be handled in BlocListener
                                      loginCubit.signInWithEmail(
                                        _emailController.text,
                                        _passwordController.text,
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

  Widget _buildPasswordRule(String rule, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            color: isMet ? Colors.green : Colors.black,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            rule,
            style: AppTextStyles.captionOpenSans.copyWith(
              color: isMet ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
