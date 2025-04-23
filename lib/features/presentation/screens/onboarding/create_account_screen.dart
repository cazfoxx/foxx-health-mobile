import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/login/login_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/about_yourself_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({super.key, this.isSignUp = true, required this.email});

  bool isSignUp;
  String email;

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

// Move these methods inside the _CreateAccountScreenState class
class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordValid = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            _handleNext(context);
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  OnboardingHeadingContainer(
                    title: widget.isSignUp
                        ? "Sign In"
                        : "Let's create your account",
                    subtitle: widget.isSignUp
                        ? 'Enter your email and password to sign in.'
                        : 'Enter your email and password to create an account.',
                  ),
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPasswordFields(),
                            if (!widget.isSignUp) ...[
                              const SizedBox(height: 24),
                              _buildPasswordRules(),
                            ],
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.21),
                            OnboardingButton(
                              onPressed: () => _handleSubmit(context),
                              text: widget.isSignUp
                                  ? 'Sign In'
                                  : 'Create an Account',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: _inputDecoration('Email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordFields() {
    return Column(
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: _inputDecoration('Password'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (!widget.isSignUp) {
              final cubit = context.read<LoginCubit>();
              if (!cubit.validatePassword(value)) {
                return 'Password does not meet requirements';
              }
            }
            return null;
          },
          onChanged: (value) {
            if (!widget.isSignUp) {
              final cubit = context.read<LoginCubit>();
              setState(() {
                _isPasswordValid = cubit.validatePassword(value);
              });
            }
          },
        ),
        if (!widget.isSignUp) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: _inputDecoration('Re-type Password'),
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<LoginCubit>();
      if (widget.isSignUp) {
        cubit.signInWithEmail(
          widget.email,
          _passwordController.text,
        );
      } else {
        cubit.signUpWithEmail(
          widget.email,
          _passwordController.text,
        );
      }
    }
  }

  Widget _buildPasswordRules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password Rules',
          style: AppTextStyles.heading2,
        ),
        const SizedBox(height: 8),
        _buildRule('Length: at least 8 characters'),
        _buildRule('Must include at least one letter and one number'),
        _buildRule('Must include capital letters'),
      ],
    );
  }

  Widget _buildRule(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: AppColors.amethystViolet),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _handleNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AboutYourselfScreen()),
    );
  }
}
