import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/check_list/health_assesment_checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/checklist/checklist_health_assessment.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/ethnicity_selection_sheet.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/health_details_sheet.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/physical_info_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/base_scafold.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/location_bottom_sheet.dart';

class AssessmentResultsScreen extends StatefulWidget {
  const AssessmentResultsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AssessmentResultsScreen> createState() =>
      _AssessmentResultsScreenState();
}

class _AssessmentResultsScreenState extends State<AssessmentResultsScreen>
    with SingleTickerProviderStateMixin {
  Map<String, bool> _documents = {};
  Map<String, bool> _informationToPrepare = {};
  Map<String, bool> _questionsForDoctor = {};
  Map<String, bool> _testsToDiscuss = {};
  Map<String, bool> _followUpItems = {};
  String _lastEdited = '';

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
    return BlocListener<HealthAssessmentCubit, HealthAssessmentState>(
      listener: (context, state) {
        if (state is HealthAssessmentGuideViewFetched) {
          setState(() {
            // Clear existing maps
            _documents.clear();
            _informationToPrepare.clear();
            _questionsForDoctor.clear();
            _testsToDiscuss.clear();
            _followUpItems.clear();

            // Populate documents
            for (var doc in state.guideView['documents_to_bring_details']) {
              _documents[doc['document_name']] = false;
            }

            // Populate information to prepare
            for (var info
                in state.guideView['information_to_prepare_details']) {
              _informationToPrepare[info['information']] = false;
            }

            // Populate questions for doctor
            for (var question
                in state.guideView['questions_for_doctor_details']) {
              _questionsForDoctor[question['question_text']] = false;
            }

            // Populate tests to discuss
            for (var test in state.guideView['medical_test_details']) {
              _testsToDiscuss[test['test_name']] = false;
            }

            // Populate follow-up items
            for (var item
                in state.guideView['appointment_followup_items_details']) {
              _followUpItems[item['follow_up_item_text']] = false;
            }

            // Update last edited date
            _lastEdited = state.guideView['updated_at'];
          });
        }
      },
      child:
      
      
     Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 90,
        color: Colors.white,
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                final healthCubit = context.read<HealthAssessmentCubit>();
                if (healthCubit.state is HealthAssessmentGuideViewFetched) {
                  final state = healthCubit.state as HealthAssessmentGuideViewFetched;
                  final checklistCubit = context.read<HealthAssessmentChecklistCubit>();
                  
                  // Create filtered guide view with only selected items
                  final filteredGuideView = Map<String, dynamic>.from(state.guideView);
                  
                  // Filter information to prepare
                  filteredGuideView['information_to_prepare_details'] = state.guideView['information_to_prepare_details']
                      .where((info) => _informationToPrepare[info['information']] == true)
                      .toList();
                  
                  // Filter questions for doctor
                  filteredGuideView['questions_for_doctor_details'] = state.guideView['questions_for_doctor_details']
                      .where((question) => _questionsForDoctor[question['question_text']] == true)
                      .toList();
                  
                  // Filter tests to discuss
                  filteredGuideView['medical_test_details'] = state.guideView['medical_test_details']
                      .where((test) => _testsToDiscuss[test['test_name']] == true)
                      .toList();
                  
                  checklistCubit.populateFromAssessmentResults(filteredGuideView);
                  
                  checklistCubit.setChecklistTitle(healthCubit.appointmentType);
                  checklistCubit.setAppointmentTypeId(healthCubit.appointmentTypeId);
                  
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistHealthAssessment()));
              },
              child: Container(
                width: double.infinity,
                height: 50,
               decoration: BoxDecoration(
                color: AppColors.amethystViolet,
                borderRadius: BorderRadius.circular(30)
               ),
               child: Center(
                child: Text('Create a Check List', style: AppTextStyles.bodyOpenSans.copyWith(color: Colors.white),),
               )
              ),
            )
          ],
        )

      ),
        
        body: BlocBuilder<HealthAssessmentCubit, HealthAssessmentState>(
            builder: (context, state) {
          if (state is HealthAssessmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  title: Text('Results', style: AppTextStyles.heading3,),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                Container(
                  color: AppColors.lightViolet,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: BlocBuilder<HealthAssessmentCubit,
                          HealthAssessmentState>(
                        builder: (context, state) {
                          final healthCubit =
                              context.read<HealthAssessmentCubit>();
                          final weight = healthCubit.userWeight;
                          final heightInches = healthCubit.heightInInches;


                          final age = healthCubit.age;
                          final heightFeet = healthCubit.heightInFeet;
                          final appointment = healthCubit.appointmentType;
                          final existingCondiontion =
                              healthCubit.preExistingConditionText;
                          final healthConcerns =
                              healthCubit.specificHealthConcerns;
                          final healthGoals = healthCubit.specificHealthGoals;
                          final householdIncome = healthCubit.income;
                          final location = healthCubit.location;
                          final symptoms = healthCubit.symptoms;
                          final ethinicietes = healthCubit.ethnicities;
                          final existingCondition =
                              healthCubit.preExistingConditionText;
                              
                          

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) =>
                                        PhysicalInfoBottomSheet(
                                      initialFeet: heightFeet,
                                      initialInches: heightInches,
                                      initialWeight: weight.toDouble(),
                                      initialAge: age,
                                    ),
                                  );
                                },
                                child: _buildInfoSection('Physical Information',
                                    '$heightFeet Feet $heightInches Inches, 128 lbs, $age years Old'),
                              ),
                              GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    LocationBottomSheet.show(
                                      context: context,
                                      states: healthCubit.states,
                                      onStateSelected: (p0) {
                                        healthCubit.setLocation(p0.stateName);
                                        healthCubit.setSelectedState(p0);
                                        healthCubit.updateHealthAssessment();
                                      },
                                    ).then(
                                      (value) {
                                        setState(() {});
                                      },
                                    );
                                  },
                                  child:
                                      _buildInfoSection('Location', location)),
                              GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)),
                                      ),
                                      builder: (context) =>
                                          EthnicitySelectionSheet(
                                        selectedEthnicities:
                                            ethinicietes, // Pass current ethnicities list
                                      ),
                                    );
                                  },
                                  child: _buildInfoSection(
                                      'Ethnicity', '$ethinicietes')),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  final AppointmentTypeModel result =
                                      await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    builder: (context) =>
                                        DraggableScrollableSheet(
                                      initialChildSize: 0.90,
                                      maxChildSize: 0.90,
                                      minChildSize: 0.5,
                                      builder: (context, scrollController) =>
                                          Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: const AppointmentTypeScreen(),
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    final healthCubit =
                                        context.read<HealthAssessmentCubit>();
                                    healthCubit.setAppointmentTypeId(result.id);
                                    healthCubit.setAppointmentType(result.name); 
                                    setState(() {});
                                  }
                                },
                                child: _buildInfoSection(
                                    'Type of Appointment', '$appointment'),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    builder: (context) => HealthDetailsSheet(
                                      existingCondition:
                                          existingCondition, // Pass current values
                                      healthGoals: healthGoals,
                                      healthConcerns: healthConcerns,
                                      currentIncome: householdIncome,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    _buildInfoSection('Pre-existing conditions',
                                        existingCondition),
                                    _buildInfoSection(
                                        'Health Concerns', healthConcerns),
                                    _buildInfoSection(
                                        'Health Goals', healthGoals),
                                    _buildInfoSection(
                                        'Household income', householdIncome),
                                  ],
                                ),
                              ),
                              // _buildInfoSection('Symptoms', symptoms),
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
                        ),
                        child: Text(
                          'We understand that managing multiple health concerns can be challenging, and we are here to support you every step of the way. Your upcoming appointment is a great opportunity to address these issues comprehensively with your health care provider.',
                          style: AppTextStyles.bodyOpenSans,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _documents.isEmpty
                          ? SizedBox()
                          : _buildSection(
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
                      _testsToDiscuss.isEmpty
                          ? SizedBox()
                          : _buildSection(
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
          );
        }),
      ),
    );
  }

  Widget _buildSection(String title, Map<String, bool> items) {
    return Container(
      decoration: BoxDecoration(),
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
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: items.isEmpty
                  ? [
                      Text(
                        'No items available',
                        style: AppTextStyles.bodyOpenSans,
                      ),
                    ]
                  : items.entries
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
        IgnorePointer(
          child: TextFormField(
              controller: TextEditingController(text: content),
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Enter $title',
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              )),
        ),
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
    return GestureDetector(
      onTap: () {
        SnackbarUtils.showSuccess(
            context: context,
            title: 'Updated',
            message: 'Assessment has been updated');
      },
      child: Container(
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
      ),
    );
  }
}
