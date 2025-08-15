import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/view/appointment_companion_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/revamp/appointment/view/appointment_flow.dart';

class MyPrepScreen extends StatefulWidget {
  const MyPrepScreen({Key? key}) : super(key: key);

  @override
  State<MyPrepScreen> createState() => _MyPrepScreenState();
}

class _MyPrepScreenState extends State<MyPrepScreen> {
  String selectedTag = 'All';
  final List<String> tags = ['All', 'Upcoming Visit', 'PCOS', 'Past', 'M'];

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
                // Tags Section
                Text(
                  'Tags',
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(color: AppColors.davysGray),
                ),
                const SizedBox(height: 12),
                _buildTagsSection(),
                const SizedBox(height: 24),
                
                // Title and Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Prep',
                      style: AppHeadingTextStyles.h2.copyWith(color: AppColors.primary01),
                    ),
                                         Row(
                       children: [
                                                   GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AppointmentFlow(),
                                ),
                              );
                            },
                            child: _buildActionButton('New', Icons.add),
                          ),
                         const SizedBox(width: 12),
                         _buildActionButton('', Icons.sort),
                       ],
                     ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Appointment Companions List
                Expanded(
                  child: ListView(
                    children: [
                      _buildAppointmentCard(
                        'PCOS Appointment Companion',
                        'Apr 22, 2025',
                      ),
                      const SizedBox(height: 12),
                      _buildAppointmentCard(
                        'PCP Appointment Companion',
                        'Mar 07, 2025',
                      ),
                      const SizedBox(height: 12),
                      _buildAppointmentCard(
                        'Eye Doctor Appointment Companion',
                        'Jan 2, 2025',
                      ),
                      const SizedBox(height: 12),
                      _buildAppointmentCard(
                        'Dermatologist Appointment Companion',
                        'Nov 18, 2024',
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

  Widget _buildTagsSection() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          final isSelected = tag == selectedTag;
          
          return Padding(
            padding: EdgeInsets.only(right: index < tags.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTag = tag;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.mauve50 : Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.amethyst : AppColors.gray200,
                    width: 1,
                  ),
                ),
                child: Text(
                  tag,
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: isSelected ? AppColors.amethyst : AppColors.davysGray,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.mauve50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.amethyst.withOpacity(0.3)),
      ),
      child: Center(
        child: text.isNotEmpty
            ? Text(
                text,
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: AppColors.amethyst,
                ),
              )
            : Icon(
                icon,
                color: AppColors.amethyst,
                size: 20,
              ),
      ),
    );
  }

  Widget _buildAppointmentCard(String title, String lastUpdated) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AppointmentCompanionScreen(
              appointmentData: {},
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: AppColors.glassCardDecoration,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                      color: AppColors.primary01,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last updated: $lastUpdated',
                    style: AppOSTextStyles.osSmSemiboldBody.copyWith(
                      color: AppColors.davysGray,
                    ),
                  ),
                ],
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

  void _showNavigationBottomSheet(BuildContext context, String appointmentTitle) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  appointmentTitle,
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: AppColors.primary01,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              
              // Navigation options
              _buildNavigationOption(
                context,
                Icons.edit,
                'Edit Appointment Companion',
                'Modify details and questions',
                () {
                  Navigator.pop(context);
                  // TODO: Navigate to edit screen
                },
              ),
              _buildNavigationOption(
                context,
                Icons.share,
                'Share',
                'Share with your healthcare provider',
                () {
                  Navigator.pop(context);
                  // TODO: Implement share functionality
                },
              ),
              _buildNavigationOption(
                context,
                Icons.download,
                'Export',
                'Download as PDF or document',
                () {
                  Navigator.pop(context);
                  // TODO: Implement export functionality
                },
              ),
              _buildNavigationOption(
                context,
                Icons.delete_outline,
                'Delete',
                'Remove this appointment companion',
                () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, appointmentTitle);
                },
              ),
              const SizedBox(height: 20),
              
              // Cancel button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: AppOSTextStyles.osMdSemiboldLink.copyWith(
                        color: AppColors.davysGray,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.mauve50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.amethyst,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
          color: AppColors.primary01,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppOSTextStyles.osSmSemiboldBody.copyWith(
          color: AppColors.davysGray,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showDeleteConfirmation(BuildContext context, String appointmentTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Appointment Companion',
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: AppColors.primary01,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$appointmentTitle"? This action cannot be undone.',
            style: AppOSTextStyles.osMd.copyWith(
              color: AppColors.davysGray,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppOSTextStyles.osMdSemiboldLink.copyWith(
                  color: AppColors.davysGray,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement delete functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$appointmentTitle deleted'),
                    backgroundColor: AppColors.amethyst,
                  ),
                );
              },
              child: Text(
                'Delete',
                style: AppOSTextStyles.osMdSemiboldLink.copyWith(
                  color: AppColors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }



  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
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
