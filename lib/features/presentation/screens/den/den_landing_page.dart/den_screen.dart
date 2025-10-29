import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/components/foxx_tab_bar.dart';
import 'package:foxxhealth/core/constants/shared_pref_keys.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/data/repositories/den_comments_repository.dart';
import 'package:foxxhealth/features/data/repositories/den_profile_repositoty.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/my_feed_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den_user_profile/community_den_profile_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/my_bookmarks/my_bookmark_bloc.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/den_landing_page_header.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/my_bookmark_tab_content.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/my_dens.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/my_feeds_tab_content.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_profile_search/den_user_profile_page.dart';
import 'package:foxxhealth/features/presentation/screens/den/widgets/den_search_bar.dart';
import 'package:foxxhealth/features/presentation/screens/den/widgets/guide_line_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DenScreen extends StatefulWidget {
  const DenScreen({super.key});

  @override
  State<DenScreen> createState() => _DenScreenState();
}

class _DenScreenState extends State<DenScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchQuery = '';
  final CommunityDenRepository _repository = CommunityDenRepository();
   final DenProfileRepositoty _denProfileRepositoty = DenProfileRepositoty();
  late Future<List<CommunityDenModel>> _futureMyden;

  final List<String> _tabs = ['My feeds', 'My bookmarks'];
  bool _isPinned = false;

  @override
  void initState() {
    super.initState();
    loadMyDens();
    _tabController = TabController(length: _tabs.length, vsync: this);
    showInitialPopup();
  }

  void loadMyDens() {
    _futureMyden = _repository.getMydens();
  }

  void showInitialPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenDenPopup =
          prefs.getBool(SharedPrefKeys.hasSeenDenPopup) ?? false;
      log("has seen den popup: $hasSeenDenPopup");
      if (hasSeenDenPopup) return;

      if (mounted) {
        await showModalBottomSheet<void>(
          context: context,
          isDismissible: false,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          builder: (_) => const GuideLinePopup(),
        );

        setState(() {
          loadMyDens();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MyFeedBloc>(
          create: (context) =>
              MyFeedBloc( _repository),
        ),
        BlocProvider<DenProfilePostBloc>(
          create: (context) => DenProfilePostBloc(
            repo:_denProfileRepositoty,
          ),
        ),
        BlocProvider<CommentBloc>(
          create: (context) =>
              CommentBloc(CommentRepository()),
        ),
       BlocProvider<MyBookmarkBloc>(
          create: (context) =>
              MyBookmarkBloc(repository: _repository),
        ),

          BlocProvider<CommentBloc>(
          create: (context) =>
              CommentBloc(CommentRepository()),
        ),
      ],
      child: Foxxbackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                DenSearchBar(
                  hintText: "Search",
                  controller: _searchController,
                  autoImplyLeading: false,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                if (_searchQuery.isNotEmpty)
                  DenUserProfilePage(userName: _searchQuery.trim(),)
                else
                  Expanded(
                    child: NestedScrollView(
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            //Todo: implement true logic here
                            ...[
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    // UserInfoWiget(),
                                    const DenLandingPageHeader(),
                                    MyDens(futureMyden: _futureMyden),
                                  ],
                                ),
                              ),
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: CustomTabBarDelegate(
                                    onPinned: (pinned) {
                                      setState(() {
                                        _isPinned = pinned;
                                      });
                                    },
                                    child: FoxxTabBar(
                                      tabController: _tabController,
                                      isPinned: _isPinned,
                                      tabs: const [
                                        Tab(text: 'My Feeds'),
                                        Tab(text: 'My Bookmarks'),
                                      ],
                                    )),
                              ),
                            ]

                            // SliverAppBar(
                            //   pinned: true,
                            //   backgroundColor: Colors.transparent,
                            //   automaticallyImplyLeading: false,
                            //   flexibleSpace: CustomTabBar(
                            //     tabs: _tabs,
                            //     selectedIndex: _selectedIndex,
                            //     isPinned: _isPinned,
                            //     onTabSelected: (index) {
                            //       setState(() => _selectedIndex = index);
                            //       _tabController.animateTo(index);
                            //     },
                            //   ),
                            // ),
                          ];
                        },

                        // 🔹 Tab Content
                        body: TabBarView(
                          controller: _tabController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  MyFeedsTabContent(searchQuery: _searchQuery),
                            ),
                            const MyBookmarkTabContent(),
                          ],
                        )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
