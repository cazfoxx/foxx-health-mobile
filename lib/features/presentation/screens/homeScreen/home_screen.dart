import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/features/presentation/cubits/checklist/checklist_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/health_assessment/health_assessment_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/profile/profile_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_tracker/symptom_tracker_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/api_logger/api_logger_screen.dart';
import 'package:foxxhealth/features/presentation/screens/appointment/new_appointment_screen.dart';
import 'package:foxxhealth/features/presentation/screens/feedback/feedback_screen.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/base_scafold.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/widgets/add_bottom_sheet.dart';
import 'package:foxxhealth/features/presentation/screens/news/news_screen.dart';
import 'package:foxxhealth/features/presentation/screens/premiumScreen/premium_overlay.dart';
import 'package:foxxhealth/features/presentation/screens/visit/visit_details_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/screens/profileScreen/profile_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foxxhealth/features/presentation/screens/symptoms/symptoms_list_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, this.selectedIndex});
  int? selectedIndex;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
    if (widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
    _initializeScreens();
    _logScreenView();
  }

  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'HomeScreen',
      screenClass: 'HomeScreen',
    );
  }

  int _selectedIndex = 0;
  late final List<Widget> _screens;

  void _initializeScreens() {
    _screens = [
      HomeContent(onSwipe: () {
        setState(() {
          _selectedIndex = 1;
        });
      }),
      const NewsScreen(),
      const SizedBox(),
      const SymptomsListScreen(),
      const FeedbackScreen(),
    ];
  }

  void _onSwipe(DragEndDetails details) async {
    if (details.primaryVelocity! > 0) {
      // Swiping right
      log('swiping right ${_selectedIndex}');
      log('swiping right');
      if (_selectedIndex > 0) {
        if (_selectedIndex == 3) {
          _selectedIndex = 1;
        } else if (_selectedIndex == 4) {
          _selectedIndex = 3;
        } else {
          _selectedIndex--;
        }
        setState(() {});
        await _analytics.logEvent(
          name: 'screen_swipe',
          parameters: {
            'direction': 'right',
            'from_screen': _screens[_selectedIndex].toString(),
            'to_screen': _screens[_selectedIndex].toString(),
          },
        );
      }
    } else if (details.primaryVelocity! < 0) {
      // Swiping left
      log('swiping left ${_selectedIndex}');
      log('swiping left');
      if (_selectedIndex < 4) {
        // Check against max index (4 for FeedbackScreen)
        if (_selectedIndex == 1) {
          _selectedIndex = 3;
        } else if (_selectedIndex == 3) {
          _selectedIndex = 4;
        } else if (_selectedIndex < 1) {
          _selectedIndex++;
        }
        setState(() {});
        await _analytics.logEvent(
          name: 'screen_swipe',
          parameters: {
            'direction': 'left',
            'from_screen': _screens[_selectedIndex].toString(),
            'to_screen': _screens[_selectedIndex].toString(),
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().fetchProfile();
    return BaseScaffold(
      currentIndex: _selectedIndex,
      body: GestureDetector(
        onHorizontalDragEnd: _onSwipe,
        child: _screens[_selectedIndex],
      ),
      onTap: (index) async {
        if (index == 2) {
          await _analytics.logEvent(
            name: 'add_button_tapped',
            parameters: {'screen': 'home'},
          );
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return const AddBottomSheet();
            },
          );
        } else {
          setState(() {
            _selectedIndex = index;
          });
          await _analytics.logEvent(
            name: 'bottom_nav_tapped',
            parameters: {
              'index': index,
              'screen': _screens[index].toString(),
            },
          );
        }
      },
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key, required this.onSwipe});

  final Function() onSwipe;

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();
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
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onDoubleTap: () async {
                    await _analytics.logEvent(
                      name: 'api_logger_opened',
                      parameters: {'from': 'home_screen'},
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApiLoggerScreen(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/logo_horizontal.svg',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 68),
                FutureBuilder(
                    future: _getUserInitial(),
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: () async {
                          await _analytics.logEvent(
                            name: 'profile_opened',
                            parameters: {'from': 'home_screen'},
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ProfileScreen(),
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
                          'assets/svg/splash/symptom_tracking.svg'),
                      title: 'Track Symptoms',
                      onTap: () async {
                        await _analytics.logEvent(
                          name: 'symptom_tracking_tapped',
                          parameters: {'from': 'home_screen'},
                        );
                        context
                            .read<SymptomTrackerCubit>()
                            .checkAndNavigateToLastScreen(context);
                      },
                    ),
                    const Divider(height: 24),
                    _buildActionItem(
                      icon: SvgPicture.asset(
                          'assets/svg/home/create_check_list.svg'),
                      title: 'Create Check List',
                      onTap: () async {
                        await _analytics.logEvent(
                          name: 'checklist_tapped',
                          parameters: {'from': 'home_screen'},
                        );
                        context
                            .read<ChecklistCubit>()
                            .checkAndNavigateToLastScreen(context);
                      },
                    ),
                    const Divider(height: 24),
                    _buildActionItem(
                      icon: SvgPicture.asset(
                          'assets/svg/splash/personal_health_guide.svg'),
                      title: 'Create Health Assessment',
                      onTap: () async {
                        await _analytics.logEvent(
                          name: 'health_assessment_tapped',
                          parameters: {'from': 'home_screen'},
                        );
                        context
                            .read<HealthAssessmentCubit>()
                            .checkAndNavigateToLastScreen(context);
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
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
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
                                                const VisitDetailsScreen(
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
                              GestureDetector(
                                onHorizontalDragEnd: (details) {
                                  if (details.primaryVelocity! < 0) {
                                    widget.onSwipe();
                                  }
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      // _buildCheckListItem(
                                      //   context: context,
                                      //   isRecentAction: true,
                                      //   title: 'PCP Check List in Progress',
                                      //   subtitle: 'In Progress',
                                      //   date: 'Apr 20, 2025',
                                      //   onTap: () {},
                                      // ),
                                    ],
                                  ),
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
