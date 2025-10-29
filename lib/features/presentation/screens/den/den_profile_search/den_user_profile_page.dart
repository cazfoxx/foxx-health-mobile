import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foxxhealth/core/components/foxx_tab_bar.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den_user_profile/community_den_profile_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den_user_profile/community_den_profile_state.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_profile_search/den_profile_tab_bar_contents/user_post_tab_content.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenUserProfilePage extends StatefulWidget {
  final String userName;
  const DenUserProfilePage({super.key, required this.userName});

  @override
  State<DenUserProfilePage> createState() => _DenUserProfilePageState();
}

class _DenUserProfilePageState extends State<DenUserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  bool _isPinned = false;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // if (state is Loading) {
    //   return const Center(child: CircularProgressIndicator());
    // } else if (state is Error) {
    //   return Center(
    //     child: Text(
    //       'Something went wrong. Please try again.',
    //       style: Theme.of(context).textTheme.bodyMedium,
    //     ),
    //   );
    // } else if (state is Loaded) {
    //   final posts = state.feed.posts;
    //   // if (posts.isEmpty) {
    //   //   return const Align(
    //   //     alignment: Alignment.topCenter,
    //   //     child: JoinDenSection(),
    //   //   );
    //   }
    return Expanded(
        child: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: BlocBuilder<DenProfilePostBloc, DenProfilePostState>(
                builder: (context, state) {
              if (state is Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is Loaded) {
                return UserInfoWiget(userName: state.feed.userName ?? "");
              }
              return const UserInfoWiget(userName: "");
            }),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16)
                .copyWith(top: 16, bottom: 12),
            sliver: const SliverToBoxAdapter(
              child: Text(
                "My Activity",
                style: AppHeadingTextStyles.h2,
              ),
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
                  tabController: tabController,
                  isPinned: _isPinned,
                  tabs: const [
                    Tab(text: 'Post'),
                    Tab(text: 'Comments'),
                    Tab(text: 'BookMarks'),
                    Tab(text: 'Likes'),
                  ],
                )),
          ),
        ];
      },
      body:
          //Todo; Implement search result data
          TabBarView(controller: tabController, children:const [
        UserPostTabContent(
          // userName: widget.userName ,
          userName: "popular72",

        ),
        Text(""),
        Text(""),
        Text("")
      ]),
    ));
  }
}

class UserInfoWiget extends StatelessWidget {
  final String userName;
  const UserInfoWiget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.45),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Avatar
          GestureDetector(
            onTap: () {},
            child: const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg',
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Username + Pronouns
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(userName, style: AppHeadingTextStyles.h3),
                    const Spacer(),
                    Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        child: SvgPicture.asset(
                            "assets/svg/icons/settings_account_box.svg")),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "she / her",
                  style: AppOSTextStyles.osMd
                      .copyWith(color: AppColors.secondaryTxt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//TEST CODe

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   int selectedIndex = 0;
//   bool isPinned = false;

//   final tabs = ["Posts", "Comments", "Bookmarks", "Likes"];

//   @override
//   Widget build(BuildContext context) {
//     return NotificationListener<ScrollNotification>(
//       onNotification: (notification) {
//         if (notification.metrics.pixels >= 160 && !isPinned) {
//           setState(() => isPinned = true);
//         } else if (notification.metrics.pixels < 160 && isPinned) {
//           setState(() => isPinned = false);
//         }
//         return false;
//       },
//       child: Scaffold(
//         body: CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: 200,
//               flexibleSpace: const FlexibleSpaceBar(
//                 title: Text("Profile Header"),
//               ),
//             ),

//             /// Custom Tab Bar
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: SliverTabDelegate(
//                 child: CustomTabBar(
//                   tabs: tabs,
//                   selectedIndex: selectedIndex,
//                   onTabSelected: (index) =>
//                       setState(() => selectedIndex = index),
//                   isPinned: isPinned,
//                 ),
//               ),
//             ),

//             /// Example Body
//             SliverToBoxAdapter(
//               child: Container(
//                 height: 1200,
//                 color: Colors.grey.shade100,
//                 child: Center(
//                   child: Text("Selected: ${tabs[selectedIndex]}"),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SliverTabDelegate extends SliverPersistentHeaderDelegate {
//   final Widget child;
//   const SliverTabDelegate({required this.child});

//   @override
//   Widget build(
//           BuildContext context, double shrinkOffset, bool overlapsContent) =>
//       child;

//   @override
//   double get maxExtent => 46;

//   @override
//   double get minExtent => 46;

//   @override
//   bool shouldRebuild(covariant SliverTabDelegate oldDelegate) =>
//       oldDelegate.child != child;
// }
