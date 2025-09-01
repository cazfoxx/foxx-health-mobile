import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/profile/profile_cubit.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_screen.dart';
import 'package:foxxhealth/features/presentation/screens/home_screen/revamp_home_screen.dart';
import 'package:foxxhealth/features/presentation/screens/my_prep/my_prep_screen.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';
import 'package:foxxhealth/features/data/models/health_tracker_model.dart';


class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}
class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final List<Widget> _screens = [
    const HomeTab(),
    const MyPrepTab(),
    const TrackerTab(),
    const InsightTab(),
    const DenTab(),
  ];
  final List<String> _tabLabels = [
    'Home',
    'My Prep',
    'Tracker',
    'Insight',
    'The Den',
  ];
  final List<IconData> _tabIcons = [
    Icons.home,
    Icons.assignment,
    Icons.timeline,
    Icons.search,
    Icons.group,
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProfileCubit>().fetchProfile();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error loading profile: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Foxxbackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _screens,
            ),
            bottomNavigationBar: _buildBottomNavigationBar(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          _tabIcons.length,
          (index) => _buildNavItem(
            _tabIcons[index],
            _tabLabels[index],
            _currentIndex == index,
            () => _onTabTapped(index),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.primary01 : AppColors.gray600,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
              color: isActive ? AppColors.primary01 : AppColors.gray600,
            ),
          ),
        ],
      ),
    );
  }
}

// Tab Screen Widgets
class HomeTab extends StatelessWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RevampHomeScreen();
  }
}

class MyPrepTab extends StatelessWidget {
  const MyPrepTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyPrepScreen();
  }
}

class TrackerTab extends StatefulWidget {
  const TrackerTab({Key? key}) : super(key: key);

  @override
  State<TrackerTab> createState() => _TrackerTabState();
}

class _TrackerTabState extends State<TrackerTab> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _symptomController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _feelingGood = true;
  String? _selectedRecentSymptom;
  
  // Health tracker data
  List<HealthTrackerResponse> _healthTrackers = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHealthTrackers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _symptomController.dispose();
    super.dispose();
  }

  Future<void> _loadHealthTrackers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final symptomCubit = context.read<SymptomSearchCubit>();
      final healthTrackersData = await symptomCubit.getHealthTrackersByDate(_selectedDate);
      
      setState(() {
        _healthTrackers = healthTrackersData.map((data) => HealthTrackerResponse.fromJson(data)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Selector
                  _buildDateSelector(),
                  const SizedBox(height: 24),
              
                  // My Health - Symptoms Section
                  Text(
                    'My Health',
                    style: AppHeadingTextStyles.h2.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Symptoms',
                    style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  // Feeling Good Card
                  _buildFeelingGoodCard(),
                  const SizedBox(height: 24),
              
                  // Recent Symptoms Section
                  Text(
                    'Recent symptoms',
                    style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  // Recent Symptoms Cards
                  _buildRecentSymptomsCards(),
                  const SizedBox(height: 24),
              
                  // Add Symptoms Section
                  Text(
                    'Add symptoms',
                    style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  // Search Bar
                  _buildSearchBar(),
                  const SizedBox(height: 12),
              
                  // Symptom Input Field
                  _buildSymptomInputField(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      children: [
        // Main Date Button
        GestureDetector(
          onTap: () {
            _showDatePicker();
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: AppColors.glassCardDecoration,
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.amethyst,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  _formatDate(_selectedDate),
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Horizontal Date Cards
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = DateTime.now().subtract(Duration(days: 3 - index));
              final isSelected = date.day == _selectedDate.day;
              final dayAbbreviation = _getDayAbbreviation(date.weekday);
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                  _loadHealthTrackers(); 
                },
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.amethyst : Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayAbbreviation,
                        style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                          color: isSelected ? Colors.white : AppColors.primary01,
                        ),
                      ),
                      Text(
                        '${date.day}',
                        style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                          color: isSelected ? Colors.white : AppColors.primary01,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeelingGoodCard() {
    // Check if there are any active symptoms for the selected date
    final activeSymptoms = _healthTrackers
        .where((tracker) => tracker.isActive)
        .expand((tracker) => tracker.selectedSymptoms)
        .toList();

    final hasSymptoms = activeSymptoms.isNotEmpty;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppColors.glassCardDecoration,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _feelingGood = !_feelingGood;
              });
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _feelingGood ? AppColors.amethyst : Colors.transparent,
                border: Border.all(
                  color: AppColors.amethyst,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: _feelingGood
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hasSymptoms 
                  ? 'Experiencing: ${activeSymptoms.take(2).map((s) => s.info.name).join(', ')}'
                  : 'I feel good, no symptoms',
              style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                color: AppColors.primary01,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSymptomsCards() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
        child: Text(
          'Error loading symptoms: $_error',
          style: AppOSTextStyles.osMd.copyWith(color: Colors.red),
        ),
      );
    }

    // Get all symptoms from health trackers
    final allSymptoms = _healthTrackers
        .expand((tracker) => tracker.selectedSymptoms)
        .map((symptom) => symptom.info.name)
        .toSet()
        .toList();

    if (allSymptoms.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
        child: Text(
          'No symptoms recorded for this date',
          style: AppOSTextStyles.osMd.copyWith(color: AppColors.davysGray),
        ),
      );
    }
    
    return Column(
      children: allSymptoms.take(5).map((symptom) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: AppColors.glassCardDecoration,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRecentSymptom = _selectedRecentSymptom == symptom ? null : symptom;
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _selectedRecentSymptom == symptom ? AppColors.amethyst : Colors.transparent,
                    border: Border.all(
                      color: AppColors.amethyst,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: _selectedRecentSymptom == symptom
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 12,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  symptom,
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppColors.amethyst,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search symptoms',
                hintStyle: AppOSTextStyles.osMd.copyWith(
                  color: AppColors.gray400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppOSTextStyles.osMd.copyWith(
                color: AppColors.primary01,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomInputField() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray200,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _symptomController,
        decoration: InputDecoration(
          hintText: 'Enter symptom name',
          hintStyle: AppOSTextStyles.osMd.copyWith(
            color: AppColors.gray400,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: AppOSTextStyles.osMd.copyWith(
          color: AppColors.primary01,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = DateTime(date.year, date.month, date.day);

    if (selectedDate == today) {
      return 'Today, ${_formatDateString(date)}';
    } else if (selectedDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday, ${_formatDateString(date)}';
    } else if (selectedDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${_formatDateString(date)}';
    } else {
      return _formatDateString(date);
    }
  }

  String _formatDateString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _getDayAbbreviation(int weekday) {
    const days = ['M', 'TU', 'W', 'TH', 'F', 'S', 'SU'];
    return days[weekday - 1];
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.amethyst,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.primary01,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadHealthTrackers(); // Reload data for new date
    }
  }
}

class InsightTab extends StatefulWidget {
  const InsightTab({Key? key}) : super(key: key);

  @override
  State<InsightTab> createState() => _InsightTabState();
}

class _InsightTabState extends State<InsightTab> {
  DateTime _selectedDate = DateTime(2025, 4, 10); // April 10, 2025
  DateTime _currentMonth = DateTime(2025, 4, 1); // April 2025

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Section with Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40), // Spacer for balance
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.mauve50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: AppColors.amethyst,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.mauve50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_outline,
                              color: AppColors.amethyst,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Title Section
                  Text(
                    'Symptom Insights',
                    style: AppHeadingTextStyles.h2.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Symptom Insights helps you spot patterns and changes over time, so you can feel more informed and in control.',
                    style: AppOSTextStyles.osMd.copyWith(
                      color: AppColors.davysGray,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Calendar Section
                  _buildCalendarSection(),
                  const SizedBox(height: 32),

                  // Insights by Symptom Section
                  Text(
                    'Insights by symptom',
                    style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Symptom List
                  _buildSymptomInsightsList(),
                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppColors.glassCardDecoration,
      child: Column(
        children: [
          // Month Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatMonthYear(_currentMonth),
                style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                  color: AppColors.primary01,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                      });
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.amethyst,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                      });
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.amethyst,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Days of Week Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'M', 'Tu', 'W', 'Th', 'F', 'Sa'].map((day) {
              return Text(
                day,
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: AppColors.davysGray,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Calendar Grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;
    
    // Calculate total cells needed (including empty cells for days before month starts)
    final totalCells = firstWeekday - 1 + daysInMonth;
    final weeks = (totalCells / 7).ceil();

    return Column(
      children: List.generate(weeks, (weekIndex) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(7, (dayIndex) {
            final cellIndex = weekIndex * 7 + dayIndex;
            final dayOfMonth = cellIndex - (firstWeekday - 1) + 1;
            
            if (dayOfMonth < 1 || dayOfMonth > daysInMonth) {
              // Empty cell
              return Container(
                width: 32,
                height: 40,
                margin: const EdgeInsets.all(2),
              );
            }

            final date = DateTime(_currentMonth.year, _currentMonth.month, dayOfMonth);
            final isSelected = date.day == _selectedDate.day && 
                             date.month == _selectedDate.month && 
                             date.year == _selectedDate.year;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              child: Container(
                width: 32,
                height: 40,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.amethyst : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayOfMonth',
                      style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                        color: isSelected ? Colors.white : AppColors.primary01,
                      ),
                    ),
                    if (dayOfMonth != 1) // Show dots for all days except day 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildSymptomInsightsList() {
    final symptoms = ['Cramps', 'Fatigue', 'Headaches', 'Sleep'];
    
    return Column(
      children: symptoms.map((symptom) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: AppColors.glassCardDecoration,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  symptom,
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.amethyst,
                size: 16,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class DenTab extends StatelessWidget {
  const DenTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DenScreen();
  }
}
