import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/view/onboarding_flow.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_app_bar.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final Function() onSuccess;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    required this.onSuccess,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    // Auto-focus the OTP input field when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _otpFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  // Future<void> _verifyOTP() async {
  //   if (_otpController.text.trim().isEmpty) {
  //     SnackbarUtils.showError(
  //       context: context,
  //       title: 'Error',
  //       message: 'Please enter the OTP',
  //     );
  //     return;
  //   }

  //   setState(() {
  //     _isVerifying = true;
  //   });

  //   final loginCubit = context.read<LoginCubit>();
  //   final success = await loginCubit.verifyRegistrationOTP(
  //     widget.email,
  //     _otpController.text.trim(),
  //   );

  //   setState(() {
  //     _isVerifying = false;
  //   });

  // // 🔹 Step 1: Verify OTP
  // final otpVerified = await loginCubit.verifyRegistrationOTP(
  //   widget.email,
  //   _otpController.text.trim(),
  // );

  // setState(() {
  //   _isVerifying = false;
  // });

  // if (otpVerified) {
  //   SnackbarUtils.showSuccess(
  //     context: context,
  //     title: 'Verified',
  //     message: 'OTP verified successfully!',
  //   );

  //   // 🔹 Step 2: Navigate to onboarding instead of logging in directly
  //   widget.onSuccess();
  // } else {
  //   SnackbarUtils.showError(
  //     context: context,
  //     title: 'Verification Failed',
  //     message: 'Invalid OTP. Please try again.',
  //   );
  // }

  //   // if (success) {
  //   //   // After successful OTP verification, proceed with login
  //   //   // We need to get the password from the cubit's stored data
  //   //   final loginSuccess = await loginCubit.signInWithEmail(
  //   //     widget.email,
  //   //     loginCubit.password ?? '', // Get password from cubit
  //   //   );

  //   //   if (loginSuccess) {
  //   //     widget.onSuccess();
  //   //   } else {
  //   //     SnackbarUtils.showError(
  //   //       context: context,
  //   //       title: 'Login Failed',
  //   //       message: 'Failed to login after OTP verification',
  //   //     );
  //   //   }
  //   // } else {
  //   //   SnackbarUtils.showError(
  //   //     context: context,
  //   //     title: 'Verification Failed',
  //   //     message: 'Invalid OTP. Please try again.',
  //   //   );
  //   // }
  // }

  Future<void> _verifyOTP() async {
  if (_otpController.text.trim().isEmpty) {
    SnackbarUtils.showError(
      context: context,
      title: 'Error',
      message: 'Please enter the OTP',
    );
    return;
  }

  if (!mounted) return; // Extra safety
  setState(() {
    _isVerifying = true;
  });

  final loginCubit = context.read<LoginCubit>();
  final success = await loginCubit.verifyRegistrationOTP(
    widget.email,
    _otpController.text.trim(),
  );

  if (!mounted) return; // <-- stop if widget disposed

  setState(() {
    _isVerifying = false;
  });

  if (success) {
    // OTP verified → sign in
    final loginSuccess = await loginCubit.signInWithEmail(
      widget.email,
      loginCubit.password ?? '',
    );

    if (!mounted) return;

    if (loginSuccess) {
      // widget.onSuccess(); // Navigate to onboarding flow
      // ✅ Navigate to OnboardingFlow
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardingFlow(
            email: widget.email,
            password: loginCubit.password ?? '',
          ),
        ),
      );
    } else {
      SnackbarUtils.showError(
        context: context,
        title: 'Login Failed',
        message: 'Failed to login after OTP verification',
      );
    }
  } else {
    SnackbarUtils.showError(
      context: context,
      title: 'Verification Failed',
      message: 'Invalid OTP. Please try again.',
    );
  }
}


  // Future<void> _resendOTP() async {
  //   setState(() {
  //     _isResending = true;
  //   });

  //   try {
  //     final loginCubit = context.read<LoginCubit>();
  //     // Call the resend OTP method from the cubit
  //     final success = await loginCubit.resendRegistrationOTP(widget.email);
      
  //     if (success) {
  //       SnackbarUtils.showSuccess(
  //         context: context,
  //         title: 'Code Sent',
  //         message: 'A new verification code has been sent to your email',
  //       );
  //     } else {
  //       SnackbarUtils.showError(
  //         context: context,
  //         title: 'Failed',
  //         message: 'Failed to resend verification code. Please try again.',
  //       );
  //     }
  //   } catch (e) {
  //     SnackbarUtils.showError(
  //       context: context,
  //       title: 'Error',
  //       message: 'An error occurred while resending the code: $e',
  //     );
  //   } finally {
  //     setState(() {
  //       _isResending = false;
  //     });
  //   }
  // }
  Future<void> _resendOTP() async {
  if (!mounted) return;
  setState(() {
    _isResending = true;
  });

  try {
    final loginCubit = context.read<LoginCubit>();
    final success = await loginCubit.resendRegistrationOTP(widget.email);

    if (!mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(
        context: context,
        title: 'Code Sent',
        message: 'A new verification code has been sent to your email',
      );
    } else {
      SnackbarUtils.showError(
        context: context,
        title: 'Failed',
        message: 'Failed to resend verification code. Please try again.',
      );
    }
  } catch (e) {
    if (!mounted) return;
    SnackbarUtils.showError(
      context: context,
      title: 'Error',
      message: 'An error occurred while resending the code: $e',
    );
  } finally {
    if (!mounted) return;
    setState(() {
      _isResending = false;
    });
  }
}


  // @override
  // Widget build(BuildContext context) {
  //   return Foxxbackground(
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       appBar: FoxxAppBar(
  //         showBack: true,
  //         onBack: () => Navigator.of(context).pop(),
  //       ),
  //       body: SafeArea(
  //         child: Padding(
  //           padding: AppSpacing.safeAreaHorizontalPadding,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               SizedBox(height: AppSpacing.appBarHeight),
                
  //               // Title
  //               Text(
  //                 'Check your email',
  //                 style: AppTypography.h2.copyWith(
  //                   color: AppColors.textPrimary,
  //                 ),
  //                 textAlign: TextAlign.start,
  //               ),
                
  //               const SizedBox(height: AppSpacing.sm),
                
  //               // Subtitle
  //               Text(
  //                 'We sent you a one-time code to verify your account. If it\'s not there, check your spam or junk folder.',
  //                 style: AppTypography.bodyMd.copyWith(
  //                   fontWeight: AppTypography.regular,
  //                   fontSize: 18,
  //                   height: 28 / 18,
  //                   color: AppColors.textSecondary,
  //                 ),
  //                 textAlign: TextAlign.start,
  //               ),
                
  //               const SizedBox(height: AppSpacing.xxl),
                
  //               // OTP Input Field
  //               SizedBox(
  //                 height: 52,
  //                 child: TextFormField(
  //                   controller: _otpController,
  //                   focusNode: _otpFocusNode,
  //                   keyboardType: TextInputType.number,
  //                   textAlign: TextAlign.center,
  //                   style: AppTypography.bodyLgSemibold.copyWith(
  //                     color: AppColors.textPrimary,
  //                   ),
  //                   decoration: InputDecoration(
  //                     hintText: 'OTP Code',
                      
  //                     hintStyle: AppTypography.bodyMd.copyWith(
  //                       color: AppColors.inputTextPlaceholder,

  //                     ),
  //                     border: OutlineInputBorder(
  //                       borderRadius: AppRadius.brMd,
  //                       borderSide: BorderSide(color: AppColors.gray300, width: 1),
  //                     ),
  //                     enabledBorder: OutlineInputBorder(
  //                       borderRadius: AppRadius.brMd,
  //                       borderSide: BorderSide(color: AppColors.gray300, width: 1),
  //                     ),
  //                     focusedBorder: OutlineInputBorder(
  //                       borderRadius: AppRadius.brMd,
  //                       borderSide: BorderSide(color: AppColors.primaryTint, width: 2),
  //                     ),
  //                     filled: true,
  //                     fillColor: AppColors.foxxWhite,
  //                     contentPadding: const EdgeInsets.symmetric(
  //                       horizontal: AppSpacing.sm,
  //                       vertical: AppSpacing.sm,
  //                     ),
  //                   ),
                  
  //                   onFieldSubmitted: (_) => _verifyOTP(),
  //                 ),
  //               ),
                
  //               const SizedBox(height: AppSpacing.sm),
                
  //               // Submit Button
  //               SizedBox(
  //                 height: 48,
  //                 child: ElevatedButton(
  //                   onPressed: _isVerifying ? null : _verifyOTP,
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: AppColors.primaryTint,
  //                     foregroundColor: Colors.white,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: AppRadius.brSm,
  //                     ),
  //                     elevation: 0,
  //                   ),
  //                   child: _isVerifying
  //                       ? const SizedBox(
  //                           height: 20,
  //                           width: 20,
  //                           child: CircularProgressIndicator(
  //                             strokeWidth: 2,
  //                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  //                           ),
  //                         )
  //                       : Text(
  //                           'Submit',
  //                           style: AppTypography.labelLgSemibold.copyWith(
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                 ),
  //               ),
                
  //               const SizedBox(height: AppSpacing.md),
                
  //               // Resend Code Link
  //               Center(
  //                 child: TextButton(
  //                   onPressed: _isResending || _isVerifying ? null : _resendOTP,
  //                   child: _isResending
  //                       ? const SizedBox(
  //                           height: 20,
  //                           width: 20,
  //                           child: CircularProgressIndicator(
  //                             strokeWidth: 2,
  //                             valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTint),
  //                           ),
  //                         )
  //                       : Text(
  //                           'Resend code',
  //                           style: AppTypography.labelMdSemibold.copyWith(
  //                             color: AppColors.primaryTint,
  //                             decoration: TextDecoration.underline,
  //                             decorationColor: AppColors.primaryTint,
  //                           ),
  //                         ),
  //                 ),
  //               ),
                
  //               const Spacer(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: FoxxAppBar(
          showBack: true,
          onBack: () => Navigator.of(context).pop(),
        ),
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.safeAreaHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.appBarHeight),

                Text(
                  'Check your email',
                  style: AppTypography.h2.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'We sent you a one-time code to verify your account. '
                  'If it\'s not there, check your spam or junk folder.',
                  style: AppTypography.bodyMd.copyWith(
                    fontWeight: AppTypography.regular,
                    fontSize: 18,
                    height: 28 / 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // OTP Field
                SizedBox(
                  height: 52,
                  child: TextFormField(
                    controller: _otpController,
                    focusNode: _otpFocusNode,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyLgSemibold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'OTP Code',
                      hintStyle: AppTypography.bodyMd.copyWith(
                        color: AppColors.inputTextPlaceholder,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray300, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.gray300, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primaryTint, width: 2),
                      ),
                      filled: true,
                      fillColor: AppColors.foxxWhite,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onFieldSubmitted: (_) => _verifyOTP(),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Submit Button
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTint,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Submit',
                            style: AppTypography.labelLgSemibold.copyWith(color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Resend OTP
                Center(
                  child: TextButton(
                    onPressed: _isResending || _isVerifying ? null : _resendOTP,
                    child: _isResending
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryTint),
                            ),
                          )
                        : Text(
                            'Resend code',
                            style: AppTypography.labelMdSemibold.copyWith(
                              color: AppColors.primaryTint,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
