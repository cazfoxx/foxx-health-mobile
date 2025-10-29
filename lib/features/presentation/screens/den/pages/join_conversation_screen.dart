import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foxxhealth/core/components/foxx_button.dart';
import 'package:foxxhealth/core/components/foxx_selectable_chips.dart';
import 'package:foxxhealth/core/constants/shared_pref_keys.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/den/widgets/den_loading_dialog.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart'
    show AppHeadingTextStyles, AppOSTextStyles;
import 'package:foxxhealth/features/presentation/widgets/navigation_buttons.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinConversationScreen extends StatefulWidget {
  const JoinConversationScreen({super.key});

  @override
  State<JoinConversationScreen> createState() => _JoinConversationScreenState();
}

class _JoinConversationScreenState extends State<JoinConversationScreen> {
  final CommunityDenRepository _repository = CommunityDenRepository();

  bool isLoadingDen = false;

  // final List<String> dens = [
  // "Autoimmune Health",
  // "Bone Health",
  // "Breast Health",
  // "Chronic Pain",
  // "Diabetes",
  // "Heart Health",
  // "Hormone Health",
  // "Maternal Health",
  // "Mental Health",
  // "Patient Advocacy",
  // "Pelvic Health",
  // "Reproductive Health",
  // "Respiratory Health",
  // "Sexual Health",
  // ];

  List<CommunityDenModel> dens = [];

  final Set<int> selectedTopics = {};

  fetchDens() async {
    setState(() {
      isLoadingDen = true;
    });
    _repository.getCommunityDens().then((v) {
      setState(() {
        dens = v;
        isLoadingDen = false;
      });
    });
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const FoxxBackButton(),
          // title: Text(
          //   'My Prep',
          //   style: AppOSTextStyles.osMdBold.copyWith(color: AppColors.primary01),
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Title and subtitle
              Text(
                "Join the conversation",
                style: AppHeadingTextStyles.h2.copyWith(
                  color: AppColors.primary01,
                ),
              ),
              const SizedBox(height: 8),
              Text("Pick the topics and spaces that matter to you.",
                  style: AppOSTextStyles.osMd.copyWith(
                    color: AppColors.davysGray,
                    height: 1.5,
                  )),
              const SizedBox(height: 40),

              // Topic chips

              isLoadingDen
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Flexible(
                      child: SingleChildScrollView(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 12,
                          children: dens.map((den) {
                            final isSelected = selectedTopics.contains(den.id);

                            return FoxxSelectableChips(
                              label: den.name,
                              isSelected: isSelected,
                              // selectedTextColor: Colors.white,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedTopics.remove(den.id);
                                  } else {
                                    selectedTopics.add(den.id);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),

              const SizedBox(height: 40),
              // Next button
              FoxxButton(
                label: "Next",
                onPressed: _ontapNext,
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _ontapNext() async {
    if (selectedTopics.isEmpty) {
      SnackbarUtils.showError(
          context: context,
          title: 'No topics selected',
          message: 'Please select at least one topic to proceed.');
      return;
    }

    // Show loading dialog
    showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, anim1, anim2) {
          return const DenLoadingDialog();
        });

    try {
      // SET VALUE IN SHARED PREFERENCE TO NOT SHOW AGAIN

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(SharedPrefKeys.hasSeenDenPopup, true);
      log("Selected Topics Id ${selectedTopics.toList()}");
      final bool success =
          await _repository.bulkJoinDen(selectedTopics.toList());

      if (success) {
        if (mounted) {
          while (navigator!.canPop()) {
            navigator!.pop(context);
          }
          // Navigator.of(context).pop(); // / go back to previous screen
        }
      }
    } catch (e) {
      log('Error saving topics: $e');
      if (mounted) {
        Navigator.of(context).pop(); // Close the loading dialog
        SnackbarUtils.showError(
          context: context,
          title: "Error",
          message: "Failed to save the topics. Please try again."
        );
      }
    }
  }
}
