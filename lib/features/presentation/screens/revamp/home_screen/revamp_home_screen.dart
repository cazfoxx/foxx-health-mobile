import 'package:flutter/material.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/features/presentation/screens/premiumScreen/premium_overlay.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/my_prep/my_prep_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/profile/profile_screen.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/health_tracker/health_tracker_screen.dart';

class RevampHomeScreen extends StatefulWidget {
  const RevampHomeScreen({Key? key}) : super(key: key);

  @override
  State<RevampHomeScreen> createState() => _RevampHomeScreenState();
}

class _RevampHomeScreenState extends State<RevampHomeScreen> {
  // Profile fetching is now handled by MainNavigationScreen

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with date and icons
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                 SizedBox(height: 10,),
                    // Top right icons
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.mauve50,
                          radius: 20,
                          child: Icon(Icons.chat_bubble_outline,
                              color: AppColors.amethyst, size: 20),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.mauve50,
                            radius: 20,
                            child: Icon(Icons.person_outline,
                                color: AppColors.amethyst, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                   Text(
                      'Wednesday, Apr 17',
                      style: AppOSTextStyles.osMdSemiboldLabel
                          .copyWith(color: AppColors.davysGray),
                    ),
                // Greeting
                Text(
                  'Hi, ${UserProfileConstants.getDisplayName()}',
                  style: AppHeadingTextStyles.h2
                      .copyWith(color: AppColors.primary01),
                ),
                const SizedBox(height: 24),

                // How are you feeling card
                _buildFeelingCard(context),
                const SizedBox(height: 16),

                // Physical feeling card with pagination
                _buildPhysicalFeelingCard(context),
                const SizedBox(height: 16),

                // Create & Health Profile cards
                Row(
                  children: [
                    Expanded(child: _buildCreateCard(context)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildHealthProfileCard()),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Items
                Text('Recent Items',
                    style: AppOSTextStyles.osMdSemiboldTitle
                        .copyWith(color: AppColors.primary01)),
                const SizedBox(height: 12),

                // Recent Item Cards
                Expanded(
                  child: ListView(
                    children: [
                      _RecentItemCard(
                        title: 'Yearly Check Up',
                        date: 'Mar 2025',
                        lastEdited: 'Apr 13, 2025',
                      ),
                      const SizedBox(height: 12),
                      _RecentItemCard(
                        title: 'Appointment prep with PCP',
                        date: 'Mar 2025',
                        lastEdited: 'Apr 13, 2025',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeelingCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
       
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.mauve50,
                  child: Icon(Icons.timeline, color: AppColors.amethyst),
                ),
                const SizedBox(width: 8),
                Text(
                  'How are you feeling?',
                  style: AppOSTextStyles.osMdSemiboldLink.copyWith(
                    color: AppColors.primary01,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: AppColors.glassCardDecoration.copyWith(
                    color: AppColors.gray100.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Text(
                      "I feel good, no symptoms",
                      style: AppOSTextStyles.osMdSemiboldTitle
                          .copyWith(color: AppColors.primary01),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HealthTrackerScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: AppColors.glassCardDecoration.copyWith(
                      color: AppColors.gray100.withOpacity(0.7),
                    ),
                    child: Center(
                      child: Text(
                        "Log my symptoms",
                        style: AppOSTextStyles.osMdSemiboldTitle
                            .copyWith(color: AppColors.primary01),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalFeelingCard(BuildContext context) {
    return GestureDetector(
      onTap: (){
         showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height*0.9,
            decoration: BoxDecoration(
              color: AppColors.amethystViolet.withOpacity(0.97),
            ),
            child: PremiumOverlay(),
          ),
        );
        
      },
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: AppColors.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments, color: AppColors.amethyst, size: 30),
              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  '2 Days left to renew, renew now to continue using the app',
                  style:
                      AppOSTextStyles.osMd.copyWith(color: AppColors.primary01),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: AppColors.amethyst, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primary01,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.gray400,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.gray400,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildCreateCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MyPrepScreen(),
        ));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
        child: Column(
          children: [
            Icon(Icons.add_box, color: AppColors.amethyst, size: 32),
            const SizedBox(height: 8),
            Text('Create',
                style: AppOSTextStyles.osMdSemiboldTitle
                    .copyWith(color: AppColors.primary01)),
            const SizedBox(height: 4),
            Text('Appointment companion',
                style: AppOSTextStyles.osSmSemiboldBody
                    .copyWith(color: AppColors.primary01),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppColors.glassCardDecoration,
      child: Column(
        children: [
          Icon(Icons.favorite, color: AppColors.amethyst, size: 32),
          const SizedBox(height: 8),
          Text('Health Profile',
              style: AppOSTextStyles.osMdSemiboldTitle
                  .copyWith(color: AppColors.primary01)),
          const SizedBox(height: 4),
          Text('Help us get to know you',
              style: AppOSTextStyles.osSmSemiboldBody
                  .copyWith(color: AppColors.primary01),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // Bottom navigation methods removed - now handled by MainNavigationScreen
}

class _RecentItemCard extends StatelessWidget {
  final String title;
  final String date;
  final String lastEdited;

  const _RecentItemCard({
    required this.title,
    required this.date,
    required this.lastEdited,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppColors.glassCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppOSTextStyles.osMdSemiboldTitle
                  .copyWith(color: AppColors.primary01)),
          const SizedBox(height: 4),
          Text('Last Edited: $lastEdited',
              style: AppOSTextStyles.osSmSemiboldBody
                  .copyWith(color: AppColors.primary01)),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Date',
                  style: AppOSTextStyles.osSmSemiboldBody
                      .copyWith(color: AppColors.primary01)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 16, color: AppColors.amethyst),
                    const SizedBox(width: 4),
                    Text(date,
                        style: AppOSTextStyles.osSmSemiboldBody
                            .copyWith(color: AppColors.primary01)),
                  ],
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios,
                  size: 18, color: AppColors.amethyst),
            ],
          ),
        ],
      ),
    );
  }
}
