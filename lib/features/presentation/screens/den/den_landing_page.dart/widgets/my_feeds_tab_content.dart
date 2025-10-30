import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/components/foxx_button.dart';
import 'package:foxxhealth/core/components/paginated_list_view.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/features/data/managers/feed_manager.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_state.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/my_feed_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/feed_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/feed_state.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/feed_card.dart';
import 'package:foxxhealth/features/presentation/screens/den/pages/explore_den_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class MyFeedsTabContent extends StatefulWidget {
  final String searchQuery;
  const MyFeedsTabContent({super.key, required this.searchQuery});

  @override
  State<MyFeedsTabContent> createState() => _MyFeedsTabContentState();
}

class _MyFeedsTabContentState extends State<MyFeedsTabContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyFeedBloc>().add(const LoadFeeds(feedType: FeedType.feed));
    });
  }

  List<Post> filterPosts(FeedState state) {
    if (state is! FeedLoaded) return [];

    final query = widget.searchQuery.toLowerCase();

    return state.posts.where((post) {
      final usernameMatch =
          post.userProfile.username.toLowerCase().contains(query);

      final contentMatch = post.content.toLowerCase().contains(query);

      // Use null-aware operator to safely access den name
      final denMatch = post.den?.name.toLowerCase().contains(query) ?? false;

      // Use null-aware operator for hashtags
      final hashtagsMatch = post.hashtags?.any(
            (tag) => tag.toLowerCase().contains(query),
          ) ??
          false;

      return usernameMatch || contentMatch || denMatch || hashtagsMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<FeedManagerCubit, FeedManagerState>(
      builder: (context, state) {
        const FeedType feed = FeedType.feed;
        final posts = state.feedMap[feed]?.posts ?? <Post>[];

        if (state.isLoading(feed)) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<MyFeedBloc>().add(const RefreshFeeds(feedType: feed));
          },
          child: PaginatedListView<Post>(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            data: posts,
            hasMore: context.read<FeedManagerCubit>().hasMore(FeedType.feed),
            fetchMore: () async {
              // trigger the bloc event to load more
              context
                  .read<MyFeedBloc>()
                  .add(const LoadMoreFeeds(feedType: feed));
            },
            itemBuilder: (context, post) => FeedCard(
              post: post,
              userName: UserProfileConstants.getDisplayName(),
              onLikeToggled: (post, isLiked) {
                context
                    .read<MyFeedBloc>()
                    .add(UpdateLikes(postId: post.id, isLiked: isLiked));
                context.read<FeedManagerCubit>().toggleLike(post.id, isLiked);
              },
              onToggleBookMark: (post, isSaved) {
                context.read<MyFeedBloc>().add(
                    UpdateBookmark(postId: post.id, isBookmarked: isSaved));
                context
                    .read<FeedManagerCubit>()
                    .toggleBookmark(post.id, isSaved);
              },
            ),
            emptyWidget: const Align(
              alignment: Alignment.center,
              child: JoinDenSection(),
            ),
          ),
        );
      },
    );

    // return BlocBuilder<MyFeedBloc, FeedState>(
    //   builder: (context, state) {
    //     if (state is FeedLoading) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (state is FeedError) {
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 24),
    //         child: Center(
    //           child: Column(
    //             children: [
    //               Text(
    //                 'Something went wrong. Please try again.',
    //                 style: Theme.of(context).textTheme.bodyMedium,
    //               ),
    //               TextButton(
    //                   onPressed: () {
    //                     context.read<MyFeedBloc>().add(RefreshFeeds());
    //                   },
    //                   child: const Text("Retry"))
    //             ],
    //           ),
    //         ),
    //       );
    //     } else if (state is FeedLoaded) {
    //       final posts = state.posts;
    //       if (posts.isEmpty) {
    //         return const Align(
    //           alignment: Alignment.topCenter,
    //           child: JoinDenSection(),
    //         );
    //       }

    //       // ✅ Use the reusable pagination component
    //       return BlocListener<CommentBloc, CommentState>(
    //         listener: (context, state) {
    //           debugPrint("🎯 Global listener triggered");

    //           if (state is AddCommentSuccess) {
    //             final postId = state.postId; // make sure comment has postId
    //             final newCommentCount = state.comments.length;

    //             debugPrint(
    //                 "Updating post $postId comment count to $newCommentCount");

    //             context.read<MyFeedBloc>().add(
    //                   UpdatedComments(
    //                     postId: postId!,
    //                     commentLength: newCommentCount,
    //                   ),
    //                 );
    //           }
    //         },
    //         child: RefreshIndicator(
    //           onRefresh: () async {
    //             context.read<MyFeedBloc>().add(const RefreshFeeds());
    //           },
    //           child: PaginatedListView<Post>(
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    //             data: posts,
    //             hasMore: state.hasMore,
    //             fetchMore: () async {
    //               // trigger the bloc event to load more
    //               context.read<MyFeedBloc>().add(const LoadMoreFeeds());
    //             },
    //             itemBuilder: (context, post) => FeedCard(
    //               post: post,
    //               userName: UserProfileConstants.getDisplayName(),
    //               onLikeToggled: (post, isLiked) {
    //                 context
    //                     .read<MyFeedBloc>()
    //                     .add(UpdateLikes(postId: post.id, isLiked: isLiked));
    //               },
    //               onToggleBookMark: (post, isSaved) {
    //                 context.read<MyFeedBloc>().add(
    //                     UpdateBookmark(postId: post.id, isBookmarked: isSaved));
    //               },
    //             ),
    //             emptyWidget: const Align(
    //               alignment: Alignment.topCenter,
    //               child: JoinDenSection(),
    //             ),
    //           ),
    //         ),
    //       );
    //     }

    //     return const SizedBox.shrink();
    //   },
    // );
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
