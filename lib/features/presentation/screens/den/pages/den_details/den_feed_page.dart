import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foxxhealth/core/components/foxx_button.dart';
import 'package:foxxhealth/core/components/foxx_text_field.dart';
import 'package:foxxhealth/core/components/paginated_list_view.dart';
import 'package:foxxhealth/core/constants/user_profile_constants.dart';
import 'package:foxxhealth/core/utils/extensions.dart';
import 'package:foxxhealth/features/data/managers/feed_manager.dart';
import 'package:foxxhealth/features/data/models/community_den_model.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/data/repositories/community_den_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/den_feed_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/feed/feed_event.dart';
import 'package:foxxhealth/features/presentation/cubits/den/post_feed/post_feed_cubit.dart';
import 'package:foxxhealth/features/presentation/cubits/den/post_feed/post_feed_state.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_landing_page.dart/widgets/feed_card.dart';
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
  late final DenFeedBloc _denFeedBloc;
  late final CommunityDenRepository _communityDenRepository;

  @override
  void initState() {
    super.initState();
    _communityDenRepository = CommunityDenRepository();

    _denFeedBloc = DenFeedBloc(
      _communityDenRepository,
      context.read<FeedManagerCubit>(),
    );

    // Load initial feeds
    _denFeedBloc.add(LoadFeeds(id: widget.den.id, feedType: FeedType.den));
  }

  @override
  void dispose() {
    _denFeedBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _denFeedBloc),
        // BlocProvider(
        //   create: (_) => PostFeedCubit(_communityDenRepository, context.read<FeedManagerCubit>()),
        // ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildConversationInput(context),
            Expanded(child: _buildFeedList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildConversationInput(BuildContext context) {
    return FoxxTextField(
      hint: "Start a conversation",
      readOnly: true,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () => _showConversationSheet(context, widget.den.id),
          child: Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
              color: Color(0xffCECECF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_upward, color: Colors.white),
          ),
        ),
      ),
      onChanged: (String s) {},
    );
  }

  Widget _buildFeedList(BuildContext context) {
    return BlocBuilder<FeedManagerCubit, FeedManagerState>(
      builder: (context, feedState) {
        const denType = FeedType.den;
        final posts = feedState.feedMap[denType]?.posts ?? <Post>[];

        if (feedState.isLoading(denType)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (feedState.hasError(denType).isNotEmpty) {
          return _buildErrorWidget(context);
        }

        return RefreshIndicator(
          onRefresh: () async {
            _denFeedBloc
                .add(RefreshFeeds(id: widget.den.id, feedType: denType));
          },
          child: PaginatedListView<Post>(
            padding: const EdgeInsets.symmetric(vertical: 12),
            data: posts,
            hasMore: feedState.hasMoreMap[denType] ?? false,
            fetchMore: () async {
              _denFeedBloc
                  .add(LoadMoreFeeds(id: widget.den.id, feedType: denType));
            },
            itemBuilder: (context, post) => FeedCard(
              post: post,
              userName: post.userProfile?.username ?? "",
              onLikeToggled: (post, isLiked) {
                _denFeedBloc
                    .add(UpdateLikes(postId: post.id, isLiked: isLiked));
                context.read<FeedManagerCubit>().toggleLike(post.id, isLiked);
              },
              onToggleBookMark: (post, saved) {
                _denFeedBloc
                    .add(UpdateBookmark(postId: post.id, isBookmarked: saved));
                context.read<FeedManagerCubit>().toggleBookmark(post.id, saved);
              },
            ),
            emptyWidget: const Align(
              alignment: Alignment.center,
              child: Text("No posts"),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
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
                _denFeedBloc.add(
                  RefreshFeeds(id: widget.den.id, feedType: FeedType.den),
                );
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  void _showConversationSheet(BuildContext context, int denId) {
    showModalBottomSheet(
      backgroundColor: AppColors.backgroundDefault,
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: ConversationSheetContent(
            denId: denId, repository: _communityDenRepository),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ConversationSheetContent extends StatefulWidget {
  final int denId;
  final CommunityDenRepository repository;
  const ConversationSheetContent(
      {super.key, required this.denId, required this.repository});

  @override
  State<ConversationSheetContent> createState() =>
      _ConversationSheetContentState();
}

class _ConversationSheetContentState extends State<ConversationSheetContent> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // Add listeners to update button state whenever text changes
    _titleController.addListener(_updateButtonState);
    _contentController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    _isButtonEnabled.value = _titleController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _titleController.removeListener(_updateButtonState);
    _contentController.removeListener(_updateButtonState);
    _titleController.dispose();
    _contentController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PostFeedCubit(widget.repository, context.read<FeedManagerCubit>()),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
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
                    FoxxTextField(
                      controller: _titleController,
                      hint: "Title",
                      borderColor: AppColors.amethyst,
                      focusBorderColor: AppColors.amethyst,
                      onChanged: (c) {},
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: FoxxTextField(
                        controller: _contentController,
                        hint: "Content",
                        maxLines: 6,
                        borderColor: AppColors.amethyst,
                        focusBorderColor: AppColors.amethyst,
                        onChanged: (c) {},
                      ),
                    ),
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocConsumer<PostFeedCubit, PostFeedState>(
          listener: (context, state) {
            if (state is PostDenSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Posted successfully!")),
              );
              _titleController.clear();
              _contentController.clear();

              // Close the bottom sheet after successful post
              Navigator.pop(context);
            } else if (state is PostDenFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
               Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return ValueListenableBuilder<bool>(
              valueListenable: _isButtonEnabled,
              builder: (_, isEnabled, __) {
                return FoxxButton(
                  label: "Post",
                  width: 100,
                  height: 36,
                  verticalPadding: 0,
                  isLoading: state is PostDenLoading,
                  isEnabled: isEnabled && state is! PostDenLoading,
                  onPressed: isEnabled && state is! PostDenLoading
                      ? () {
                          final content = _contentController.text.trim();
                          final hashtags = content.extractHashtags();

                          final post = Post.create(
                            denId: widget.denId,
                            title: _titleController.text.trim(),
                            content: content,
                            hashtags: hashtags,
                          );

                          context.read<PostFeedCubit>().postFeedToDen(post);
                          if (state is PostDenSuccess ||
                              state is PostDenFailure) {
                            Navigator.pop(context);
                          }
                        }
                      : null,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// class ConversationSheetContent extends StatefulWidget {
//   final int denId;
//   const ConversationSheetContent({super.key, required this.denId});

//   @override
//   State<ConversationSheetContent> createState() =>
//       _ConversationSheetContentState();
// }

// class _ConversationSheetContentState extends State<ConversationSheetContent> {
//   final TextEditingController _controller = TextEditingController();
//   final TextEditingController _titleController = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // const borderColor = Color(0xffCEA2FD);

//     return Container(
//       height: MediaQuery.of(context).size.height * 0.5,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildHeader(context),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   // Text Field
//                   FoxxTextField(
//                       hint: "Title",
//                       borderColor: AppColors.amethyst,
//                       focusBorderColor: AppColors.amethyst,
//                       onChanged: (v) {}),
//                   const SizedBox(
//                     height: 16,
//                   ),

//                   Expanded(
//                     child: FoxxTextField(
//                       controller: _controller,
//                         hint: "Title",
//                         maxLines: 6,
//                         borderColor: AppColors.amethyst,
//                         focusBorderColor: AppColors.amethyst,
//                         onChanged: (v) {}),
//                   ),

//                   // Footer with Post button
//                   _buildFooter(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       height: 54,
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () => Navigator.pop(context),
//             child: const Icon(Icons.close, size: 24, color: AppColors.amethyst),
//           ),
//           const Text(
//             'Start a conversation',
//             style: AppOSTextStyles.osMdBold,
//           ),
//           const Icon(Icons.close, size: 24, color: Colors.transparent),
//         ],
//       ),
//     );
//   }

//   Widget _buildFooter() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         //to do change icon and nav to event creation page
//         IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.abc,
//               color: Colors.transparent,
//             )),
//      BlocConsumer<PostFeedCubit, PostDenState>(
//   listener: (context, state) {
//     if (state is PostDenSuccess) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Posted successfully!")),
//       );
//       _controller.clear(); // reset field after success
//     } else if (state is PostDenFailure) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(state.message)),
//       );
//     }
//   },
//   builder: (context, state) {
//     return ValueListenableBuilder<TextEditingValue>(
//       valueListenable: _controller,
//       builder: (_, value, __) {
//         return FoxxButton(
//           isEnabled: value.text.isNotEmpty,
//           isLoading: state is PostDenLoading,
//           width: 100,
//           height: 36,
//           verticalPadding: 0,
//           label: "Post",
//           onPressed: value.text.isNotEmpty && state is! PostDenLoading
//               ? () {
//                   final String content = _controller.text;
//                   final extractedHashWithHash = content.extractHashtags();
//                   final extractedHashClean =
//                       content.extractHashtags(includeHash: false);

//                   print('Tags (with #): $extractedHashWithHash');
//                   print('Tags (clean): $extractedHashClean');

//                   // create post model
//                   final post = Post.create(
//                     denId:  widget.denId,
//                     title: _titleController.text.trim(),
//                     content: content,
//                     hashtags: extractedHashWithHash,
//                   );

//                   // call Cubit
//                   context.read<PostFeedCubit>().postFeedToDen(post);
//                 }
//               : null,
//         );
//       },
//     );
//   },
// );
//  ],
//     );
//   }
// }

// ---
