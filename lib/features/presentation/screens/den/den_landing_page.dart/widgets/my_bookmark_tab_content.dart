import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/components/paginated_list_view.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/presentation/cubits/den/community_den_user_profile/community_den_profile_state.dart';
import 'package:foxxhealth/features/presentation/cubits/den/my_bookmarks/my_bookmark_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/my_bookmarks/my_bookmark_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/my_bookmarks/my_bookmark_state.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/feed_card.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class MyBookmarkTabContent extends StatefulWidget {
  const MyBookmarkTabContent({super.key});

  @override
  State<MyBookmarkTabContent> createState() => _MyBookmarkTabContentState();
}

class _MyBookmarkTabContentState extends State<MyBookmarkTabContent> {
  @override
  void initState() {
    super.initState();
    context.read<MyBookmarkBloc>().add(LoadBookmark());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBookmarkBloc, MyBookmarkState>(
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookmarkError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'Something went wrong. Please try again.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<MyBookmarkBloc>().add(RefreshBookmark());
                      },
                      child: const Text("Retry"))
                ],
              ),
            ),
          );
        } else if (state is BookmarkLoaded) {
          final posts = state.posts;
          // if (posts.isEmpty) {
          //   return const Align(
          //     alignment: Alignment.topCenter,
          //     child: EmptyBookmarkWidget(),
          //   );
          // }

          // ✅ Use the reusable pagination component
          return PaginatedListView<Post>(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            data: posts,
            hasMore: state.hasMore,
            fetchMore: () async {
              // trigger the bloc event to load more
              context.read<MyBookmarkBloc>().add(LoadMoreBookmark());
            },
            itemBuilder: (context, post) => FeedCard(
              post: post,
              // userName: UserProfileConstants.getDisplayName(),
            ),
            emptyWidget: const Align(
              alignment: Alignment.topCenter,
              child: EmptyBookmarkWidget(),
            ),
          );
        }

        return const SizedBox.shrink();
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
