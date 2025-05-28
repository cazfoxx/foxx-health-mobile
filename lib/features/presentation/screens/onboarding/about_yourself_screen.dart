import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_heading_container_widget.dart';

class AboutYourselfScreen extends StatefulWidget {
  const AboutYourselfScreen({super.key});

  @override
  State<AboutYourselfScreen> createState() => AboutYourselfScreenState();
}

class AboutYourselfScreenState extends State<AboutYourselfScreen> {
  final _usernameController = TextEditingController();
  final _customPronounController = TextEditingController();
  String? _selectedPronoun;
  bool _isCustomPronoun = false;
  String getUserName() {
    return _usernameController.text;
  }

  String getPronoun() {
    final pronoun = _isCustomPronoun ? _customPronounController.text : _selectedPronoun ?? '';

    return pronoun;
  }
  @override
  void dispose() {
    _usernameController.dispose();
    _customPronounController.dispose();
    super.dispose();
  }

  

  Widget _buildPronounOption(String pronoun) {
    final isSelected = _selectedPronoun == pronoun && !_isCustomPronoun;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPronoun = pronoun;
            _isCustomPronoun = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.amethystViolet,
                radius: 10,
                child: CircleAvatar(
                  backgroundColor:
                      isSelected ? AppColors.amethystViolet : Colors.white,
                  radius: 9,
                ),
              ),
              SizedBox(width: 10),
              Text(
                pronoun,
                style: AppTextStyles.body2OpenSans.copyWith(),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomPronounSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isCustomPronoun = true;
                _selectedPronoun = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.amethystViolet,
                    radius: 10,
                    child: CircleAvatar(
                      backgroundColor: _isCustomPronoun
                          ? AppColors.amethystViolet
                          : Colors.white,
                      radius: 9,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('I prefer', style: AppTextStyles.body2OpenSans),
                  const Spacer(),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
            padding: EdgeInsets.only(left: 50, right: 10, bottom: 10),
            child: TextField(
              controller: _customPronounController,
              decoration: InputDecoration(
                hintText: 'Enter',
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
              ),
            ),
          ),
        ],
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
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "What's your pronoun?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPronounOption('She / Her'),
                    _buildPronounOption('They / Them'),
                    _buildPronounOption('She / They'),
                    _buildCustomPronounSection(),
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
