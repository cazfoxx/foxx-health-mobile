import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment_info/appointment_info_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class AppointmentInfoScreen extends StatefulWidget {
  const AppointmentInfoScreen({
    super.key,
    this.onAppointmentSelected,
  });
  
  final Function(dynamic appointment)? onAppointmentSelected;

  @override
  State<AppointmentInfoScreen> createState() => _AppointmentInfoScreenState();
}

class _AppointmentInfoScreenState extends State<AppointmentInfoScreen> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<AppointmentInfoCubit>().getAppointmentInfo();
    _textController.addListener(() {
      setState(() {
        _searchQuery = _textController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<dynamic> _filterAppointments(List<dynamic> appointments) {
    if (_searchQuery.isEmpty) return appointments;
    return appointments
        .where((appointment) =>
            appointment.titleText.toLowerCase().contains(_searchQuery))
        .toList();
  }

  void _handleAppointmentTap(dynamic appointment) {
    if (widget.onAppointmentSelected != null) {
      widget.onAppointmentSelected!(appointment);
    }
    Navigator.pop(context, appointment);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'Appointments',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(width: 50),
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
                    hintText: 'Search appointments',
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
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AppointmentInfoCubit, AppointmentInfoState>(
                builder: (context, state) {
                  if (state is AppointmentInfoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is AppointmentInfoError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: AppTextStyles.body.copyWith(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              context.read<AppointmentInfoCubit>().getAppointmentInfo();
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (state is AppointmentInfoLoaded) {
                    final filteredAppointments = _filterAppointments(state.appointments);
                    
                    if (filteredAppointments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _searchQuery.isEmpty 
                                ? 'No appointments found'
                                : 'No appointments match your search',
                              style: AppTextStyles.body.copyWith(color: Colors.grey[600]),
                            ),
                            if (_searchQuery.isEmpty) ...[
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => const NewAppointmentScreen(),
                                  ).then((_) {
                                    context.read<AppointmentInfoCubit>().getAppointmentInfo();
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.amethystViolet,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Create Appointment'),
                              ),
                            ],
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await context.read<AppointmentInfoCubit>().getAppointmentInfo();
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredAppointments.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final appointment = filteredAppointments[index];
                          return InkWell(
                            onTap: () => _handleAppointmentTap(appointment),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.transparent,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.titleText,
                                    style: AppTextStyles.bodyOpenSans.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        'Last Edited: ',
                                        style: AppTextStyles.labelOpensans.copyWith(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      Text(
                                        DateFormat('MMM dd, yyyy').format(appointment.visitDate),
                                        style: AppTextStyles.labelOpensans.copyWith(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
