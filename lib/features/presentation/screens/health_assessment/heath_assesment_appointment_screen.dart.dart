import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/utils/save_health_assessment.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart'
    show AppointmentTypeModel;
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessement_enums.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
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


  @override
  void initState() {
    super.initState();

  }

  void _showTypeSelector() async {
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
      final healthCubit = context.read<HealthAssessmentCubit>();
      healthCubit.setAppointmentTypeId(result.id);
      healthCubit.setAppointmentType(result.name);
      setState(() {
        _appointmentController.text = result.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeaderWidget(
      onSave: () {
        SaveHealthAssessment.saveAssessment(context, HealthAssessmentScreen.appointmentType);
      },
      title: 'Which doctor you will be meeting with?',
      subtitle:
          'Type of appointment help us tailored our assessment to your need. If you have one, click next if not applicable.',
      progress: 0.6,
      onNext: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PreExistingConditionsScreen()));
      },
      isNextEnabled: _appointmentController.text.isNotEmpty,
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
