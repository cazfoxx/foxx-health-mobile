import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/components/foxx_button.dart';
import 'package:foxxhealth/core/components/paginated_list_view.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den_user_profile/community_den_profile__event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den_user_profile/community_den_profile_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den_user_profile/community_den_profile_state.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/feed_card.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/explore_den_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class UserPostTabContent extends StatefulWidget {
  final String userName;
  const UserPostTabContent({super.key, required this.userName});

  @override
  State<UserPostTabContent> createState() => _UserPostTabContentState();
}

class _UserPostTabContentState extends State<UserPostTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context
        .read<DenProfilePostBloc>()
        .add(LoadPosts(userName: widget.userName));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<DenProfilePostBloc, DenProfilePostState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is Error) {
          return Center(
            child: Text(
              'Something went wrong. Please try again.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        } else if (state is Loaded) {
          final posts = state.feed.posts;
          if (posts.isEmpty) {
            return  Align(
              alignment: Alignment.topCenter,
              child: Text("No post for user name ${widget.userName}"),
            );
          }

          // ✅ Use the reusable pagination component
          return PaginatedListView<Post>(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            data: posts,
            hasMore: state.hasMore,
            fetchMore: () async {
              // trigger the bloc event to load more
              context
                  .read<DenProfilePostBloc>()
                  .add(LoadMorePosts(userName: widget.userName));
            },
            itemBuilder: (context, post) => FeedCard(post: post),
            emptyWidget: const Align(
              alignment: Alignment.topCenter,
              child: JoinDenSection(),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class JoinDenSection extends StatelessWidget {
  const JoinDenSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.45),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Join a den to see the feed",
                style: AppOSTextStyles.osMd,
              ),
              const SizedBox(height: 8),
              FoxxButton(
                  height: 42,
                  width: 150,
                  label: "Explore dens",
                  verticalPadding: 0,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return const ExploreDenScreen();
                    }));
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
