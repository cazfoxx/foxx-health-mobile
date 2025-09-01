import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/profile/profile_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/symptom_search/symptom_search_cubit.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Profile fetching is now handled by MainNavigationScreen
  final SymptomSearchCubit _symptomCubit = SymptomSearchCubit();
  final ImagePicker _picker = ImagePicker();
  
  String? _profileIconUrl;
  bool _hasProfileIcon = false;
  bool _isLoadingProfileIcon = false;

  @override
  void initState() {
    super.initState();
    _loadProfileIcon();
  }

  Future<void> _loadProfileIcon() async {
    setState(() {
      _isLoadingProfileIcon = true;
    });

    try {
      final profileIconUrl = await _symptomCubit.getProfileIcon();
      if (profileIconUrl != null) {
        setState(() {
          _hasProfileIcon = true;
          _profileIconUrl = profileIconUrl;
          _isLoadingProfileIcon = false;
        });
      } else {
        setState(() {
          _hasProfileIcon = false;
          _profileIconUrl = null;
          _isLoadingProfileIcon = false;
        });
      }
    } catch (e) {
      print('Error loading profile icon: $e');
      setState(() {
        _isLoadingProfileIcon = false;
      });
    }
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _isLoadingProfileIcon = true;
        });

        final result = await _symptomCubit.uploadProfileIcon(image.path);
        
        if (result != null) {
          // Reload profile icon data
          await _loadProfileIcon();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile picture updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload profile picture. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error picking/uploading image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingProfileIcon = false;
        });
      }
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Account',
                          style: AppHeadingTextStyles.h2.copyWith(
                            color: AppColors.primary01,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Implement sign out functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sign out functionality coming soon'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          },
                          child: Text(
                            'Sign Out',
                            style: AppOSTextStyles.osMdSemiboldLabel.copyWith(
                              color: AppColors.amethyst,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Greeting Section
                    Text(
                      'Hi, ${UserProfileConstants.getDisplayName()}',
                      style: AppHeadingTextStyles.h2.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your account settings and preferences',
                      style: AppOSTextStyles.osMd.copyWith(
                        color: AppColors.davysGray,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // User Profile Section
                    _buildUserProfileCard(),
                    const SizedBox(height: 32),

                    // Settings Section
                    Text(
                      'Settings',
                      style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Settings Items
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildSettingsItem(
                              icon: Icons.lock_outline,
                              title: 'Update Password',
                              onTap: () {
                                // TODO: Navigate to update password screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Update password functionality coming soon'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingsItem(
                              icon: Icons.share,
                              title: 'Den Privacy',
                              onTap: () {
                                // TODO: Navigate to den privacy screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Den privacy functionality coming soon'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingsItem(
                              icon: Icons.storage,
                              title: 'Manage my data',
                              onTap: () {
                                // TODO: Navigate to manage data screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Manage data functionality coming soon'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingsItem(
                              icon: Icons.star,
                              title: 'My subscription',
                              onTap: () {
                                // TODO: Navigate to subscription screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Subscription functionality coming soon'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingsItem(
                              icon: Icons.notifications_outlined,
                              title: 'Alerts',
                              onTap: () {
                                // TODO: Navigate to alerts screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Alerts functionality coming soon'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _buildSettingsItem(
                              icon: Icons.person_remove,
                              title: 'Close my account',
                              onTap: () {
                                // TODO: Navigate to close account screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Close account functionality coming soon'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: _buildBottomNavigationBar(context),
          ),
        
    
    );
  }

  Widget _buildUserProfileCard() {
    return GestureDetector(
      onTap: _pickAndUploadImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
        child: Row(
          children: [
            // Profile Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.mauve50,
                  backgroundImage: _hasProfileIcon && _profileIconUrl != null
                      ? NetworkImage('https://fastapi-backend-v2-788993188947.us-central1.run.app/$_profileIconUrl')
                      : null,
                  child: _hasProfileIcon && _profileIconUrl != null
                      ? null
                      : _isLoadingProfileIcon
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Icon(
                              Icons.person,
                              size: 30,
                              color: AppColors.amethyst,
                            ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.amethyst,
                      shape: BoxShape.circle,
                    ),
                    child: _isLoadingProfileIcon
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
          const SizedBox(width: 16),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserProfileConstants.getDisplayName(),
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'she/her', // TODO: Get from user profile
                  style: AppOSTextStyles.osMd.copyWith(
                    color: AppColors.davysGray,
                  ),
                ),
              ],
            ),
          ),
          
          // Arrow Icon
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.amethyst,
            size: 16,
          ),
        ],
      ),
    ));
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: AppColors.glassCardDecoration,
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.amethyst,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
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
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', false, () {
            Navigator.of(context).pop();
          }),
          _buildNavItem(Icons.assignment, 'My Prep', false, () {
            // TODO: Navigate to My Prep
          }),
          _buildNavItem(Icons.timeline, 'Tracker', false, () {
            // TODO: Navigate to Tracker
          }),
          _buildNavItem(Icons.search, 'Insight', false, () {
            // TODO: Navigate to Insight
          }),
          _buildNavItem(Icons.group, 'The Den', false, () {
            // TODO: Navigate to The Den
          }),
        ],
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
