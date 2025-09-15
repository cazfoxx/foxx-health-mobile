import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';

class DenPrivacyScreen extends StatefulWidget {
  const DenPrivacyScreen({Key? key}) : super(key: key);

  @override
  State<DenPrivacyScreen> createState() => _DenPrivacyScreenState();
}

class _DenPrivacyScreenState extends State<DenPrivacyScreen> {
  // Privacy settings state
  bool _postsVisible = false;
  bool _commentsVisible = false;
  bool _bookmarksVisible = false;
  bool _likesVisible = true; // Default to true as shown in the design

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
   
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: FoxxBackButton(),
          title: Text(
            'Den privacy',
            style: AppOSTextStyles.osMdBold.copyWith(
              color: AppColors.primary01,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Description
                Text(
                  'Manage your den privacy',
                  style: AppHeadingTextStyles.h4.copyWith(
                    color: AppColors.primary01,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose what you share in the Den and what stays just for you.',
                  style: AppOSTextStyles.osMd.copyWith(
                    color: AppColors.primary01,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // Privacy Options
                Expanded(
                  child: Column(
                    children: [
                      _buildPrivacyOption(
                        title: 'Posts',
                        value: _postsVisible,
                        onChanged: (value) {
                          setState(() {
                            _postsVisible = value;
                          });
                          _savePrivacySetting('posts', value);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPrivacyOption(
                        title: 'Comments',
                        value: _commentsVisible,
                        onChanged: (value) {
                          setState(() {
                            _commentsVisible = value;
                          });
                          _savePrivacySetting('comments', value);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPrivacyOption(
                        title: 'Bookmarks',
                        value: _bookmarksVisible,
                        onChanged: (value) {
                          setState(() {
                            _bookmarksVisible = value;
                          });
                          _savePrivacySetting('bookmarks', value);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildPrivacyOption(
                        title: 'Likes',
                        value: _likesVisible,
                        onChanged: (value) {
                          setState(() {
                            _likesVisible = value;
                          });
                          _savePrivacySetting('likes', value);
                        },
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

  Widget _buildPrivacyOption({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: AppColors.glassCardDecoration2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: AppColors.primary01,
              fontWeight: FontWeight.w600,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.amethyst,
            activeTrackColor: AppColors.amethyst.withOpacity(0.3),
            inactiveThumbColor: AppColors.gray400,
            inactiveTrackColor: AppColors.gray200,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  void _savePrivacySetting(String setting, bool value) {
    // TODO: Implement API call to save privacy settings
    // For now, just show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$setting privacy setting updated'),
        backgroundColor: AppColors.amethyst,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
