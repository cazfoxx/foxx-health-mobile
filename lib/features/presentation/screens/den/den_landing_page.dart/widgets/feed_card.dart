import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foxxhealth/core/components/bookmark_icon.dart';
import 'package:foxxhealth/core/components/heart_toggle_button.dart';
import 'package:foxxhealth/core/utils/app_ui_helper.dart';
import 'package:foxxhealth/core/utils/share.dart';
import 'package:foxxhealth/features/data/models/community_feed_model.dart';
import 'package:foxxhealth/features/data/repositories/den_comments_repository.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_bloc.dart';
import 'package:foxxhealth/features/presentation/cubits/den/comments/comment_event.dart';
import 'package:foxxhealth/features/presentation/screens/den/den_comments/den_comments_screen.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';

class FeedCard extends StatefulWidget {
  final Post post;
  final String?
      userName; // for own feed , if user name is not available for post
  const FeedCard({super.key, required this.post, this.userName});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool _isExpanded = false;
  static const int _truncateLength = 220;
  @override
  Widget build(BuildContext context) {
    final content = widget.post.content;
    final bool showMoreButton = content.length > _truncateLength;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          if (widget.post.den?.name != null)
            Row(
              children: [
                Text(
                  'Posted in ',
                  style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to specific den
                  },
                  child: Text(
                    widget.post.den?.name ?? "",
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
                child: Icon(
                  Icons.person,
                  color: Colors.grey[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.userName ?? widget.post.userProfile.username,
                  style: AppOSTextStyles.osMdSemiboldTitle.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Post content
          // Text(
          //   widget.post.content,
          //   style: AppOSTextStyles.osMd.copyWith(
          //     color: Colors.black,
          //     height: 1.4,
          //   ),
          // ),
          // if (widget.post. == true) ...[
          //   const SizedBox(height: 4),
          //   GestureDetector(
          //     onTap: () {
          //       // Show full content
          //     },
          //     child: Text(
          //       'More',
          //       style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
          //         color: const Color(0xFF9B7EDE), // Purple color
          //       ),
          //     ),
          //   ),
          // ],
          // const SizedBox(height: 8),

          RichText(
            text: TextSpan(
              style: AppOSTextStyles.osMd.copyWith(
                color: Colors.black,
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
                      isLiked: false,
                      onToggle: () async {
                        await Future.delayed(const Duration(milliseconds: 300));
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
                    child: BlocProvider(
                      create: (_) => CommentBloc(CommentRepository())
                        ..add(FetchComments(widget.post.id)),
                      child: DenCommentsScreen(postId: widget.post.id),
                    ),
                  );

                  // showModalBottomSheet(
                  //   backgroundColor: Colors.white,
                  //   context: context,
                  //   isScrollControlled: true,
                  //   builder: (context) => Padding(
                  //     padding: EdgeInsets.only(
                  //       bottom: MediaQuery.of(context).viewInsets.bottom,
                  //     ),
                  //     child: SizedBox(
                  //       height: MediaQuery.of(context).size.height * 0.6,
                  //       child: const DenCommentsScreen(),
                  //     ),
                  //   ),
                  // );
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
                isBookMarked: false,
                onToggle: () async {
                  await Future.delayed(const Duration(milliseconds: 300));
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

  // void _showCommentDialog(Post post) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Comments on ${post['userName']}\'s post'),
  //         content: Container(
  //           width: double.maxFinite,
  //           height: 300,
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: ListView(
  //                   children: [
  //                     // Sample comments
  //                     _buildCommentItem('SarahM',
  //                         'Thanks for sharing this! I\'ve been dealing with similar issues.'),
  //                     _buildCommentItem('HealthJourney',
  //                         'This is really helpful information.'),
  //                     _buildCommentItem(
  //                         'WellnessSeeker', 'I can relate to this experience.'),
  //                     _buildCommentItem(
  //                         'FitLife', 'Great insights, thank you!'),
  //                   ],
  //                 ),
  //               ),
  //               const Divider(),
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: TextField(
  //                       decoration: InputDecoration(
  //                         hintText: 'Add a comment...',
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(20),
  //                         ),
  //                         contentPadding: const EdgeInsets.symmetric(
  //                             horizontal: 16, vertical: 8),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 8),
  //                   IconButton(
  //                     onPressed: () {
  //                       // Handle comment submission
  //                       Navigator.of(context).pop();
  //                       ScaffoldMessenger.of(context).showSnackBar(
  //                         const SnackBar(
  //                           content: Text('Comment posted successfully!'),
  //                           backgroundColor: Colors.green,
  //                         ),
  //                       );
  //                     },
  //                     icon: const Icon(Icons.send),
  //                     color: AppColors.amethystViolet,
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Close'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Widget _buildCommentItem(String username, String comment) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CircleAvatar(
  //           radius: 16,
  //           backgroundColor: AppColors.amethystViolet.withOpacity(0.2),
  //           child: Text(
  //             username[0].toUpperCase(),
  //             style: const TextStyle(
  //               color: AppColors.amethystViolet,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 username,
  //                 style: AppOSTextStyles.osSmSemiboldLabel.copyWith(
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 2),
  //               Text(
  //                 comment,
  //                 style: AppOSTextStyles.osSmSemiboldBody.copyWith(
  //                   color: Colors.black87,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
