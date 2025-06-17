import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/features/data/models/appointment_type_model.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/appointment_type_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/suggested_questions_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/onboarding_button.dart';

class CreateChecklistScreen extends StatefulWidget {
  const CreateChecklistScreen({super.key});

  @override
  State<CreateChecklistScreen> createState() => _CreateChecklistScreenState();
}

class _CreateChecklistScreenState extends State<CreateChecklistScreen> {
  String? selectedType;
  final TextEditingController _searchController = TextEditingController();

  final _analytics = AnalyticsService();

  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'CreateChecklistScreen',
      screenClass: 'CreateChecklistScreen',
    );
  }
  @override
  void dispose() {
    _searchController.dispose();
    _logScreenView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Check List',
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.lightViolet,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: 0.1,
                      color: AppColors.sunglow,
                      backgroundColor: AppColors.lightViolet.withOpacity(0.2),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a Check List',
                      style: AppTextStyles.heading2
                          .copyWith(color: AppColors.amethystViolet),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Personalized questions to help you advocate for yourself',
                      style: AppTextStyles.body2.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard(),
            const SizedBox(height: 24),
            InkWell(
              onTap: () async {
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
                  checklistCubit.setAppointmentType(result.name);
                  setState(() {
                    selectedType = result.name;
                    _searchController.text = result.name;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type of Appointment',
                              style: AppTextStyles.body2),
                          const SizedBox(height: 16),
                          _buildSearchField(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            selectedType == null
                ? SizedBox()
                : OnboardingButton(
                    text: 'Next',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuggestedQuestionsScreen(
                            appointmentType: selectedType ?? 'Checkup',
                          ),
                        ),
                      );
                    }),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/svg/home/premium_star.svg'),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get a tailored check list based on your personal info with premium feature',
                  style: AppTextStyles.body2OpenSans.copyWith(),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 25,
            color: AppColors.amethystViolet,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(
            Icons.search,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Enter',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
