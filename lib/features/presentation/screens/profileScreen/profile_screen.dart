import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/services/analytics_service.dart';
import 'package:foxxhealth/core/utils/app_storage.dart';
import 'package:foxxhealth/features/presentation/cubits/profile/profile_cubit.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/base_scafold.dart';
import 'package:foxxhealth/features/presentation/screens/homeScreen/home_screen.dart';
import 'package:foxxhealth/features/presentation/screens/splash/splash_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      // Clear AppStorage
      AppStorage.clearCredentials();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: ${e.toString()}')),
      );
    }
  }

  final _analytics = AnalyticsService();


  Future<void> _logScreenView() async {
    await _analytics.logScreenView(
      screenName: 'ProfileScreen',
      screenClass: 'ProfileScreen',
    );
  }


  



  @override
  Widget build(BuildContext context) {
    _logScreenView();
    context.read<ProfileCubit>().fetchProfile();
    return BaseScaffold(
      currentIndex: 0,
      onTap: (index) {
                Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
          (route) => false, // This removes all previous routes from stack
        );

      },
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildProfileSection(),
              _buildSectionTitle('Health Profile'),
              _buildHealthSection(),
              _buildSectionTitle('Archives'),
              _buildArchivesSection(),
              _buildSectionTitle('Account Settings'),
              _buildSettingsSection(),
              _buildInviteButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.amethystViolet,
            ),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.amethystViolet),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _handleSignOut(context);
                        },
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(color: AppColors.amethystViolet),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text(
              'Sign out',
              style: TextStyle(
                color: AppColors.amethystViolet,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.lightViolet,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is ProfileError) {
          return Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.lightViolet,
            child: Center(
              child: Text('Error: ${state.message}'),
            ),
          );
        }

        final userName = state is ProfileLoaded ? state.userName : 'Loading...';
        final pronoun = state is ProfileLoaded ? state.pronoun : '';

        return Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.lightViolet,
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.woman,
                  size: 40,
                  color: AppColors.amethystViolet,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      pronoun,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showEditProfileBottomSheet(context, state),
                icon: const Icon(Icons.edit, color: AppColors.amethystViolet),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHealthSection() {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.flag,
              title: 'Health Goals',
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            _buildListTile(
              icon: Icons.fitness_center,
              title: 'Health Concerns',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArchivesSection() {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.checklist,
              title: 'Check List Archive',
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            _buildListTile(
              icon: Icons.favorite_border,
              title: 'Health Assessment Archive',
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            _buildListTile(
              icon: Icons.calendar_today,
              title: 'Appointment Archive',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            _buildListTile(
              icon: Icons.security,
              title: 'Manage my data',
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            _buildListTile(
              icon: Icons.card_membership,
              title: 'My Subscription',
              onTap: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(),
            ),
            _buildListTile(
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.amethystViolet),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildInviteButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          side: const BorderSide(color: AppColors.amethystViolet),
          padding: const EdgeInsets.symmetric(vertical: 12),
          minimumSize: const Size(double.infinity, 48),
        ),
        child: const Text(
          'Invite a Friend',
          style: TextStyle(
            color: AppColors.amethystViolet,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

void _showEditProfileBottomSheet(BuildContext context, ProfileState state) {
  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final pronounController = TextEditingController();
  // Pre-fill the text fields if state is ProfileLoaded
  if (state is ProfileLoaded) {
    emailController.text = state.emailAddress;
    userNameController.text = state.userName;
    pronounController.text = state.pronoun;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pronounController,
              decoration: const InputDecoration(
                labelText: 'Preferred Pronoun',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.amethystViolet,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                context.read<ProfileCubit>().updateProfile(
                      emailAddress: emailController.text,
                      userName: userNameController.text,
                      preferPronoun: pronounController.text,
                    );
                Navigator.pop(context);
              },
              child: const Text(
                'Save Changes',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

  // Update the IconButton in _buildProfileSection


