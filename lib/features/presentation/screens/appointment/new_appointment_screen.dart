import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart'
    show AppointmentTypeModel;
import 'package:foxxhealth/features/data/models/symptom_tracker_request.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment/appointment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart'
    show SymptomTrackerCubit;
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/widgets/checklist_selection_sheet.dart';
import 'package:foxxhealth/features/presentation/widgets/symptoms_selection_sheet.dart';

class NewAppointmentScreen extends StatefulWidget {
  const NewAppointmentScreen({super.key});
  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedChecklist;
  String? _selectedSymptom;

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _titleController,
                    label: 'Title',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _typeController,
                    label: 'Type of Appointment',
                    readOnly: true,
                    onTap: () async {
                      final AppointmentTypeModel result =
                          await showModalBottomSheet(
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
                        setState(() {
                          _typeController.text = result.appointmentTypeText;
                        });
                      }
                    },
                    suffixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(),
                  const SizedBox(height: 16),
                  _buildAddCheckList(),
                  const SizedBox(height: 16),
                  _buildAddSymptom(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            'New Appointment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () async {
              // Create appointment type
              final appointmentCubit = context.read<AppointmentCubit>();
              await appointmentCubit.createAppointmentType(
                appointmentTypeCode:
                    _titleController.text.toUpperCase().replaceAll(' ', '_'),
                appointmentTypeText: _titleController.text,
              );

              // Close the screen after creation
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: AppColors.amethystViolet,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              _selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'Date',
              style: TextStyle(
                color: _selectedDate != null ? Colors.black : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCheckList() {
    return InkWell(
      onTap: () {
        _showCheckListBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.checklist, color: AppColors.amethystViolet),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedChecklist ?? 'Add Check List',
                style: TextStyle(
                  color: _selectedChecklist != null
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAddSymptom() {
    return InkWell(
      onTap: () {
        _showSymptomsBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.healing, color: AppColors.amethystViolet),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedSymptom ?? 'Add Symptoms',
                style: TextStyle(
                  color: _selectedSymptom != null
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _showCheckListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CheckListSelectionSheet(
        onCheckListSelected: (checklist) {
          setState(() {
            _selectedChecklist = checklist;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSymptomsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SymptomsSelectionSheet(
        onSymptomSelected: (SymptomId symptom) {
          context.read<SymptomTrackerCubit>().addSymptom(symptom);
          setState(() {
          _selectedSymptom = symptom.symptomName;
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}
