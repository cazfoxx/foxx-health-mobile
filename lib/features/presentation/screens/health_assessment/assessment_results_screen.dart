import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class AssessmentResultsScreen extends StatefulWidget {
  final List<String> selectedSymptoms;

  const AssessmentResultsScreen({
    Key? key,
    required this.selectedSymptoms,
  }) : super(key: key);

  @override
  State<AssessmentResultsScreen> createState() =>
      _AssessmentResultsScreenState();
}

class _AssessmentResultsScreenState extends State<AssessmentResultsScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, bool> _documents = {
    'Photo ID': false,
    'Insurance card': false,
    'List of current medications and supplements': false,
    'Any relevant medical records or previous test results': false,
  };

  final Map<String, bool> _informationToPrepare = {
    'Detailed description of your migraine episodes including frequency, intensity, and triggers, recent changes in your diet or lifestyle, any new symptoms or changes in existing conditions, family medical history, especially related to migraine or dental issue.':
        false,
    'Lorem ipsum dolor sit amet consectetur. Facilisi sit fermentum faucibus enim aliquet in pellentesque odio urna.':
        false,
    'Lorem ipsum dolor sit amet consectetur.': false,
  };

  final Map<String, bool> _questionsForDoctor = {
    'Given my background and diet, what additional dietary changes or supplements would you recommend to better manage my scurvy?':
        false,
    'Could there be a link between my tooth pain and vitamin deficiencies, and what steps can we take to address this?':
        false,
    'Are there specific migraine treatments that have shown effectiveness in South Asian populations?':
        false,
    'Considering my age and symptoms, are there any preventive measures or screenings you suggest to avoid future health issues?':
        false,
    'How should I monitor the effectiveness of the current supplements I am taking, and are there potential interactions I should be aware of?':
        false,
  };

  final Map<String, bool> _testsToDiscuss = {
    'Lorem ipsum dolor sit amet consectetur. Facilisi sit fermentum faucibus enim aliquet in pellentesque odio urna.':
        false,
    'Lorem ipsum dolor sit amet consectetur. Facilisi sit fermentum faucibus.':
        false,
    'Lorem ipsum dolor sit amet consectetur.': false,
  };

  final Map<String, bool> _followUpItems = {
    'Lorem ipsum dolor sit amet consectetur. Facilisi sit fermentum faucibus enim aliquet in pellentesque odio urna.':
        false,
    'Lorem ipsum dolor sit amet consectetur. Facilisi sit fermentum faucibus.':
        false,
    'Lorem ipsum dolor sit amet consectetur.': false,
  };

  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = Tween(
      begin: -0.25,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen())),
        ),
        title: const Text(
          'Results',
          style: AppTextStyles.heading3,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.lightViolet,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Personal Health Guide',
                      style: AppTextStyles.heading2.copyWith(
                        color: AppColors.amethystViolet,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last Edited: April 3, 2025',
                      style: AppTextStyles.body2OpenSans.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              shape: const Border(),
              onExpansionChanged: (expanded) {
                setState(() {
                  if (expanded) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                });
              },
              title: Text(
                'What I Shared About Me',
                style: AppTextStyles.heading3,
              ),
              trailing: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.amethystViolet,
                child: RotationTransition(
                  turns: _expandAnimation,
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF000000)
                            .withOpacity(0.09), // 9% opacity black
                        offset: const Offset(0, 0), // Y offset of 13
                        blurRadius: 13, // Blur of 13
                        spreadRadius: 6, // Spread of 6
                      ),
                    ],
                  ),
                  child:
                      BlocBuilder<HealthAssessmentCubit, HealthAssessmentState>(
                    builder: (context, state) {
                      final healthCubit = context.read<HealthAssessmentCubit>();
                      final weight = healthCubit.userWeight;
                      final heightInches = healthCubit.heightInInches;
                      final heightFeet = healthCubit.heightInFeet;
                      final appointment = healthCubit.appointmentTypeId;
                      final existingCondiontion =
                          healthCubit.preExistingConditionText;
                      final healthConcerns = healthCubit.specificHealthConcerns;
                      final healthGoals = healthCubit.specificHealthGoals;
                      final householdIncome = healthCubit.income;
                      final location = healthCubit.location;
                      final symptoms = healthCubit.symptoms;
                      final ethinicietes = healthCubit.ethnicities;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoSection('Physical Information',
                              '$heightFeet Feet $heightInches Inches, 128 lbs, 22 years Old'),
                          _buildInfoSection('Location', location),
                          _buildInfoSection('Ethnicity', '$ethinicietes'),
                          _buildInfoSection(
                              'Type of Appointment', '$appointment'),
                          _buildInfoSection('Pre-existing conditions', 'None'),
                          _buildInfoSection('Health Concerns', healthConcerns),
                          _buildInfoSection('Health Goals', healthGoals),
                          _buildInfoSection(
                              'Household income', householdIncome),
                          _buildInfoSection('Symptoms', symptoms),
                          _buildSymptomChips(),
                          // _buildInfoSection('Prescriptions & Supplements',
                          //     'Vitamin C, Montelukast, Zyrtec, Calcium'),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Personal Health Guide',
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.amethystViolet,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000)
                              .withOpacity(0.09), // 9% opacity black
                          offset: const Offset(0, 0), // Y offset of 13
                          blurRadius: 13, // Blur of 13
                          spreadRadius: 6, // Spread of 6
                        ),
                      ],
                    ),
                    child: Text(
                      'We understand that managing multiple health concerns like ${widget.selectedSymptoms.join(", ")} can be challenging, and we are here to support you every step of the way. Your upcoming appointment is a great opportunity to address these issues comprehensively with your health care provider.',
                      style: AppTextStyles.bodyOpenSans,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Documents to bring',
                    _documents,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Information to prepare',
                    _informationToPrepare,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Questions for doctor',
                    _questionsForDoctor,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Tests to discuss',
                    _testsToDiscuss,
                  ),
                  const SizedBox(height: 20),
                  _buildSection(
                    'Follow-up items',
                    _followUpItems,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Emotional Support',
                    style: AppTextStyles.heading3.copyWith(),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000)
                              .withOpacity(0.09), // 9% opacity black
                          offset: const Offset(0, 13), // Y offset of 13
                          blurRadius: 13, // Blur of 13
                          spreadRadius: 6, // Spread of 6
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'We understand that managing multiple health concerns like scurvy, tooth pain, and migraines can be challenging, and we are here to support you every step of the way.Your upcoming appointment is a great opportunity to address these issues comprehensively with your health care provider.',
                          style: AppTextStyles.bodyOpenSans,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Your Personal Life Healthcare Appointment Check List',
                          style: AppTextStyles.heading3
                              .copyWith(color: AppColors.amethystViolet),
                        ),
                        Text(
                          'prepared especially for you.',
                          style: AppTextStyles.bodyOpenSans,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Map<String, bool> items) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color:
                const Color(0xFF000000).withOpacity(0.09), // 9% opacity black
            offset: const Offset(0, 13), // Y offset of 13
            blurRadius: 13, // Blur of 13
            spreadRadius: 6, // Spread of 6
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.heading3),
              TextButton(
                onPressed: () {
                  setState(() {
                    items.updateAll((key, value) => true);
                  });
                },
                child: Text(
                  'Select All',
                  style: AppTextStyles.bodyOpenSans.copyWith(
                    color: AppColors.amethystViolet,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: items.entries
                  .map((entry) => CheckboxListTile(
                        value: entry.value,
                        onChanged: (bool? value) {
                          setState(() {
                            items[entry.key] = value ?? false;
                          });
                        },
                        title: Text(
                          entry.key,
                          style: AppTextStyles.bodyOpenSans,
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyOpenSans.copyWith(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextFormField(
            controller: TextEditingController(text: content),
            decoration: InputDecoration(
              hintText: 'Enter $title',
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            )),
        Divider(
          color: Colors.grey[300],
          height: 16,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildSymptomChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildSymptomChip('Changes in eating habits'),
        _buildSymptomChip('Chest & Upper back\nDull Pain'),
      ],
    );
  }

  Widget _buildSymptomChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightViolet.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyOpenSans.copyWith(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.close,
            size: 16,
            color: AppColors.amethystViolet,
          ),
        ],
      ),
    );
  }
}
