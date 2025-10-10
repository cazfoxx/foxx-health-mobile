import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_spacing.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_question_header.dart';

class UsernameScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final Function(String)? onDataUpdate;
  
  const UsernameScreen({super.key, this.onNext, this.onDataUpdate});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _hasError = false;
  String _errorMessage = '';
  // Username validation flags (login-style)
  bool _hasMinLength = false;
  bool _hasAllowedCharacters = false;
  bool _withinMaxLength = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_usernameFocusNode);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  String? getUsername() {
    final username = _usernameController.text.trim();
    return username.isNotEmpty ? username : null;
  }

  void _clearText() {
    _usernameController.clear();
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
  }

  void _updateUsernameValidation() {
    final username = _usernameController.text;
    setState(() {
      _hasMinLength = username.length >= 3;
      _withinMaxLength = username.length <= 20;
      _hasAllowedCharacters = RegExp(r'^[a-zA-Z0-9_]*$').hasMatch(username);
      // Clear inline error while typing; rely on rules UI
      _hasError = false;
      _errorMessage = '';
    });
  }

  void _validateUsername(String username) {
    // Only keep a simple required error; rules box conveys specific requirements
    if (username.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please enter a username';
      });
      return;
    }
    if (!(_hasMinLength && _withinMaxLength && _hasAllowedCharacters)) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please fix the highlighted rules above';
      });
    } else {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
    }
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
            padding: AppSpacing.safeAreaContentPadding,
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
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface01,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.overlayLight,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _usernameController,
                    focusNode: _usernameFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: AppTypography.bodyMd.copyWith(
                        fontWeight: AppTypography.regular,
                        color: AppColors.textInputPlaceholder,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: AppTypography.bodyMd.copyWith(
                      fontWeight: AppTypography.regular,
                    ),
                    onChanged: (value) {
                      _updateUsernameValidation();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Login-style validation rules box
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
                if (_hasError && _errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textError,
                      ),
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FoxxNextButton(
                    isEnabled: getUsername() != null &&
                        _hasAllowedCharacters &&
                        _hasMinLength &&
                        _withinMaxLength &&
                        !_hasError,
                    onPressed: () {
                      final username = getUsername();
                      if (username == null) {
                        setState(() {
                          _hasError = true;
                          _errorMessage = 'Please enter a username';
                        });
                        return;
                      }
                      
                      // Validate username before proceeding
                      _validateUsername(username);
                      
                      // Only proceed if no validation errors
                      if (!_hasError) {
                        // Save the username data
                        widget.onDataUpdate?.call(username);
                        // Close keyboard
                        FocusScope.of(context).unfocus();
                        widget.onNext?.call();
                      }
                    },
                    text: 'Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}