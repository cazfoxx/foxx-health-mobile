import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment/appointment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment/appointment_state.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';


class AppointmentTypeScreen extends StatefulWidget {
  const AppointmentTypeScreen({super.key, this.isSelectionEnabled = false});
  final bool isSelectionEnabled;

  @override
  State<AppointmentTypeScreen> createState() => _AppointmentTypeScreenState();
}

class _AppointmentTypeScreenState extends State<AppointmentTypeScreen> {
  String? _selectedType;
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  List<AppointmentTypeModel> _appointmentTypes = [];
  List<AppointmentTypeModel> _filteredTypes = [];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_filterAppointmentTypes);
    // Fetch appointment types when screen initializes
    context.read<AppointmentCubit>().getAppointmentTypes();

  }

  void _filterAppointmentTypes() {
    final query = _textController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredTypes = List.from(_appointmentTypes);
      } else {
        _filteredTypes = _appointmentTypes
            .where((type) =>
                type.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: AppColors.amethystViolet,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Type of Appointment',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  // Empty SizedBox to balance the back button
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Container(
              color: AppColors.lightViolet,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Enter',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _textController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _textController.clear();
                              FocusScope.of(context).unfocus();
                            },
                          )
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            BlocConsumer<AppointmentCubit, AppointmentState>(
              listener: (context, state) {
                if (state is AppointmentTypesLoaded) {
                  setState(() {
                    _appointmentTypes = state.appointmentTypes;
                    _filteredTypes = state.appointmentTypes;
                  });
                } else if (state is AppointmentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is AppointmentLoading) {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                return _filteredTypes.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'No appointment types found',
                            style: AppTextStyles.body.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredTypes.length,
                          itemBuilder: (context, index) {
                            final type = _filteredTypes[index];
                            return _buildTypeItem(type.name, type);
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeItem(String type, AppointmentTypeModel appointment) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        if (appointment.isActive) {  // Only allow selection of active appointment types
          setState(() {
            _selectedType = type;
          });
          Navigator.pop(context, appointment);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.amethystViolet.withOpacity(0.1) : null,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                type,
                style: AppTextStyles.body.copyWith(
                  color: appointment.isActive ? Colors.black : Colors.grey,
                ),
              ),
            ),
            if (!appointment.isActive)
              const Icon(Icons.block, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
