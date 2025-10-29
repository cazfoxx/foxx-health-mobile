import 'package:flutter/material.dart';
import 'package:foxxhealth/core/utils/app_ui_helper.dart';
import 'package:foxxhealth/core/utils/snackbar_utils.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_details/den_about_page.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_details/den_feed_page.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_details/den_talk_event_page.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_details/widgets/den_app_bar_widget.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_details/widgets/den_banner_widget.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/den_details/widgets/den_tab_bar_widget.dart';
import 'package:foxxhealth/features/presentation/screens/den/widgets/den_dialog_box.dart';

class DenDetailScreen extends StatefulWidget {
  final CommunityDenModel den;
  const DenDetailScreen({super.key, required this.den});

  @override
  State<DenDetailScreen> createState() => _DenDetailScreenState();
}

class _DenDetailScreenState extends State<DenDetailScreen> {
  final CommunityDenRepository repository = CommunityDenRepository();
  late Future<CommunityDenModel> _futureDen;

// if the user is a member of the den
  bool isMember = false;

  @override
  void initState() {
    super.initState();
    fetchDenDetails();
    isMember =widget.den.isJoined;
  }

  fetchDenDetails() {
    _futureDen = repository.getCommunityDenDetails(widget.den.id);
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                DenAppBarWidget(den: widget.den),
                Expanded(
                  child: FutureBuilder(
                      future: _futureDen,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData) {
                          return const Center(child: Text('No data found'));
                        }

                        final den = snapshot.data!;
                        return Column(
                          children: [
                            DenBannerWidget(
                                den: den,
                                onTap: () {
                                  _joinOrLeaveDen();
                                },
                                isMember: isMember),

                            const DenTabBarWidget(),

                            // TAB BAR  CONTENTES
                            Expanded(
                                child: TabBarView(children: [
                              DenAboutPage(den: den),
                              DenFeedPage(
                                den: den,
                              ),
                              const DenTalkEventPage(),
                            ]))
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///JOIN OR LEAVE DEN

  Future<void> _joinOrLeaveDen() async {
    try {
      if (isMember) {
        // Leave den

        // show dialog box for confirmation
        AppHelper.showDialogBox(
            context: context,
            child: DenDialogBox(
                title: "Leaving this Den?",
                subtitle:
                    "If you leave, you’ll lose access to the conversations and updates. You can always rejoin later if you choose. All your comments and activities history will stay.",
                onPressed: () async {
                  final message = await repository.leaveDen(widget.den.id);

                  if (message != null && mounted) {
                    setState(() => isMember = false);
                    SnackbarUtils.showSuccess(
                      context: context,
                      title: "Success",
                      message: message,
                    );
                  }
                },
                buttonLabelText: "Leave Den"));
        return;
      }

      // Join den
      final success = await repository.joinDen(widget.den.id);

      if (success && mounted) {
        setState(() => isMember = true);
        SnackbarUtils.showSuccess(
          context: context,
          title: "Success",
          message: "You have joined the den.",
        );
      } else {
        if (mounted) {
          SnackbarUtils.showError(
            context: context,
            title: "Error",
            message: "Failed to join the den. Please try again.",
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _joinOrLeaveDen: $e\n$stackTrace');
      if (mounted) {
        SnackbarUtils.showError(
          context: context,
          title: "Error",
          message: "Something went wrong. Please try again.",
        );
      }
    }
  }
}
