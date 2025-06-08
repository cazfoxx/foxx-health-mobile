import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer';
import 'package:foxxhealth/features/data/models/appointment_info_model.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/check_list/health_assesment_checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/appointment_info/appointment_info_screen.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/base_scafold.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
// import 'package:share_plus/share_plus.dart';

class ChecklistHealthAssessment extends StatefulWidget {
  const ChecklistHealthAssessment({super.key});

  @override
  State<ChecklistHealthAssessment> createState() => _ChecklistHealthAssessmentState();
}

class _ChecklistHealthAssessmentState extends State<ChecklistHealthAssessment> {
  bool _isEditing = false;
  String appointment = '';

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to ensure the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      saveChecklist();
    });
  }

  saveChecklist() async {
    try {
      final cubit = context.read<HealthAssessmentChecklistCubit>();
      await cubit.saveChecklist();
      if (mounted && cubit.state is! HealthAssessmentChecklistError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checklist saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save checklist: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthAssessmentChecklistCubit, HealthAssessmentChecklistState>(
      builder: (context, state) {
        final cubit = context.read<HealthAssessmentChecklistCubit>();
        return BaseScaffold(
          appBar: _buildAppBar(),
          currentIndex: 0,
          onTap: (p0) {
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false,
        );   
          },
       
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      if (cubit.informationToPrepare.isNotEmpty)
                        Column(
                          children: [
                            _buildSection(
                              'Information to prepare',
                              cubit.informationToPrepare,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      if (cubit.questionsForDoctor.isNotEmpty)
                        Column(
                          children: [
                            _buildSection(
                              'Questions for Doctor',
                              cubit.questionsForDoctor,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      if (cubit.testsToDiscuss.isNotEmpty)
                        _buildSection(
                          'Tests to discuss',
                          cubit.testsToDiscuss,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Check List',
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
      ),
      leadingWidth: 100,
      leading: TextButton(
        onPressed: () {
          setState(() => _isEditing = !_isEditing);
        },
        child: Text(
          _isEditing ? 'Done' : 'Edit',
          style: AppTextStyles.body.copyWith(
            color: AppColors.amethystViolet,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon:
              const Icon(CupertinoIcons.share, color: AppColors.amethystViolet),
          onPressed: _shareChecklist,
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  void _shareChecklist() {
    // Share functionality to be implemented
  }

  Widget _buildHeaderSection() {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: InkWell(
                onTap: () => _showEditBottomSheet('Health Assessment Checklist'),
                child: Text(
                  'Health Assessment Checklist',
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.amethystViolet,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.disabledButton.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: _buildAppointmentRow(),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheet(String currentName) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        TextEditingController controller =
            TextEditingController(text: currentName);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(hintText: 'Enter new name'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppointmentRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Appointment',
          style: AppTextStyles.body2,
        ),
        SizedBox(
          height: 50,
          child: VerticalDivider(
            color: Colors.grey.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'existing',
                child: Text(
                  'Add to Existing Visit',
                  style: AppTextStyles.body2OpenSans,
                ),
              ),
              PopupMenuItem(
                value: 'new',
                child: Text(
                  'Create New Visit',
                  style: AppTextStyles.body2OpenSans,
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'existing') {
                final AppointmentInfoModel result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.transparent,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.90,
                    maxChildSize: 0.90,
                    minChildSize: 0.5,
                    builder: (context, scrollController) => Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: const AppointmentInfoScreen(),
                    ),
                  ),
                );

                if (result != null) {
                  //show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appointment added successfully')),
                  );
                  setState(() {
                    appointment = result.titleText;
                  });
                }
              } else {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => const NewAppointmentScreen(),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    appointment.isEmpty ? 'Add to Visit' : appointment,
                    style: AppTextStyles.body2OpenSans,
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddItemBottomSheet(String section) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final TextEditingController controller = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Item',
                style: AppTextStyles.heading3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter item details',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        final cubit = context.read<HealthAssessmentChecklistCubit>();
                        switch (section) {
                          case 'Information to prepare':
                            cubit.addInformationToPrepare(controller.text.trim());
                            break;
                          case 'Questions for Doctor':
                            cubit.addQuestionForDoctor(controller.text.trim());
                            break;
                          case 'Tests to discuss':
                            cubit.addTestToDiscuss(controller.text.trim());
                            break;
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amethystViolet,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showAddNoteBottomSheet(ChecklistItem item, String section) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final TextEditingController controller = TextEditingController(text: item.note);
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Note',
                style: AppTextStyles.heading3.copyWith(color: AppColors.davysGray),
              ),
              const SizedBox(height: 8),
              Text(
                item.text,
                style: AppTextStyles.body2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter your note here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      final cubit = context.read<HealthAssessmentChecklistCubit>();
                      cubit.updateNote(item.text, controller.text, section);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.amethystViolet,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, List<ChecklistItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.heading3),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.lightViolet.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.lightViolet.withOpacity(0.2),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(
                      item.text,
                      style: AppTextStyles.body2,
                    ),
                    subtitle: title == 'Information to prepare' ? GestureDetector(
                      onTap: () => _showAddNoteBottomSheet(item, title),
                      child: Text(
                        item.note?.isNotEmpty == true ? item.note! : 'Add note',
                        style: AppTextStyles.body2OpenSans.copyWith(
                          color: AppColors.davysGray,
                          fontSize: 12,
                        ),
                      ),
                    ) : null,
                    trailing: _isEditing
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              final cubit = context.read<HealthAssessmentChecklistCubit>();
                              switch (title) {
                                case 'Information to prepare':
                                  cubit.removeInformationToPrepare(item.text);
                                  break;
                                case 'Questions for Doctor':
                                  cubit.removeQuestionForDoctor(item.text);
                                  break;
                                case 'Tests to discuss':
                                  cubit.removeTestToDiscuss(item.text);
                                  break;
                              }
                            },
                          )
                        : null,
                  );
                },
              ),
              InkWell(
                onTap: () => _showAddItemBottomSheet(title),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: AppColors.davysGray,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Add Item',
                        style: AppTextStyles.body2OpenSans.copyWith(
                          color: AppColors.davysGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
