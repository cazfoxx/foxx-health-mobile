import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment/appointment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/appointment/appointment_state.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/checklist/create_checklist_screen.dart';
import 'package:foxxhealth/features/presentation/screens/feedback/feedback_screen.dart';
import 'package:foxxhealth/features/presentation/screens/health_assessment/health_assessment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/news/news_screen.dart';
import 'package:foxxhealth/features/presentation/screens/premiumScreen/premium_overlay.dart';
import 'package:foxxhealth/features/presentation/screens/track_symptoms/start_date_screen.dart';
import 'package:foxxhealth/features/presentation/screens/visit/visit_details_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/screens/profileScreen/profile_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HomeContent(),
    const NewsScreen(),
    const SizedBox(),
    const Center(child: Text('Review')),
    const FeedbackScreen(),
  ];
  void _showAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: AppColors.amethystViolet.withOpacity(0.8),
                ),
              ),
              Positioned(
                top: 35,
                right: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 50), // avoid close button overlap
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.3,
                  maxChildSize: 0.9,
                  builder: (_, controller) => Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildActionItem(
                            icon: SvgPicture.asset(
                                'assets/svg/home/track_symptoms.svg'),
                            title: 'Track Symptoms',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StartDateScreen()),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildActionItem(
                            icon: SvgPicture.asset(
                                'assets/svg/home/create_check_list.svg'),
                            title: 'Create Check List',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateChecklistScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildActionItem(
                            icon: SvgPicture.asset(
                                'assets/svg/home/health_icon.svg'),
                            title: 'Create Health Assessment',
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HealthAssessmentScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            _showAddBottomSheet(context);
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.amethystViolet,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/home/home_icon.svg'),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/home/news_icon.svg'),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              width: 70,
              decoration: BoxDecoration(
                color: AppColors.amethystViolet,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            label: 'Health',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svg/home/feedback.svg'),
            label: 'Feedback',
          ),
        ],
      ),
    );
  }
}

Widget _buildActionItem({
  required Widget icon,
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Row(
      children: [
        icon,
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Icon(
          Icons.add_circle,
          color: AppColors.amethystViolet,
        ),
      ],
    ),
  );
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  void initState() {
    super.initState();
    _getAppointments();
  }

  _getAppointments() async {
    context.read<AppointmentCubit>().getAppointmentTypes();
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    return name[0].toUpperCase();
  }

  Future<String> _getUserInitial() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email') ?? '';
    return _getInitials(email);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
                const SizedBox(width: 65),
                FutureBuilder(
                    future: _getUserInitial(),
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 20,
                          child: Text(snapshot.data ?? '?',
                              style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          backgroundColor: AppColors.blue,
                        ),
                      );
                    }),
                const SizedBox(width: 20)
              ],
            ),
            const SizedBox(height: 24),
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
                  children: [
                    _buildActionItem(
                      icon: SvgPicture.asset(
                          'assets/svg/home/track_symptoms.svg'),
                      title: 'Track Symptoms',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartDateScreen()),
                        );
                      },
                    ),
                    const Divider(height: 24),
                    _buildActionItem(
                      icon: SvgPicture.asset(
                          'assets/svg/home/create_check_list.svg'),
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
                    _buildActionItem(
                      icon: SvgPicture.asset('assets/svg/home/health_icon.svg'),
                      title: 'Create Health Assessment',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const HealthAssessmentScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPremiumCard(context),
                  const SizedBox(height: 10),
                  DefaultTabController(
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
                              // Upcoming Visits Tab with dummy data
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _buildCheckListItem(
                                      context: context,
                                      title: 'Dr. Sarah Johnson',
                                      subtitle: 'General Physician',
                                      date: 'Apr 25, 2024',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VisitDetailsScreen(
                                              doctorName: 'Dr. Sarah Johnson',
                                              specialization:
                                                  'General Physician',
                                              date: 'Apr 25, 2024',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildCheckListItem(
                                      context: context,
                                      title: 'Dr. Michael Chen',
                                      subtitle: 'Cardiologist',
                                      date: 'Apr 28, 2024',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VisitDetailsScreen(
                                              doctorName: 'Dr. Michael Chen',
                                              specialization: 'Cardiologist',
                                              date: 'Apr 28, 2024',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    _buildCheckListItem(
                                      context: context,
                                      title: 'Dr. Emily Rodriguez',
                                      subtitle: 'Dermatologist',
                                      date: 'May 2, 2024',
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VisitDetailsScreen(
                                              doctorName: 'Dr. Emily Rodriguez',
                                              specialization: 'Dermatologist',
                                              date: 'May 2, 2024',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          builder: (context) =>
                                              const NewAppointmentScreen(),
                                        );
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.add_circle,
                                            color: AppColors.amethystViolet,
                                          ),
                                          title: Text(
                                            'Create an upcoming visit',
                                            style:
                                                AppTextStyles.body2.copyWith(),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppColors.amethystViolet,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 50)
                                  ],
                                ),
                              ),
                              // Keep existing Recent Actions Tab
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    _buildCheckListItem(
                                      context: context,
                                      isRecentAction: true,
                                      title: 'PCP Check List in Progress',
                                      subtitle: 'In Progress',
                                      date: 'Apr 20, 2025',
                                      onTap: () {},
                                    ),
                                    const SizedBox(height: 12),
                                    _buildCheckListItem(
                                      context: context,
                                      isRecentAction: true,
                                      title:
                                          'New Health Assessment in Progress',
                                      subtitle: 'In Progress',
                                      date: 'Apr 13, 2025',
                                      onTap: () {},
                                    ),
                                    const SizedBox(height: 12),
                                    _buildCheckListItem(
                                      context: context,
                                      isRecentAction: true,
                                      title: 'New Symptom Tracker in Progress',
                                      subtitle: 'In Progress',
                                      date: 'Jan 13, 2025',
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(
            Icons.add_circle,
            color: AppColors.amethystViolet,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(),
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: const PremiumOverlay(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(13),
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
        child: Row(
          children: [
            SvgPicture.asset('assets/svg/home/premium_star.svg'),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Unlock all features with Premium',
                  style: AppTextStyles.body2OpenSans),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckListItem({
    required String title,
    required String subtitle,
    String? date,
    bool isAddNew = false,
    bool isRecentAction = false,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.bodyOpenSans
                                  .copyWith(fontSize: 16),
                            ),
                            Text(
                              'Last Edited: Apr 13, 2025',
                              style: AppTextStyles.labelOpensans
                                  .copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.chevron_right_outlined,
                            color: AppColors.amethystViolet, size: 30),
                      ],
                    ),
                  ],
                ),
              ),
              isRecentAction
                  ? const SizedBox.shrink()
                  : Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffF1EFF7),
                        border: Border(
                            top: BorderSide(
                                color: Colors.grey.withOpacity(0.2))),
                      ),
                      padding: const EdgeInsets.only(
                          left: 20, right: 10, bottom: 10, top: 5),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'Date',
                              style: AppTextStyles.body2OpenSans,
                            ),
                          ),
                          const SizedBox(width: 13),
                          if (isAddNew)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.add, size: 16),
                                  SizedBox(width: 4),
                                  Text('Add'),
                                ],
                              ),
                            )
                          else if (date != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 4),
                                  InkWell(
                                      onTap: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                      },
                                      child: Text(date)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
