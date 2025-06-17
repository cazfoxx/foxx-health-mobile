import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart'
    show AppointmentTypeModel;
import 'package:foxxhealth/features/data/models/checklist_model.dart';

import 'package:foxxhealth/features/data/models/symptom_tracker_response.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment_info/appointment_info_cubit.dart';
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
  List<ChecklistModel> _selectedChecklists = [];
  List<SymptomTrackerResponse> _selectedSymptoms = [];
  AppointmentTypeModel? _selectedType;
  final _analytics = AnalyticsService();

  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'NewAppointmentScreen',
      screenClass: 'NewAppointmentScreen',
    );
  }
  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _logScreenView();
    super.dispose();
  }


  void _saveAppointment()async {
    if (_titleController.text.isEmpty ||
        _selectedType == null ||
        _selectedDate == null ||
        _selectedChecklists.isEmpty ||
        _selectedSymptoms.isEmpty) {
          
          Navigator.pop(context);
          SnackbarUtils.showError(
            context: context,
            title: 'Please fill in all fields',
          );
    
     
    }else{
      


    final appointmentCubit = context.read<AppointmentInfoCubit>();
    appointmentCubit.setTitleText(_titleController.text);
    appointmentCubit.setVisitDate(_selectedDate!);
    appointmentCubit.setAppointmentTypeId(_selectedType!.id);
    appointmentCubit
        .setChecklistIds(_selectedChecklists.map((c) => c.id ?? 0).toList());
    appointmentCubit
        .setSymptomIds(_selectedSymptoms.map((s) => s.id ?? 0).toList());
    appointmentCubit.createAppointmentInfo().then((_) {
      Navigator.pop(context);
      //show success snackbar
      SnackbarUtils.showSuccess(
        context: context,
        title: 'Appointment created successfully',
      );
    });
    }
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
                      final result =
                          await showModalBottomSheet<AppointmentTypeModel>(
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
                          _selectedType = result;
                          _typeController.text = result.name;
                        });
                      }
                    },
                    suffixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(),
                  const SizedBox(height: 16),
                  if (_selectedChecklists.isNotEmpty) ...[
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(0),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _selectedChecklists.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.checklist, color: AppColors.amethystViolet),
                                const SizedBox(width: 12),
                                Text(_selectedChecklists[index].name ?? '',
                                  style: const TextStyle(color: Colors.black),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _selectedChecklists.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  Divider(),
                  const SizedBox(height: 10),
                  _buildAddCheckList(),
                  const SizedBox(height: 10),
                   Divider(),
                  if (_selectedSymptoms.isNotEmpty) ...[
                    SizedBox(
                      height: 50,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedSymptoms.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.healing, color: AppColors.amethystViolet),
                                const SizedBox(width: 12),
                                Text(_selectedSymptoms[index]
                                          .symptomIds
                                          ?.map((s) => s.symptomName)
                                          .join(', ') ??
                                      '',
                                  style: const TextStyle(color: Colors.black),
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    setState(() {
                                      _selectedSymptoms.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                   Divider(),

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
            onPressed: _saveAppointment,
            child: const Text(
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
      child: Row(
        children: [
          const Icon(Icons.add, color: AppColors.davysGray),
          const SizedBox(width: 12),
          Text(
            'Add Check Lists',
            style: TextStyle(
              color: 
                   AppColors.davysGray
            ),
        
          ),
      
        ],
      ),
    );
  }

  Widget _buildAddSymptom() {
    return InkWell(
      onTap: () {
        _showSymptomsBottomSheet(context);
      },
      child: Row(
        children: [
          const Icon(Icons.add, color: AppColors.davysGray),
          const SizedBox(width: 12),
          Text(
            'Add Symptoms',
            style: TextStyle(
              color: AppColors.davysGray
            ),
          ),
        ],
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
            if (!_selectedChecklists.contains(checklist)) {
              _selectedChecklists.add(checklist);
              Navigator.pop(context);
            }
          });
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
        onSymptomSelected: (symptom) {
          setState(() {
            if (!_selectedSymptoms.contains(symptom)) {
              _selectedSymptoms.add(symptom);
              Navigator.pop(context);
            }
          });
        },
      ),
    );
  }
}
