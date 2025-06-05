import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart'
    show AppointmentTypeModel;
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/see_full_list_screen.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/base_scafold.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

// import 'package:share_plus/share_plus.dart';

class ChecklistDetailsScreen extends StatefulWidget {
  const ChecklistDetailsScreen({super.key});

  @override
  State<ChecklistDetailsScreen> createState() => _ChecklistDetailsScreenState();
}

class _ChecklistDetailsScreenState extends State<ChecklistDetailsScreen> {
  bool _isEditing = false;
  String appointment = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistCubit, ChecklistState>(
      builder: (context, state) {
        final cubit = context.read<ChecklistCubit>();
        return BaseScaffold(
          currentIndex: 0,
          onTap: (p0) {
             Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) =>  HomeScreen(selectedIndex: p0,)),
                  (route) => false,);
          },
          
        
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                _buildHeaderSection(),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: (){
                          showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => FractionallySizedBox(
                      heightFactor: 0.9,
                      child: SeeFullListScreen(
                        selectedQuestions: cubit.suggestedQuestion,
                        onUpdate: (updatedQuestions) {
                          // Handle updated questions
                        },
                      ),
                    ),
                  ).then(
                    (value) {
                      setState(() {});
                    },
                  );
                        },
                        child: _buildReorderableSection(
                          'Suggested Questions',
                          cubit.suggestedQuestion,
                          (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) newIndex -= 1;
                              final item =
                                  cubit.suggestedQuestion.removeAt(oldIndex);
                              cubit.suggestedQuestion.insert(newIndex, item);
                            });
                          },
                          showSeeAll: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: (){

                _showAddItemSheet('Personal Questions', (text) {
                  final cubit = context.read<ChecklistCubit>();
                  cubit.addCustomQuestion(text);
                });
                        },
                        child: _buildReorderableSection(
                          'Personal Questions',
                          cubit.customQuestion,
                          (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) newIndex -= 1;
                              final item =
                                  cubit.customQuestion.removeAt(oldIndex);
                              cubit.customQuestion.insert(newIndex, item);
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        'Prescriptions & Supplements',
                        cubit.prescription,
                      ),
                      const SizedBox(height: 24),
                      _buildSection('Medical Term Explainer', []),
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
          if (_isEditing) {
            // Get the cubit instance
            final cubit = context.read<ChecklistCubit>();

            // Call edit checklist API
            cubit.editChecklist().then((_) {
              SnackbarUtils.showSuccess(
                context: context,
                title: 'Checklist',
                message: 'Updated successfully',
              );
              // Show success snackbar
            });
          }
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
    final cubit = context.read<ChecklistCubit>();
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
                onTap: () => _showEditBottomSheet(cubit.checkListName),
                child: Text(
                  cubit.checkListName.isEmpty
                      ? 'Check List'
                      : cubit.checkListName,
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
        final cubit = context.read<ChecklistCubit>();
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
                  cubit.setCheckListName(controller.text);
                  setState(() {}); // Refresh UI
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
                final AppointmentTypeModel result = await showModalBottomSheet(
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
                      child: const AppointmentTypeScreen(),
                    ),
                  ),
                );

                if (result != null) {
                  final checklistCubit = context.read<ChecklistCubit>();
                  checklistCubit.setAppointmentTypeId(result.id);
                  checklistCubit.setCheckListName(result.name);
                  setState(() {
                    appointment = result.name;
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

  Widget _buildReorderableSection(
    String title,
    List<String> items,
    void Function(int, int) onReorder, {
    bool showSeeAll = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.heading3),
            if (showSeeAll)
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => FractionallySizedBox(
                      heightFactor: 0.9,
                      child: SeeFullListScreen(
                        selectedQuestions: items,
                        onUpdate: (updatedQuestions) {
                          // Handle updated questions
                        },
                      ),
                    ),
                  ).then(
                    (value) {
                      setState(() {});
                    },
                  );
                },
                child: Text(
                  'See All',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.amethystViolet,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightViolet.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: AppColors.amethystViolet,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add $title',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.amethystViolet,
                  ),
                ),
              ],
            ),
          )
        else if (_isEditing)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightViolet.withOpacity(0.2),
              ),
            ),
            child: ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: onReorder,
              children: [
                for (int index = 0; index < items.length; index++)
                  ListTile(
                    key: ValueKey('$title-$index'),
                    leading: const Icon(
                        Icons.drag_handle), // Drag handle on the left
                    title: Text(
                      items[index],
                      style: AppTextStyles.body2,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          items.removeAt(index);
                        });
                      },
                    ), // Delete button on the right
                  ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightViolet.withOpacity(0.2),
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Divider(
                  color: Colors.grey.withOpacity(0.3),
                  height: 1,
                ),
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    items[index],
                    style: AppTextStyles.body2,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items,
      {bool showSeeAll = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.heading3),
            if (showSeeAll)
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeeFullListScreen(
                        selectedQuestions: items,
                        onUpdate: (updatedQuestions) {
                          // Handle updated questions
                        },
                      ),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.amethystViolet,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          InkWell(
            onTap: () {
         
           
             if (title == 'Prescriptions & Supplements') {
                _showAddItemSheet(title, (text) {
                  final cubit = context.read<ChecklistCubit>();
                  cubit.addPrescription(text);
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.lightViolet.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: AppColors.amethystViolet,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Add $title',
                    style: AppTextStyles.body2.copyWith(
                      color: AppColors.amethystViolet,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.lightViolet.withOpacity(0.2),
              ),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.lightViolet.withOpacity(0.2),
                height: 1,
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    items[index],
                    style: AppTextStyles.body2,
                  ),
                  trailing: _isEditing
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                        )
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }

  void _showAddItemSheet(String title, Function(String) onSave) {
    final textController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add ${title.split('&').first.trim()}',
                    style: AppTextStyles.heading3,
                  ),
                  TextButton(
                    onPressed: () {
                      if (textController.text.isNotEmpty) {
                        onSave(textController.text);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Save',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.amethystViolet,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter ${title.split('&').first.trim().toLowerCase()}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.lightViolet.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.lightViolet.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.amethystViolet,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }
}
