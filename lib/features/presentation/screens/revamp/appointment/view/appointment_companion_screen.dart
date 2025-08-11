import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';


class AppointmentCompanionScreen extends StatefulWidget {
  final Map<String, dynamic> appointmentData;

  const AppointmentCompanionScreen({
    Key? key,
    required this.appointmentData,
  }) : super(key: key);

  @override
  State<AppointmentCompanionScreen> createState() => _AppointmentCompanionScreenState();
}

class _AppointmentCompanionScreenState extends State<AppointmentCompanionScreen> {
  bool isCompanionTabSelected = true;
  bool isSymptomsExpanded = true;
  final TextEditingController _newQuestionController = TextEditingController();

  final List<String> questions = [
    'I\'ve tried various things and still feel without answers. What is our comprehensive diagnostic roadmap for my **fatigue** and **irregular cycles**, and what\'s the plan if initial tests don\'t provide a clear explanation?',
    'I\'ve tried various things and still feel without answers. What is our comprehensive diagnostic roadmap for my **fatigue** and **irregular cycles**, and what\'s the plan if initial tests don\'t provide a clear explanation?',
    'I\'ve tried various things and still feel without answers. What is our comprehensive diagnostic roadmap for my **fatigue** and **irregular cycles**, and what\'s the plan if initial tests don\'t provide a clear explanation?',
  ];

  @override
  void dispose() {
    _newQuestionController.dispose();
    super.dispose();
  }

  String _generatePersonalizedMessage() {
    // Generate personalized message based on collected data
    final symptoms = widget.appointmentData['selectedSymptoms'] as List<String>? ?? [];
    final situations = widget.appointmentData['lifeSituations'] as List<String>? ?? [];
    final experiences = widget.appointmentData['careExperiences'] as List<String>? ?? [];
    
    String message = "It sounds like you're carrying a heavy load right now";
    
    if (situations.isNotEmpty) {
      message += ", navigating the demands of ${situations.first.toLowerCase()}";
    }
    
    if (symptoms.isNotEmpty) {
      message += ", all while grappling with persistent ${symptoms.first.toLowerCase()}";
    }
    
    message += " at just 22. It's incredibly frustrating to have sought answers before and still feel stuck, but your determination to understand why you're so tired is truly commendable. This appointment is an important step in advocating for your well-being, and we're here to help you feel prepared and empowered.";
    
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary01),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Appointment Companion',
            style: AppHeadingTextStyles.h4.copyWith(
              color: AppColors.primary01,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // TODO: Implement save functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Appointment companion saved!')),
                );
              },
              child: Text(
                'Save',
                style: AppOSTextStyles.osMd.copyWith(
                  color: AppColors.amethyst,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Appointment Header Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.backgroundHighlighted.withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: AppColors.davysGray,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Appointment: Dec 15, 2024',
                              style: AppOSTextStyles.osMd.copyWith(
                                color: AppColors.davysGray,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            // TODO: Show more options
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Appointment prep for your Endocrinologist',
                      style: AppHeadingTextStyles.h4.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 16,
                          color: AppColors.amethyst,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Add tag',
                          style: AppOSTextStyles.osMd.copyWith(
                            color: AppColors.amethyst,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Tabs
              Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isCompanionTabSelected = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: isCompanionTabSelected 
                                ? AppColors.backgroundHighlighted.withOpacity(0.3)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Companion',
                            textAlign: TextAlign.center,
                            style: AppOSTextStyles.osMd.copyWith(
                              color: isCompanionTabSelected 
                                  ? AppColors.amethyst 
                                  : AppColors.davysGray,
                              fontWeight: isCompanionTabSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isCompanionTabSelected = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: !isCompanionTabSelected 
                                ? AppColors.backgroundHighlighted.withOpacity(0.3)
                                : Colors.transparent,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Post Visit',
                            textAlign: TextAlign.center,
                            style: AppOSTextStyles.osMd.copyWith(
                              color: !isCompanionTabSelected 
                                  ? AppColors.amethyst 
                                  : AppColors.davysGray,
                              fontWeight: !isCompanionTabSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isCompanionTabSelected) ...[
                        // Personalized Result Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Here\'s your result for your appointment companion',
                                style: AppHeadingTextStyles.h4.copyWith(
                                  color: AppColors.primary01,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _generatePersonalizedMessage(),
                                style: AppOSTextStyles.osMd.copyWith(
                                  color: AppColors.davysGray,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Questions Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Questions to ask your doctor',
                                style: AppHeadingTextStyles.h4.copyWith(
                                  color: AppColors.primary01,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // Based on symptoms section
                              GestureDetector(
                                onTap: () => setState(() => isSymptomsExpanded = !isSymptomsExpanded),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: AppColors.gray200,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Based on my symptoms',
                                        style: AppOSTextStyles.osMd.copyWith(
                                          color: AppColors.primary01,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(
                                        isSymptomsExpanded 
                                            ? Icons.keyboard_arrow_up 
                                            : Icons.keyboard_arrow_down,
                                        color: AppColors.amethyst,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              if (isSymptomsExpanded) ...[
                                const SizedBox(height: 16),
                                
                                // More like this button
                                Row(
                                  children: [
                                    Icon(
                                      Icons.refresh,
                                      size: 16,
                                      color: AppColors.amethyst,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'More like this',
                                      style: AppOSTextStyles.osMd.copyWith(
                                        color: AppColors.amethyst,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Questions list
                                ...questions.map((question) => _buildQuestionCard(question)),
                                
                                const SizedBox(height: 16),
                                
                                // Add question section
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 16,
                                      color: AppColors.amethyst,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Add question',
                                      style: AppOSTextStyles.osMd.copyWith(
                                        color: AppColors.amethyst,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // New question input
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.gray200),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.drag_handle,
                                        size: 16,
                                        color: AppColors.gray400,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: _newQuestionController,
                                          decoration: InputDecoration(
                                            hintText: 'Add question',
                                            border: InputBorder.none,
                                            hintStyle: AppOSTextStyles.osMd.copyWith(
                                              color: AppColors.gray400,
                                            ),
                                          ),
                                          style: AppOSTextStyles.osMd.copyWith(
                                            color: AppColors.primary01,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ] else ...[
                        // Post Visit content
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post Visit Notes',
                                style: AppHeadingTextStyles.h4.copyWith(
                                  color: AppColors.primary01,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Add your notes and follow-up items here after your appointment.',
                                style: AppOSTextStyles.osMd.copyWith(
                                  color: AppColors.davysGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 40),
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

  Widget _buildQuestionCard(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundHighlighted.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.drag_handle,
                size: 16,
                color: AppColors.gray400,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppOSTextStyles.osMd.copyWith(
                      color: AppColors.primary01,
                      height: 1.4,
                    ),
                    children: _parseQuestionText(question),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Hide question',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.amethyst,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _parseQuestionText(String text) {
    final List<TextSpan> spans = [];
    final RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;
    
    for (final Match match in boldPattern.allMatches(text)) {
      // Add text before the bold part
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
        ));
      }
      
      // Add the bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      
      lastIndex = match.end;
    }
    
    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
      ));
    }
    
    return spans;
  }
}
