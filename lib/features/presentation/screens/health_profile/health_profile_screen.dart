import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/profile/profile_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_profile/health_profile_questions_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic.dart';
import 'package:foxxhealth/features/presentation/widgets/neumorphic_card.dart';

class HealthProfileScreen extends StatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  late SymptomSearchCubit _symptomCubit;
  List<Map<String, dynamic>> sampleQuestions = [];
  bool _isLoadingQuestions = true;
  Map<String, dynamic>? _userProfile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _symptomCubit = SymptomSearchCubit();
    _loadSampleQuestions();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _symptomCubit.close();
    super.dispose();
  }

  Future<void> _loadSampleQuestions() async {
    try {
      final questionsData = await _symptomCubit.getHealthProfileQuestions();
      if (questionsData.isNotEmpty) {
        setState(() {
          // Take first 3 questions for the preview
          sampleQuestions = questionsData
              .take(3)
              .map((question) => {
                    'question': question['question_text'] ?? '',
                    'id': question['id'] ?? '',
                    'data_usage': question['data_usage'] ?? [],
                    'answers': question['answers'] ?? {},
                  })
              .toList();
          _isLoadingQuestions = false;
        });
      } else {
        setState(() {
          _isLoadingQuestions = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingQuestions = false;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.primary01),
          ),
          // actions: [
          //   Row(
          //     children: [
          //       const CircleAvatar(
          //         backgroundColor: AppColors.mauve50,
          //         radius: 20,
          //         child: Icon(Icons.chat_bubble_outline,
          //             color: AppColors.amethyst, size: 20),
          //       ),
          //       const SizedBox(width: 12),
          //       GestureDetector(
          //         onTap: () {
          //           Navigator.of(context).push(
          //             MaterialPageRoute(
          //               builder: (context) => const ProfileScreen(),
          //             ),
          //           );
          //         },
          //         child: const CircleAvatar(
          //           backgroundColor: AppColors.mauve50,
          //           radius: 20,
          //           child: Icon(Icons.person_outline,
          //               color: AppColors.amethyst, size: 20),
          //         ),
          //       ),
          //     ],
          //   ),
          // ],
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              _buildHeader(),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Get to know me section
                      // _buildGetToKnowMeSection(),
                      // const SizedBox(height: 32),

                      // My core profile section
                      _buildCoreProfileSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top right icons

          SizedBox(height: 16),

          // Title
          Text(
            'Health Profile',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primary01,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGetToKnowMeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with "See All" link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Health Profile Questions',
                style: AppTextStyles.heading3),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HealthProfileQuestionsScreen(),
                  ),
                );
              },
              child: const Text('See All',
                  style: AppOSTextStyles.osMdSemiboldTitle),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Horizontal scrollable cards
        SizedBox(
          height: 100,
          child: _isLoadingQuestions
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.amethyst),
                  ),
                )
              : sampleQuestions.isEmpty
                  ? const Center(
                      child: Text(
                        'No questions available',
                        style: AppOSTextStyles.osMd,
                      ),
                    )
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: sampleQuestions.map((question) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: _buildGetToKnowMeCard(question['question']),
                        );
                      }).toList(),
                    ),
        ),
      ],
    );
  }

  Widget _buildGetToKnowMeCard(String text) {
    return GestureDetector(
      onTap: () {
        // Handle card tap
      },
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.28),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: AppColors.gray200,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary01,
                  height: 1.3,
                ),
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

  Widget _buildCoreProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My core profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primary01,
          ),
        ),
        const SizedBox(height: 16),

        // Core profile cards
        if (_isLoadingProfile)
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.amethyst),
            ),
          )
        else if (_userProfile != null) ...[
          _buildCoreProfileCard(
              'Gender', _userProfile!['gender'] ?? 'Not set', 'gender'),
          const SizedBox(height: 12),
          _buildCoreProfileCard(
              'Age', '${_userProfile!['age'] ?? 'Not set'} years', 'age'),
          const SizedBox(height: 12),
          _buildCoreProfileCard('Weight',
              '${_userProfile!['weight'] ?? 'Not set'} lbs', 'weight'),
          const SizedBox(height: 12),
          _buildCoreProfileCard(
              'Height', _formatHeight(_userProfile!['height']), 'height'),
          const SizedBox(height: 12),
          _buildCoreProfileCard('Ethnicity',
              _userProfile!['ethnicity'] ?? 'Not set', 'ethnicity'),
          const SizedBox(height: 12),
          _buildCoreProfileCard(
              'Location', _userProfile!['address'] ?? 'Not set', 'address'),
        ] else
          const Text(
            'Failed to load profile data',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  String _formatHeight(dynamic height) {
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

  Widget _buildCoreProfileCard(String title, String value, String field) {
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
  late TextEditingController _selfDescribeController;
  late TextEditingController _searchController;
  bool _isSelfDescribeSelected = false;

  final FocusNode _focusNode = FocusNode();
  final FocusNode _feetFocusNode = FocusNode();
  final FocusNode _inchesFocusNode = FocusNode();
  String? _selectedGender;
  int? _selectedAge;
  double? _selectedWeight;
  double? _selectedHeight;
  String? _selectedEthnicity;
  String? _selectedLocation;
  String? selectedState;
  List<String> filteredStates = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _feetController = TextEditingController();
    _inchesController = TextEditingController();
    _selfDescribeController = TextEditingController();
    _searchController = TextEditingController();
    filteredStates = List.from(allStates);
    _initializeValues();
    // Auto-focus the feet field when screen loads
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_feetFocusNode);
    });
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
          final feet = heightInInches ~/ 12; // Integer division
          final inches = heightInInches % 12; // Remainder
          _feetController.text = feet.toStringAsFixed(0);
          _inchesController.text = inches.toStringAsFixed(0);
        } else {
          _controller.text = '';
        }
        break;
      case 'ethnicity':
        _selectedEthnicity = widget.userProfile?['ethnicity'];
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
    _selfDescribeController.dispose();
    _searchController.dispose();
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
                    const Expanded(
                      child: Text(
                        'My core profile',
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

              // Content based on field type
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildFieldContent(),
              ),

              const SizedBox(height: 20),
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

  String? getSelectedGender() {
    if (_selectedGender == 'Prefer to self describe' ||
        _selectedGender == 'Prefer to self-describe') {
      return _selfDescribeController.text.isNotEmpty
          ? _selfDescribeController.text
          : null;
    }
    return _selectedGender;
  }

  Widget _buildSelfDescribeField() {
    return Visibility(
      visible: _isSelfDescribeSelected,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _selfDescribeController,
            decoration: const InputDecoration(
              hintText: 'Self describe',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: AppTextStyles.bodyOpenSans,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption(String option) {
    final bool isSelected = _selectedGender == option;
    final bool isSelfDescribe = option == 'Prefer to self describe' ||
        option == 'Prefer to self-describe';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: NeumorphicOptionCard(
        text: option,
        isSelected: isSelected,
        onTap: () {
          setState(() {
            _selectedGender = option;
            _isSelfDescribeSelected = isSelfDescribe;
          });
        },
      ),
    );
  }

  Widget _buildGenderSelector() {
    final genderOptions = [
      'Woman',
      'Transgender Woman',
      'Gender queer/Gender fluid',
      'Agender',
      'Prefer not to say',
      'Prefer to self describe',
      // 'Woman',
      // 'Transgender Woman',
      // 'Gender queer/Gender fluid',
      // 'Agender',
      // 'Prefer not to say',
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
        ...genderOptions.map(_buildGenderOption).toList(),
        _buildSelfDescribeField(),
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    hintText: '16',
                    hintStyle: AppOSTextStyles.osSmSingleLine
                        .copyWith(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTextStyles.bodyOpenSans.copyWith(fontSize: 18),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              Text(
                'Years',
                style: AppTextStyles.bodyOpenSans
                    .copyWith(color: Colors.grey[600]),
              ),
            ],
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter your weight in lbs',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () => _controller.clear(),
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  style: AppTextStyles.bodyOpenSans.copyWith(fontSize: 18),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              // Text(
              //   'lbs',
              //   style: AppTextStyles.bodyOpenSans
              //       .copyWith(color: Colors.grey[600]),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  bool isHeightValid() {
    return _feetController.text.isNotEmpty;
  }

  bool hasTextInput() {
    return _feetController.text.isNotEmpty || _inchesController.text.isNotEmpty;
  }

  Map<String, dynamic>? getHeight() {
    if (_feetController.text.isEmpty) return null;
    final feet = int.tryParse(_feetController.text);
    final inches = int.tryParse(_inchesController.text) ?? 0;
    if (feet == null) return null;
    return {'feet': feet, 'inches': inches};
  }

  Widget _buildHeightInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How tall are you?',
          style: AppHeadingTextStyles.h4,
        ),
        const SizedBox(height: 8),
        Text(
          'Your height helps us interpret symptom trends and offer more accurate support for your body.',
          style: AppOSTextStyles.osMd.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _feetController,
                        focusNode: _feetFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style:
                            AppTextStyles.bodyOpenSans.copyWith(fontSize: 18),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_inchesFocusNode);
                        },
                      ),
                    ),
                    Text(
                      'ft',
                      style: AppTextStyles.bodyOpenSans
                          .copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inchesController,
                        focusNode: _inchesFocusNode,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style:
                            AppTextStyles.bodyOpenSans.copyWith(fontSize: 18),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Text(
                      'in',
                      style: AppTextStyles.bodyOpenSans
                          .copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEthnicityOption(String option) {
    final bool isSelected = _selectedEthnicity == option;

    final backgroundColor = isSelected
        ? AppColors.progressBarSelected
        : Colors.white.withOpacity(0.15);

    final shadowColor = isSelected
        ? Colors.white.withOpacity(0.5)
        : Colors.white.withOpacity(0.3);

    final textColor = isSelected
        ? Colors.black.withOpacity(0.85)
        : Colors.black.withOpacity(0.85);

    return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
            onTap: () {
              setState(() {
                _selectedEthnicity = option;
              });
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isSelected
                              ? AppColors.progressBarSelected
                              : Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        isSelected
                            ? const Icon(Icons.check_circle,
                                color: AppColors.amethyst)
                            : Icon(Icons.circle_outlined,
                                color: Colors.grey[400]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: AppTextStyles.bodyOpenSans.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }

  Widget _buildEthnicityInput() {
    final ethnicityOptions = [
      'Asian (East Asian, South Asian)',
      'Black or African American',
      'Hispanic or Latino',
      'Middle Eastern or North African',
      'Mixed/Multiracial',
      'Native American or Alaska Native',
      'Pacific Islander or Native Hawaiian',
      'White or Caucasian',
      'Prefer not to answer',
    ];
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
        ...ethnicityOptions.map(_buildEthnicityOption).toList(),
      ],
    );
  }

  static const List<String> allStates = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California',
    'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia',
    'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa',
    'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland',
    'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri',
    'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey',
    'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio',
    'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina',
    'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
    'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
  ];

  void _filterStates(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStates = List.from(allStates);
      } else {
        filteredStates = allStates
            .where((state) => state.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showStateSelector() {
    setState(() {
      filteredStates = List.from(allStates);
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(CupertinoIcons.xmark)),
                        Text(
                          'Location',
                          style: AppTextStyles.bodyOpenSans.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 50)
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: AppColors.lightViolet,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search state',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _filterStates('');
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filterStates(value);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStates.length,
                  itemBuilder: (context, index) {
                    final state = filteredStates[index];
                    return InkWell(
                      onTap: () {
                        this.setState(() {
                          selectedState = state;
                          _controller.text = state;
                        });
                        _searchController.clear();
                        _filterStates('');
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey[200]!),
                          ),
                        ),
                        child: Text(
                          state,
                          style: AppTextStyles.bodyOpenSans,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
        NeumorphicCard(
          isSelected: false,
          onTap: _showStateSelector,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location',
                style: AppTextStyles.bodyOpenSans
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  readOnly: true,
                  onTap: _showStateSelector,
                  decoration: const InputDecoration(
                    hintText: 'Select state',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
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
          updatedData['gender'] = getSelectedGender();
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
        final height = _updateTotalHeighToInches();
        if (height != null) {
          // Convert inches to cm for API
          final heightInCm = height * 2.54;
          updatedData['height'] = heightInCm;
        }
        break;
      case 'ethnicity':
        if (_selectedEthnicity != null) {
          updatedData['ethnicity'] = _selectedEthnicity;
        }
        break;
      case 'address':
        updatedData['address'] = _controller.text;
        break;
    }

    widget.onUpdate(updatedData);
    Navigator.pop(context);
  }
}
