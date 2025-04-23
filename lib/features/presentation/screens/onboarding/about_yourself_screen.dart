import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/onboarding/age_selection_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class AboutYourselfScreen extends StatefulWidget {
  const AboutYourselfScreen({super.key});

  @override
  State<AboutYourselfScreen> createState() => _AboutYourselfScreenState();
}

class _AboutYourselfScreenState extends State<AboutYourselfScreen> {
  final _usernameController = TextEditingController();
  String? _selectedPronoun;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Widget _buildPronounOption(String pronoun) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPronoun = pronoun;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _selectedPronoun == pronoun
                  ? AppColors.amethystViolet
                  : Colors.grey[300]!,
            ),
          ),
          child: Row(
            children: [
              Text(pronoun),
              const Spacer(),
              Icon(
                _selectedPronoun == pronoun ? Icons.check : null,
                color: AppColors.amethystViolet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingHeadingContainer(
              title: 'Tell me about yourself',
              subtitle:
                  'We want you to have personalize medical information but we want to keep your privacy.',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your username',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This username will be used as your unique ID to connect with other FoXX member',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Pronoun',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPronounOption('She/her'),
                    _buildPronounOption('They/Them'),
                    _buildPronounOption('She/they'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
