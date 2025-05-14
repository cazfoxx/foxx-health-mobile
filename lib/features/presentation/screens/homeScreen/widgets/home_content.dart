import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/create_checklist_screen.dart';
import 'package:foxxhealth/features/presentation/screens/visit/visit_details_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'action_item.dart';
import 'premium_card.dart';
import 'checklist_item.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});
  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  Future<String> _getUserInitial() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name') ?? '';
    return _getInitials(userName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildActionSection(context),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PremiumCard(),
                    const SizedBox(height: 24),
                    _buildTabSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/svg/foxx_logo.svg',
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 8),
        const Text(
          'FoXX Health',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.amethystViolet,
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection(context) {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            ActionItem(
              icon: Icons.timer,
              title: 'Track Symptoms',
              onTap: () {},
            ),
            const Divider(height: 24),
            ActionItem(
              icon: Icons.checklist,
              title: 'Create Check List',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateChecklistScreen(),
                  ),
                );
              },
            ),
            const Divider(height: 24),
            ActionItem(
              icon: Icons.favorite_border,
              title: 'Create Health Assessment',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TabBar(
            labelColor: AppColors.amethystViolet,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.amethystViolet,
            labelStyle: AppTextStyles.heading3,
            unselectedLabelStyle: AppTextStyles.heading3,
            tabs: [
              Tab(text: 'Upcoming Visits'),
              Tab(text: 'Recent Actions'),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: TabBarView(
              children: [
                SizedBox(height: 10),
                _buildUpcomingVisitsTab(context),
                _buildRecentActionsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingVisitsTab(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ChecklistItem(
            title: 'New Visit',
            subtitle: 'Appointment',
            date: 'Apr 13, 2025',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisitDetailsScreen(
                    doctorName: 'Dr Smith',
                    specialization: 'Oncologist',
                    date: 'May 2026',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          ChecklistItem(
            title: 'Yearly Check Up',
            subtitle: 'Appointment',
            date: 'Mar 2025',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildCreateVisitCard(context),
          const SizedBox(height: 70),
        ],
      ),
    );
  }

  Widget _buildRecentActionsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ChecklistItem(
            title: 'PCP Check List in Progress',
            subtitle: 'In Progress',
            date: 'Apr 20, 2025',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          ChecklistItem(
            title: 'New Health Assessment in Progress',
            subtitle: 'In Progress',
            date: 'Apr 13, 2025',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          ChecklistItem(
            title: 'New Symptom Tracker in Progress',
            subtitle: 'In Progress',
            date: 'Jan 13, 2025',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCreateVisitCard(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => const NewAppointmentScreen(),
        );
      },
      child: Card(
        color: Colors.white,
        child: ListTile(
          leading: Icon(
            Icons.add_circle,
            color: AppColors.amethystViolet,
          ),
          title: Text('Create an upcoming visit',
              style: AppTextStyles.body2.copyWith()),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: AppColors.amethystViolet,
          ),
        ),
      ),
    );
  }
}
