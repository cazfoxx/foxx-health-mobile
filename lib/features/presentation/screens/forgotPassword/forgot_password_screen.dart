import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/presentation/cubits/forgot_password/forgot_password_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  int _currentStep = 0; 
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isButtonEnabled = false;

  bool _hasMinLength = false;
  bool _hasLetterAndNumber = false;
  bool _hasCapitalLetter = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _otpController.addListener(_updateButtonState);
    _passwordController.addListener(_updatePasswordValidation);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  void _updatePasswordValidation() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = password.length >= 8;
      _hasLetterAndNumber = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password);
      _hasCapitalLetter = RegExp(r'[A-Z]').hasMatch(password);
      _updateButtonState();
    });
  }

  void _updateButtonState() {
    setState(() {
      switch (_currentStep) {
        case 0:
          _isButtonEnabled = _formKey.currentState?.validate() ?? false &&
              _emailController.text.trim().isNotEmpty;
          break;
        case 1:
          _isButtonEnabled = _otpController.text.length == 6;
          break;
        case 2:
          _isButtonEnabled = _formKey.currentState?.validate() ?? false &&
              _passwordController.text.trim().isNotEmpty &&
              _confirmPasswordController.text.trim().isNotEmpty &&
              _passwordController.text == _confirmPasswordController.text;
          break;
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is EmailSent) {
          setState(() => _currentStep = 1);
          SnackbarUtils.showSuccess(
            context: context,
            title: 'Email Sent',
            message: 'Please check your email for the OTP code',
          );
        } else if (state is PasswordReset) {
          SnackbarUtils.showSuccess(
            context: context,
            title: 'Success',
            message: 'Your password has been reset successfully',
          );
          Navigator.pop(context);
        } else if (state is ForgotPasswordError) {
          // SnackbarUtils.showError(
          //   context: context,
          //   title: 'Error',
          //   message: state.message,
          // );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 710,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(),
                        _buildCurrentStep(),
                      ],
                    ),
                  ),
                ),
              ),
              if (state is ForgotPasswordLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.amethystViolet,
                  ),
                ),
            ],
          ),
        );
      },
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
            _currentStep == 2 ? 'Reset Password' : 'Forgot Password',
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

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildOTPStep();
      case 2:
        return _buildNewPasswordStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildEmailStep() {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  OnboardingHeadingContainer(
                    title: 'Reset your password',
                    subtitle: 'Please enter your email address. We will send you an email with an OTP code to reset your password.',
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email cannot be empty';
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
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
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildActionButton(
                    'Send Email',
                    () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgotPasswordCubit>().sendResetEmail(_emailController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOTPStep() {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  OnboardingHeadingContainer(
                    title: 'Enter OTP Code',
                    subtitle: 'Please enter the OTP code we sent to your email address.',
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onChanged: (_) => _updateButtonState(),
                      decoration: InputDecoration(
                        hintText: 'Enter OTP Code',
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
                  TextButton(
                    onPressed: () {
                      context.read<ForgotPasswordCubit>().sendResetEmail(_emailController.text);
                      SnackbarUtils.showInfo(
                        context: context,
                        title: 'Resending Email',
                        message: 'Please wait while we send you a new OTP code',
                      );
                    },
                    child: const Text(
                      'Resend Email',
                      style: TextStyle(
                        color: AppColors.amethystViolet,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildActionButton(
                    'Verify OTP',
                    () {
                      if (_otpController.text.length == 6) {
                        setState(() => _currentStep = 2);
                      } else {
                        SnackbarUtils.showError(
                          context: context,
                          title: 'Invalid OTP',
                          message: 'Please enter a valid 6-digit OTP code',
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep() {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  OnboardingHeadingContainer(
                    title: 'Enter your new password',
                    subtitle: 'Create a strong password that you haven\'t used before.',
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              if (!_hasMinLength) return 'Must be at least 8 characters';
                              if (!_hasCapitalLetter) {
                                return 'Must contain a capital letter';
                              }
                              if (!_hasLetterAndNumber) {
                                return 'Must contain letters and numbers';
                              }
                              return null;
                            },
                            onChanged: (_) {
                              _updatePasswordValidation();
                              _formKey.currentState?.validate();
                            },
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
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            validator: (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            onChanged: (_) {
                              _formKey.currentState?.validate();
                              _updateButtonState();
                            },
                            decoration: InputDecoration(
                              hintText: 'Re-enter Password',
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
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Password Rules',
                            style: AppTextStyles.body2OpenSans.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildPasswordRule('Length: at least 8 characters', _hasMinLength),
                          _buildPasswordRule('Must include at least one letter and one number', _hasLetterAndNumber),
                          _buildPasswordRule('Must include capital letters', _hasCapitalLetter),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildActionButton(
                    'Reset Password',
                    () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ForgotPasswordCubit>().resetPassword(
                          otp: _otpController.text,
                          newPassword: _passwordController.text,
                        );
                      }
                    },
                  ),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            color: isMet ? Colors.green : Colors.grey[400],
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rule,
              style: AppTextStyles.body2OpenSans.copyWith(
                color: isMet ? Colors.green : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _isButtonEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isButtonEnabled ? AppColors.amethystViolet : Colors.grey[300],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: _isButtonEnabled ? Colors.white : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
} 