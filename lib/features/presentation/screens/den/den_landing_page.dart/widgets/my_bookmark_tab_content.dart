import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/components/paginated_list_view.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/features/data/managers/feed_manager.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/feed_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/my_bookmarks/my_bookmark_bloc.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/feed_card.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class MyBookmarkTabContent extends StatefulWidget {
  const MyBookmarkTabContent({super.key});

  @override
  State<MyBookmarkTabContent> createState() => _MyBookmarkTabContentState();
}

class _MyBookmarkTabContentState extends State<MyBookmarkTabContent> {
  final FeedType bookmark = FeedType.bookmark;
  @override
  void initState() {
    super.initState();
    context.read<MyBookmarkBloc>().add(LoadFeeds(feedType: bookmark));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedManagerCubit, FeedManagerState>(
      builder: (context, state) {
        final posts = state.feedMap[bookmark]?.posts ?? <Post>[];

        if (state.isLoading(bookmark)) {
          return const Center(child: CircularProgressIndicator());
        }

        // if (posts.isEmpty) {
        //   return const Padding(
        //     padding: EdgeInsets.only(top: 16.0),
        //     child: Align(
        //         alignment: Alignment.topCenter, child: EmptyBookmarkWidget()),
        //   );
        // }

        // ✅ Use the reusable pagination component
        return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<MyBookmarkBloc>()
                  .add(RefreshFeeds(feedType: bookmark));
            },
            child: PaginatedListView<Post>(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                data: posts,
                hasMore: state.hasMoreMap[bookmark] ?? false,
                emptyWidget: const Align(
                alignment: Alignment.center, child: EmptyBookmarkWidget()),
                fetchMore: () async {
                  // trigger the bloc event to load more
                  context
                      .read<MyBookmarkBloc>()
                      .add(LoadMoreFeeds(feedType: bookmark));
                },
                itemBuilder: (context, post) => FeedCard(
                      post: post,
                      userName: UserProfileConstants.getDisplayName(),
                      onLikeToggled: (post, isLiked) {
                        context.read<MyBookmarkBloc>().add(
                            UpdateLikes(postId: post.id, isLiked: isLiked));
                        context
                            .read<FeedManagerCubit>()
                            .toggleLike(post.id, isLiked);
                      },
                      onToggleBookMark: (post, isSaved) {
                        context.read<MyBookmarkBloc>().add(UpdateBookmark(
                            postId: post.id, isBookmarked: isSaved));
                        context
                            .read<FeedManagerCubit>()
                            .toggleBookmark(post.id, isSaved);
                      },
                    )));
      },
    );
  }
}

class EmptyBookmarkWidget extends StatelessWidget {
  const EmptyBookmarkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.bookmark,
            size: 64,
            color: const Color(0xFF9B7EDE).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No bookmarks yet',
            style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
