import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/shared/navigation_buttons.dart';

class UsernameScreen extends StatefulWidget {
  final VoidCallback? onNext;
  
  const UsernameScreen({super.key, this.onNext});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  bool _hasError = false;
  String _errorMessage = '';

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

  void _validateUsername(String username) {
    // Simulate username validation - you can replace this with actual validation
    if (username.toLowerCase() == 'applesauce') {
      setState(() {
        _hasError = true;
        _errorMessage = 'That username is taken. Try adding a number or symbol.';
      });
    } else {
      setState(() {
        _hasError = false;
        _errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let\'s personalize your experience.',
                  style: AppHeadingTextStyles.h2,
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll get to know you and provide better visit preps.',
                  style: AppOSTextStyles.osLg.copyWith(color: AppColors.primaryTxt),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _hasError ? Colors.red : Colors.transparent,
                      width: _hasError ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _usernameController,
                          focusNode: _usernameFocusNode,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: AppTextStyles.bodyOpenSans,
                          onChanged: (value) {
                            setState(() {
                              if (_hasError && value.isNotEmpty) {
                                _hasError = false;
                                _errorMessage = '';
                              }
                            });
                          },
                        ),
                      ),
                      if (_usernameController.text.isNotEmpty)
                        IconButton(
                          onPressed: _clearText,
                          icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
                if (_hasError && _errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _errorMessage,
                      style: AppTextStyles.bodyOpenSans.copyWith(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundDefault,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'This username will be used as your unique ID to connect with other FoXX members',
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(color: Colors.grey[600]),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FoxxNextButton(
                    isEnabled: getUsername() != null && !_hasError,
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