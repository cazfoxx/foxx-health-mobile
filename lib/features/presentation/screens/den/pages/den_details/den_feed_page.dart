import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/components/foxx_button.dart';
import 'package:foxxhealth/core/components/foxx_text_field.dart';
import 'package:foxxhealth/core/components/paginated_list_view.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/data/repositories/den_comments_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/den_feed_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/feed_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/feed_state.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/feed_card.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/my_feeds_tab_content.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class DenFeedPage extends StatefulWidget {
  final CommunityDenModel den;
  const DenFeedPage({super.key, required this.den});

  @override
  State<DenFeedPage> createState() => _DenFeedPageState();
}

class _DenFeedPageState extends State<DenFeedPage>
    with AutomaticKeepAliveClientMixin {
  late DenFeedBloc _bloc;
  final communityDenRepository = CommunityDenRepository();

  @override
  initState() {
    super.initState();
    _bloc = DenFeedBloc(communityDenRepository);
    _bloc.add(LoadFeeds(id: widget.den.id));
    // fetchDens()
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CommentBloc(CommentRepository()))
      ],
      child: BlocProvider.value(
        value: _bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              FoxxTextField(
                  hint: "Start a conversation",
                  readOnly: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        // open  conversation creation
                        _showConversationSheet(context);
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xffCECECF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onChanged: (c) {}),

              // todo: fetch feed data from den

              Expanded(
                child: BlocBuilder<DenFeedBloc, FeedState>(
                  builder: (context, state) {
                    if (state is FeedLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FeedError) {
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
                                    context
                                        .read<DenFeedBloc>()
                                        .add(RefreshFeeds(id: widget.den.id));
                                  },
                                  child: const Text("Retry"))
                            ],
                          ),
                        ),
                      );
                    } else if (state is FeedLoaded) {
                      final posts = state.posts;
                      if (posts.isEmpty) {
                        return const Align(
                          alignment: Alignment.topCenter,
                          child: JoinDenSection(),
                        );
                      }

                      // ✅ Use the reusable pagination component
                      return RefreshIndicator(
                        onRefresh: () async {
                          context
                              .read<DenFeedBloc>()
                              .add(RefreshFeeds(id: widget.den.id));
                        },
                        child: PaginatedListView<Post>(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          data: posts,
                          hasMore: state.hasMore,
                          fetchMore: () async {
                            // trigger the bloc event to load more
                            context
                                .read<DenFeedBloc>()
                                .add(LoadMoreFeeds(id: widget.den.id));
                          },
                          itemBuilder: (context, post) => FeedCard(
                            post: post,
                            userName: UserProfileConstants.getDisplayName(),
                            onLikeToggled: (post, isLiked) {
                              context.read<DenFeedBloc>().add(UpdateLikes(
                                  postId: post.id, isLiked: isLiked));
                            },
                          ),
                          emptyWidget: const Align(
                            alignment: Alignment.topCenter,
                            child: JoinDenSection(),
                          ),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showConversationSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundDefault,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: const ConversationSheetContent(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ConversationSheetContent extends StatefulWidget {
  const ConversationSheetContent({super.key});

  @override
  State<ConversationSheetContent> createState() =>
      _ConversationSheetContentState();
}

class _ConversationSheetContentState extends State<ConversationSheetContent> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xffCEA2FD);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Text Field
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      minLines: 8,
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Share your thoughts...',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: borderColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: borderColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: borderColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Footer with Post button
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 24, color: AppColors.amethyst),
          ),
          const Text(
            'Start a conversation',
            style: AppOSTextStyles.osMdBold,
          ),
          const Icon(Icons.close, size: 24, color: Colors.transparent),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //to do change icon and nav to event creation page
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.abc,
              color: Colors.transparent,
            )),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (_, value, __) {
            return FoxxButton(
              isEnabled: value.text.isNotEmpty,
              width: 100,
              height: 36,
              verticalPadding: 0,
              label: "Post",
              onPressed: value.text.isNotEmpty ? () {} : null,
            );
          },
        ),
      ],
    );
  }
}

// ---
