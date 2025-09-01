import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/profile/profile_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_profile/health_profile_questions_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';

class HealthProfileScreen extends StatefulWidget {
  const HealthProfileScreen({super.key});

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  late SymptomSearchCubit _symptomCubit;
  List<Map<String, dynamic>> sampleQuestions = [];
  bool _isLoadingQuestions = true;

  @override
  void initState() {
    super.initState();
    _symptomCubit = SymptomSearchCubit();
    _loadSampleQuestions();
  }

  @override
  void dispose() {
    _symptomCubit.close();
    super.dispose();
  }

  Future<void> _loadSampleQuestions() async {
    try {
      final questionsData = await _symptomCubit.getGetToKnowMeQuestions();
      if (questionsData.isNotEmpty) {
        setState(() {
          // Take first 3 questions for the preview
          sampleQuestions = questionsData.take(3).map((question) => {
            'question': question['question_text'] ?? '',
            'id': question['id'] ?? '',
          }).toList();
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
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary01),
          ),
          actions: [
          Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.mauve50,
                              radius: 20,
                              child: Icon(Icons.chat_bubble_outline,
                                  color: AppColors.amethyst, size: 20),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ProfileScreen(),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.mauve50,
                                radius: 20,
                                child: Icon(Icons.person_outline,
                                    color: AppColors.amethyst, size: 20),
                              ),
                            ),
                          ],
                        ),
          ],
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
                      _buildGetToKnowMeSection(),
                      const SizedBox(height: 32),
                      
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top right icons
       
          const SizedBox(height: 16),
          
          // Title
          const Text(
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
            const Text(
              'Get to know me',
              style: AppTextStyles.heading3
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HealthProfileQuestionsScreen(),
                  ),
                );
              },
              child: const Text(
                'See All',
                style: AppOSTextStyles.osMdSemiboldTitle
              ),
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
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.amethyst),
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
        _buildCoreProfileCard('Gender', 'Female'),
        const SizedBox(height: 12),
        _buildCoreProfileCard('Age', '27 years'),
        const SizedBox(height: 12),
        _buildCoreProfileCard('Weight', '100 lbs'),
      ],
    );
  }

  Widget _buildCoreProfileCard(String title, String value) {
    return GestureDetector(
      onTap: () {
        // Handle card tap
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
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
}
