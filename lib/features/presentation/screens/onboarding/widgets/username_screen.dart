import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';
import 'package:foxxhealth/features/presentation/widgets/foxx_text_field.dart';

class UsernameScreen extends StatefulWidget {
  final Function(String)? onDataUpdate;
  final String? currentValue; // Previously entered username
  final ValueChanged<bool>? onEligibilityChanged;
  final VoidCallback? onNext;

  const UsernameScreen({
    super.key,
    this.onNext,
    this.onDataUpdate,
    this.currentValue,
    this.onEligibilityChanged,
  });

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _hasError = false;

  // Username validation flags (login-style)
  bool _hasMinLength = false;
  bool _hasAllowedCharacters = false;
  bool _withinMaxLength = true;

  String? getUsername() {
    final username = _usernameController.text.trim();
    return username.isNotEmpty ? username : null;
  }

  void _updateUsernameValidation() {
    final username = _usernameController.text;
    setState(() {
      _hasMinLength = username.length >= 3;
      _withinMaxLength = username.length <= 20;
      _hasAllowedCharacters = RegExp(r'^[a-zA-Z0-9_]*$').hasMatch(username);
      _hasError = false;
    });
  }

  void _emitEligibility() {
    final isValid = getUsername() != null &&
        _hasAllowedCharacters &&
        _hasMinLength &&
        _withinMaxLength &&
        !_hasError;
    widget.onEligibilityChanged?.call(isValid);
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill if currentValue exists
    if (widget.currentValue != null) {
      _usernameController.text = widget.currentValue!;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateUsernameValidation();
      _emitEligibility();
      FocusScope.of(context).requestFocus(_usernameFocusNode);
    });
  }

  Widget _buildUsernameRule(String rule, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            color: isMet ? AppColors.insightPineGreen : AppColors.textPrimary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rule,
              style: AppTypography.labelXsSemibold.copyWith(
                color: isMet ? AppColors.insightPineGreen : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.safeAreaHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppSpacing.appBarHeight),
                OnboardingQuestionHeader(
                  questions: const [],
                  questionType: 'USERNAME_INTRO',
                  questionOverride: "What should we call you?",
                  descriptionOverride:
                      "Your username is how we'll refer to you, and it's how other FoXX members will connect with you. It can be your name, a nickname, or something completely unique, just make it you.",
                ),
                const SizedBox(height: 24),
                FoxxTextField(
                  hintText: 'Username',
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  showClearButton: true,
                  onChanged: (value) {
                    _updateUsernameValidation();
                    widget.onDataUpdate?.call(value.trim());
                    _emitEligibility();
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.onSurfaceSubtle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username must:',
                        style: AppTypography.labelSmSemibold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildUsernameRule(
                        'Only letters, numbers, and underscores',
                        _hasAllowedCharacters,
                      ),
                      _buildUsernameRule(
                        'At least 3 characters',
                        _hasMinLength,
                      ),
                      _buildUsernameRule(
                        'No more than 20 characters',
                        _withinMaxLength,
                      ),
                    ],
                  ),
                ),
                if (_hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Please enter a valid username',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textError,
                      ),
                    ),
                  ),
                const Spacer(),
                // ✅ Local Next button removed; parent bottom bar handles navigation
              ],
            ),
          ),
        ),
      ),
    );
  }
}