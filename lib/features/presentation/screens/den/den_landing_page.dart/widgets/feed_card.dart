import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/components/bookmark_icon.dart';
import 'package:foxxhealth/core/components/heart_toggle_button.dart';
import 'package:foxxhealth/core/components/photo_grid_view.dart';
import 'package:foxxhealth/core/utils/app_ui_helper.dart';
import 'package:foxxhealth/core/utils/share.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_bloc.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_comments/den_comments_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class FeedCard extends StatefulWidget {
  final Post post;
  final String?
      userName; // for own feed , if user name is not available for post
  final void Function(Post post, bool isLiked)? onLikeToggled;
  final void Function(Post post, bool isLiked)? onToggleBookMark;

  const FeedCard({
    super.key,
    required this.post,
    this.userName,
    this.onLikeToggled,
    this.onToggleBookMark,
  });

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool _isExpanded = false;
  static const int _truncateLength = 220;

  bool _isLiked = false;
  bool _isBookMarked = false;
  // int _likesCount = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.userLiked ?? false;
    // _likesCount = widget.post.likesCount;
  }

  void _handleLocalToggle() {
    setState(() {
      _isLiked = !_isLiked;
      // _likesCount += _isLiked ? 1 : -1;
    });

    widget.onLikeToggled?.call(widget.post, _isLiked);
  }

  _handleLocalBookMarkToggle() {
    setState(() {
      _isBookMarked = !_isBookMarked;
      // _likesCount += _isLiked ? 1 : -1;
    });

    widget.onToggleBookMark?.call(widget.post, _isBookMarked);
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.post.content;
    final post = widget.post;
    final bool showMoreButton = content.length > _truncateLength;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.45),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Posted in section
          if (post.den?.name != null)
            Row(
              children: [
                Text(
                  'Posted in  ',
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to specific den
                  },
                  child: Text(
                    post.den?.name ?? "",
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: const Color(0xFF9B7EDE), // Purple color
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 12),

          // User info
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: post.userProfile?.profilePictureUrl != null
                    ? Image.network(post.userProfile!.profilePictureUrl)
                    : Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: 24,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.userName ?? widget.post.userProfile?.username ?? '',
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// photo view
          PhotoGrid(imageUrls: widget.post.mediaUrls ?? []),
          if ((widget.post.mediaUrls ?? []).isNotEmpty)
            const SizedBox(height: 12),
          RichText(
              text: TextSpan(
            style: AppOSTextStyles.osLg
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: widget.post.title),
            ],
          )),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: AppOSTextStyles.osMd.copyWith(
                color: AppColors.secondaryTxt,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: _isExpanded || !showMoreButton
                      ? content
                      : '${content.substring(0, _truncateLength)}...',
                ),
                if (showMoreButton)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 4), // small spacing
                        child: Text(
                          _isExpanded ? 'Show less' : 'More',
                          style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                            color: const Color(0xFF9B7EDE),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Hashtags
          Wrap(
            spacing: 8,
            children: (widget.post.hashtags ?? []).map((tag) {
              return Text(
                tag,
                style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                  color: const Color(0xFF9B7EDE), // Purple color
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Interaction buttons
          Row(
            children: [
              // Like button
              Row(
                children: [
                  HeartToggleButton(
                      isLiked: widget.post.userLiked ?? false,
                      onToggle: () async {
                        _handleLocalToggle();
                      }),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.post.likesCount}',
                    style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              // Comment button
              GestureDetector(
                onTap: () {
                  AppHelper.showBottomModalSheet(
                    context: context,
                    child: BlocProvider.value(
                      value: context.read<CommentBloc>(),
                      child: DenCommentsScreen(postId: widget.post.id),
                    ),
                  );
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/icons/comments.svg',
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.post.commentsCount}',
                      style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Action buttons
              ToggleBookmarkIcon(
                isBookMarked: widget.post.userSaved ?? false,
                onToggle: () async {
                  _handleLocalBookMarkToggle();
                },
              ),
              // Icon(
              //   Icons.bookmark_border,
              //   color: Colors.grey[600],
              //   size: 20,
              // ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  ShareHelper.shareContentWithImage(
                    message: 'Check out this awesome post!',
                    imageUrl: 'https://picsum.photos/id/237/200/300',
                  );
                },
                child: SvgPicture.asset(
                  'assets/svg/icons/share.svg',
                  height: 24,
                  width: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
