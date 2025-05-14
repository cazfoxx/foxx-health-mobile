import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/widgets/appointment_list_bottomsheet_widget.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/see_full_list_screen.dart';
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
  final List<String> _allSuggestedQuestions = [
    'How often should I schedule checkups?',
    'What screenings should I be getting based on my age and family history?',
    'Am I up-to-date on my immunizations?',
    'Should I be taking supplements?',
  ];

  List<String> get _suggestedQuestions {
    return _allSuggestedQuestions.take(3).toList();
  }

  final List<String> _personalQuestions = [
    'Do I need a flu shot?',
    'Should I be taking supplements?',
    'Do I need a new blood test?',
    'Can you explain my test results?',
  ];
  String appointment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
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
                  _buildSection(
                    'Suggested Questions',
                    _suggestedQuestions,
                    showSeeAll: true,
                  ),
                  const SizedBox(height: 24),
                  _buildSection('Personal Questions', _personalQuestions),
                  const SizedBox(height: 24),
                  _buildSection('Prescriptions & Supplements', []),
                  const SizedBox(height: 24),
                  _buildSection('Medical Term Explainer', []),
                ],
              ),
            )
          ],
        ),
      ),
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
        onPressed: () => setState(() => _isEditing = !_isEditing),
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
    // Share.share('Collaborate your check list with other Foxx members\n\n' +
    //     _suggestedQuestions.join('\n') +
    //     '\n\n' +
    //     _personalQuestions.join('\n'));
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
              child: Text(
                'PCP Check List',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.amethystViolet,
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
            offset: Offset(0, 40),
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
              // Handle selection
              if (value == 'existing') {
                final result = await showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => const AppointmentListBottomSheet(),
                );
                setState(() {
                  appointment = result;
                });
              } else {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => const NewAppointmentScreen(),
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 4),
                appointment.isEmpty ? Icon(Icons.add, size: 18) : SizedBox(),
                const SizedBox(width: 4),
                Text(
                  appointment.isEmpty ? 'Add' : appointment,
                  style: AppTextStyles.body2OpenSans.copyWith(),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items,
      {bool showSeeAll = false}) {
    final TextEditingController controller = TextEditingController();
    final displayItems =
        title == 'Suggested Questions' ? _suggestedQuestions : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            if (showSeeAll)
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => FractionallySizedBox(
                      heightFactor: 0.9,
                      child: SeeFullListScreen(
                        selectedQuestions: _allSuggestedQuestions,
                        onUpdate: (updatedQuestions) {
                          setState(() {
                            _allSuggestedQuestions.clear();
                            _allSuggestedQuestions.addAll(updatedQuestions);
                          });
                        },
                      ),
                    ),
                  );
                },
                child: Text(
                  'See Full List',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.amethystViolet,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              if (displayItems.isNotEmpty)
                _isEditing
                    ? _buildEditableList(displayItems)
                    : _buildReadOnlyList(displayItems),
              if (items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              if (!_isEditing && title != 'Suggested Questions')
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: 'Add',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Icon(
                          Icons.add_circle_outline,
                          color: Colors.grey[600],
                          // size: 20,
                        ),
                      ),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        setState(() {
                          items.add(value.trim());
                          controller.clear();
                        });
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableList(List<String> items) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => Column(
        key: ValueKey(items[index]),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                  child: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    items[index],
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
              ],
            ),
          ),
          if (index < items.length - 1)
            Divider(thickness: 1, color: Colors.grey.withOpacity(0.2)),
        ],
      ),
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
    );
  }

  Widget _buildReadOnlyList(List<String> items) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => Divider(
        thickness: 1,
        color: Colors.grey.withOpacity(0.2),
      ),
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          items[index],
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}
