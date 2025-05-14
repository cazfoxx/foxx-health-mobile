import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/widgets/header_wdiget.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/pre_existing_conditions_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class HealthAssessmentAppointTypeScreen extends StatefulWidget {
  const HealthAssessmentAppointTypeScreen({Key? key}) : super(key: key);

  @override
  State<HealthAssessmentAppointTypeScreen> createState() =>
      _HealthAssessmentAppointTypeScreenState();
}

class _HealthAssessmentAppointTypeScreenState
    extends State<HealthAssessmentAppointTypeScreen> {
  final _appointmentController = TextEditingController();
  final _searchController = TextEditingController();
  String? selectedType;
  List<String> filteredTypes = [];
  final List<String> appointmentTypes = [
    'Primary Care',
    'Cardiology',
    'Dermatology',
    'Endocrinology',
    'Gastroenterology',
    'Neurology',
    'Oncology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'Rheumatology',
    'Not Applicable'
  ];

  @override
  void initState() {
    super.initState();
    filteredTypes = List.from(appointmentTypes);
  }

  void _filterTypes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTypes = List.from(appointmentTypes);
      } else {
        filteredTypes = appointmentTypes
            .where((type) => type.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showTypeSelector() {
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
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(13),
                margin: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                          icon: Icon(CupertinoIcons.xmark),
                        ),
                        Text(
                          'Type of Appointment',
                          style: AppTextStyles.bodyOpenSans.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 50),
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
                      hintText: 'Enter',
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
                                  _filterTypes('');
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filterTypes(value);
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTypes.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        this.setState(() {
                          selectedType = filteredTypes[index];
                          _appointmentController.text = filteredTypes[index];
                        });
                        _searchController.clear();
                        _filterTypes('');
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
                          filteredTypes[index],
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

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      title: 'Which doctor you will be meeting with?',
      subtitle:
          'Type of appointment help us tailored our assessment to your need. If you have one, click next if not applicable.',
      progress: 0.6,
      onNext: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PreExistingConditionsScreen()));
      },
      isNextEnabled: selectedType != null,
      body: GestureDetector(
        onTap: _showTypeSelector,
        child: Container(
          padding: const EdgeInsets.all(13),
          margin: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Type of Appointment',
                style: AppTextStyles.bodyOpenSans.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _appointmentController,
                readOnly: true,
                onTap: _showTypeSelector,
                decoration: InputDecoration(
                  hintText: 'Enter',
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _appointmentController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
