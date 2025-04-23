import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
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

  Widget _buildHeader() {
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
            onPressed: () {},
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RedDelicious',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'She/her',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: AppColors.amethystViolet),
          ),
        ],
      ),
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
