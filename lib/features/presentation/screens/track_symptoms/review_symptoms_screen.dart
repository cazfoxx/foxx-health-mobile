import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/widgets/appointment_list_bottomsheet_widget.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/widgets/start_date_body_widget.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/widgets/symptom_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class ReviewSymptomsScreen extends StatefulWidget {
  ReviewSymptomsScreen({Key? key, required this.descriptions})
      : super(key: key);
  String? descriptions;

  @override
  State<ReviewSymptomsScreen> createState() => _ReviewSymptomsScreenState();
}

class _ReviewSymptomsScreenState extends State<ReviewSymptomsScreen> {
  DateTime selectedDate = DateTime.now();

  String appointment = '';

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
                'Review',
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
          style: AppTextStyles.body2OpenSans,
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

  Widget _buildSymptomChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: AppTextStyles.body2OpenSans),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                // Remove the chip
                // Note: You'll need to modify your data structure to properly handle removal
                // This is just a placeholder for the removal logic
              });
            },
            child: Icon(Icons.close, size: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Track Symptoms',
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            Expanded(
              child: ListView(
                children: [
                  StartDateBodyWidget(
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    selectedDate: selectedDate,
                  ),
                  const SizedBox(height: 24),
                  _buildSymptomsSection(),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(
                      widget.descriptions ?? 'blah blah blah blah blah'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Symptoms',
            style: AppTextStyles.heading3.copyWith(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 0),
                  blurRadius: 13.0,
                  spreadRadius: 6.0,
                  color: Colors.black.withOpacity(0.09),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSymptomCategory('Physical', [
                  _buildSymptomChip('Chest & Upper back\nThrobbing pain – Mild',
                      Colors.yellow.shade100),
                  _buildSymptomChip(
                      'Abdomen & Lower back\nSharp pain – Moderate',
                      Colors.orange.shade100),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 0),
                  blurRadius: 13.0,
                  spreadRadius: 6.0,
                  color: Colors.black.withOpacity(0.09),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSymptomCategory('Physical', [
                  _buildSymptomChip('Chest & Upper back\nThrobbing pain – Mild',
                      Colors.yellow.shade100),
                  _buildSymptomChip(
                      'Abdomen & Lower back\nSharp pain – Moderate',
                      Colors.orange.shade100),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildExpandableSection(
              'Memory & concentration', 'Description', Icons.chevron_right),
          const SizedBox(height: 16),
          _buildExpandableSection(
              'Changes in behavior', 'Description', Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _buildSymptomCategory(String title, List<Widget> chips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: AppTextStyles.bodyOpenSans
                    .copyWith(fontWeight: FontWeight.w600)),
            GestureDetector(
              onTap: () {
                final categories = [
                  Category(
                    title: 'Chest & Upper Back',
                    symptoms: [
                      SymptomItem(name: 'Sharp Pain'),
                      SymptomItem(name: 'Dull Pain'),
                      SymptomItem(name: 'Throbbing Pain'),
                      SymptomItem(name: 'Pressure'),
                      SymptomItem(name: 'Tingling or Numbness'),
                    ],
                  ),
                  Category(
                    title: 'Abdomen & Lower Back',
                    symptoms: [
                      SymptomItem(name: 'Sharp Pain'),
                      SymptomItem(name: 'Dull Pain'),
                      SymptomItem(name: 'Throbbing Pain'),
                      SymptomItem(name: 'Pressure'),
                      SymptomItem(name: 'Tingling or Numbness'),
                    ],
                  ),
                ];

                SymptomBottomSheet.show(context, 'Body', categories);
              },
              child: Text(
                'Change',
                style: AppTextStyles.body2OpenSans
                    .copyWith(color: AppColors.amethystViolet),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips,
        ),
      ],
    );
  }

  Widget _buildExpandableSection(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTextStyles.bodyOpenSans
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTextStyles.body2OpenSans),
              ],
            ),
          ),
          Icon(icon, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(description) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Describe your symptoms', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              description ?? 'dfilsdkjflksdjfkljsdklfjsdklfjksldjfkldsj',
              style: AppTextStyles.body2OpenSans.copyWith(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
