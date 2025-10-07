import 'package:flutter/material.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';

class PersonalInfoReviewScreen extends StatefulWidget {
  final Function(Map<String, String>) onDataUpdate;

  const PersonalInfoReviewScreen({
    Key? key,
    required this.onDataUpdate,
  }) : super(key: key);

  @override
  State<PersonalInfoReviewScreen> createState() =>
      _PersonalInfoReviewScreenState();
}

class _PersonalInfoReviewScreenState extends State<PersonalInfoReviewScreen> {
  Map<String, dynamic>? _userProfile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final token = AppStorage.accessToken;
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final apiClient = ApiClient();
      final response = await apiClient.get(
        '/api/v1/accounts/me',
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _userProfile = response.data;
          _isLoadingProfile = false;
        });

        // Update data after the widget is fully built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Map<String, String> personalInfo = {
            'age': _userProfile?['age']?.toString() ?? 'Not specified',
            'gender': _userProfile?['gender'] ?? 'Not specified',
            'height': _formatHeightInchToFeet(_userProfile?['height']),
            'weight': '${_userProfile?['weight'] ?? 'Not specified'} lbs',
            'ethnicity': _userProfile?['ethnicity'] ?? 'Not specified',
            'income':
                UserProfileConstants.householdIncomeRange ?? 'Not specified',
          };
          widget.onDataUpdate(personalInfo);
        });
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        _isLoadingProfile = false;
      });
    }
  }

  String _formatHeightInchToFeet(dynamic height) {
    if (height == null) return 'Not set';
    if (height is num) {
      // Convert cm to inches for display
      final heightInInches = height.toDouble() / 2.54;
      final feet = (heightInInches / 12).floor();
      final inches = (heightInInches % 12).round();
      return '$feet ft $inches in';
    }
    return height.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Title
          Text(
            'Let\'s make sure everything looks right:',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          const SizedBox(height: 16),

          // Description paragraphs
          Text(
            'Before we prep for your appointment, take a moment to review your personal info.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            'Little things, like your age, weight, or health background, can make a big difference in how we support you. If anything\'s changed, it\'s easy to update.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Personal information cards
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_isLoadingProfile)
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.amethyst),
                      ),
                    )
                  else if (_userProfile != null) ...[
                    _buildInfoCard('Gender',
                        _userProfile!['gender'] ?? 'Not set', 'gender'),
                    const SizedBox(height: 12),
                    _buildInfoCard('Age',
                        '${_userProfile!['age'] ?? 'Not set'} years', 'age'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                        'Weight',
                        '${_userProfile!['weight'] ?? 'Not set'} lbs',
                        'weight'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                        'Height',
                        _formatHeightInchToFeet(_userProfile!['height']),
                        'height'),
                    const SizedBox(height: 12),
                    _buildInfoCard('Ethnicity',
                        _userProfile!['ethnicity'] ?? 'Not set', 'ethnicity'),
                    const SizedBox(height: 12),
                    _buildInfoCard('Location',
                        _userProfile!['address'] ?? 'Not set', 'address'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                        'Income',
                        UserProfileConstants.householdIncomeRange ??
                            'Not specified',
                        'income'),
                    const SizedBox(height: 12),
                    _buildInfoCard('Health Concerns', _formatHealthConcerns(),
                        'health_concerns'),
                    const SizedBox(height: 12),
                    _buildInfoCard('Health History', _formatHealthHistory(),
                        'health_history'),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                        'Medications', _formatMedications(), 'medications'),
                  ] else
                    const Text(
                      'Failed to load profile data',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),

          // Data update on mount
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, String field) {
    return GestureDetector(
      onTap: () {
        _showEditBottomSheet(field, title, value);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: AppColors.glassCardDecoration,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.amethyst,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  String _formatHealthConcerns() {
    if (UserProfileConstants.healthConcerns == null ||
        UserProfileConstants.healthConcerns!.isEmpty) {
      return 'None specified';
    }
    return UserProfileConstants.healthConcerns!.join(', ');
  }

  String _formatHealthHistory() {
    if (UserProfileConstants.healthHistory == null ||
        UserProfileConstants.healthHistory!.isEmpty) {
      return 'None specified';
    }
    return UserProfileConstants.healthHistory!.join(', ');
  }

  String _formatMedications() {
    if (UserProfileConstants.medicationsOrSupplements == null ||
        UserProfileConstants.medicationsOrSupplements!.isEmpty) {
      return 'None specified';
    }
    return UserProfileConstants.medicationsOrSupplements!.join(', ');
  }

  void _showEditBottomSheet(String field, String title, String currentValue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditProfileBottomSheet(
        field: field,
        title: title,
        currentValue: currentValue,
        userProfile: _userProfile,
        onUpdate: (updatedData) async {
          try {
            final token = AppStorage.accessToken;
            if (token == null) {
              throw Exception('No authentication token found');
            }

            final apiClient = ApiClient();
            final response = await apiClient.put(
              '/api/v1/accounts/me',
              data: updatedData,
            );

            if (response.statusCode == 200) {
              await _loadUserProfile(); // Reload profile data
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else {
              throw Exception('Failed to update profile');
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to update profile: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }
}

class _EditProfileBottomSheet extends StatefulWidget {
  final String field;
  final String title;
  final String currentValue;
  final Map<String, dynamic>? userProfile;
  final Function(Map<String, dynamic>) onUpdate;

  const _EditProfileBottomSheet({
    required this.field,
    required this.title,
    required this.currentValue,
    required this.userProfile,
    required this.onUpdate,
  });

  @override
  State<_EditProfileBottomSheet> createState() =>
      _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<_EditProfileBottomSheet> {
  late TextEditingController _controller;
  late TextEditingController _feetController;
  late TextEditingController _inchesController;
  String? _selectedGender;
  int? _selectedAge;
  double? _selectedWeight;
  double? _selectedHeight;
  String? _selectedEthnicity;
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _feetController = TextEditingController();
    _inchesController = TextEditingController();
    _initializeValues();
  }

  void _initializeValues() {
    switch (widget.field) {
      case 'gender':
        _selectedGender = widget.userProfile?['gender'];
        break;
      case 'age':
        _selectedAge = widget.userProfile?['age'];
        _controller.text = _selectedAge?.toString() ?? '';
        break;
      case 'weight':
        _selectedWeight = widget.userProfile?['weight']?.toDouble();
        _controller.text = _selectedWeight?.toString() ?? '';
        break;
      case 'height':
        _selectedHeight = widget.userProfile?['height']?.toDouble();
        // Convert cm to inches for display
        if (_selectedHeight != null) {
          final heightInInches = _selectedHeight! / 2.54;
          _controller.text = heightInInches.toStringAsFixed(0);
        } else {
          _controller.text = '';
        }
        break;
      case 'ethnicity':
        _selectedEthnicity = widget.userProfile?['ethnicity'];
        _controller.text = _selectedEthnicity ?? '';
        break;
      case 'address':
        _selectedLocation = widget.userProfile?['address'];
        _controller.text = _selectedLocation ?? '';
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9, // 90% of screen height
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE6B2), Color(0xFFE6D6FF)],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppColors.primary01),
                    ),
                    Expanded(
                      child: Text(
                        'Update ${widget.title}',
                        style: AppTextStyles.heading3,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    TextButton(
                      onPressed: _handleUpdate,
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          color: AppColors.amethyst,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Field content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildFieldContent(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldContent() {
    switch (widget.field) {
      case 'gender':
        return _buildGenderSelector();
      case 'age':
        return _buildAgeInput();
      case 'weight':
        return _buildWeightInput();
      case 'height':
        return _buildHeightInput();
      case 'ethnicity':
        return _buildEthnicityInput();
      case 'address':
        return _buildLocationInput();
      default:
        return const Text('Field not supported');
    }
  }

  Widget _buildGenderSelector() {
    final genderOptions = [
      'Woman',
      'Transgender Woman',
      'Gender queer/Gender fluid',
      'Agender',
      'Prefer not to say',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How do you currently describe your gender identity?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary01,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your gender identity can impact everything from how symptoms show up to how you\'re treated in medical settings. We want to get it right, for you.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 20),
        ...genderOptions.map((gender) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedGender = gender;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _selectedGender == gender
                        ? AppColors.amethyst.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _selectedGender == gender
                          ? AppColors.amethyst
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    gender,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _selectedGender == gender
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: _selectedGender == gender
                          ? AppColors.amethyst
                          : AppColors.primary01,
                    ),
                  ),
                ),
              ),
            )),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.yellow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.yellow),
          ),
          child: const Text(
            'Prefer to self describe',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary01,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildAgeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your age matters',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary01,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Age can impact how symptoms show up and change over time—knowing yours helps us get it right.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter your age',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              onPressed: () => _controller.clear(),
              icon: const Icon(Icons.clear),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What\'s your current weight?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary01,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Weight helps us understand your health patterns and provide better insights.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter your weight in lbs',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              onPressed: () => _controller.clear(),
              icon: const Icon(Icons.clear),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How tall are you?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary01,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your height helps us interpret symptom trends and offer more accurate support for your body.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _feetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Feet',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _inchesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Inches',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEthnicityInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What\'s your ethnicity?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary01,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ethnicity can influence health patterns and help us provide more personalized care.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter your ethnicity',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              onPressed: () => _controller.clear(),
              icon: const Icon(Icons.clear),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Where are you located?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary01,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Location helps us understand environmental factors that might affect your health.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray600,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter your location',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            suffixIcon: IconButton(
              onPressed: () => _controller.clear(),
              icon: const Icon(Icons.clear),
            ),
          ),
        ),
      ],
    );
  }

  int _updateTotalHeighToInches() {
    final feet = int.tryParse(_feetController.text) ?? 0;
    final inches = int.tryParse(_inchesController.text) ?? 0;
    final total = feet * 12 + inches;

    return total;
  }

  void _handleUpdate() {
    if (widget.userProfile == null) return;

    final updatedData = Map<String, dynamic>.from(widget.userProfile!);

    switch (widget.field) {
      case 'gender':
        if (_selectedGender != null) {
          updatedData['gender'] = _selectedGender;
        }
        break;
      case 'age':
        final age = int.tryParse(_controller.text);
        if (age != null) {
          updatedData['age'] = age;
        }
        break;
      case 'weight':
        final weight = double.tryParse(_controller.text);
        if (weight != null) {
          updatedData['weight'] = weight;
        }
        break;
      case 'height':
        final height =
            _updateTotalHeighToInches();
        if (height != null) {
          // Convert inches to cm for API
          final heightInCm = height * 2.54;
          updatedData['height'] = heightInCm;
        }
        break;
      case 'ethnicity':
        updatedData['ethnicity'] = _controller.text;
        break;
      case 'address':
        updatedData['address'] = _controller.text;
        break;
    }

    widget.onUpdate(updatedData);
    Navigator.pop(context);
  }
}
